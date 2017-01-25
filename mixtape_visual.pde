import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;
FFT spectrum;

String [] song = {"straight from the start.mp3", "pt1.mp3", "pt2.mp3", "crookeddreams.mp3", "yah.mp3", "wasabi.mp3", "interlude.mp3", "crazy.mp3"};
PImage cover;
int txtsz = 30;
boolean pause =false;
int current = 0;
int past = 0;
String a;
boolean rep = false;
boolean shuf = false;

void setup()
{
  size(800, 800);
  minim = new Minim(this);
  player = minim.loadFile(song[0], 2048);
  cover = loadImage("mixtape.jpg");
  meta = player.getMetaData();
  spectrum = new FFT(player.bufferSize(), player.sampleRate());
}

void draw() { 
  back();
  isPlaying();
  spectrum.forward(player.mix);
  freq();
  nextSong();
  currentSong();
  println("shuf", "c  p", "pause");
  println(shuf, current, past, pause);
}

void currentSong() {
  textSize(30);
  fill(255);

  ellipse(130, 90+txtsz*current, 10, 10);
  for (int i = 0; i < song.length; i++) {
    stroke(0);
    //text(i+1+") "+ song[i].substring(0, song[i].length() - 4), 150, 100 + txtsz*i);
    text(i+1+")"+ "????????", 150, 100 + txtsz*i);
  }
}


void back() {
  image(cover, 0, 0);
  fill(40, 40, 40, 70);
  rect(0, 0, width, height);
}
void isPlaying() {
  if (pause == true) {
    player.pause();
  } else {
    player.play();
  }
}

void nextSong() {
  if (((!player.isPlaying() && !pause) && (!shuf))) {
    player.pause();
    if (!shuf){
      current+=1;
    }
    else{
      past = current;
      //println("works");
      while (past == current){
        current = int(random(0.0, float(song.length)));
      }
      past = current;
    }
    player = minim.loadFile( song[current], 2048);
    player.play();
  } 
  if (current < 0) {
    current = song.length-1;
  }
}

void freq() {
  stroke(255);
  strokeWeight(4);
  fill(255);
  for (int i = 0; i < 100 - 1; i++) {
    if (spectrum.getBand(i)*2 > 200) {
      line((i*5)+150, 650, (i*5)+150, 450);
    } else {
      line((i*5)+150, 650, (i*5)+150, 650 - (spectrum.getBand(i)*2));
    }
  }
}



void keyReleased() {
  //songChange();
  if ((key==' ') && (pause == false)) {
    pause = true;
  } else {
    pause = false;
  }
  if ((keyCode == DOWN) || (keyCode == RIGHT)) {
    player.pause();
    if (!shuf){
      current+=1;
    }
    else{
      past = current;
      //println("works");
      while (past == current){
        current = int(random(0.0, float(song.length)));
      }
      past = current;
    }
    if (current < 0) {
      current = song.length-1;
    }
    a = song[current];
    player = minim.loadFile( a, 2048);
    player.play();
  }
  if (keyCode == UP) {
    player.pause();
    current-= 1;
    if (current < 0) {
      current = song.length-1;
    }
    a = song[current];
    player = minim.loadFile( a, 2048);
    player.play();
  }
  if (keyCode == LEFT) {
    player.pause();
    a = song[current];
    player = minim.loadFile( a, 2048);
    player.play();
  }
  //shuffle
  if ((key == 's') && (!shuf)){
    shuf = true;
  } 
  else if ((key == 's') && (shuf)){
    shuf = false;
  }
}

void repeat() {
  if (((rep) && (current == song.length - 1)) && (!player.isPlaying())) {
    current = 0;
    player.pause();
    a = song[current];
    player = minim.loadFile( a, 2048);
    player.play();
  }
}