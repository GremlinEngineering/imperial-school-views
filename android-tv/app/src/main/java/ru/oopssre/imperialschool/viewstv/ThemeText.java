package ru.oopssre.imperialschool.viewstv;

public final class ThemeText {
    private ThemeText() {}
    public static String title(Protocol.Theme theme) {
        String english=theme.descriptor.optString("title_en", "");
        String suffix=" · "+english;
        String result= !english.isEmpty() && theme.title.endsWith(suffix)
                ? theme.title.substring(0, theme.title.length()-suffix.length()) : theme.title;
        return result.replace(" / ","\u00a0/\u00a0");
    }
    public static String group(String kind) {
        return kind.equals("dynamic") ? "Живые сцены" : kind.equals("weather") ? "Погода" : "Коллекции изображений";
    }
    public static String description(Protocol.Theme theme) {
        String value=theme.descriptor.optString("description", "").trim();
        if (!value.isEmpty()) {
            int sentence=value.indexOf(". ");
            if (sentence>=0 && sentence<220) return value.substring(0,sentence+1);
            if (value.length()<=220) return value;
            int end=value.lastIndexOf(' ',210);
            return value.substring(0,end>0?end:210)+"…";
        }
        if(theme.kind.equals("dynamic")) return "Сцена меняется вместе со временем, погодой и событиями мира.";
        if(theme.kind.equals("weather")) return "Время суток, времена года и погода меняют знакомую сцену.";
        return "Изображения сменяются по расписанию коллекции.";
    }
}
