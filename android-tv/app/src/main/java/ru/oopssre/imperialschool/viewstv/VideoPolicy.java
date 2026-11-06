package ru.oopssre.imperialschool.viewstv;

import java.util.concurrent.ThreadLocalRandom;

/** Client polling is independent of the frame's validity interval. */
public final class VideoPolicy {
    public static long nextDelay(){return ThreadLocalRandom.current().nextLong(600000L,1200001L);}
    public static long retryDelay(int failures){return Math.min(300000L,60000L*(1L<<Math.min(3,Math.max(0,failures-1))));}
}
