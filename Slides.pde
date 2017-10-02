int START, OVERVIEW, WHATISIT, MYPROJECTS, DRAWHESSE, WHYTECH, JOBS, HIGHPAY, TOOLSET, WOMENINTECH, PERCENTWOMEN, WOMENTREND, WOMENK12, DEBB, WHITEPRIV, WHYCARE, MORE, CITED;
int totalSlides = 0;
int tool = 0;
PImage romeo, blood, wizard, mathematica;

void initModes() {
  romeo = loadImage("romeo.png");
  blood = loadImage("bloodmeridian.png");
  wizard = loadImage("wizard.png");
  mathematica = loadImage("mathematica.png");
  
  int n = 0;
  START = n++;
  OVERVIEW = n++; 
  WHATISIT = n++; 
  MYPROJECTS = n++;
  DRAWHESSE = n++;
  WHYTECH = n++; 
  JOBS = n++;
  //HIGHPAY = n++;
  TOOLSET = n++;
  WOMENINTECH = n++;
  PERCENTWOMEN = n++; 
  WOMENTREND = n++;
  WOMENK12 = n++;
  DEBB  = n++;
  WHITEPRIV = n++;
  WHYCARE = n++;
  //MORE = n++;
  CITED = n++;
  totalSlides = n;
}

void slideStart() {

  background(0);
  ////obtain an ArrayList of the users currently being tracked
  ArrayList<PImage> bodyTrackList = kinect.getBodyTrackUser();
  //iterate through all the users
  fill(255, 0, 0);
  for (int i = 0; i < bodyTrackList.size(); i++) {
    PImage bodyTrackImg = (PImage)bodyTrackList.get(i);
    if (i <= 2)
      image(bodyTrackImg, 0, 0);
    else
      image(bodyTrackImg, 0, 0);
  }
  //image(kinect.getColorImage(), 0, 0, width, height);
  //drawSkeleton();
  showTitleCenter("Computer Science");
}

void slideOverview() {
  colorMode(HSB, 255);
  background((millis()/50)%255, 255, 125);
  showTitle("Overview", color(255));
  if (!attractMode && millis() - startTime > 3000 && millis() - startTime < 12000) attractMode = true;
  else if (attractMode && millis() - startTime > 12000) {
    attractMode = false;
    flock.startFlying();
  }
  drawFlocking(color(255, 80));
  textSize(100);
  stroke(255);
  fill(255);
  if (overviewStep > 0) text("1) Importance of computer science", 130, 450);
  if (overviewStep > 1) text("2) Diversity in tech", 130, 630);
}

void slideWhatIsIt() {

  background(0);
  drawTunnel();
  showTitleCenter("What is computer science?");
}

void slideMyProjects() {

  background(0);
  image(myMovie, 0, 0, width, height);
}

void slideDrawHesse() {
  background(0);
  drawHesse();
}

void slideWhyTech() {
  background(255);
  drawWaves();
  showTitleCenter("Why computer science?", color(0));
}

void slideJobs() {
  background(0);
  computingJobs();
}

void slideHighPay() {
  background(0);
  showTitleCenter("$$$");
}

void slideToolset() {
  background(0);
  if (tool == 0) {
    // a toolset for
    showTitleCenter("every field, y'all");
  }
  else if (tool == 1) {
    // math - pesky integral? let's use mathematica
    image(mathematica, (width - mathematica.width)/2, 200);
    showTitle("Math");
  }
  else if (tool == 2) {
    
  }
  else if (tool == 3) {
    // history
  }
  else if (tool == 4) {
    // science - 
  }
  else if (tool == 5) {
    background(255);
    // english - want to compare and contrast puncuation style, use a programming language to make a heat map
    // Periods and question marks and exclamation marks are red. Commas and quotation marks are green. Semicolons and colons are blue.
    // https://medium.com/@neuroecology/punctuation-in-novels-8f316d542ec4
   showTitle("English?", color(0));
   int w = wizard.width;
   int sp = (width - w*3)/4;
    image(wizard, sp, 200);
    
    image(blood, w+sp*2, 200);
   
    image(romeo, w*2+sp*3, 200);
    
  }
}

