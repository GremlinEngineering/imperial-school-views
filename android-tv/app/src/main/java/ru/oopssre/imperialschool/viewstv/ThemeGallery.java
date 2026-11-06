package ru.oopssre.imperialschool.viewstv;

import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.*;
import java.util.List;
import java.util.concurrent.*;

/** Focus previews a collection; only OK applies it. No slideshow or future-frame prefetch. */
final class ThemeGallery implements AutoCloseable {
    final TvScene scene;
    final ScrollView list;
    final ImageView image;
    final TextView title,description,state;
    final Handler main=new Handler(Looper.getMainLooper());
    final ExecutorService worker;
    Future<?> job,cacheJob;
    Runnable delayed;
    Bitmap bitmap;
    boolean closed;
    long generation;

    ThemeGallery(TvScene scene, List<Protocol.Theme> themes) {
        this.scene=scene;this.worker=scene.previewWorker;
        LinearLayout row=new LinearLayout(scene.context);
        row.setOrientation(LinearLayout.HORIZONTAL);
        int height=Math.max(scene.dp(280),scene.context.getResources().getDisplayMetrics().heightPixels-scene.dp(160));
        scene.content.addView(row,new LinearLayout.LayoutParams(-1,height));
        LinearLayout preview=new LinearLayout(scene.context);
        preview.setOrientation(LinearLayout.VERTICAL);
        LinearLayout.LayoutParams left=new LinearLayout.LayoutParams(0,-1,1);
        left.rightMargin=scene.dp(24);row.addView(preview,left);
        image=new ImageView(scene.context);image.setScaleType(ImageView.ScaleType.FIT_CENTER);
        image.setBackgroundColor(0xff0a0917);image.setContentDescription("Предпросмотр коллекции");
        preview.addView(image,new LinearLayout.LayoutParams(-1,scene.dp(180)));
        title=scene.text("",23);title.setPadding(0,scene.dp(14),0,scene.dp(8));
        title.setMaxLines(2);title.setEllipsize(android.text.TextUtils.TruncateAt.END);title.setTypeface(scene.context.getResources().getFont(R.font.oswald_semibold));
        preview.addView(title);
        description=scene.text("",18);description.setMaxLines(3);
        description.setEllipsize(android.text.TextUtils.TruncateAt.END);preview.addView(description);
        state=scene.text("",17);state.setTextColor(0xffb9b1ce);state.setPadding(0,scene.dp(10),0,0);preview.addView(state);
        list=new ScrollView(scene.context);list.setFillViewport(true);list.setVerticalFadingEdgeEnabled(true);list.setFadingEdgeLength(scene.dp(16));
        row.addView(list,new LinearLayout.LayoutParams(0,-1,1));
        LinearLayout choices=new LinearLayout(scene.context);choices.setOrientation(LinearLayout.VERTICAL);
        list.addView(choices,new ScrollView.LayoutParams(-1,-2));
        String selected=scene.repo.selected().id;
        for(String group:new String[]{"dynamic","weather","plain"}) {
            boolean found=false;
            for(Protocol.Theme theme:themes) {
                String kind=theme.kind.equals("dynamic")?"dynamic":theme.kind.equals("weather")?"weather":"plain";
                if(!kind.equals(group))continue;
                if(!found){TextView heading=scene.text(ThemeText.group(group),18);heading.setTextColor(0xffb9b1ce);heading.setPadding(0,scene.dp(8),0,scene.dp(12));choices.addView(heading);found=true;}
                Button button=scene.makeButton("theme:"+theme.id,(theme.id.equals(selected)?"✓ ":"")+ThemeText.title(theme),()->scene.chooseTheme(theme));
                button.setOnFocusChangeListener((v,focus)->{if(focus)focus(theme);});
                choices.addView(button,scene.buttonLayout());
            }
        }
        Protocol.Theme current=scene.repo.selected();
        if(!current.kind.equals("dynamic")) {
            Button parameters=scene.makeButton("collection","Параметры текущих обоев",scene::collectionMenu);
            choices.addView(parameters,scene.buttonLayout());
        }
    }
    void focus(Protocol.Theme theme) {
        if(closed)return;
        long token=++generation;
        if(delayed!=null)main.removeCallbacks(delayed);
        if(job!=null)job.cancel(true);if(cacheJob!=null)cacheJob.cancel(true);
        title.setText(ThemeText.title(theme));description.setText(ThemeText.description(theme));
        clearBitmap();state.setText("Загружаю превью…");
        delayed=()->{if(closed||token!=generation)return;cacheJob=scene.controller.cacheWorker.submit(()->loadCached(theme,token));};
        main.postDelayed(delayed,300);
    }
    void loadCached(Protocol.Theme theme,long token){
        try{
            Protocol.Frame frame=scene.repo.cached(theme);
            if(frame!=null){Bitmap decoded=scene.repo.decode(frame,720,405);publish(theme,token,decoded);return;}
        }catch(Exception ignored){if(Thread.currentThread().isInterrupted())return;}
        main.post(()->{if(!closed&&token==generation)job=worker.submit(()->loadNetwork(theme,token));});
    }
    void loadNetwork(Protocol.Theme theme,long token) {
        Bitmap decoded=null;
        try {
            Protocol.Frame frame=scene.repo.refresh(theme,scene.imagePin());
            if(Thread.currentThread().isInterrupted())return;
            decoded=scene.repo.decode(frame,720,405);
        }catch(Exception error){if(Thread.currentThread().isInterrupted())return;}
        publish(theme,token,decoded);
    }
    void publish(Protocol.Theme theme,long token,Bitmap result){
        main.post(()->{
            if(closed||token!=generation){if(result!=null)result.recycle();return;}
            if(result!=null){bitmap=result;image.setImageBitmap(result);state.setText(theme.id.equals(scene.repo.selected().id)?"Сейчас на экране":"OK — выбрать обои");}
            else state.setText("Не удалось загрузить превью. OK — выбрать коллекцию.");
        });
    }
    void clearBitmap(){image.setImageDrawable(null);if(bitmap!=null){bitmap.recycle();bitmap=null;}}
    public void close(){closed=true;generation++;if(delayed!=null)main.removeCallbacks(delayed);if(job!=null)job.cancel(true);if(cacheJob!=null)cacheJob.cancel(true);clearBitmap();}
    Future<?> drain(){if(delayed!=null)main.removeCallbacks(delayed);if(job!=null)job.cancel(true);return worker.submit(()->{});}
}
