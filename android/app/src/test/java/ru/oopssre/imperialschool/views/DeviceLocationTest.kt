package ru.oopssre.imperialschool.views

import android.Manifest
import android.location.Location
import android.location.LocationManager
import android.os.Looper
import android.os.SystemClock
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.annotation.LooperMode
import java.time.Duration

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34])
@LooperMode(LooperMode.Mode.PAUSED)
class DeviceLocationTest {
    private val app get()=RuntimeEnvironment.getApplication()
    private val manager get()=app.getSystemService(LocationManager::class.java)
    private fun fix(age: Long=0)=Location(LocationManager.NETWORK_PROVIDER).apply{latitude=52.52;longitude=13.4;accuracy=5000f;elapsedRealtimeNanos=SystemClock.elapsedRealtimeNanos()-age;time=System.currentTimeMillis()}
    @Before fun setup(){shadowOf(app).grantPermissions(Manifest.permission.ACCESS_COARSE_LOCATION);shadowOf(manager).setLocationEnabled(true);shadowOf(manager).setProviderEnabled(LocationManager.NETWORK_PROVIDER,true)}
    @Test fun approximateLocationIsEnoughAndFreshCacheDoesNotSubscribe() {
        val point=fix();shadowOf(manager).setLastKnownLocation(LocationManager.NETWORK_PROVIDER,point)
        var result: Location?=null;DeviceLocation(app).start({result=it},{fail(it)})
        assertEquals(point,result);assertTrue(shadowOf(manager).locationUpdateListeners.isEmpty())
    }
    @Test fun freshFixUnsubscribesAndDoesNotFireTimeoutLater() {
        var count=0;val service=DeviceLocation(app);service.start({count++},{fail(it)})
        assertFalse(shadowOf(manager).locationUpdateListeners.isEmpty())
        shadowOf(manager).simulateLocation(LocationManager.NETWORK_PROVIDER,fix());shadowOf(Looper.getMainLooper()).idle()
        assertEquals(1,count);assertTrue(shadowOf(manager).locationUpdateListeners.isEmpty())
        shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(26));assertEquals(1,count)
    }
    @Test fun timeoutAndCancellationReleaseAllListeners() {
        var error="";val service=DeviceLocation(app);service.start({fail("unexpected fix")},{error=it})
        shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(26));assertTrue(error.contains("25 секунд"));assertTrue(shadowOf(manager).locationUpdateListeners.isEmpty())
        error="";service.start({fail("cancelled")},{error=it});service.cancel()
        shadowOf(manager).simulateLocation(LocationManager.NETWORK_PROVIDER,fix());shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(26))
        assertEquals("",error);assertTrue(shadowOf(manager).locationUpdateListeners.isEmpty())
    }
    @Test fun permissionDenialAndDisabledLocationKeepManualChoicePossible() {
        shadowOf(app).denyPermissions(Manifest.permission.ACCESS_COARSE_LOCATION,Manifest.permission.ACCESS_FINE_LOCATION)
        var error="";DeviceLocation(app).start({fail("denied")},{error=it});assertTrue(error.contains("вручную"))
        shadowOf(app).grantPermissions(Manifest.permission.ACCESS_COARSE_LOCATION);shadowOf(manager).setLocationEnabled(false)
        DeviceLocation(app).start({fail("disabled")},{error=it});assertTrue(error.contains("выключена"))
    }
    @Test fun staleOrInvalidCoordinatesAreNotAccepted() {
        assertFalse(DeviceLocation.usable(fix(600000000001L)))
        assertFalse(DeviceLocation.usable(fix().apply{latitude=Double.NaN}))
        assertFalse(DeviceLocation.usable(fix().apply{longitude=181.0}))
        assertFalse(DeviceLocation.usable(fix().apply{accuracy=50000f}))
    }
    @Test fun coordinateTimezoneComesFromProviderAndExactCoordinatesRemainSaved() {
        var requested=""
        val city=LocalWeather.coordinates(52.52,13.4){url->requested=url;JSONObject().put("timezone","Europe/Berlin").put("latitude",52.5).put("longitude",13.5)}
        assertTrue(requested.contains("timezone=auto"));assertTrue(requested.contains("latitude=52.52"))
        assertEquals(52.52,city.getDouble("latitude"),0.0);assertEquals(13.4,city.getDouble("longitude"),0.0);assertEquals("Europe/Berlin",city.getString("timezone"))
        val selected=Selection(source="weather",weatherSource="open-meteo",weatherCity=city.toString())
        assertTrue(LocalWeather.deviceLocation(selected));assertTrue(LocalWeather.cityTitle(selected).contains("52.520"))
        assertThrows(IllegalArgumentException::class.java){LocalWeather.coordinates(Double.NaN,0.0){fail("invalid coordinates sent");JSONObject()}}
    }
    @Test fun locationPermissionsDoNotIncludeBackgroundAccess() {
        val permissions=app.packageManager.getPackageInfo(app.packageName,android.content.pm.PackageManager.GET_PERMISSIONS).requestedPermissions!!.toList()
        assertTrue(permissions.contains(Manifest.permission.ACCESS_COARSE_LOCATION));assertFalse(permissions.contains(Manifest.permission.ACCESS_BACKGROUND_LOCATION))
    }
}
