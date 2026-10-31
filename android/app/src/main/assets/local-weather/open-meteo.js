/* Open-Meteo forecast + local archive selection. No macOS/UI dependencies. */
var ViewsOpenMeteo=(function(){
  'use strict';
  var HOUR=3600000, DAY=86400000, RETRY=180000;
  function check(v,m){if(!v)throw new Error(m);}
  function city(v){
    check(v&&typeof v.name==='string'&&v.name.trim()&&v.name.length<=200,'Выберите город из результатов поиска');
    check(Number.isFinite(v.latitude)&&Math.abs(v.latitude)<=90&&Number.isFinite(v.longitude)&&Math.abs(v.longitude)<=180,'Неверные координаты города');
    check(typeof v.timezone==='string'&&v.timezone.length<=100&&/^[A-Za-z0-9_+\/-]+$/.test(v.timezone),'В результате поиска нет часового пояса');
    return {id:Number.isSafeInteger(v.id)?v.id:null,name:v.name.trim(),latitude:v.latitude,longitude:v.longitude,timezone:v.timezone,country:typeof v.country==='string'?v.country.slice(0,120):'',admin1:typeof v.admin1==='string'?v.admin1.slice(0,120):''};
  }
  function cityTitle(v){return [v.name,v.admin1&&v.admin1!==v.name?v.admin1:'',v.country].filter(Boolean).join(' · ');}
  function locationKey(v){v=city(v);return [v.latitude,v.longitude,v.timezone].map(function(x){return encodeURIComponent(String(x));}).join('_');}
  function searchURL(query){query=String(query||'').trim();check(query.length>=2&&query.length<=120,'Введите название города: от 2 до 120 символов');return 'https://geocoding-api.open-meteo.com/v1/search?name='+encodeURIComponent(query)+'&count=20&language=ru&format=json';}
  function searchResults(raw){check(raw&&typeof raw==='object'&&!raw.error,'Не удалось получить результаты поиска');var rows=raw.results||[];check(Array.isArray(rows)&&rows.length<=100,'Неверный ответ поиска города');var seen=Object.create(null);return rows.reduce(function(out,v){try{var c=city(v),key=locationKey(c);if(!seen[key]){seen[key]=true;out.push(c);}}catch(ignore){}return out;},[]);}
  function forecastURL(value){var c=city(value);return 'https://api.open-meteo.com/v1/forecast?latitude='+encodeURIComponent(c.latitude)+'&longitude='+encodeURIComponent(c.longitude)+'&hourly=weather_code&timezone=UTC&timeformat=unixtime&forecast_hours=49&past_hours=1';}
  function normalize(raw,c,now){
    c=city(c);check(raw&&!raw.error&&raw.hourly,'Open-Meteo не вернул почасовой прогноз');
    var times=raw.hourly.time,codes=raw.hourly.weather_code;
    check(Array.isArray(times)&&Array.isArray(codes)&&times.length>0&&times.length===codes.length&&times.length<=1000,'Неверные массивы прогноза Open-Meteo');
    var hours=times.map(function(t,i){check(Number.isSafeInteger(t)&&t>0&&Number.isSafeInteger(t*1000),'Ожидалось время Unix в секундах');check(codes[i]===null||Number.isInteger(codes[i]),'Неверный код погоды');if(i)check(t-times[i-1]===3600,'В прогнозе есть пропущенные или повторяющиеся часы');return {time:t*1000,code:codes[i]};});
    var end=hours[hours.length-1].time+HOUR;
    check(hours[0].time<=now&&end>=now+DAY,'Прогноз не покрывает следующие 24 часа');
    return {schema:1,provider:'open-meteo',location_key:locationKey(c),fetched_at:now,valid_until:end,hours:hours};
  }
  function validProvider(p,c,now){
    if(!(p&&p.schema===1&&p.provider==='open-meteo'&&p.location_key===locationKey(c)&&Number.isFinite(p.fetched_at)&&p.fetched_at<=now&&Array.isArray(p.hours)&&p.hours.length>0&&p.hours.length<=1000))return false;
    if(!p.hours.every(function(h,i){return h&&Number.isSafeInteger(h.time)&&h.time>0&&(h.code===null||Number.isInteger(h.code))&&(!i||h.time-p.hours[i-1].time===HOUR);}))return false;
    return p.hours[0].time<=now&&p.valid_until===p.hours[p.hours.length-1].time+HOUR&&p.valid_until>now;
  }
  function validAstronomy(v,date){return Boolean(v&&v.date===date&&ViewsAstronomy.PHASES.indexOf(v.moon_phase)>=0&&['dawn','sunrise','sunset','dusk'].every(function(k){return v[k]===null||Number.isSafeInteger(v[k]);}));}
  function packageIndex(receipt,c,fmt,descriptor){
    check(receipt&&receipt.id===c.id&&receipt.format===fmt&&receipt.sha256===descriptor.sha256&&receipt.version===descriptor.version,'Сохранённый ZIP не соответствует выбранной коллекции и формату');
    ViewsWeather.packageManifest({schema:3,document_type:'weather-wallpaper-package',type:'weather',id:receipt.id,format:receipt.format,version:receipt.version,variants:receipt.variants},c,fmt,descriptor.version);
    var result=Object.create(null);
    receipt.variants.forEach(function(v){var key=v.state_id+'|'+v.moon_phase;check(!result[key],'В архиве неоднозначное состояние и фаза Луны');result[key]=v;});return result;
  }
  function season(date){var month=Number(date.slice(5,7));return Object.keys(ViewsWeatherPolicy.season_months).filter(function(k){return ViewsWeatherPolicy.season_months[k].indexOf(month)>=0;})[0];}
  function schedule(provider,c,index,now,io){
    check(validProvider(provider,c,now),'Прогноз устарел. Сохранены последние обои.');
    var A=ViewsAstronomy,first=Math.max(Math.floor(now/HOUR)*HOUR,provider.hours[0].time),end=Math.min(first+DAY,provider.valid_until),zone=c.timezone,loc=locationKey(c),memo=io.load('local/open-meteo/'+loc+'/astronomy');
    if(!memo||memo.policy!==A.POLICY||!memo.days||typeof memo.days!=='object'||Array.isArray(memo.days))memo={policy:A.POLICY,days:{}};
    var from=A.parts(first,zone,io.calendar).date,to=A.parts(end,zone,io.calendar).date,boundaries=[first,end],days=Object.create(null),date=A.addDays(from,-1),last=A.addDays(to,1),changed=false;
    for(var n=0;date<=last&&n<8;n++,date=A.addDays(date,1)){
      var events=memo.days[date];if(!validAstronomy(events,date)){events=A.day(date,c,io.calendar);memo.days[date]=events;changed=true;}days[date]=events;
      var midnight=A.midnight(date,zone,io.calendar);if(midnight!==null&&midnight>first&&midnight<end)boundaries.push(midnight);
      ['dawn','sunrise','sunset','dusk'].forEach(function(k){if(events[k]!==null&&events[k]>first&&events[k]<end)boundaries.push(events[k]);});
    }
    if(changed){Object.keys(memo.days).forEach(function(k){if(k<A.addDays(from,-3)||k>A.addDays(to,3))delete memo.days[k];});io.save('local/open-meteo/'+loc+'/astronomy',memo);}
    provider.hours.forEach(function(row){if(first<row.time&&row.time<end)boundaries.push(row.time);});
    boundaries.sort(function(a,b){return a-b;});boundaries=boundaries.filter(function(x,i,a){return !i||a[i-1]!==x;});
    var rows=[],hour=0;
    for(var i=0;i<boundaries.length-1;i++){
      var start=boundaries[i],stop=boundaries[i+1];while(hour+1<provider.hours.length&&provider.hours[hour+1].time<=start)hour++;
      var local=A.parts(start,zone,io.calendar).date,events=days[local],code=provider.hours[hour].code;
      var weather=code===null?null:(ViewsWeatherPolicy.mapping[String(code)]||null),light=A.light(start,events,c),s=season(local),state=weather?s+'-'+light+'-'+weather:null;
      var noMoon=state&&index[state+'|none'],phase=noMoon?'none':events.moon_phase,file=state&&(noMoon||index[state+'|'+phase]);
      var row={valid_from:new Date(start).toISOString(),valid_until:new Date(stop).toISOString(),season:s,time_of_day:light,weather:weather,weather_code:code,state_id:state,moon_phase:phase,status:file?'ready':'not_ready',state_title:[s,light,weather?ViewsWeatherPolicy.labels[weather]:'Неизвестная погода'].join(' · ')};
      if(file)row.file=file;else row.reason=weather?'prepared_variant_missing':'unknown_weather_code';
      var prev=rows[rows.length-1];if(prev&&['season','time_of_day','weather_code','state_id','moon_phase','status'].every(function(k){return prev[k]===row[k];}))prev.valid_until=row.valid_until;else rows.push(row);
    }
    return {generated_at:provider.fetched_at,valid_until:end,location_key:loc,intervals:rows,astronomy:days[from]};
  }
  function engine(io){
    var retry=Object.create(null),refreshGeneration=0,seenRefresh=Object.create(null),lastNow=0,prepared=Object.create(null);
    function provider(c,now){
      var key=locationKey(c),cache='local/open-meteo/'+key+'/provider',old=io.load(cache),url=forecastURL(c),available=io.hasJSON(url),due=!validProvider(old,c,now)||now-old.fetched_at>=HOUR;
      var warning='',forced=refreshGeneration>0&&seenRefresh[key]!==refreshGeneration;
      if((available||forced||due)&&(!retry[key]||retry[key]<=now||available||forced)){
        retry[key]=now+RETRY;seenRefresh[key]=refreshGeneration;
        try{old=normalize(io.getJSON(url),c,now);io.save(cache,old);retry[key]=now+HOUR;}
        catch(e){if(!e.pending)warning='Open-Meteo недоступен: '+e.message;else if(!old)warning='Получаю прогноз Open-Meteo…';}
      }
      if(old&&now-old.fetched_at>=HOUR)warning=warning||'Используется сохранённый прогноз Open-Meteo.';
      return {value:validProvider(old,c,now)?old:null,warning:warning,expired:Boolean(old&&old.valid_until<=now)};
    }
    function cycle(data,p,screens,now){
      check(p.mode==='weather'&&p.weather_provider==='open-meteo'&&p.weather_source==='real'&&!ViewsWeather.isDaily(p),'Open-Meteo доступен для реальной погоды конкретной коллекции');
      var cityValue=city(p.weather_city),key=locationKey(cityValue),c=data.collections.filter(function(c){return c.type==='weather'&&c.id===p.collection;})[0];check(c,'Выберите погодную коллекцию');ViewsWeather.validateCollection(c);
      if(lastNow&&now<lastNow){retry=Object.create(null);prepared=Object.create(null);}lastNow=now;
      var forecast=provider(cityValue,now),next=now+60000,memo=Object.create(null),title='Open-Meteo · '+cityTitle(cityValue);
      var results=screens.map(function(screen){
        var fmt=p.weather_format&&p.weather_format!=='auto'?p.weather_format:ViewsWeather.bestFormat(c,screen.width,screen.height);
        if(memo[fmt])return Object.assign({},memo[fmt],{screen:screen});
        var cacheKey='last/local/open-meteo/'+key+'/'+c.id+'/'+fmt,r={format:fmt,cache_key:cacheKey,last:io.load(cacheKey),status:'not_ready',message:forecast.expired?'Прогноз устарел. Сохранены последние обои.':forecast.warning||'Подготавливаю архив…'};
        try{
          check(ViewsWeather.desktopFormats(c).indexOf(fmt)>=0,'В коллекции нет выбранного формата');
          var descriptor=ViewsWeather.archive(data,c,fmt),receipt=io.load('packages/'+descriptor.sha256);
          if(!receipt||receipt.version!==descriptor.version){var job=io.requestPackage(descriptor,c,fmt,descriptor.version);if(job&&job.error)throw new Error(job.error);receipt=job&&job.receipt;if(!receipt)r.archive_pending=true;}
          if(receipt&&forecast.value){
            var index=packageIndex(receipt,c,fmt,descriptor),preparedKey=key+'|'+c.id+'|'+fmt+'|'+descriptor.sha256+'|'+forecast.value.fetched_at+'|'+Math.floor(now/HOUR),plan=prepared[preparedKey];
            if(!plan){plan=schedule(forecast.value,cityValue,index,now,io);if(Object.keys(prepared).length>32)prepared=Object.create(null);prepared[preparedKey]=plan;}
            r.forecast=plan;r.package_sha256=descriptor.sha256;r.astronomy=plan.astronomy;
            var active=plan.intervals.filter(function(row){return Date.parse(row.valid_from)<=now&&now<Date.parse(row.valid_until);});
            check(active.length===1,'Нет единственного интервала локальной погоды');r.row=active[0];r.status=r.row.status;next=Math.min(next,Date.parse(r.row.valid_until));
            if(r.status==='ready'){
              var path=io.imagePath(r.row.file.sha256);
              if(!io.goodFile(path,r.row.file)){
                io.save('packages/'+descriptor.sha256,null);var repair=io.requestPackage(descriptor,c,fmt,descriptor.version);r.status='not_ready';r.archive_pending=!(repair&&repair.error);r.message=repair&&repair.error||'Кадр архива отсутствует или повреждён. Повторно загружаю ZIP.';
              }else{r.path=path;r.message='';}
            }else r.message=r.row.reason==='unknown_weather_code'?'Нет сопоставления для кода погоды '+String(r.row.weather_code)+'. Сохранены прежние обои.':'В архиве нет кадра '+r.row.state_id+' / '+r.row.moon_phase+'. Сохранены прежние обои.';
          }else if(!forecast.value){r.status=forecast.expired?'stale':'waiting';}
          if(!receipt)r.message=(r.message&&forecast.expired?r.message+' ':'')+'Ожидаю готовый ZIP коллекции.';
        }catch(e){r.status='error';r.message=e.message;r.archive_error=e.message;}
        memo[fmt]=r;return Object.assign({},r,{screen:screen});
      });
      return {local:true,collection:c.id,collection_title:c.title,source:'real',source_title:title,world_id:null,location_revision:'open-meteo/'+key,city:cityValue,warning:forecast.warning,results:results,next:next};
    }
    function applied(result,r){io.save(r.cache_key,{collection:result.collection,location_revision:result.location_revision,world_id:null,path:r.path,source_title:result.source_title,state_title:r.row.state_title,sha256:r.row.file.sha256,bytes:r.row.file.bytes,width:r.row.file.width,height:r.row.file.height});}
    return {cycle:cycle,applied:applied,forceRefresh:function(){refreshGeneration+=1;}};
  }
  return {city:city,cityTitle:cityTitle,locationKey:locationKey,searchURL:searchURL,searchResults:searchResults,forecastURL:forecastURL,normalize:normalize,validProvider:validProvider,packageIndex:packageIndex,schedule:schedule,engine:engine};
})();
if(typeof module!=='undefined')module.exports=ViewsOpenMeteo;
