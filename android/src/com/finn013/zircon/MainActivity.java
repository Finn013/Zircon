package com.finn013.zircon;

import android.app.Activity;
import android.content.ClipData;
import android.content.ContentValues;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Base64;
import android.webkit.*;
import android.widget.Toast;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

public class MainActivity extends Activity {
  private WebView web;
  private ValueCallback<Uri[]> fileCb;
  private static final int PICK = 1;

  private static final String INJECT =
    "(function(){if(window.__cnHook)return;window.__qHook=1;" +
    "var oc=HTMLAnchorElement.prototype.click;" +
    "HTMLAnchorElement.prototype.click=function(){var h=this.href||'',n=this.download;" +
    "if(n&&(h.indexOf('blob:')==0||h.indexOf('data:')==0)){fetch(h).then(function(r){return r.blob();})" +
    ".then(function(b){var fr=new FileReader();fr.onload=function(){var d=String(fr.result);ZirconAndroid.saveFile(n,d.substring(d.indexOf(',')+1),b.type||'');};fr.readAsDataURL(b);});return;}return oc.call(this);};})();";

  @Override protected void onCreate(Bundle b) {
    super.onCreate(b);
    web = new WebView(this);
    setContentView(web);
    WebSettings s = web.getSettings();
    s.setJavaScriptEnabled(true);
    s.setDomStorageEnabled(true);
    s.setDatabaseEnabled(true);
    s.setAllowFileAccess(true);
    s.setAllowContentAccess(true);
    s.setTextZoom(100);
    web.addJavascriptInterface(new Bridge(), "ZirconAndroid");
    web.setWebViewClient(new WebViewClient() {
      @Override public boolean shouldOverrideUrlLoading(WebView v, WebResourceRequest r) {
        Uri u = r.getUrl();
        if ("file".equals(u.getScheme())) return false;
        try { startActivity(new Intent(Intent.ACTION_VIEW, u)); } catch (Exception e) {}
        return true;
      }
      @Override public void onPageFinished(WebView v, String url) { v.evaluateJavascript(INJECT, null); }
    });
    web.setWebChromeClient(new WebChromeClient() {
      @Override public boolean onShowFileChooser(WebView v, ValueCallback<Uri[]> cb, FileChooserParams p) {
        if (fileCb != null) fileCb.onReceiveValue(null);
        fileCb = cb;
        Intent i = new Intent(Intent.ACTION_GET_CONTENT);
        i.addCategory(Intent.CATEGORY_OPENABLE);
        String[] t = p.getAcceptTypes();
        String type = "*/*";
        if (t != null && t.length > 0 && t[0] != null && t[0].startsWith("image")) type = "image/*";
        i.setType(type);
        if (p.getMode() == FileChooserParams.MODE_OPEN_MULTIPLE) i.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
        try { startActivityForResult(Intent.createChooser(i, "Zircon"), PICK); }
        catch (Exception e) { fileCb = null; return false; }
        return true;
      }
    });
    if (b != null) web.restoreState(b); else web.loadUrl("file:///android_asset/index.html");
  }

  @Override protected void onSaveInstanceState(Bundle o) { super.onSaveInstanceState(o); web.saveState(o); }

  @Override protected void onActivityResult(int req, int res, Intent data) {
    if (req == PICK && fileCb != null) {
      Uri[] r = null;
      if (res == RESULT_OK && data != null) {
        ClipData c = data.getClipData();
        if (c != null && c.getItemCount() > 0) { r = new Uri[c.getItemCount()]; for (int k = 0; k < r.length; k++) r[k] = c.getItemAt(k).getUri(); }
        else if (data.getData() != null) r = new Uri[]{data.getData()};
      }
      fileCb.onReceiveValue(r); fileCb = null;
    } else super.onActivityResult(req, res, data);
  }

  @Override public void onBackPressed() { if (web.canGoBack()) web.goBack(); else super.onBackPressed(); }

  class Bridge {
    @JavascriptInterface public void saveFile(final String name, final String b64, final String mime) {
      String msg;
      try {
        byte[] bytes = Base64.decode(b64, Base64.DEFAULT);
        if (Build.VERSION.SDK_INT >= 29) {
          ContentValues cv = new ContentValues();
          cv.put(MediaStore.MediaColumns.DISPLAY_NAME, name);
          cv.put(MediaStore.MediaColumns.MIME_TYPE, mime.length() > 0 ? mime : "application/octet-stream");
          cv.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS + "/Zircon");
          String rel = Environment.DIRECTORY_DOWNLOADS + "/Zircon/";
          Uri u = null;
          android.database.Cursor cur = null;
          try {
            cur = getContentResolver().query(MediaStore.Downloads.EXTERNAL_CONTENT_URI, new String[]{MediaStore.MediaColumns._ID},
              MediaStore.MediaColumns.DISPLAY_NAME + "=? AND " + MediaStore.MediaColumns.RELATIVE_PATH + "=?", new String[]{name, rel}, null);
            if (cur != null && cur.moveToFirst()) u = android.content.ContentUris.withAppendedId(MediaStore.Downloads.EXTERNAL_CONTENT_URI, cur.getLong(0));
          } catch (Exception qe) { u = null; } finally { if (cur != null) cur.close(); }
          if (u == null) u = getContentResolver().insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, cv);
          OutputStream os = getContentResolver().openOutputStream(u, "wt");
          os.write(bytes); os.close();
        } else {
          if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.WRITE_EXTERNAL_STORAGE}, 2);
          }
          File d = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "Zircon");
          d.mkdirs();
          FileOutputStream f = new FileOutputStream(new File(d, name)); f.write(bytes); f.close();
        }
        msg = "Сохранено: Загрузки/Zircon/" + name;
      } catch (Exception e) { msg = "Не удалось сохранить: " + e.getMessage(); }
      final String m = msg;
      runOnUiThread(new Runnable() { public void run() { Toast.makeText(MainActivity.this, m, Toast.LENGTH_LONG).show(); } });
    }
  }
}
