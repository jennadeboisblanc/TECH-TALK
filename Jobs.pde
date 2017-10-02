int jobIndex = 0;

void computingJobs() {
  int leftMargin = 300;
  int topMargin = 200;
  int gHeight = height-topMargin*2;
  int x1 = int(map(2011, 2011, 2020, leftMargin, width - leftMargin));
  int x2 = int(map(2020, 2011, 2020, leftMargin, width - leftMargin));
  int yJob1 = int(map(180000, 0, 1400000, topMargin + gHeight, topMargin));
  int yJob2 =  int(map(1400000, 0, 1400000, topMargin + gHeight, topMargin));
  int yStud1 = int(map(40000, 0, 1400000, topMargin + gHeight, topMargin));
  int yStud2 = int(map(400000, 0, 1400000, topMargin + gHeight, topMargin));

  stroke(255);
  textSize(30);
  strokeWeight(4);

  //y axis
  for ( int i = 0; i < 8; i++) {
    int y = int(map(i*200000, 0, 1400000, topMargin+gHeight, topMargin));
    line(leftMargin-5, y, leftMargin + 5, y);
    text(i*20000, leftMargin - textWidth(i*200000+"") - 5, y);
  }

  // jobs
  if (jobIndex > 1) {
    stroke(#FCAE03);
    fill(#FCAE03);
    //pushMatrix();
    //translate(leftMargin-30, topMargin + gHeight/2+ textWidth("Jobs")/2);
    //rotate(radians(-90));
    //textSize(90);
    //text("Jobs", 0, 0);
    //popMatrix();


    beginShape();
    vertex(x1, yJob1);
    vertex(x2, yJob2);
    vertex(x2, topMargin+gHeight);
    vertex(x1, topMargin+gHeight);
    endShape();
  }
  if (jobIndex == 1) {
    textSize(100);
    fill(255);
    stroke(255);
    int xv = 700;
    int yv =  topMargin + gHeight - 230;
    text("400,000 CS students", xv,yv);
    textSize(70);
    text("by 2020", xv + 100, yv + 80);
    drawEndPointStud(topMargin, leftMargin, gHeight);
  } else if (jobIndex == 2) {
    textSize(100);
    fill(255);
    stroke(255);
    int xv = 700;
    int yv = 200;
    text("1.4 million CS jobs", xv, yv);
    textSize(70);
    text("by 2020", xv+200, yv+70);

    drawEndPointJobs(topMargin, leftMargin, gHeight);
  } else if (jobIndex == 3) {
    textSize(100);
    fill(255);
    stroke(255);
    int xv = 350;
    int yv = 200;
    text("1 million UNFILLED CS jobs", xv, yv);
    textSize(70);
    text("by 2020", xv + 100, yv + 70);
    //strokeWeight(8);
    //line(width - leftMargin + 20, getYJobs(1.0, topMargin, gHeight), width - leftMargin + 20, getYStud(1.0, topMargin, gHeight));
  }

  stroke(255);
  fill(255);
  line(x1, topMargin + gHeight, x1, topMargin);

  // students
  if (jobIndex > 0) {
    stroke(#1AF5FF);
    fill(#1AF5FF);
    beginShape();
    vertex(x1, yStud1);
    vertex(x2, yStud2);
    vertex(x2, topMargin + gHeight);
    vertex(x1, topMargin + gHeight);
    endShape();
  }

  // x axis
  int ts = 40;
  textSize(ts);
  stroke(255);
  fill(255);
  line(x1, topMargin + gHeight, x2, topMargin + gHeight);
  for ( int i = 0; i < 10; i+=3) {
    int x = int(map(2011+i, 2011, 2020, leftMargin, width - leftMargin));
    line(x, topMargin + gHeight - 5, x, topMargin + gHeight + 5);
    text(2011+i, x-textWidth((i+2001)+"")/2, topMargin + gHeight + ts/2 + 30);
  }
  //drawEquation();
  //drawPoint(topMargin, leftMargin, gHeight);
  textSize(25);
  text("\"What's wrong with this picture?\" Code.org, code.org/promote. Accessed 27 Sept. 2017.", leftMargin, height - 50);
}

float getNumJobs(float per) {
  per = constrain(per, 0, 1.0);
  float num = map(per, 0, 1.0, 180000, 1400000);
  return num;
}

float getYJobs(float per, int topMargin, int gHeight) {
  per = constrain(per, 0, 1.0);
  int yJob1 = int(map(180000, 0, 1400000, topMargin + gHeight, topMargin));
  int yJob2 =  int(map(1400000, 0, 1400000, topMargin + gHeight, topMargin));
  float num = map(per, 0, 1.0, yJob1, yJob2);
  return num;
}

float getYStud(float per, int topMargin, int gHeight) {
  per = constrain(per, 0, 1.0);
  int yStud1 = int(map(40000, 0, 1400000, topMargin + gHeight, topMargin));
  int yStud2 = int(map(400000, 0, 1400000, topMargin + gHeight, topMargin));
  float num = map(per, 0, 1.0, yStud1, yStud2);
  return num;
}

float getNumStudents(float per) {
  per = constrain(per, 0, 1.0);
  float num = map(per, 0, 1.0, 40000, 400000);
  return num;
}

void drawEndPointStud(int topMargin, int leftMargin, int gHeight) {
  pushMatrix();
  translate(0, 0, 1);
  ellipse(width - leftMargin, getYStud(1.0, topMargin, gHeight), 10, 10);
  popMatrix();
}

void drawEndPointJobs(int topMargin, int leftMargin, int gHeight) {
   pushMatrix();
  translate(0, 0, 1);
  ellipse(width - leftMargin, getYJobs(1.0, topMargin, gHeight), 10, 10);
  popMatrix();
}

void drawPoint(int topMargin, int leftMargin, int gHeight) {
  float per = map(mouseX, leftMargin, width-leftMargin, 0, 1.0);
  per = constrain(per, 0, 1.0);
  fill(255);
  int xval = constrain(mouseX, leftMargin, width - leftMargin);
  ellipse(xval, getYJobs(per, topMargin, gHeight), 50, 50);
  ellipse(xval, getYStud(per, topMargin, gHeight), 50, 50);
}

void drawEquation() {
  float per = map(mouseX, 300, width-300, 0, 1.0);
  per = constrain(per, 0, 1.0);
  textSize(50);

  // jobs
  int jobY = 100;
  int jobX = 100;
  stroke(#1AF5FF);
  fill(#1AF5FF);
  text(round(getNumJobs(per)) + " jobs", jobX+25, jobY);

  // students
  stroke(#FCAE03);
  fill(#FCAE03);
  text("- " + round(getNumStudents(per)) + " CS students", jobX, jobY+70);

  fill(255);
  stroke(255);
  strokeWeight(1);
  line(jobX, jobY + 120, jobX + 400, jobY + 120);
}