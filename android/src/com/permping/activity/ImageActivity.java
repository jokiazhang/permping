
package com.permping.activity;
import com.permping.R;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;

public class ImageActivity extends Activity {
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.image_layout);
        
        final LinearLayout actionHide = (LinearLayout) findViewById(R.id.takePhoto);
        actionHide.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Log.d("AAAAAAAAAAAAAAAAAA", "Event caught");
            }
        });
        
    }
}
