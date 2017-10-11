package edu.northwestern.magnetometerv1;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.app.Activity;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;


public class MainActivity extends ActionBarActivity implements SensorEventListener{

	
	private static final String TAG = "MEDIA";
	private TextView tv1;
	private TextView tv2;
	private SensorManager sensor_manager = null;
	private Sensor magnetometer_uncalib= null;
	String sensorvendor =null;
	String sensorname =null;
	TextView xvalue;
	TextView yvalue;
	TextView zvalue;
	TextView vendor;
	TextView name;
	TextView sensor_accuracy;
	float x;
//	LinearLayout li;
	
	boolean save=false;
	Vector<Float> vx = new Vector(); 
	Vector<Float> vy = new Vector(); 
	Vector<Float> vz = new Vector(); 
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		sensor_manager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
		magnetometer_uncalib= sensor_manager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED);
		xvalue = (TextView) findViewById(R.id.xvalue);
		yvalue = (TextView) findViewById(R.id.yvalue);
		zvalue = (TextView) findViewById(R.id.zvalue);
		sensorvendor = magnetometer_uncalib.getVendor();
		vendor = (TextView) findViewById(R.id.vendor);
		name = (TextView) findViewById(R.id.sensor_name);
		sensorname = magnetometer_uncalib.getName();
		sensor_accuracy= (TextView) findViewById(R.id.sensor_accuracy);
		tv1 = (TextView) findViewById(R.id.TextView01);
		tv2 = (TextView) findViewById(R.id.TextView02);
//		li = (LinearLayout)findViewById(R.id.layout);

		
	}	
	

	public void onButton2Clicked(View v) {
		Toast.makeText(getApplicationContext(), "start button has been pressed", Toast.LENGTH_LONG).show();
		save=true;
		
	}


	public void onButton1Clicked(View v) {
		Toast.makeText(getApplicationContext(), "save button has been pressed", Toast.LENGTH_LONG).show();
		save=false;
		checkExternalMedia();
		writeToSDFile();
	}

	@Override
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
		// TODO Auto-generated method stub
		sensor_accuracy.setText("Sensor Accuracy : " + getSensorAccuracyAsString(accuracy));
		
		
	}
	
	private String getSensorAccuracyAsString(int accuracy) {
		String accuracyString = "";

		switch(accuracy) {
			case SensorManager.SENSOR_STATUS_ACCURACY_HIGH: accuracyString = "High"; break;
			case SensorManager.SENSOR_STATUS_ACCURACY_LOW: accuracyString = "Low"; break;
			case SensorManager.SENSOR_STATUS_ACCURACY_MEDIUM: accuracyString = "Medium"; break;
			case SensorManager.SENSOR_STATUS_UNRELIABLE: accuracyString = "Unreliable"; break;
			default: accuracyString = "Unknown";

			break;
		}

		return accuracyString;
	}
	
	@Override
	public void onSensorChanged(SensorEvent event) {
		synchronized (this){
			float raw_x= event.values[0];
			float raw_y= event.values[1];
			float raw_z= event.values[2];
			
			x=event.values[0];
			
			xvalue.setText(Float.toString(raw_x));
			yvalue.setText(Float.toString(raw_y));
			zvalue.setText(Float.toString(raw_z));
			vendor.setText("Vendor: "+sensorvendor);
			name.setText("Model: "+ sensorname);
			
			if(save==true){
			vx.add(raw_x);
			vy.add(raw_y);
			vz.add(raw_z);
			}

			
			
		}
		// TODO Auto-generated method stub
	}
	
	
	@Override
	protected void onResume() {
		super.onResume();
		sensor_manager.registerListener(this, magnetometer_uncalib, SensorManager.SENSOR_DELAY_FASTEST);
		
	  }
	
	@Override
	  protected void onPause() {
	    super.onPause();
	    sensor_manager.unregisterListener(this);
	  }

	//from stack overflow
	//check link from google
	private void checkExternalMedia(){
	    boolean mExternalStorageAvailable = false;
	    boolean mExternalStorageWriteable = false;
	    String state = Environment.getExternalStorageState();

	    if (Environment.MEDIA_MOUNTED.equals(state)) {
	        // Can read and write the media
	        mExternalStorageAvailable = mExternalStorageWriteable = true;
	    } else if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) {
	        // Can only read the media
	        mExternalStorageAvailable = true;
	        mExternalStorageWriteable = false;
	    } else {
	        // Can't read or write
	        mExternalStorageAvailable = mExternalStorageWriteable = false;
	    }   
	    tv1.setText("\n\nExternal Media: readable="
	            +mExternalStorageAvailable+" writable="+mExternalStorageWriteable);
	}	
	
//from stack overflow
	
	private void writeToSDFile(){

	    // Find the root of the external storage.
	    // See http://developer.android.com/guide/topics/data/data-  storage.html#filesExternal

	    File root = android.os.Environment.getExternalStorageDirectory(); 
	    //tv2.append("\nExternal file system root: "+root);

	    // See http://stackoverflow.com/questions/3551821/android-write-to-sd-card-folder

	    File dir = new File (root.getAbsolutePath() + "/download");
	    dir.mkdirs();
	    File file = new File(dir, "myData.txt");

	    try {
	        FileOutputStream f = new FileOutputStream(file);
	        PrintWriter pw = new PrintWriter(f);
        	pw.println("x-axis");
	        for(int i =0; i < vx.size(); i++){
	        	pw.println(vx.get(i));
	        }
	        pw.println();
	        pw.println();
	        pw.println();
	        pw.println("y-axis");
	        for(int i =0; i < vy.size(); i++){
	        	pw.println(vy.get(i));
	        }
	        pw.println();
	        pw.println();
	        pw.println();
        	pw.println("z-axis");
	        for(int i =0; i < vz.size(); i++){
	        	pw.println(vz.get(i));
	        }
	        pw.flush();
	        pw.close();
	        f.close();
	    } catch (FileNotFoundException e) {
	        e.printStackTrace();
	        Log.i(TAG, "******* File not found. Did you" +
	                " add a WRITE_EXTERNAL_STORAGE permission to the   manifest?");
	    } catch (IOException e) {
	        e.printStackTrace();
	    }   

	    tv2.setText("\n\nFile written to "+file);
	}	
		
	
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
}
