package ru.oopssre.imperialschool.views

import org.junit.Assert.*
import org.junit.Test

class ProfilesTest {
    @Test fun homeAndLockKeepDifferentCollectionsAndSchedules(){
        val home=Selection(source="weather",collection="harbour",mode="weather",target="home",weatherSource="game-world")
        val lock=Selection(source="online",collection="monthly",mode="monthly",target="lock")
        val p=Profiles().apply(home,"h1").apply(lock,"l1")
        assertFalse(p.linked);assertEquals("harbour",p.select("home").collection);assertEquals("monthly",p.select("lock").collection)
        assertEquals("game-world",p.select("home").weatherSource);assertEquals(listOf("home","lock"),p.activeTargets())
    }
    @Test fun changingOneOfLinkedTargetsPreservesTheOther(){
        val p=Profiles().apply(Selection(source="day",target="both"),"shared").apply(Selection(source="local",collection="mine",mode="daily",target="home"),"new-home")
        assertEquals("day",p.lock!!.source);assertEquals("shared",p.lock.revision);assertEquals("local",p.home!!.source);assertFalse(p.linked)
    }
    @Test fun pauseBothPreservesDifferentSettings(){
        val p=Profiles().apply(Selection(source="weather",collection="world",target="home"),"h").apply(Selection(source="local",collection="static",target="lock"),"l").pause("both",true,"pause")
        assertTrue(p.home!!.paused);assertTrue(p.lock!!.paused);assertEquals("world",p.home.collection);assertEquals("static",p.lock.collection);assertFalse(p.linked)
    }
    @Test fun pausingOneScreenDoesNotPauseTheOther(){
        val p=Profiles().apply(Selection(target="both"),"both").pause("lock",true,"paused-lock")
        assertFalse(p.home!!.paused);assertTrue(p.lock!!.paused);assertFalse(p.linked)
    }
    @Test fun migrationPreservesThePreviousTargetAndSelection(){
        val p=Profiles.migrate(Selection(source="local",collection="existing",mode="seasonal",target="lock",revision="old"))
        assertNull(p.home);assertEquals("existing",p.lock!!.collection);assertEquals("seasonal",p.lock.mode);assertEquals(listOf("lock"),p.activeTargets())
    }
    @Test fun serializationPreservesWeatherSettingsAndRevision(){
        val s=Selection(source="weather",target="lock",weatherSource="game-world",weatherDelivery="images",revision="token")
        assertEquals(s,Selection.parse(s.json()))
    }
    @Test fun untouchedScreenHasNoProfileOrScheduledTarget(){
        val p=Profiles().apply(Selection(source="weather",target="lock"),"lock")
        assertNull(p.home);assertEquals(listOf("lock"),p.activeTargets())
    }
    @Test fun leavingOneScreenToSystemPreservesOtherProfile(){
        val p=Profiles().apply(Selection(source="weather",target="both"),"shared").without("home")
        assertNull(p.home);assertEquals("shared",p.lock!!.revision);assertEquals("weather",p.lock.source);assertEquals(listOf("lock"),p.activeTargets());assertFalse(p.linked)
        val stopped=p.without("both");assertTrue(stopped.activeTargets().isEmpty())
    }
}
