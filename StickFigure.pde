class StickFigure {

  int x, y, xorig, yorig;
  float angle;
  boolean isFemale;
  int speed = 5;
  int xDir = 1;
  int yDir = 1;

  StickFigure(int x, int y, boolean isFemale) {
    this.x = x;
    this.y = y;
    this.xorig = x;
    this.yorig = y;
    this.isFemale = isFemale;
    this.angle = random(360);
  }

  void display() {
    noStroke();
    //if (isFemale) {
    //  fill(255, 120, 120);
    //  triangle(x - 10, y + 40, x, y, x + 10, y + 40);
    //}
    //else {
    //  fill(150, 150, 200);
    //  rect(x, y+5, 20, 40);
    //}

    //ellipse(x+10, y+10, 20, 20);
    if (isFemale) image(girl, x, y);
    else image(boy, x, y);
  }
  
  void display(int xp, int yp, boolean female, boolean up) {
    if (female) {
      if (up) image(girl, xp, yp);
      else image(girldown, xp, yp);
    }
    else {
      if (up) image(boy, xp, yp);
      else image(boydown, xp, yp);
    }
  }

  void move() {
    this.x += speed * xDir * cos(radians(angle));
    this.y += speed * yDir * sin(radians(angle));
    if (this.x < 0 || this.x > width) xDir *= -1;
    else if (this.y < 0 || this.y > height) yDir *= -1;
  }
}