//
// a template for receiving kinect skeleton tracking osc messages from
// Ryan Challinor's Synapse for Kinect application:
// http://synapsekinect.tumblr.com/post/6307790318/synapse-for-kinect
//
// this example includes a class to abstract the Skeleton data
//
// 2012 Dan Wilcox danomatika.com
// for the IACD Spring 2012 class at the CMU School of Art
//
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import oscP5.*;
OscP5 oscP5;

import com.getflourish.stt.*;
STT stt;
String result;
String danced;
int m;

//Our code
PFont f;

float button_x = 320;
float button_y = 300;
float button_w = 200;
float button_h = 80;

int screen; //0=Main menu, 1=Game


// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

void setup() {
 size(640, 480);
 frameRate(30);

 String key = "AIzaSyAKqQFEOpUqllTDn9RWUbCjep6pSeREUeo";
 stt = new STT(this, key);
 stt.enableDebug();
 stt.setLanguage("en"); 

 // Some text to display the result
 textFont(createFont("Arial", 24,true));
 result = "";
 danced = "";
 oscP5 = new OscP5(this, 12345);

 //Our code
 screen=0;
  f = createFont("Arial",16,true);
}

void draw() {  
background(255);
rectMode(CENTER);

switch (screen){
case 0:

 draw_menu();

 break;
 case 1:
 skeleton.update(oscP5);
 draw_infos();
 draw_body();
 //println(result);
 if(result.equals("cat"))
 {
   if(danced=="")
   {
       if(analyze_body("c"))
       {
         danced="c";
       }

   }
   else if(danced=="c")
   {
      if(analyze_body("a"))
      {
         {
         danced="ca";
       }
      }
   }
   else if(danced=="ca")
   {
   if(analyze_body("t"))
      {
         {
         danced="cat";
       }
      }
   }
 }
}
}


public void draw_menu()
{
  textFont(f,30);                 // STEP 4 Specify font to be used
   fill(0);         // STEP 5 Specify font color 
   text("Dance your Words!",200,150);  // STEP 6 Display Text

   rect(button_x,button_y,button_w,button_h);
   fill(255);
   text("Start!",280,310);

     if(mousePressed)
       {
          if(mouseX > (button_x - button_w/2) && mouseX < (button_x + button_w/2) && mouseY > (button_y - button_h/2) && mouseY < (button_y + button_h/2))
          {
                 println("The mouse is pressed and over the button");
                 screen=1;
          }
      }

}
public void draw_infos()
{
 fill(0);
 if(result!="" && danced!="cat") 
 {
   m = millis();
 text("You said: " + result, 100, 50);

 text("You danced: " + danced, 300, 50);
 }
 else if(danced == "cat") {
   text("You did it !!! Time used: " + m/1000 + "s",150,50); 
 }
 else
 {
    text("Hold a button and Say something!",100,50); 
 }
}


// update and draw the skeleton if it's being tracked
public void draw_body()
{
  if(skeleton.isTracking()) {

    PVector v;  // a temp vector to use for joint positions
    Joint j = null;    // a temp Joint
    stroke(0);
    strokeWeight(2);
    noFill();

    // head
    v = skeleton.getJoint("head").posScreen;
    ellipse(v.x, v.y, 100, 100);

    // torso
    beginShape();
      v = skeleton.getJoint("leftshoulder").posScreen;
      vertex(v.x, v.y);
       v = skeleton.getJoint("rightshoulder").posScreen;
      vertex(v.x, v.y);
       v = skeleton.getJoint("righthip").posScreen;
      vertex(v.x, v.y);
      v = skeleton.getJoint("lefthip").posScreen;
      vertex(v.x, v.y);
    endShape(CLOSE);

    // left arm
    beginShape(LINES);
      v = skeleton.getJoint("leftshoulder").posScreen;
      vertex(v.x, v.y);
      v = skeleton.getJoint("leftelbow").posScreen;
      vertex(v.x, v.y);
      vertex(v.x, v.y);
      j = skeleton.getJoint("lefthand");
      v = j.posScreen;
      vertex(v.x, v.y);
    endShape(); 
    // draw a green hand if a hit movement was detected
    if(j.hitDetected())
      fill(0, 255, 0);
    else
      noFill();
    rect(v.x, v.y, 20, 20);

    // right arm
    beginShape(LINES);
      v = skeleton.getJoint("rightshoulder").posScreen;
      vertex(v.x, v.y);
      v = skeleton.getJoint("rightelbow").posScreen;
      vertex(v.x, v.y);
      vertex(v.x, v.y);
      j = skeleton.getJoint("righthand");
      v = j.posScreen;
      vertex(v.x, v.y);
    endShape();
    // draw a green hand if a hit movement was detected
    if(j.hitDetected())
      fill(0, 255, 0);
    else
      noFill();
    rect(v.x, v.y, 20, 20);

    // legs
    beginShape(LINES);
      v = skeleton.getJoint("lefthip").posScreen;
      vertex(v.x, v.y);
      v = skeleton.getJoint("leftknee").posScreen;
      vertex(v.x, v.y);
      vertex(v.x, v.y);
      v = skeleton.getJoint("leftfoot").posScreen;
      vertex(v.x, v.y);
    endShape();
    rect(v.x, v.y, 40, 20);
    beginShape(LINES);
      v = skeleton.getJoint("righthip").posScreen;
      vertex(v.x, v.y);
      v = skeleton.getJoint("rightknee").posScreen;
      vertex(v.x, v.y);
      vertex(v.x, v.y);
      v = skeleton.getJoint("rightfoot").posScreen;
      vertex(v.x, v.y);
    endShape();
    rect(v.x, v.y, 40, 20);

  //println(skeleton.toString());
  }
}

public boolean analyze_body(String letter)
{
 println(letter);
   if(letter=="c")
   {
      if( ((abs(skeleton.getJoint("righthand").posScreen.x-skeleton.getJoint("lefthand").posScreen.x))<60) && ((abs(skeleton.getJoint("righthand").posScreen.y-skeleton.getJoint("lefthand").posScreen.y))>170))
      {
        return true;
      }

     return false;
   }
   else if (letter=="a")
   {
      if( ((abs(skeleton.getJoint("righthand").posScreen.x-skeleton.getJoint("lefthand").posScreen.x))<30) && ((abs(skeleton.getJoint("righthand").posScreen.y-skeleton.getJoint("lefthand").posScreen.y))<30))
      {
        return true;
      }
      return false;
   }
   else if (letter=="t")
   {
       if( ((abs(skeleton.getJoint("righthand").posScreen.x-skeleton.getJoint("lefthand").posScreen.x))>300) && ((abs(skeleton.getJoint("righthand").posScreen.y-skeleton.getJoint("lefthand").posScreen.y))<20))
      {
        return true;
      }
      return false;
   }

 return false;
}
// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
 skeleton.parseOSC(m);
}

// STT CALLBACK FUNCTIONS

// Method is called if transcription was successfull 
void transcribe (String utterance, float confidence) 
{
 println(utterance);
 result = utterance;

}

// Use any key to begin and end a record
public void keyPressed () {
 stt.begin();
}
public void keyReleased () {
 stt.end();
}
