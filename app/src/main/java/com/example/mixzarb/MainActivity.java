package com.example.mixzarb;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;
import android.util.Pair;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.example.mixzarb.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    EditText inputText;
    EditText metronomeField;
    Button playButton;
    SeekBar metronomeBar;


    // Used to load the 'mixzarb' library on application startup.
    static {
        System.loadLibrary("mixzarb");
    }

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        inputText = findViewById(R.id.inputText);
        playButton = findViewById(R.id.button);
        metronomeField = findViewById(R.id.metronomeNumber);
        metronomeBar = findViewById(R.id.metronomeBar);

        metronomeBar.setProgress(100);
        metronomeField.setText("bpi: 100");

        metronomeBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {
                metronomeField.setText("bpi: " + metronomeBar.getProgress());
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        playButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                playButton.setClickable(false);
                String input = inputText.getText().toString();

                int metronome = metronomeBar.getProgress();
                playMusic(input, metronome);
                playButton.setClickable(true);
            }

        });
    }

    public void calculate_cycle_time() {
        int n = 20;
        final long startTime = System.currentTimeMillis();
        playOneNoteNTime(n);
        final long finishTime = System.currentTimeMillis();
        Log.d("TIME", "average execution time: " + (
                ((float)(finishTime - startTime)) / ((float) n)
        ));
    }

    public void invalidInput() {
        showToast("invalid input");
        return;
    }

    public void playNote(String note) {
        Log.d("NOTE", "Playing note " + note);

        MediaPlayer mp = getNoteMediaplayer(note);
        if (mp == null) {
            Log.e("NOTE", "MediaPlayer not found!");
            return;
        }

        mp.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mediaPlayer) {
                mediaPlayer.reset();
                mediaPlayer.release();
                mediaPlayer = null;
            }
        });

        mp.start();
    }

    private MediaPlayer getNoteMediaplayer(String note) {
        note = note.toLowerCase();
        MediaPlayer mp = null;
        switch (note) {
            case "do":
                mp = MediaPlayer.create(MainActivity.this, R.raw.dwo);
                break;

            case "re":
                mp = MediaPlayer.create(MainActivity.this, R.raw.re);
                break;

            case "mi":
                mp = MediaPlayer.create(MainActivity.this, R.raw.mi);
                break;

            case "fa":
                mp = MediaPlayer.create(MainActivity.this, R.raw.fa);
                break;

            case "sol":
                mp = MediaPlayer.create(MainActivity.this, R.raw.sol);
                break;

            case "la":
                mp = MediaPlayer.create(MainActivity.this, R.raw.la);
                break;

            case "ti":
                mp = MediaPlayer.create(MainActivity.this, R.raw.si);
                break;
        }

        return mp;
    }

    public native void playMusic(String input, int metronome);


    /**
     * A native method that is implemented by the 'mixzarb' native library,
     * which is packaged with this application.
     */
    public native String stringFromJNI();

    public native void playOneNoteNTime(int n);

    private void showToast(String text) {
        Toast.makeText(MainActivity.this, text, Toast.LENGTH_SHORT).show();
    }
}