void slideWomenInTech() {
  background(0);
  showTitleCenter("Women in tech");
}

void slideWomenTrend() {
  background(0);
  colorMode(RGB, 255);
  drawWomenGraph();
}

void slidePercentWomen() {
  background(0);
  for (int i = 0; i < people.length; i++) {
    if (millis() - startTime > 2000) people[i].move();
    people[i].display();
  }
}

void slideWomenK12() {
  background(0);
  int topMarg = 250;
  int textTop = topMarg - 40;
  int spacing = (width - 3 * 5 * 80-20)/6;
  int leftMarg = 2*spacing;

  for (int p = 0; p < 3; p++) {
    for (int i = 0; i < 5; i++) {
      people[i].display(leftMarg + p *(80*5+spacing), i*130+ topMarg, true, rightUp || leftUp);
    }
    for (int i = 1; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        people[i*5 + j].display(i*80+leftMarg+p*(80*5+spacing), j*130+topMarg, false, false);
      }
    }
  }

  stroke(255);
  fill(255);
  textSize(100);
  text("AP CS", leftMarg + 80*5/2 - textWidth("AP CS")/2, textTop);
  text("College", leftMarg + 1.5*80 * 5 + spacing - textWidth("College")/2, textTop);
  text("Jobs", leftMarg + 2.5*80 * 5 + 2*spacing - textWidth("Jobs")/2, textTop);
  textSize(18);
  text("\"The diversity problem starts in K-12\" Code.org, code.org/promote. Accessed 27 Sept. 2017.", leftMarg, height - 50);
}

void slidedeBB() {
  colorMode(HSB, 255);
  background((millis()/100)%100 + 50, 255, 200);
  drawSwirl();
  
  showTitleCenter("My Story", color(255));
  colorMode(RGB, 255);
}

void slideWhitePriv() {
  background(0);
  drawSquares();
  showTitle("My White Privilege");
}

void slideWhyCare() {
  background(0);
  drawShapes();
  showTitle("Why should we care?");
}

void slideMore() {
  background(0);
  showTitle("Want to continue the conversation?");
  drawWaves();
}

void showTitle(String title) {
  showTitle(title, color(255));
}

void showTitle(String title, color t) {
  textSize(100);
  stroke(t);
  fill(t);
  text(title, width/2-textWidth(title)/2, 130);
  strokeWeight(2);
  line(width/2-textWidth(title)/2, 140, width/2+textWidth(title)/2, 140);
}

void showTitleCenter(String title, color c) {
  textSize(100);
  int w = int(textWidth(title));
  int lfmarg = (width - w)/2;
  fill(c);
  stroke(c);
  text(title, lfmarg, height/2-50);
}

void showTitleCenter(String title) {
  showTitleCenter(title, color(255));
}

void worksCited() {
  background(0);
  showTitle("Works Cited");
  int leftMargin = 100;
  stroke(255);
  fill(255);
  textSize(40);

  int i = 200;
  int spacer = 100;

  text("Henn, Steve. \"When Women Stopped Coding.\" NPR, 21 Oct. 2014,", leftMargin, i);
  i+= spacer/2;
  text("www.npr.org/sections/money/2014/10/21/357629765/when-women-stopped-coding. Accessed 26 Sept. 2017.", leftMargin + 30, i);

  i+= spacer;
  text("\"The diversity problem starts in K-12\" Code.org, code.org/promote. Accessed 27 Sept. 2017.", leftMargin, i);

  i+=spacer;
  text("\"What's wrong with this picture?\" Code.org, code.org/promote. Accessed 27 Sept. 2017.", leftMargin, i);
  
  i+=spacer;
  text("https://www.openprocessing.org/sketch/152169", leftMargin, i);
  
  i+=spacer;
  text("https://www.openprocessing.org/sketch/205584", leftMargin, i);
  
  i+=spacer;
  text("https://medium.com/@neuroecology/punctuation-in-novels-8f316d542ec4", leftMargin, i);
}