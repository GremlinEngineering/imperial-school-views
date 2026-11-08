package ru.oopssre.imperialschool.viewstv.navigationprobe;

import android.app.Activity;
import android.app.Instrumentation;
import android.content.Intent;
import android.os.Bundle;
import android.os.SystemClock;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.concurrent.Callable;
import java.util.concurrent.atomic.AtomicReference;

public final class NavigationProbe extends Instrumentation {
    @Override public void onCreate(Bundle args) { super.onCreate(args); start(); }

    private static void require(boolean result, String message) {
        if (!result) throw new AssertionError(message);
    }

    private <T> T main(Callable<T> action) throws Exception {
        AtomicReference<T> value = new AtomicReference<>();
        AtomicReference<Throwable> failure = new AtomicReference<>();
        runOnMainSync(() -> {
            try { value.set(action.call()); } catch (Throwable e) { failure.set(e); }
        });
        if (failure.get() != null) throw new AssertionError(failure.get());
        return value.get();
    }

    private static Object field(Object instance, String name) throws Exception {
        Field f = instance.getClass().getDeclaredField(name);
        f.setAccessible(true);
        return f.get(instance);
    }

    private static Object call(Object instance, String name, Class<?>[] types, Object... args) throws Exception {
        Method m = instance.getClass().getDeclaredMethod(name, types);
        m.setAccessible(true);
        return m.invoke(instance, args);
    }

    private static Button button(View root, String text) {
        if (root instanceof Button && ((Button) root).getText().toString().equals(text)) return (Button) root;
        if (root instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) root;
            for (int i = 0; i < group.getChildCount(); i++) {
                Button match = button(group.getChildAt(i), text);
                if (match != null) return match;
            }
        }
        return null;
    }

    private static boolean visible(Object scene) throws Exception {
        return ((View) field(scene, "panel")).getVisibility() == View.VISIBLE;
    }

    private void select(Object scene, String title) throws Exception {
        main(() -> {
            Button target = button((View) field(scene, "content"), title);
            require(target != null && target.isEnabled() && target.requestFocus(), "Focusable: " + title);
            return null;
        });
        sendKeyDownUpSync(KeyEvent.KEYCODE_DPAD_CENTER);
        waitForIdleSync();
    }

    private void waitFocused(Activity activity) throws Exception {
        long until = SystemClock.elapsedRealtime() + 10_000;
        while (SystemClock.elapsedRealtime() < until) {
            if (main(activity::hasWindowFocus)) return;
            Thread.sleep(100);
        }
        throw new AssertionError("App window never took focus");
    }

    private void wallpaperCallback(Object scene) throws Exception {
        Class<?> frame = getTargetContext().getClassLoader()
                .loadClass("ru.oopssre.imperialschool.viewstv.Protocol$Frame");
        Constructor<?> init = frame.getDeclaredConstructor(String.class, String.class, String.class, String.class,
                String.class, String.class, int.class, int.class, long.class, long.class, long.class);
        init.setAccessible(true);
        long now = System.currentTimeMillis();
        Object sample = init.newInstance("orbital-port", "desktop_1920x1080", "Орбитальный порт",
                "https://games.oopssre.ru/assets/arcade/views/frame.jpg",
                "a000000000000000000000000000000000000000000000000000000000000000", "sample",
                1920, 1080, 1L, now, now + 60000);
        call(scene, "frame", new Class<?>[]{frame}, sample);
    }

    @Override public void onStart() {
        Bundle result = new Bundle();
        try {
            String pkg = getTargetContext().getPackageName();
            getTargetContext().getSharedPreferences("tv", 0).edit()
                    .putInt("music_volume", 35).putBoolean("video_output", false).commit();
            Activity activity = startActivitySync(new Intent(Intent.ACTION_MAIN)
                    .setClassName(pkg, pkg + ".MainActivity").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            Object scene = field(activity, "scene");
            waitFocused(activity);
            main(() -> {
                require(visible(scene) && "menu".equals(field(scene, "page")), "Cold start shows menu");
                require(field(field(scene, "controller"), "frame") == null, "Cold start has no wallpaper");
                wallpaperCallback(scene);
                require(visible(scene) && "menu".equals(field(scene, "page")), "Wallpaper callback keeps menu visible");
                return null;
            });
            select(scene, "Музыка");
            select(scene, "Станции темы");
            select(scene, "9128 Live");
            main(() -> {
                require(visible(scene) && "music".equals(field(scene, "page")), "Station opens the music page");
                require(((Button) field(scene, "volumeControl")).hasFocus(), "Volume focused immediately");
                require("9128 Live".equals(call(field(scene, "music"), "title", new Class<?>[0])), "Correct station selected");
                return null;
            });
            sendKeyDownUpSync(KeyEvent.KEYCODE_DPAD_RIGHT);
            waitForIdleSync();
            require(getTargetContext().getSharedPreferences("tv", 0).getInt("music_volume", -1) == 40,
                    "Right key changes app volume without reopening settings");
            sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
            require(main(() -> visible(scene) && "menu".equals(field(scene, "page"))), "Back from music goes to root menu");
            sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
            require(main(() -> !visible(scene) && !activity.isFinishing()), "Back closes menu and keeps app open");
            sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
            require(main(() -> !activity.isFinishing() && (long) field(scene, "exitBackUntil") > 0),
                    "First Back arms exit");
            main(() -> {
                long now = SystemClock.uptimeMillis();
                activity.dispatchKeyEvent(new KeyEvent(now, now, KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_BACK, 1));
                require(!activity.isFinishing(), "Holding Back does not confirm exit");
                return null;
            });
            Thread.sleep(2150);
            sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
            require(main(() -> !activity.isFinishing()), "Expired confirmation starts a new countdown");
            sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
            require(main(activity::isFinishing), "Second Back exits");
            result.putString("stream", "PASS Android TV navigation: cold start, wallpaper callback, station, volume, menu Back, held Back, expiry and double Back\n");
            finish(Activity.RESULT_OK, result);
        } catch (Throwable e) {
            result.putString("stream", "FAIL " + android.util.Log.getStackTraceString(e));
            finish(Activity.RESULT_CANCELED, result);
        }
    }
}
