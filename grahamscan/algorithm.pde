import java.util.Collections;

class GrahamsScanAlgorithm{
  PVector center;
  ArrayList<PVector> points;
  ArrayList<PVector> vectors;
  ArrayList<PVector> convexHull;
  ArrayList<Entry> entries;
  int idx, idxTriangle, n;
  
  GrahamsScanAlgorithm(ArrayList<PVector> points){
    this.entries = new ArrayList<Entry>();
    this.convexHull = new ArrayList<PVector>();
    this.vectors = new ArrayList<PVector>();
    this.center = new PVector(0, 0);
    this.points = points;
    this.n = points.size();
    
    // Get the bottom point as the starting point
    PVector bottom = points.get(0);
    for(PVector point : points){
      if(bottom.y > point.y){
        bottom = point;
      }
    }
    
    // Add entries
    for(PVector point : points){
      entries.add(new Entry(point, center, bottom));
    }
    
    // Sort points according to the first point
    Collections.sort(entries);
    
    // Add first three elements
    convexHull.add(entries.get(0).point);
    convexHull.add(entries.get(1).point);
    convexHull.add(entries.get(2).point);
    
    // Set index of entry
    this.idx = 2;
  }
  
  void next(){
    if(idx <= n){
      // Get last 3 elements
      int last = convexHull.size();
      PVector p0 = convexHull.get(last - 3);
      PVector p1 = convexHull.get(last - 2);
      PVector p2 = convexHull.get(last - 1);
      
      float direction = orientation(p0, p1, p2);
      if(direction < 0){
        // Backtrack
        if(convexHull.size() > 3){
          while(direction < 0 && convexHull.size() > 3){
            convexHull.remove(p1);
            last = convexHull.size();
            p0 = convexHull.get(last - 3);
            p1 = convexHull.get(last - 2);
            p2 = convexHull.get(last - 1);
            
            direction = orientation(p0, p1, p2);
          }
        }else{
          convexHull.remove(p1);
          if(idx < n){
            convexHull.add(entries.get((idx + 1) % n).point);
          }
          idx++;
        }
      }else if(direction >= 0 && idx < n){
        // Next point
        convexHull.add(entries.get((idx + 1) % n).point);
        idx++;
      }
    }
  }
  
  float orientation(PVector p0, PVector p1, PVector p2){
    // http://stackoverflow.com/questions/27635188/algorithm-to-detect-left-or-right-turn-from-x-y-co-ordinates
    PVector v1 = new PVector(p1.x - p0.x, p1.y - p0.y);
    PVector v2 = new PVector(p2.x - p1.x, p2.y - p1.y);
    return (v1.x*v2.y - v1.y*v2.x > 0.0) ? -1.0 : 1.0;
  }
  
  void drawPoints(){
    for(PVector point : points){
      ellipse(point.x, point.y, 5, 5);
    }
  }
  
  void drawConvexHull(){
    stroke(10);
    if(convexHull.size() > 1){
      int m = convexHull.size();
      PVector p0, p1 = new PVector(0, 0);
      for(int i=0; i<m-1; i++){
        p0 = convexHull.get(i);
        p1 = convexHull.get((i + 1) % m);
        line(p0.x, p0.y, p1.x, p1.y);
      }
    }
  }
}

class Entry implements Comparable<Entry>{
  PVector point;
  float distance;
  float angle;
  
  Entry(PVector point, PVector center, PVector bottom){
    this.point = point.copy();
    this.distance = dist(point.x, point.y, center.x, center.y);
    this.angle = atan2(bottom.y, bottom.x) - atan2(point.y, point.x);
    if(this.angle < 0){
      this.angle += TAU;
    }
  }
  
  int compareTo(Entry entry){
    float value = angle - entry.angle;
    if(value > 0){
      return 1;
    }else if(value < 0){
      return -1;
    }else{
      return 0;
    }
  }
}