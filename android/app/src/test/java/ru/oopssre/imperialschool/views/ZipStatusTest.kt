package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test

class ZipStatusTest {
    @Test fun distinguishesEveryDownloadPhase() {
        val checks=mapOf("" to "не начата","downloaded" to "проверяю","verifying" to "проверяю","unpacking" to "сохраняю","ready" to "готов","error" to "ошибка","cancelled" to "отменена","outdated" to "новая версия")
        checks.forEach{(stage,text)->assertTrue(ZipStatus.describe(JSONObject().put("stage",stage),"any").contains(text))}
    }
    @Test fun queueDoesNotClaimBytesAreAlreadyDownloading() {
        assertTrue(ZipStatus.describe(JSONObject().put("stage","downloading").put("transfer_status",1),"wifi").contains("в очереди · только Wi-Fi"))
        assertTrue(ZipStatus.describe(JSONObject().put("stage","downloading").put("transfer_status",4),"wifi").contains("ожидание Wi-Fi"))
    }
    @Test fun runningDownloadShowsPercentAndBytes() {
        val text=ZipStatus.describe(JSONObject().put("stage","downloading").put("transfer_status",2).put("received",1048576).put("total",4194304),"any")
        assertTrue(text.contains("25%"));assertTrue(text.contains("1,0 / 4,0 МБ"))
    }
}
