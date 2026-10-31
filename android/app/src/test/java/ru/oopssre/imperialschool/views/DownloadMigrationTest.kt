package ru.oopssre.imperialschool.views

import android.app.DownloadManager
import android.net.Uri
import android.os.Environment
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import org.robolectric.shadow.api.Shadow
import org.robolectric.shadows.ShadowDownloadManager
import java.io.File

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34])
class DownloadMigrationTest {
    private fun fixture(): Triple<Repository,Long,File> {
        val repo=Repository(RuntimeEnvironment.getApplication());repo.put("download_network","wifi")
        val request=DownloadRequests.allowNetworks(DownloadManager.Request(Uri.parse(SITE+"downloads/test.zip")),"wifi")
        val id=repo.context.getSystemService(DownloadManager::class.java).enqueue(request)
        Shadow.extract<ShadowDownloadManager.ShadowRequest>(request).status=DownloadManager.STATUS_RUNNING
        val file=File(repo.root,"collection-downloads/test.json")
        Net.atomic(file,JSONObject().put("stage","downloading").put("network_policy","wifi").put("download_id",id).put("url","downloads/test.zip").put("sha256","a".repeat(64)).toString().toByteArray())
        return Triple(repo,id,file)
    }
    private fun exists(repo: Repository,id: Long)=repo.context.getSystemService(DownloadManager::class.java).query(DownloadManager.Query().setFilterById(id)).use{it.moveToFirst()}
    @Test fun badMetadataDoesNotRemoveAnExistingRequestAndErrorCanBeCleared() {
        val(repo,id,file)=fixture()
        val result=DownloadRequests.select(repo,"any")
        assertFalse(result.errors.isEmpty());assertEquals(0,result.restarted);assertTrue(exists(repo,id))
        assertEquals("wifi",JSONObject(file.readText()).getString("network_policy"))
        assertTrue(JSONObject(file.readText()).getString("network_error").isNotBlank())
        assertTrue(DownloadRequests.message("any",result).contains("не удалось"))
        assertTrue(DownloadRequests.select(repo,"wifi").errors.isEmpty())
        assertFalse(JSONObject(file.readText()).has("network_error"));assertTrue(repo.text("download_migration_error").isBlank())
    }
    @Test fun successfulSwitchReplacesRequestWithSelectedNetworkFlags() {
        val(repo,id,file)=fixture()
        val destination=File(repo.context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS),"test.zip").apply{parentFile!!.mkdirs();writeText("partial")}
        Net.atomic(file,JSONObject(file.readText()).put("path",destination.path).toString().toByteArray())
        val result=DownloadRequests.select(repo,"any")
        assertEquals(1,result.restarted);assertTrue(result.errors.isEmpty());assertFalse(exists(repo,id));assertFalse(destination.exists())
        val job=JSONObject(file.readText());assertEquals("any",job.getString("network_policy"));assertNotEquals(id,job.getLong("download_id"))
        val request=org.robolectric.Shadows.shadowOf(repo.context.getSystemService(DownloadManager::class.java)).getRequest(job.getLong("download_id"))
        val shadow=Shadow.extract<ShadowDownloadManager.ShadowRequest>(request)
        assertEquals(-1,shadow.allowedNetworkTypes);assertTrue(shadow.allowedOverMetered);assertTrue(shadow.allowedOverRoaming)
    }
}
