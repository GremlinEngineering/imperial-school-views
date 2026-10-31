package ru.oopssre.imperialschool.views

import java.io.InputStream
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL
import java.util.Locale
import java.util.zip.GZIPInputStream
import org.brotli.dec.BrotliInputStream

internal class JsonTransferException(message: String,cause: Throwable?=null): IOException(message,cause)

/** JSON representation decoding only; ZIP and image bytes keep their original hashes. */
internal object JsonBody {
    fun configure(connection: HttpURLConnection) {
        // An explicit header disables Android's implicit gzip decoding. Decode exactly once here.
        connection.setRequestProperty("Accept-Encoding","br, gzip")
        connection.setRequestProperty("Accept","application/json")
    }
    fun endpoint(actual: String,expected: String)=actual==expected || actual==expected+".br"
    fun read(input: InputStream,encoding: String?,url: String,limit: Long): ByteArray {
        val encodings=encoding.orEmpty().split(',').map{it.trim().lowercase(Locale.ROOT)}.filter{it.isNotEmpty() && it!="identity"}
        if(encodings.size>2 || encodings.any{it!="br" && it!="gzip"})throw JsonTransferException("Сервер использует неподдерживаемое сжатие JSON. Повторите обновление позже.")
        var bytes=Net.bounded(input,limit)
        val layers=encodings.asReversed().toMutableList()
        // A direct sidecar normally has no Content-Encoding; with 'br' the header already describes it.
        if(URL(url).path.endsWith(".json.br") && "br" !in encodings)layers.add("br")
        try {
            for(layer in layers)bytes=(if(layer=="br")BrotliInputStream(bytes.inputStream()) else GZIPInputStream(bytes.inputStream())).use{Net.bounded(it,limit)}
        }catch(e: IllegalArgumentException){throw e}
        catch(e: Exception){throw JsonTransferException("Не удалось распаковать JSON с сервера. Повторите обновление.",e)}
        return bytes
    }
}
