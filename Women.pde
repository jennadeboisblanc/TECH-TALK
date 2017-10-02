Table table;

void initTable() {
  table = loadTable("data.csv", "header");
  println(table.getRowCount() + " total rows in table");
}

void drawWomenGraph() {
  float scaler = height - 300;
  int leftMargin = 300;
  int yearSpace = (width-leftMargin*2)/(table.getRowCount()-1);
  int topMargin = 50;
  for (int i = 0; i < table.getRowCount()-1; i++) {

    TableRow row = table.getRow(i);
    TableRow nextRow = table.getRow(i+1);

    float med = scaler - row.getFloat("Medical School")*scaler;
    float law = scaler - row.getFloat("Law School")*scaler;
    float phys = scaler - row.getFloat("Physical Sciences")*scaler;
    float cs = scaler - row.getFloat("Computer science")*scaler;

    float med2 = scaler - nextRow.getFloat("Medical School")*scaler;
    float law2 =scaler -  nextRow.getFloat("Law School")*scaler;
    float phys2 = scaler -  nextRow.getFloat("Physical Sciences")*scaler;
    float cs2 = scaler - nextRow.getFloat("Computer science")*scaler;


    strokeWeight(8);
    stroke(0, 255, 0);
    line(i * yearSpace+leftMargin, med, (i+1) * yearSpace+leftMargin, med2);
    stroke(0, 0, 255);
    line(i * yearSpace+leftMargin, law, (i+1) * yearSpace+leftMargin, law2);
    stroke(255, 255, 0);
    line(i * yearSpace+leftMargin, phys, (i+1) * yearSpace+leftMargin, phys2);
    stroke(255, 0, 0);
    line(i * yearSpace+leftMargin, cs, (i+1) * yearSpace+leftMargin, cs2);
  }
  textSize(50);
  drawAxes(leftMargin, topMargin, yearSpace, scaler);
  drawFifty(leftMargin, topMargin, scaler);
  drawLegend(leftMargin, topMargin, scaler);
  drawCitation();
}

void drawAxes(int leftMargin, int topMargin, int yearSpace, float scaler) {
  stroke(255);

  // x axis horizontal
  strokeWeight(4);
  line(leftMargin, scaler + topMargin, width - leftMargin, scaler + topMargin);

  // x axis
  for (int i = 4; i < table.getRowCount(); i+=10) {

    TableRow row = table.getRow(i);
    int date = row.getInt("date");
    stroke(255);
    fill(255);
    //textSize(18);
    text(date, i * yearSpace + leftMargin - textWidth(date+"")/2, scaler + topMargin + 50);
    strokeWeight(2);
    line(i * yearSpace + leftMargin, scaler + topMargin - 5, i * yearSpace + leftMargin, scaler + topMargin +5);
  }

  // y axis 
  strokeWeight(4);
  line(leftMargin, topMargin+100, leftMargin, topMargin + scaler);
  strokeWeight(2);
  for (int i = 0; i < 80; i += 50) {
    line(leftMargin-5, scaler + topMargin - i*scaler/100.0, leftMargin+5, scaler + topMargin - i*scaler/100.0);
    text(i + "%", leftMargin - textWidth(i+"%") - 20, scaler + topMargin - i*scaler/100.0+8);
  }
}

void drawFifty(int leftMargin, int topMargin, float scaler) {
  strokeWeight(4);
  stroke(200);
  line(leftMargin, topMargin+scaler/2, width - leftMargin, topMargin + scaler/2);
}

void drawLegend(int leftMargin, int topMargin, float scaler) {

  pushMatrix();
  int dy = 60;
  translate(30, topMargin + 100, 0);
  stroke(255);
  text("CS", leftMargin+25, 17);
  fill(255, 0, 0);
  noStroke();
  rect(leftMargin, 0, 20, 20);
  //stroke(0, 255, 0);
  //text("Med School");


  stroke(255);

  translate(0, dy);
  fill(255);
  text("Med", leftMargin+25, 17);
  fill(0, 255, 0);
  noStroke();
  rect(leftMargin, 0, 20, 20);

  translate(0, dy);
  stroke(255);
  fill(255);
  text("Law", leftMargin+25, 17);
  fill(0, 0, 255);
  noStroke();
  rect(leftMargin, 0, 20, 20);

  translate(0, dy);
  stroke(255);
  fill(255);
  text("Phys", leftMargin+25, 17);
  fill(255, 255, 0);
  noStroke();
  rect(leftMargin, 0, 20, 20);

  popMatrix();
}

void drawCitation() {
  //textSize(12);
  textSize(20);
  stroke(255);
  fill(255);
  text("Henn, Steve. \"When Women Stopped Coding.\" NPR, 21 Oct. 2014,", 10, height-50);
  text("www.npr.org/sections/money/2014/10/21/357629765/when-women-stopped-coding. Accessed 26 Sept. 2017.", 20, height -30);
}

void demographicsWalk() {
  
}