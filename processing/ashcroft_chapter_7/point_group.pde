class PointGroup {
  int n;
  int a = 0, b = 0, c = 0, d = 0;
  
  public PointGroup(int n) {
    this.n = n;
  }
  
  void drawPointGroup(boolean thin) {
    PVector[][] v = new PVector[n][2];
    for(int i = 0; i < n; i++){
      for(int j = 0; j < 2; j++){
        v[i][j] = new PVector(150*cos(TAU/n*i), 150*sin(TAU/n*i), (j*2-1)*150);
      }
    }
    
    if (showSurface && !thin) fill(0, 0, 255, 64); 
    else noFill();
    strokeWeight(4);
    if(thin) stroke(64, 64, 0); else stroke(255, 255, 0);
    
    for(int j = 0; j < 2; j++) {
      beginShape();
      for(int i = 0; i < n; i++) vertex(v[i][j].x, v[i][j].y, v[i][j].z);
      endShape(CLOSE);
    }
    noStroke();
    for(int i = 0; i < n; i++) {
      int j = (i+1) % n;
      PVector[][] u = new PVector[3][3];
      for(int k = 0; k <= 2; k++) for(int l = 0; l <= 2; l++)
        u[k][l] = v[i][0].copy().add(
            PVector.add(PVector.sub(v[j][0], v[i][0]).mult(k / 2.0),
                              PVector.sub(v[i][1], v[i][0]).mult(l / 2.0))
            );
      for(int k = 0; k < 2; k++) {
        for(int l = 0; l < 2; l++) {
          if(thin) noFill();
          else if(((a&k) ^ (b&l) ^ (c&k&l) ^ (d&i&1)) > 0) fill(0, 255, 0, 64);
          else fill(0, 0, 255, 192);
          beginShape(QUAD);
          vertexVec(u[k+0][l+0]);
          vertexVec(u[k+0][l+1]);
          vertexVec(u[k+1][l+1]);
          vertexVec(u[k+1][l+0]);
          endShape();
        }
      }
    }
    
    strokeWeight(4);
    if(thin) stroke(64, 64, 0); else stroke(255, 255, 0);
    for(int i = 0; i < n; i++) line(v[i][0].x, v[i][0].y, v[i][0].z, v[i][1].x, v[i][1].y, v[i][1].z);
  }
}

void vertexVec(PVector v) {
  vertex(v.x, v.y, v.z);
}
