Table tablePOC;

void initTablePOC() {
  tablePOC = loadTable("employees.csv", "header");
  println(tablePOC.getRowCount() + " total rows in POC table");
}

void drawTablePOC() {
  background(0);
  colorMode(RGB, 255);
  // white

  int topMargin = -100;
  int barLen = 600;
  int space = 50;
  int xSmallSp = 10;
  int xSpace = 50;
  int textW = 100;
  int barW = 110;
  int gHeight = 900;
  int leftMargin = (width - xSpace * 4 - barW*12)/2;
  int xsp = leftMargin + xSpace;
  color pocC = color(#1AF5FF);
  color whiteC = color(#FCAE03);

  float [] whites = new float[4];
  float [] blacks = new float[4];
  float [] latinos = new float[4];
  for (int i = 0; i < 4; i ++) {
    TableRow r = tablePOC.getRow(i);
    whites[i] = r.getFloat("White")/100.0;
    latinos[i] = r.getFloat("Latino")/100.0;
    blacks[i] = r.getFloat("Black")/100.0;
  }

  noStroke();
  // whites
  textSize(70);
  strokeWeight(2);
  fill(255);
  stroke(255);
  text("White", xsp, topMargin + gHeight + 80);
  for (int i = 0; i < 4; i++) {
    if (i == 0) fill(whiteC);
    else fill (0, 255-(i-1)*50, 255-(i-1)*50);
    rect(xsp, (topMargin + gHeight) - whites[i]*gHeight, barW, whites[i]*gHeight);
    xsp += barW;
  }

  xsp += xSpace;

  // black
  textSize(70);
  fill(255);
  stroke(255);
  text("Black", xsp, topMargin + gHeight + 80);
  for (int i = 0; i < 4; i++) {

    if (i == 0) fill(whiteC);
    else fill  (0, 255-(i-1)*50, 255-(i-1)*50);
    rect(xsp, (topMargin + gHeight) - blacks[i]*gHeight, barW, blacks[i]*gHeight);
    textSize(12);
    fill(255);
    text(round(blacks[i]*100), xsp, 100);
    xsp += barW;
  }
  xsp += xSpace;


  // hispanic
  textSize(70);
  fill(255);
  stroke(255);
  text("Latino", xsp, topMargin + gHeight + 80);
  for (int i = 0; i < 4; i++) {
    if (i == 0) fill(whiteC);
    else fill (0, 255-(i-1)*50, 255-(i-1)*50);
    rect(xsp, (topMargin + gHeight) - latinos[i]*gHeight, barW, latinos[i]*gHeight);
    xsp += barW;
  }
  xsp += xSpace;

  // legend 
  String names[] = {"Facebook", "Instagram", "Google"};
  textSize(60);

  fill (whiteC);
  rect(1100, 150, 60, 60);
  fill(255);
  text("U.S. Population", 1100 + 70, 150 + 50);
  for (int i = 1; i < 4; i ++) {
    fill (0, 255-(i-1)*50, 255-(i-1)*50);
    rect(1100, 150 + i * 70, 60, 60);
    fill(255);
    text(names[i-1], 1100 + 70, 150 + i * 70 + 50);
  }
  
   // y axis 
  strokeWeight(4);
  line(leftMargin, topMargin+100, leftMargin, topMargin + gHeight);
  strokeWeight(2);
  for (int i = 0; i < 60; i += 50) {
    line(leftMargin-5, gHeight + topMargin - i*gHeight/100.0, leftMargin+5, gHeight + topMargin - i*gHeight/100.0);
    text(i + "%", leftMargin - textWidth(i+"%") - 20, gHeight + topMargin - i*gHeight/100.0+8);
  }
}