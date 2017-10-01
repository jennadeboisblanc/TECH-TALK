int START, OVERVIEW, WHATISIT, MYPROJECTS, DRAWHESSE, WHYTECH, PERCENTWOMEN, WOMENTREND, WOMENK12, DEBB, WHITEPRIV, WHYCARE, MORE, CITED;
int totalSlides = 0;

void initModes() {
  int n = 0;
  START = n++;
  OVERVIEW = n++; 
  WHATISIT = n++; 
  MYPROJECTS = n++;
  DRAWHESSE = n++;
  WHYTECH = n++; 
  PERCENTWOMEN = n++; 
  WOMENTREND = n++;
  WOMENK12 = n++;
  DEBB  = n++;
  WHITEPRIV = n++;
  WHYCARE = n++;
  MORE = n++;
  CITED = n++;
  totalSlides = n;
}

void slideStart() {
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
  showTitle("Tech");
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
  showTitle("What is computer science?");
  
}

void slideMyProjects() {
  image(myMovie, 0, 0);
}

void slideDrawHesse() {
  drawHesse();
}

void slideWhyTech() {
  showTitle("Why is computer science?");
  computingJobs();
}

void slideWomenTrend() {
  showTitle("Women in tech");

  drawWomenGraph();
}

void slidePercentWomen() {
  for (int i = 0; i < people.length; i++) {
    if (millis() - startTime > 2000) people[i].move();
    people[i].display();
  }
}

void slideWomenK12() {

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
  showTitle("My Story");
}

void slideWhitePriv() {
  showTitle("My White Privilege");
}

void slideWhyCare() {
  showTitle("Why should we care?");
}

void slideMore() {
  showTitle("Want to continue the conversation?");
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

void worksCited() {
  showTitle("Works Cited");
  int leftMargin = 100;
  stroke(255);
  fill(255);
  textSize(26);

  int i = 200;

  text("Henn, Steve. \"When Women Stopped Coding.\" NPR, 21 Oct. 2014,", leftMargin, i);
  i+= 30;
  text("www.npr.org/sections/money/2014/10/21/357629765/when-women-stopped-coding. Accessed 26 Sept. 2017.", leftMargin + 30, i);

  i+= 50;
  text("\"The diversity problem starts in K-12\" Code.org, code.org/promote. Accessed 27 Sept. 2017.", leftMargin, i);

  i+=50;
  text("\"What's wrong with this picture?\" Code.org, code.org/promote. Accessed 27 Sept. 2017.", leftMargin, i);
}