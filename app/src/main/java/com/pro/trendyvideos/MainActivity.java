package com.pro.trendyvideos;

import androidx.appcompat.app.AppCompatActivity;

import android.app.ProgressDialog;
import android.content.SharedPreferences;

import android.os.Bundle;
import android.provider.Settings;

import android.util.Log;
import android.view.View;
import android.view.Window;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.adjust.sdk.Adjust;

import com.adjust.sdk.webbridge.AdjustBridge;

import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    public String ga_id;
    public String package_name;
    public String adjust_id;
    public String device_id;
    public String locale_id;

    public String Url;
    public String Url_1;
    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        webView = findViewById(R.id.webView);

        SharedPreferences prefs = getSharedPreferences("info", MODE_PRIVATE);
        ga_id = prefs.getString("ga_id", "");

        package_name = BuildConfig.APPLICATION_ID;

        device_id = Settings.Secure.getString(MainActivity.this.getContentResolver(), Settings.Secure.ANDROID_ID);

        adjust_id = Adjust.getAdid();

        String[] language = Locale.getDefault().toString().split("_");
        locale_id = language[0];

        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebChromeClient(new WebChromeClient());
        webView.setWebViewClient(new WebViewClient() {
            public void onPageFinished(WebView view, String url) {

            }
        });

        Url = "https://d1d549ovjx5nbf.cloudfront.net?packageName=" + package_name + "&lang=" + locale_id + "&deviceId=" + device_id + "&isPremium=false&gpsAdid=" + ga_id + "&adjustId=" + adjust_id;
        Url_1 = "http://d1d549ovjx5nbf.cloudfront.net?packageName=" + package_name + "&lang=" + locale_id + "&deviceId=" + device_id + "&isPremium=false&gpsAdid=" + ga_id + "&adjustId=" + adjust_id;
        AdjustBridge.registerAndGetInstance(getApplication(), webView);
        try {

            webView.loadUrl(Url);

            Log.i("load url", Url);
        } catch (Exception e) {

            try {
                webView.loadUrl(Url_1);
            } catch (Exception d) {
                d.getMessage();
            }
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }
}
