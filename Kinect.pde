//KJoint[] joints;
PImage hesse;
long slideTime = 0;
boolean rightUp = false;
boolean leftUp = false;
boolean raiseEmUp = false;

void hesseHead(KJoint[] joints) {
  pushMatrix();
  translate(joints[KinectPV2.JointType_Head].getX()-hesse.width/2, joints[KinectPV2.JointType_Head].getY()-hesse.height/2, joints[KinectPV2.JointType_Head].getZ());
  image(hesse, 0, 0);
  popMatrix();
}

/*
Thomas Sanchez Lengeling. http://codigogenerativo.com/
 KinectPV2, Kinect for Windows v2 library for processing
 Skeleton depth tracking example
 */

void initKinect() {
  hesse = loadImage("nowellhead.png");
  hesse.resize(int(hesse.width*.3), int(hesse.height*.3));

  kinect = new KinectPV2(this);

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableColorImg(true);
  kinect.enableSkeletonColorMap(true);

  kinect.init();
}

void checkHands(KJoint[] joints) {
  if (checkNextSlide(joints)) advanceSlide();
  else if (checkPreviousSlide(joints)) previousSlide();
}                                      


void checkArms(KJoint[] joints) {
  rightUp = (joints[KinectPV2.JointType_HandRight].getY() < joints[KinectPV2.JointType_ElbowRight].getY());
  leftUp = (joints[KinectPV2.JointType_HandLeft].getY() < joints[KinectPV2.JointType_ElbowLeft].getY());
}                                      

boolean checkNextSlide(KJoint[] joints) {
  if (millis() - slideTime > 1000) {
    if (joints[KinectPV2.JointType_HandRight].getY() < joints[KinectPV2.JointType_Head].getY()) {
      slideTime = millis();
      return true;
    }
  }
  return false;
}

boolean checkPreviousSlide(KJoint[] joints) {
  if (millis() - slideTime > 1000) {
    if (joints[KinectPV2.JointType_HandLeft].getY() < joints[KinectPV2.JointType_Head].getY()) {
      slideTime = millis();
      return true;
    }
  }
  return false;
}

void checkSkeleton() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      if (raiseEmUp) checkArms(joints);
      checkHands(joints);

      //draw different color for each hand state
      //drawHandState(joints[KinectPV2.JointType_HandRight]);
      //drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }
}

void drawSkeleton() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      drawBody(joints);
    }
  }
}

void drawHesse() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);
      hesseHead(joints);
    }
  }
}

void drawRainbowsSkeleton() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      //rainbows(joints);
      drawBody(joints);
    }
  }
}

void rainbows(KJoint[] joints) {
  noFill();
  strokeWeight(4);
  int num = 20;
  int space = 30;
  colorMode(HSB, num);
  pushMatrix();
  float x = joints[KinectPV2.JointType_SpineShoulder].getX();
  float y =  joints[KinectPV2.JointType_SpineShoulder].getY();
  float z =  joints[KinectPV2.JointType_SpineShoulder].getZ();
  translate(x, y, z);

  if (x > -1 && y > -1) {
    for (int i = 0; i < num; i++) {

      int r = (millis()/30);
      int rad = (r + i * space) % (num * space);
      //stroke(i, 50, 50, map(rad, 0, width/4, 50, 0));
      stroke(i, num, num, map(rad, 0, num*space, num, 0));
      ellipse(0, 0, rad + 100, rad + 100);
    }
  }
  ellipse(0, 0, 70, 70);
  popMatrix();
}

void updateSkeleton() {
}

//draw the body
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  //Single joints
  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw a ellipse depending on the hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */

//Depending on the hand state change the color
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    break;
  }
}