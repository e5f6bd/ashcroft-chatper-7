void setupBravis() {
  resetRotationVectors();
}

PVector[][] baseVectors = {
  {new PVector(1, 0, 0), new PVector(0, 1, 0), new PVector(0, 0, 1)}, 
  {new PVector(1, 0, 0), new PVector(0, 1, 0), new PVector(0, 0, 2.4)}, 
  {new PVector(1, 0, 0), new PVector(0, 1.6, 0), new PVector(0, 0, 2.4)}, 
  {new PVector(1, 0, 0), new PVector(-0.8, 1.6, 0), new PVector(0, 0, 2.4)}, 
  {new PVector(1, 0, 0), new PVector(-0.8, 1.6, 0), new PVector(1.7, 1.8, 2.4)}, 
  rhombo(), 
};
PVector[] rhombo() {
  float k = sqrt(2) / 3;
  return new PVector[]{
    new PVector(1+k, k, k), 
    new PVector(k, 1+k, k), 
    new PVector(k, k, 1+k), 
  };
}
PVector[] beforeVector = baseVectors[0];
PVector[] afterVector = baseVectors[0];
float changeMillis = -1000;
PVector[] getCurrentVector() {
  PVector[] ret = new PVector[3];
  // Change here to change animation time
  float t = easeInOutCubic(min((millis() - changeMillis) / 1000.0, 1));
  for (int i = 0; i < 3; i++) {
    ret[i] = PVector.add(PVector.mult(beforeVector[i], 1-t), PVector.mult(afterVector[i], t));
  }
  return ret;
}
float easeInOutCubic(float x) {
  return x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2;
}
PVector[] getLatticeVectors(PVector r, PVector[] a, float d) {
  PVector[] v = new PVector[8];
  for (int m = 0; m < 8; m++) {
    v[m] = r.copy();
    for (int i = 0; i < 3; i++) {
      if ((m & (1<<i)) > 0) {
        v[m].add(PVector.mult(a[i], d));
      }
    }
  }
  return v;
}

BravaisState bravaisState = BravaisState.NONE;
enum BravaisState {
  NONE, PRIMITIVE, BASE, BODY, FACE
}
boolean showSurface = true;

PVector rotationOrig, rotationVec;
float rotationAngle = 0;
int rotationMillis = -1000;
void resetRotationVectors() {
  rotationOrig = new PVector(0, 0, 0);
  rotationVec = new PVector(0, 0, 0);
}
float getRotationAngle() {
  float t = easeInOutCubic(min((millis() - rotationMillis) / 1000.0, 1));
  return rotationAngle * t;
}

