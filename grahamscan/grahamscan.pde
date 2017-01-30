ArrayList<PVector> points;
int n = 200;
GrahamsScanAlgorithm algorithm;
boolean animate = true;
boolean saveFrames = true;
int numFrames = 350;

void setup(){
  size(500, 500);
  background(255);
  stroke(0);
  strokeWeight(3);
  fill(0);
  smooth();
  
  float r0 = 200;
  points = new ArrayList<PVector>();
  for(int i=0; i<n; i++){
    float r = random(0, 1);
    float phi = random(0, TAU);
    float x = r0*sqrt(r)*cos(phi);
    float y = r0*sqrt(r)*sin(phi);
    points.add(new PVector(x, y));
  }
  algorithm = new GrahamsScanAlgorithm(points);
}

void keyPressed(){
  switch(key){
    case ' ': algorithm.next(); break;
  }
}

void draw(){
  println("FPS : " + frameCount);  
  background(255);
  
  translate(width/2, height/2);
  scale(1, -1);
  
  algorithm.drawPoints();
  algorithm.drawConvexHull();
  
  if(animate){
    algorithm.next();
  }
  if(saveFrames){
    if(frameCount <= numFrames){
      saveFrame("frames/#####.png");
    }else{
      noLoop();
    }
  }
}