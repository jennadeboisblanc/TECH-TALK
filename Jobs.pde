
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
  strokeWeight(8);
  
  // y axis
  //for( int i = 0; i < 8; i++) {
  //  int y = int(map(i*200000, 0, 1400000, topMargin+gHeight, topMargin));
  //  line(leftMargin-5, y, leftMargin + 5,y);
  //  text(i*20000, leftMargin - textWidth(i*200000+"") - 5, y);
  //}
  
  // jobs
  stroke(#55FC03);
  fill(#55FC03);
  beginShape();
  vertex(x1, yJob1);
  vertex(x2, yJob2);
  vertex(x2, topMargin+gHeight);
  vertex(x1, topMargin+gHeight);
  endShape();
  stroke(255);
  
  //float slope = (yJob2 - yJob1)/ (x2 - x1);
  //colorMode(HSB, width-2*leftMargin);
  //for (int i = leftMargin; i < width-leftMargin; i++) {
  //  stroke(i, width-2*leftMargin, width-2*leftMargin);
  //  line(i, -slope *i + x1, i, topMargin + gHeight);
  //}
  //colorMode(RGB, 255);
  
  fill(255);
  line(x1, topMargin + gHeight, x1, topMargin);
  
  // students
  stroke(#FC03AA);
  fill(#FC03AA);
  beginShape();
  vertex(x1, yStud1);
  vertex(x2, yStud2);
  vertex(x2, topMargin + gHeight);
  vertex(x1, topMargin + gHeight);
  endShape();
  
  // x axis
  stroke(255);
  fill(255);
  line(x1, topMargin + gHeight, x2, topMargin + gHeight);
  for( int i = 0; i < 10; i+=3) {
    int x = int(map(2011+i, 2011, 2020, leftMargin, width - leftMargin));
    line(x, topMargin + gHeight - 5, x, topMargin + gHeight + 5);
    text(2011+i, x-15, topMargin + gHeight + 30);
  }
  
  textSize(25);
  text("\"What's wrong with this picture?\" Code.org, code.org/promote. Accessed 27 Sept. 2017.", leftMargin, height - 50);

}