void bravais() {
  background(0);
  PVector[] currentVector = getCurrentVector();
  PVector[] latticePoints = getLatticeVectors(new PVector(), currentVector, 100);

  drawRotationAxis(latticePoints);

  strokeWeight(1);
  stroke(255, 0, 0);
  line(0, 0, 0, 1000, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 1000, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 1000);

  pushMatrix();
  PMatrix3D m = new PMatrix3D();
  if(!rotationDisabled()){
    PVector o = translateVec(rotationOrig, latticePoints), v = translateVec(rotationVec, latticePoints);
    m.translate(o.x, o.y, o.z);
    m.rotate(getRotationAngle(), v.x, v.y, v.z);
    m.translate(-o.x, -o.y, -o.z);
  }
  applyMatrix(m);
  drawLattice(latticePoints);
  popMatrix();

  if (lastKeyTyped) {
    lastKeyTyped = false;
    if ('1' <= key && key < '1' + baseVectors.length) {
      beforeVector = currentVector;
      afterVector = baseVectors[key - '1'];
      changeMillis = millis();
    }
    if (key == 'q') bravaisState = BravaisState.NONE;
    if (key == 'w') bravaisState = BravaisState.PRIMITIVE;
    if (key == 'e') bravaisState = BravaisState.BODY;
    if (key == 'r') bravaisState = BravaisState.FACE;
    if (key == 't') bravaisState = BravaisState.BASE;
    if (key == '0') showSurface = !showSurface;
    if ('x' <= key && key <= 'z' || 'X' <= key || key <= 'Z' || key == ' ' || key == 'c') {
      rotationAngle = 0;
      if (key == 'x') rotationVec.x = (rotationVec.x + 2) % 3 - 1;
      if (key == 'y') rotationVec.y = (rotationVec.y + 2) % 3 - 1;
      if (key == 'z') rotationVec.z = (rotationVec.z + 2) % 3 - 1;
      if (key == 'X') rotationOrig.x = 0.5 - rotationOrig.x;
      if (key == 'Y') rotationOrig.y = 0.5 - rotationOrig.y;
      if (key == 'Z') rotationOrig.z = 0.5 - rotationOrig.z;
      if (key == 'c') {
        resetRotationVectors();
      }
      println("rotation =", rotationVec, rotationOrig);
    }
    if (key == ',' || key == '.' || key == '/' || key == '_') {
      rotationMillis = millis();
      if(key == ',') rotationAngle = TAU / 2;
      if(key == '.') rotationAngle = TAU / 3;
      if(key == '/') rotationAngle = TAU / 4;
      if(key == '_') rotationAngle = TAU / 6;
    }
  }
}
void parallelepiped(PVector[] v) {
  int[][] q = {
    {0, 1, 3, 2}, 
    {0, 1, 5, 4}, 
    {0, 2, 6, 4}, 
  };

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j <= 7; j += 7) {
      beginShape(QUAD);
      for (int k = 0; k < 4; k++) {
        PVector u = v[q[i][k] ^ j];
        vertex(u.x, u.y, u.z);
        //println((q[i][k] ^ j) + " " + u);
      }
      endShape();
      //println();
    }
  }
  //println("==");
}

void drawAtoms(ArrayList<PVector> latticePoints) {
  for (PVector v : latticePoints) {
    pushMatrix();
    translate(v.x, v.y, v.z);
    sphere(5);
    popMatrix();
  }
}

// lps ... lattice points
PVector translateVec(PVector coef, PVector[] lps) {
  PVector ret = new PVector();
  for(int i = 0; i < 3; i++){
    ret.add(PVector.mult(lps[1<<i], coef.array()[i]));
  }
  return ret;
}
void drawRotationAxis(PVector[] lps) {
  if(rotationDisabled()) return;
  PVector o = translateVec(rotationOrig, lps), v = PVector.mult(translateVec(rotationVec, lps), 100);
  PVector a = PVector.add(o, v), b = PVector.sub(o, v);
  if (a.equals(b)) return;
  stroke(0, 255, 255);
  strokeWeight(2);
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

void drawLattice(PVector[] latticePoints){
    pushMatrix();
  if (showSurface) fill(0, 0, 255, 64); 
  else noFill();
  strokeWeight(4);
  stroke(255, 255, 0);
  parallelepiped(latticePoints);
  popMatrix();

  noStroke();
  fill(255, 0, 255);
  switch(bravaisState) {
  case NONE:
    break;
  default:
    ArrayList<PVector> vs = new ArrayList(java.util.Arrays.asList(latticePoints));
    switch(bravaisState) {
    case BODY:
      vs.add(PVector.add(latticePoints[0], latticePoints[7]).div(2));
      break;
    case FACE:
    case BASE:
      for (int i = 0; i < 8; i++) {
        for (int j = i; j < 8; j++) {
          if (Integer.bitCount(i ^ j) == 2) {
            if (bravaisState == BravaisState.FACE || ((i ^ j) & 4) == 0) {
              vs.add(PVector.add(latticePoints[i], latticePoints[j]).div(2));
            }
          }
        }
      }
    }
    drawAtoms(vs);
  }
}

boolean rotationDisabled() {
  return rotationVec.mag() < 1e-3;
}
