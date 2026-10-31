/* Solar and lunar equations adapted from Astral 3.2 (Apache-2.0).
 * Copyright 2009-2021 Simon Kennedy. Modified for Imperial School Views, 2026.
 * See licences/astral-LICENSE.txt and docs/OPEN_METEO_REVIEW.md.
 * Pure arithmetic: no files, processes, geolocation or implicit host timezone.
 */
var ViewsAstronomy = (function () {
  'use strict';
  var DAY=86400000, PHASES=['new_moon','waxing_crescent','first_quarter','waxing_gibbous','full_moon','waning_gibbous','last_quarter','waning_crescent'];
  var formatters=Object.create(null);
  function check(ok,message){if(!ok)throw new Error(message);}
  function radians(x){return x*(Math.PI/180);}
  function degrees(x){return x*(180/Math.PI);}
  // Python's % is non-negative with a positive divisor. JavaScript's % is not.
  function mod(x,n){var r=x%n;return r<0?r+n:r;}
  function dateUTC(key){check(/^\d{4}-\d{2}-\d{2}$/.test(key),'Неверная дата астрономии');var p=key.split('-').map(Number),t=Date.UTC(p[0],p[1]-1,p[2]);check(p[0]>=1900&&p[0]<=2100&&new Date(t).toISOString().slice(0,10)===key,'Дата астрономии вне диапазона 1900–2100');return t;}
  function addDays(key,n){return new Date(dateUTC(key)+n*DAY).toISOString().slice(0,10);}
  function intlParts(ms,zone){
    check(Number.isFinite(ms),'Неверный момент времени');
    check(typeof Intl!=='undefined'&&Intl.DateTimeFormat,'Нет календарного адаптера');
    var f=formatters[zone];if(!f)f=formatters[zone]=new Intl.DateTimeFormat('en-GB-u-ca-gregory-nu-latn',{timeZone:zone,year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit',hourCycle:'h23'});
    var out={};f.formatToParts(new Date(ms)).forEach(function(p){if(p.type!=='literal')out[p.type]=p.value;});
    return {date:out.year+'-'+out.month+'-'+out.day,hour:Number(out.hour)%24,minute:Number(out.minute),second:Number(out.second)};
  }
  function parts(ms,zone,calendar){return (calendar||intlParts)(ms,zone);}
  function location(city){check(city&&Number.isFinite(city.latitude)&&Math.abs(city.latitude)<=90&&Number.isFinite(city.longitude)&&Math.abs(city.longitude)<=180&&typeof city.timezone==='string'&&city.timezone.length>0,'Неверные координаты или часовой пояс города');}
  function julian(ms){
    // Keep the Astral expression order; microseconds are deliberately ignored there.
    var d=new Date(Math.floor(ms/1000)*1000),y=d.getUTCFullYear(),m=d.getUTCMonth()+1,day=d.getUTCDate(),fraction=(d.getUTCHours()*3600+d.getUTCMinutes()*60+d.getUTCSeconds())/86400;
    if(m<=2){y-=1;m+=12;}var a=Math.trunc(y/100),b=2-a+Math.trunc(a/4);
    return Math.trunc(365.25*(y+4716))+Math.trunc(30.6001*(m+1))+day+fraction+b-1524.5;
  }
  function century(jd){return (jd-2451545.0)/36525.0;}
  function meanLong(t){return mod(280.46646+t*(36000.76983+0.0003032*t),360.0);}
  function anomaly(t){return 357.52911+t*(35999.05029-0.0001537*t);}
  function eccentricity(t){return 0.016708634-t*(0.000042037+0.0000001267*t);}
  function center(t){var m=radians(anomaly(t));return Math.sin(m)*(1.914602-t*(0.004817+0.000014*t))+Math.sin(m+m)*(0.019993-0.000101*t)+Math.sin(m+m+m)*0.000289;}
  function apparentLong(t){return meanLong(t)+center(t)-0.00569-0.00478*Math.sin(radians(125.04-1934.136*t));}
  function obliquity(t){var seconds=21.448-t*(46.815+t*(0.00059-t*0.001813));var e=23+(26+seconds/60)/60;return e+0.00256*Math.cos(radians(125.04-1934.136*t));}
  function declination(t){return degrees(Math.asin(Math.sin(radians(obliquity(t)))*Math.sin(radians(apparentLong(t)))));}
  function equationOfTime(t){var l=meanLong(t),e=eccentricity(t),m=anomaly(t),y=Math.tan(radians(obliquity(t))/2);y=y*y;return degrees(y*Math.sin(2*radians(l))-2*e*Math.sin(radians(m))+4*e*y*Math.sin(radians(m))*Math.cos(2*radians(l))-0.5*y*y*Math.sin(4*radians(l))-1.25*e*e*Math.sin(2*radians(m)))*4;}
  function refraction(zenith){
    var elevation=90-zenith;if(elevation>=85)return 0;var te=Math.tan(radians(elevation)),correction;
    if(elevation>5)correction=58.1/te-0.07/(te*te*te)+0.000086/(te*te*te*te*te);
    else if(elevation>-.575){var a=-12.79+elevation*.711,b=103.4+elevation*a,c=-518.2+elevation*b;correction=1735+elevation*c;}
    else correction=-20.774/te;return correction/3600;
  }
  function transit(date,city,zenith,direction){
    location(city);var latitude=Math.max(-89.8,Math.min(89.8,city.latitude)),jd=julian(dateUTC(date)),adjustment=0,timeUTC=0,ref=refraction(zenith);
    for(var i=0;i<2;i++){
      var t=century(jd+adjustment),dec=radians(declination(t)),lat=radians(latitude);
      var h=(Math.cos(radians(zenith+ref))-Math.sin(lat)*Math.sin(dec))/(Math.cos(lat)*Math.cos(dec));
      // No clamping here: Astral treats a nonexistent crossing as a polar event.
      if(h < -1 || h > 1)return null;
      var hour=Math.acos(h)*(direction==='setting'?-1:1),delta=-city.longitude-degrees(hour),offset=delta*4-equationOfTime(t);
      if(offset < -720)offset+=1440;timeUTC=720+offset;adjustment=timeUTC/1440;
    }
    // Astral minutes_to_timedelta truncates each component, stamp() drops sub-seconds.
    var days=Math.trunc(timeUTC/1440),seconds=(timeUTC-days*1440)*60,s=Math.trunc(seconds),us=Math.trunc((seconds-s)*1000000);
    return dateUTC(date)+(days*86400+s+Math.floor(us/1000000))*1000;
  }
  function event(date,city,zenith,direction,calendar){
    var t=transit(date,city,zenith,direction);if(t===null)return null;
    var local=parts(t,city.timezone,calendar).date;
    if(local!==date){t=transit(addDays(date,local<date?1:-1),city,zenith,direction);if(t===null||parts(t,city.timezone,calendar).date!==date)return null;}
    return t;
  }
  function moonPhase(date){
    var jd=julian(dateUTC(date)),dt=Math.pow(jd-2382148,2)/(41048480*86400),t=(jd+dt-2451545)/36525,t2=Math.pow(t,2),t3=Math.pow(t,3);
    var d=radians(mod(297.85+445267.1115*t-0.0016300*t2+t3/545868,360));
    var m=radians(mod(357.53+35999.0503*t,360)),m1=radians(mod(134.96+477198.8676*t+0.0089970*t2+t3/69699,360));
    var elong=degrees(d)+6.29*Math.sin(m1);elong-=2.10*Math.sin(m);elong+=1.27*Math.sin(2*d-m1);elong+=.66*Math.sin(2*d);
    var phase=((Math.trunc(mod(elong,360))+6.43)/360)*28;if(phase>=28)phase-=28;return phase;
  }
  function day(date,city,calendar){
    location(city);dateUTC(date);var phase=moonPhase(date);
    return {date:date,dawn:event(date,city,96,'rising',calendar),sunrise:event(date,city,90+32/(60*2),'rising',calendar),sunset:event(date,city,90+32/(60*2),'setting',calendar),dusk:event(date,city,96,'setting',calendar),moon_phase:PHASES[Math.floor((phase+1.75)/3.5)%8],moon_value:phase};
  }
  function elevation(ms,city){
    location(city);var latitude=Math.max(-89.8,Math.min(89.8,city.latitude)),d=new Date(Math.floor(ms/1000)*1000),t=century(julian(ms)),dec=declination(t),eq=equationOfTime(t);
    var solar=d.getUTCHours()*60+d.getUTCMinutes()+d.getUTCSeconds()/60+eq+4*city.longitude;
    while(solar>1440)solar-=1440;var hour=solar/4-180;if(hour < -180)hour+=360;
    var cl=Math.cos(radians(latitude)),sl=Math.sin(radians(latitude)),sd=Math.sin(radians(dec)),cd=Math.cos(radians(dec)),ch=Math.cos(radians(hour));
    var csz=Math.max(-1,Math.min(1,cl*cd*ch+sl*sd)),zenith=degrees(Math.acos(csz));zenith-=refraction(zenith);return 90-zenith;
  }
  function light(ms,events,city){
    var names=[['dawn','sunrise','dawn'],['sunrise','sunset','day'],['sunset','dusk','dusk']];
    for(var i=0;i<names.length;i++){var x=names[i];if(events[x[0]]!==null&&events[x[1]]!==null&&events[x[0]]<=ms&&ms<events[x[1]])return x[2];}
    if(['dawn','sunrise','sunset','dusk'].every(function(k){return events[k]!==null;}))return 'night';
    var e=elevation(ms,city);if(e>=-.833)return 'day';if(e < -6)return 'night';return elevation(ms+30000,city)>e?'dawn':'dusk';
  }
  // First actual instant of the local date. Handles 23/25h days and midnight DST.
  function midnight(date,zone,calendar){
    var mid=dateUTC(date),lo=Math.floor((mid-2*DAY)/1000),hi=Math.floor((mid+2*DAY)/1000);
    while(lo<hi){var m=Math.floor((lo+hi)/2);if(parts(m*1000,zone,calendar).date<date)lo=m+1;else hi=m;}
    return parts(lo*1000,zone,calendar).date===date?lo*1000:null;
  }
  return {POLICY:'astral-3.2/eight-centred-sectors-local-date/1',PHASES:PHASES,day:day,light:light,elevation:elevation,moonPhase:moonPhase,midnight:midnight,parts:parts,dateUTC:dateUTC,addDays:addDays,julian:julian,transit:transit};
})();
if(typeof module!=='undefined')module.exports=ViewsAstronomy;
