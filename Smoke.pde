//------------------------------------------------------
// Color_Smoke  converted from P5.js to JavaScript
// fork of https://www.openprocessing.org/sketch/422525
//------------------------------------------------------
int numPoints = 360;
float startcol;
boolean deBBFlag = false;

void initSmoke() 
{
  colorMode(HSB);
  startcol = random(0, 255);
}

void drawSmoke() 
{
  if (deBBFlag) {
    fill(255);
    rect(0, 0, width, height);
    deBBFlag = false;
    println("should be backround white");
  }
  noFill();
  strokeWeight(2.);
  float sx=0, sy=0;
  float cx = frameCount * 2 - 200;
  float cy = height / 2.5 + 50 * sin(frameCount / 50.0);
  float hue = (cx / 10 - startcol) % 256;
  if (hue < 0) hue += 255;
  stroke(hue, 255, 220, 12);
  beginShape();
  for (int i = 0; i < numPoints; i++)
  {
    float angle = map(i, 0, numPoints, 0, TWO_PI);  // 0..360°
    float xx = 100 * cos(angle + cx / 10);
    float yy = 100 * sin(angle + cx / 10);
    PVector v = new PVector(xx, yy);
    xx = (xx + cx) / 150; 
    yy = (yy + cy) / 150;
    v.mult(1 + 1.5 * noise(xx, yy));
    vertex(cx + v.x, cy + v.y);
    if (i == 0) {    // save start point 
      sx = cx + v.x;
      sy = cy + v.y;
    }
  }
  vertex(sx, sy);  
  endShape();
  if (frameCount > width + 500) 
    noLoop();
}

int numSwirl =20;
float sz, offSet, theta, angle;
float step = 22;

void drawSwirl() {
  // https://www.openprocessing.org/sketch/152169
  strokeWeight(5);
  pushMatrix();
  translate(width/2, height*.75, 0);
  angle=0;
  for (int i=0; i<numSwirl; i++) {
    stroke(255);
    noFill();
    sz = i*step;
    float offSet = TWO_PI/numSwirl*i;
    float arcEnd = map(sin(theta+offSet), -1, 1, PI, TWO_PI);
    arc(0, 0, sz, sz, PI, arcEnd);
  }
  colorMode(RGB);
  popMatrix();
  theta += .0523;
}

//https://www.openprocessing.org/sketch/395303
void drawSquares() {
  noFill();
  fill( 255);
  stroke(0);
  //float mx = width * sin(millis()/1000);
  float mx = 500;
  float maxX = (float)180/width*mx;
  float maxY = (float)180/height*mx;

  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < 360; i+=5) {
    float x = sin(radians(i)) * maxX;
    float y = cos(radians(i)) * maxY;
    pushMatrix();
    translate(x, y);
    rotate(radians(i-frameCount));
    rect(0, 0, 140, 100);
    popMatrix();

    pushMatrix();
    translate(-x, -y);
    rotate(radians(i-frameCount));
    rect(0, 0, 100, 100);
    popMatrix();
  }
  popMatrix();
}


float tam;    // tamanho dos conjuntos
int quantas;  // quantos conjuntos
float px[] = new float[100];
float py[] = new float[100];
float pxa[] = new float[100];
float pya[] = new float[100];
float pv[] = new float[100];
color cor[] = new color[30];

void initShapes() {
  quantas=7;
  for (int i= 0; i<22; i++) {
    cor[i] = color(random(255), random(255), random(255));
  }
  for (int i=0; i<quantas; i++) {
    px[i] = random(width*.3, width*.7);
    py[i] = random(height*.3,height*.7);
  sorteiaAlvo(i);
  }
}

void drawShapes() {
  noStroke();
  tam=540;
  int c = 0;
  while (tam>5) {
    fill(cor[c]);
    for (int i=0; i<quantas; i++) {
      ellipse(px[i], py[i], tam, tam);
    }
    c = (c+1)%22;
    tam-=30;
  }

  for (int i=0; i<quantas; i++) {
    if (dist(px[i], py[i], pxa[i], pya[i])<10) {
      sorteiaAlvo(i);
    } else {
      px[i]+=((pxa[i]-px[i])/pv[i]);
      py[i]+=((pya[i]-py[i])/pv[i]);
    }
  }
}

void sorteiaAlvo(int q){
  pxa[q] = random(width*.3, width*.7);
  pya[q] = random(height*.4,height*.6);
  pv[q] = int(random(250, 500));
}

/*
 * twisted lines
 *
 * @author aadebdeb
 * @date 2017/02/04
 */

color[] colors;
int type;

void initWaves() {
  colorMode(RGB, 255);
  colors = new color[3];
  colors[0] = color(255, 0, 0);
  colors[1] = color(0, 255, 0);
  colors[2] = color(0, 0, 255);
  type = 0;
}

void drawWaves() {
  blendMode(BLEND);
  
  if(type == 0) {
    background(255);
    blendMode(EXCLUSION);
  } else {
    background(0);
    blendMode(SCREEN);
  }
  noFill();
  strokeWeight(20);
  for(int i = 0; i < 3; i++) {
    stroke(colors[i]);
    beginShape();
    for(int w = -20; w < width + 20; w += 5) {
      int h = height / 2;
      h += 200 * sin(w * 0.03 + frameCount * 0.07 + i * TWO_PI / 3) * pow(abs(sin(w * 0.001 + frameCount * 0.02)), 5);
      curveVertex(w, h);
    }    
    endShape();
  }
  blendMode(REPLACE);
  
}


float zDist = 11, zmin = -150, zmax = 250, zstep = 2.8, rad = 1200;
int nb = int((zmax - zmin) / zDist);
PVector[] circles = new PVector[nb];
color[] colors2 = new color[nb];
Boolean bnw = true, dots = false;

void initTunnel() {
   colorMode(HSB, 255);
  for (int i = 0; i < nb; i++) {
    circles[i] = new PVector(0, 0, map(i, 0, nb - 1, zmax, zmin));
    colors2[i] = color(random(110, 255), 0, random(60, 150));
    colors2[i] = color(random(220, 255), 255, 255);
  }
}

//https://www.openprocessing.org/sketch/205584
void drawTunnel() {
   noFill();
  strokeWeight(2);
  colorMode(HSB, 255);
  pushMatrix();
  translate(width/2, height/2);
  PVector pv;
  float fc = (float)frameCount, a;
  if (dots) beginShape(POINTS); 

  for (int i = 0; i < nb; i++) {
    pv = circles[i];
    pv.z += zstep;
    pv.x = (noise((fc*2 + pv.z) / 550) - .5) * height * map(pv.z, zmin, zmax, 6, 0);
    pv.y = (noise((fc*2 - 3000 - pv.z) / 550) - .5) * height * map(pv.z, zmin, zmax, 6, 0);

    a = map(pv.z, zmin, zmax, 0, 255);
    if (!bnw)stroke(colors2[i], a);
    else stroke(map(pv.z, zmin, zmax, 0, 255), a);
    float r = map(pv.z, zmin, zmax, rad*.1, rad);

    if (dots) {
      float jmax = r;
      for (int j  = 0; j < jmax; j++)
      {
        vertex(pv.x + r*cos(j*TWO_PI/jmax + fc/40)/2, pv.y + r*sin(j*TWO_PI/jmax + fc/40)/2, pv.z);
      }
    } else {
      pushMatrix();
      translate(pv.x, pv.y, pv.z);
      ellipse(0, 0, r, r);
      popMatrix();
    }

    if (pv.z > zmax) {
      circles[i].z = zmin;
    }
  }
  if (dots) endShape();
  popMatrix();
  colorMode(RGB);
}