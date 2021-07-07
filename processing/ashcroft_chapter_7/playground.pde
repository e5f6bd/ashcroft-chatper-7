void hoge() {
  
  background(0);

  strokeWeight(3);
  stroke(0, 255, 0);
  line(500, 500, 500, -500, -500, -500);
  
  float a = 100;
  int c = 1;
  for(int i = -c; i <= c; i++){
    for(int j = -c; j <= c; j++){
      for(int k = -c; k <= c; k++){
        pushMatrix();
        translate(a*i, a*j, a*k);
        fill(255, 0, 0);
        noStroke();
        sphere(3);
        popMatrix();
      }
    }
  }

  pushMatrix();
  strokeWeight(3);
  stroke(0, 255, 0);
  fill(0, 0, 255, 128);
  PMatrix3D m = new PMatrix3D();
  m.rotate(millis() / 3000.0 * TAU, 1, 1, 1);
  println(m.m00);
  applyMatrix(m);
  box(100);
  popMatrix();
}
