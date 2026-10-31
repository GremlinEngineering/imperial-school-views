package ru.oopssre.imperialschool.views

import org.json.JSONObject
import java.util.Locale

internal object ZipStatus {
    private fun mb(bytes: Long)=String.format(Locale("ru"),"%.1f",bytes.coerceAtLeast(0)/1048576.0)
    fun describe(job: JSONObject,policy: String): String {
        val received=job.optLong("received").coerceAtLeast(0);val total=job.optLong("total")
        val message=job.optString("message")
        return "ZIP: "+when(job.optString("stage")) {
            "downloading"->when {
                job.optInt("transfer_status")==4->message.ifBlank{if(policy=="wifi")"ожидание Wi-Fi" else "ожидание сети"}
                job.optInt("transfer_status")!=2 && received==0L->if(policy=="wifi")"в очереди · только Wi-Fi" else "в очереди · Wi-Fi и мобильная сеть"
                total>0->"скачивается ${(received*100/total).coerceIn(0,100)}% · ${mb(received)} / ${mb(total)} МБ"
                else->"скачивается · ${mb(received)} МБ · размер уточняется"
            }
            "downloaded","verifying"->"загрузка завершена · проверяю архив…"
            "unpacking"->"сохраняю кадры · ${job.optInt("completed")} / ${job.optInt("count")}"
            "ready"->"готов · скачан и проверен"
            "cancelled"->"загрузка отменена · можно повторить"
            "error"->"ошибка · "+message.ifBlank{"не удалось скачать архив. Повторите загрузку."}
            "outdated"->"доступна новая версия · скачайте обновление"
            else->"загрузка не начата"
        }
    }
}
