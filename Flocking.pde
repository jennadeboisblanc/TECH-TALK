// Shiffman
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;
// A reference to our box2d world
Box2DProcessing box2d;
// An object to store information about the uneven surface
Surface surface;

Flock flock;

Repeller repeller;
Attractor attractor;

Boolean attractMode = false;

void initFlocking() {
  
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(random(width),random(height)));
  }
  
  // Create the surface
  surface = new Surface();
  
  repeller = new Repeller(width/2-20,height/2);
  attractor = new Attractor(130,370);
}

void drawFlocking(color c) {
  flock.run(c);
  
  // We must always step through time!
  box2d.step();
  // Draw the surface
  //surface.display();
  if(attractMode) {
    flock.applyAttractor(attractor);
    flock.checkLanding(attractor);
    attractor.display();
  }
  else {
    flock.applyRepeller(repeller);
    repeller.display();
  }
}


// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Particles + Forces

// A very basic Repeller class
class Attractor {
  
  // Gravitational Constant
  float G = 100;
  // Location
  PVector location;
  int w = width-300;
  int h = 440;

  Attractor(float x, float y)  {
    location = new PVector(x,y);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    noFill();
    //rect(location.x,location.y,w,h);
  }

  // Calculate a force to push particle away from repeller
  PVector attract(Boid b, int index) {
    PVector spot = new PVector((w*1.0/flock.getSize())*index+location.x,location.y);
    PVector dir = PVector.sub(spot,b.location);      // Calculate direction of force
    float d = dir.mag();                       // Distance between objects
    dir.normalize();                           // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //d = constrain(d,5,100);                    // Keep distance within a reasonable range
    //float force = -1 * G / (d * d);            // Repelling force is inversely proportional to distance
    float force = 2;

    dir.mult(force);                           // Get force vector --> magnitude * direction
    return dir;
  }  
  
  void switchMode() {
    attractMode =! attractMode;
  }
  
  Boolean onLanding(Boid b, int index) {
    PVector spot = new PVector((w*1.0/flock.getSize())*index+location.x,location.y);
    PVector dir = PVector.sub(spot,b.location);      // Calculate direction of force
    float d = dir.mag();  
    return d < 5;
  }
  
  /*PVector getLanding(Boid b) {
    PVector dir = PVector.sub(location,b.location);      // Calculate direction of force
    float d = dir.mag();                       // Distance between objects
    dir.normalize();                           // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //d = constrain(d,5,100);                    // Keep distance within a reasonable range
    //float force = -1 * G / (d * d);            // Repelling force is inversely proportional to distance
    float force = 0; 
    if (d > r-5 && d < r+5) return true;
      else force = map(d, r, width/2, 0, 10);
      println(force);
    }
    dir.mult(force);                           // Get force vector --> magnitude * direction
    return dir;
  }  */
}



// The Boid class

class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  Boolean wingUp = false;
  int wingCount;
  Boolean noBoundaries = false;
  Boolean landed = false;

  Boid(float x, float y) {
    r = 6.0;
    maxspeed = 3;
    maxforce = 0.03;
    location = new PVector(x, y);
    initVel();
  }
  
  void initVel() {
    acceleration = new PVector(0, 0);

    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    
    wingCount = int(random(10));
  }

  void run(ArrayList<Boid> boids, color c) {
    if(!landed) {
      flock(boids);
      update();
      borders();
    }
    render(c);
    
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    //PVector scat = scatter(boids);   // Scatter
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render(color c) {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);

    fill(c);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    if (landed) {
      int wc = 13;
      if (wingCount++%wc == 0) wingUp =! wingUp;
    }
    else if(velocity.y > .3) {
      wingCount = 10;
      wingUp = true;
    }
    else {
      int wc = int((map(velocity.x,-maxspeed,maxspeed,10,5)));
      if (wingCount++%wc == 0) wingUp =! wingUp;
    }
    if(wingUp) {
      beginShape(TRIANGLES);
      vertex(0, -r);
      vertex(-r*2, r);
      vertex(r*2, r);
      endShape();
    }
    popMatrix();
  }

  
  void borders() {
    if(noBoundaries) {
      if (location.x < -r) location.x = width+r; // velocity = new PVector(-velocity.x,velocity.y); //
      if (location.y < -r) location.y = height+r; // velocity = new PVector(velocity.x,-velocity.y); // 
      if (location.x > width+r) location.x = -r; // velocity = new PVector(-velocity.x,velocity.y);  //
      if (location.y > height+r) location.y = -r; // velocity = new PVector(velocity.x,-velocity.y);  //
    }
    else {
      PVector desired = null;
      int buffer = 30;
      if (location.x < buffer) {
        desired = new PVector(maxspeed, velocity.y);
      } 
      else if (location.x > width -buffer) {
        desired = new PVector(-maxspeed, velocity.y);
      } 
  
      if (location.y < buffer) {
        desired = new PVector(velocity.x, maxspeed);
      } 
      else if (location.y > height-buffer) {
        desired = new PVector(velocity.x, -maxspeed);
      } 
  
      if (desired != null) {
        desired.normalize();
        desired.mult(maxspeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce*3l);
        applyForce(steer);
      }
    }
  }
  /*
  void touchBody() {
    if(insideBody(location.x, location.y)) 
      PVector desired = null;
      int buffer = 30;
      if (location.x < buffer) {
        desired = new PVector(maxspeed, velocity.y);
      } 
      else if (location.x > width -buffer) {
        desired = new PVector(-maxspeed, velocity.y);
      } 
  
      if (location.y < buffer) {
        desired = new PVector(velocity.x, maxspeed);
      } 
      else if (location.y > height-buffer) {
        desired = new PVector(velocity.x, -maxspeed);
      } 
  
      if (desired != null) {
        desired.normalize();
        desired.mult(maxspeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce+10);
        applyForce(steer);
      }
    }
  } */

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
  void landed() {
    landed = true;
    acceleration = new PVector(0,0);
    //PVector up = new PVector(0,
    velocity = new PVector(0,-1);
    
  }
  
  void startFlying() {
    initVel();
    landed = false;
  }
}


// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  int getSize() {
    return boids.size();
  }
  
  void run(color c) {
    for (Boid b : boids) {
      b.run(boids, c);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
  void startFlying() {
    for (Boid b : boids) {
      b.startFlying();
    }
  }
  
  void applyRepeller(Repeller r) {
    for (Boid b: boids) {
      PVector force = r.repel(b);        
      b.applyForce(force);
    }
  }
  
  void applyAttractor(Attractor a) {
    for (int i = 0; i < boids.size(); i++) {
      PVector force = a.attract(boids.get(i),i);        
      boids.get(i).applyForce(force);
    }
  }
  
  void checkLanding(Attractor a) {
    for (int i = 0; i < boids.size(); i++) {
      if (a.onLanding(boids.get(i),i)) {
        boids.get(i).landed();
      }
    }
  }
}


// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Particles + Forces

// A very basic Repeller class
class Repeller {
  
  // Gravitational Constant
  float G = 100;
  // Location
  PVector location;
  float r = 100;

  Repeller(float x, float y)  {
    location = new PVector(x,y);
  }

  void display() {
    location.x = mouseX;
    location.y = mouseY;
    stroke(0);
    strokeWeight(2);
    noFill();
    ellipse(location.x,location.y,r*2,r*2);
  }

  // Calculate a force to push particle away from repeller
  PVector repel(Boid b) {
    PVector dir = PVector.sub(location,b.location);      // Calculate direction of force
    float d = dir.mag();                       // Distance between objects
    dir.normalize();                           // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //d = constrain(d,5,100);                    // Keep distance within a reasonable range
    //float force = -1 * G / (d * d);            // Repelling force is inversely proportional to distance
    float force = 0; 
    if(!attractMode) {
      if(d < r+5) force = -10;
    }
    else {
      if (d < r) force = map(d, 0, r, -2, 0);
      else force = map(d, r, width/2, 0, 2);
      println(force);
    }
    dir.mult(force);                           // Get force vector --> magnitude * direction
    return dir;
  }  
  
 
  
  /*PVector getLanding(Boid b) {
    PVector dir = PVector.sub(location,b.location);      // Calculate direction of force
    float d = dir.mag();                       // Distance between objects
    dir.normalize();                           // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //d = constrain(d,5,100);                    // Keep distance within a reasonable range
    //float force = -1 * G / (d * d);            // Repelling force is inversely proportional to distance
    float force = 0; 
    if (d > r-5 && d < r+5) return true;
      else force = map(d, r, width/2, 0, 10);
      println(force);
    }
    dir.mult(force);                           // Get force vector --> magnitude * direction
    return dir;
  }  */
}

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// An uneven surface boundary

class Surface {
  // We'll keep track of all of the surface points
  ArrayList<Vec2> surface;


  Surface() {
    surface = new ArrayList<Vec2>();

    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    float theta = 0;
    
    // This has to go backwards so that the objects  bounce off the top of the surface
    // This "edgechain" will only work in one direction!
    for (float x = width+10; x > -10; x -= 5) {

      // Doing some stuff with perlin noise to calculate a surface that points down on one side
      // and up on the other
      float y = map(noise(x/100),-1,1,2*height/4,height-50);
      theta += 0.15;

      // Store the vertex in screen coordinates
      surface.add(new Vec2(x,y));

    }

    // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made
    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface.get(i));
      vertices[i] = edge;
    }
    
    // Create the chain!
    chain.createChain(vertices,vertices.length);

    // The edge chain is now attached to a body via a fixture
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    Body body = box2d.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain,1);

  }

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(2);
    stroke(0);
    noFill();
    beginShape();
    for (Vec2 v: surface) {
      vertex(v.x,v.y);
    }
    endShape();
  }

}