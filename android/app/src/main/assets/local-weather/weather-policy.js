/* Generated from the existing server policy; do not maintain a second mapping. */
var ViewsWeatherPolicy = {
  "mapping": {
    "0": "clear",
    "1": "partly-cloudy",
    "2": "partly-cloudy",
    "3": "overcast",
    "45": "fog",
    "48": "fog",
    "51": "drizzle",
    "53": "drizzle",
    "55": "drizzle",
    "61": "rain",
    "63": "rain",
    "80": "rain",
    "81": "rain",
    "65": "heavy-rain",
    "82": "heavy-rain",
    "56": "freezing-precipitation",
    "57": "freezing-precipitation",
    "66": "freezing-precipitation",
    "67": "freezing-precipitation",
    "71": "snow",
    "73": "snow",
    "77": "snow",
    "85": "snow",
    "75": "heavy-snow",
    "86": "heavy-snow",
    "95": "thunderstorm",
    "97": "severe-thunderstorm",
    "96": "thunderstorm-hail",
    "99": "thunderstorm-hail"
  },
  "labels": {
    "clear": "Ясно",
    "partly-cloudy": "Переменная облачность",
    "overcast": "Пасмурно",
    "fog": "Туман",
    "drizzle": "Морось",
    "rain": "Дождь",
    "heavy-rain": "Сильный дождь",
    "freezing-precipitation": "Ледяные осадки",
    "snow": "Снег",
    "heavy-snow": "Сильный снег",
    "thunderstorm": "Гроза",
    "severe-thunderstorm": "Сильная гроза",
    "thunderstorm-hail": "Гроза с градом"
  },
  "season_months": {
    "winter": [
      12,
      1,
      2
    ],
    "spring": [
      3,
      4,
      5
    ],
    "summer": [
      6,
      7,
      8
    ],
    "autumn": [
      9,
      10,
      11
    ]
  },
  "solar_depression": 6,
  "source": "Gremlin_Build_Incremental_1.0.13/games/gremlin_weather_discovery.py",
  "source_sha256": "0c935c7b72965a81e5466fc209ff9be5f964ef28c253a67b66026230aa9a78d4"
};
if(typeof module!=="undefined")module.exports=ViewsWeatherPolicy;
