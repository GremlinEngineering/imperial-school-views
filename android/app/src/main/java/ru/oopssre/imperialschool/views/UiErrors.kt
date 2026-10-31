package ru.oopssre.imperialschool.views

internal object UiErrors {
    fun message(error: Throwable): String {
        val causes=generateSequence(error){it.cause}.take(8).toList()
        val text=causes.mapNotNull{it.message}.joinToString(" ")
        return when {
            causes.any{it is java.net.UnknownHostException || it is java.net.ConnectException || it is java.net.NoRouteToHostException}->"Нет соединения с сервером. Проверьте интернет и повторите попытку."
            causes.any{it is java.net.SocketTimeoutException}->"Сервер не ответил вовремя. Повторите попытку."
            text.contains("ENOSPC",true) || text.contains("No space left",true)->"Недостаточно свободного места. Освободите память и повторите загрузку."
            causes.any{it is javax.net.ssl.SSLException}->"Не удалось установить защищённое соединение. Проверьте дату и время устройства."
            causes.any{it is SecurityException}->"Android запретил действие. Проверьте разрешения приложения."
            causes.any{it is JsonTransferException}->causes.filterIsInstance<JsonTransferException>().first().message!!
            causes.any{it is org.json.JSONException}->"Не удалось прочитать данные. Обновите список или повторно скачайте пакет."
            causes.any{it is InterruptedException || it is java.util.concurrent.CancellationException}->"Операция остановлена. Можно повторить её."
            error.message?.any{it in 'А'..'я' || it=='ё' || it=='Ё'}==true->error.message!!
            else->"Не удалось выполнить действие. Повторите попытку."
        }
    }
    fun download(reason: Int): String=when(reason) {
        1006->"Недостаточно свободного места для ZIP. Освободите память и повторите загрузку."
        1007->"Хранилище недоступно. Проверьте память устройства и повторите загрузку."
        1008->"Не удалось продолжить загрузку. Скачайте ZIP заново."
        1009->"Временный файл уже существует. Повторите загрузку."
        1010->"Android заблокировал загрузку. Проверьте ограничения трафика приложения."
        in 400..599->"Сервер вернул HTTP $reason. Обновите список и повторите загрузку."
        else->"Загрузка прервана (код $reason). Проверьте интернет и повторите загрузку."
    }
}
