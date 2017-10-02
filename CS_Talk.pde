
import processing.video.*;
Movie myMovie;

import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;
KinectPV2 kinect;

PFont font;
PImage boy;
PImage girl;
PImage boydown;
PImage girldown;

int currentSlide = 0;

long startTime = 0;
int overviewStep = 0;

StickFigure [] people;


void setup() {
  size(1920, 1080, P3D);
  initModes();
  initTable();
  initKinect();
  initFlocking();
  people = new StickFigure[100];
  boy = loadImage("boy100.png");
  girl = loadImage("girl100.png");
  boydown = loadImage("boy100down.png");
  girldown = loadImage("girl100down.png");

  font = createFont("HelveticaNeueThin.ttf", 100);
  textFont(font);

  myMovie = new Movie(this, "myProjects780.mov");
  //myMovie.loop();
  //myMovie.play();
  //println(myMovie.available());

  for (int i = 0; i < 100; i++) {
    boolean isFemale = i > 87;
    people[i] = new StickFigure((i % 20)*80+(width - 20*80)/2, (i/20) * 130+200, isFemale);
  }
  initSmoke();
  initShapes();
  initWaves();
  initTunnel();
  currentSlide = TOOLSET;
}

void draw() {
  checkSkeleton();
  drawSlides();
  //drawWomenGraph();
  //image(kinect.getDepthMaskImage(), 0, 0);


  //image(kinect.getColorImage(), 0, 0, width, height);
  //drawSkeleton();


  //fill(255, 0, 0);
  //text(frameRate, 50, 50);
}


void drawSlides() {
  if (currentSlide == START) { 
    slideStart();
  } else if (currentSlide == OVERVIEW) {  
    slideOverview();
  } else if (currentSlide == WHATISIT) {  
    slideWhatIsIt();
  } else if (currentSlide == MYPROJECTS) {
    slideMyProjects();
  } else if (currentSlide == DRAWHESSE) {
    slideDrawHesse();
  } else if (currentSlide == WHYTECH) {  
    slideWhyTech();
  } else if (currentSlide == JOBS) {
    slideJobs();
  } else if (currentSlide == HIGHPAY) {
    slideHighPay();
  } else if (currentSlide == TOOLSET) {
    slideToolset();
  } else if (currentSlide == WOMENINTECH) {
    slideWomenInTech();
  } else if (currentSlide == PERCENTWOMEN) {  
    raiseEmUp = true;
    slidePercentWomen();
  } else if (currentSlide == WOMENTREND) {

    slideWomenTrend();
  } else if (currentSlide == WOMENK12) {
    slideWomenK12();
  } else if (currentSlide == DEBB) {  
    raiseEmUp = false;
    slidedeBB();
  } else if (currentSlide == WHITEPRIV) {  
    slideWhitePriv();
  } else if (currentSlide == WHYCARE) {  
    slideWhyCare();
  } else if (currentSlide == MORE) {  
    slideMore();
  } else if (currentSlide == CITED) {
    worksCited();
  }
}

void keyPressed() {
  if (keyCode == RIGHT) advanceSlide();
  else if (keyCode == LEFT) previousSlide();
}

void advanceSlide() {
  if (currentSlide == OVERVIEW) {
    overviewStep++;
    if (overviewStep > 2) {
      overviewStep = 2;
      currentSlide++;
    }
  } else if (currentSlide == JOBS) {
    jobIndex++;
    if (jobIndex > 3) {
      jobIndex = 3;
      currentSlide++;
    }
  } else if (currentSlide == TOOLSET) {
    tool++;
    if (tool > 5) {
      tool = 5;
      currentSlide++;
    }
  }else {
    currentSlide++;
    if (currentSlide == OVERVIEW) startTime = millis();
    else if (currentSlide == DEBB) deBBFlag = true;
    else if (currentSlide == PERCENTWOMEN) startTime = millis();
    else if (currentSlide == MYPROJECTS) myMovie.play();
    else if (currentSlide == MYPROJECTS + 1) myMovie.pause();
    else if (currentSlide >= totalSlides) currentSlide = totalSlides-1;
  }
}

void previousSlide() {
  if (currentSlide == OVERVIEW) {
    overviewStep--;
    if (overviewStep < 0) {
      overviewStep = 0;
      currentSlide--;
    }
  } else if (currentSlide == JOBS) {
    jobIndex--;
    if (jobIndex < 0) {
      jobIndex = 0;
      currentSlide--;
    }
  } else if (currentSlide == TOOLSET) {
    tool--;
    if (tool < 0) {
      tool = 0;
      currentSlide--;
    }
  }
  else {
    currentSlide--;
    if (currentSlide == MYPROJECTS -1) myMovie.pause();
    if (currentSlide < 0) currentSlide = 0;
  }
}


// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

//----------------------------------------------------------------------------------------------------