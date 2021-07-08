void setupBravis() {
  resetRotationVectors();
  resetMirrorVectors();
  resetReverseVectors();
}

PointGroup pointGroup = null;
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

boolean showMirror = false;
PVector mirrorOrig, mirrorVec;
int mirrorMillis = -1000;
float mirrorScale = 0.0;
void resetMirrorVectors() {
  mirrorOrig = new PVector(0, 0, 0);
  mirrorVec = new PVector(0, 0, 0);
}
float getMirrorScale() {
  float t = easeInOutCubic(min((millis() - mirrorMillis) / 1000.0, 1));
  return t * mirrorScale;
}

PVector reverseOrig;
int reverseMillis = -1000;
float reverseScale = 1.0;
void resetReverseVectors() {
  reverseOrig = new PVector(0, 0, 0);
}
float getReverseScale() {
  return map(easeInOutCubic(min((millis() - reverseMillis) / 1000.0, 1)), 0, 1, 1, reverseScale);
}

void bravais() {
  background(0);
  PVector[] currentVector = getCurrentVector();
  PVector[] latticePoints = getLatticeVectors(new PVector(), currentVector, 100);

  stroke(0, 255, 255);
  strokeWeight(2);
  drawAxis(latticePoints, rotationOrig, rotationVec);
  stroke(255, 0, 255);
  strokeWeight(2);
  drawAxis(latticePoints, mirrorOrig, mirrorVec);

  strokeWeight(1);
  stroke(255, 0, 0);
  line(0, 0, 0, 1000, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 1000, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 1000);

  if(showMirror){
    PVector[] u = getPrependiculars(mirrorVec, 500);
    noStroke();
    fill(255, 255, 255, 16);
    beginShape(QUAD);
    PVector[] ws = {
      mirrorOrig.copy().add(u[0]),
      mirrorOrig.copy().add(u[1]),
      mirrorOrig.copy().sub(u[0]),
      mirrorOrig.copy().sub(u[1]),
    };
    for(PVector w : ws) vertex(w.x, w.y, w.z);
    endShape();
  }

  pushMatrix();
  PMatrix3D m = new PMatrix3D();
  if(!small(rotationVec) || !small(mirrorVec)) 
    drawLattice(latticePoints, true);
  if(!small(rotationVec)){
    PVector o = translateVec(rotationOrig, latticePoints), v = translateVec(rotationVec, latticePoints);
    m.translate(o.x, o.y, o.z);
    m.rotate(getRotationAngle(), v.x, v.y, v.z);
    m.translate(-o.x, -o.y, -o.z);
  }
  if(!small(mirrorVec)){
    PVector o = translateVec(mirrorOrig, latticePoints), v = mirrorVec.copy().normalize();
    m.translate(o.x, o.y, o.z);
    float t = getMirrorScale();
    m.apply(
      1 - t*v.x*v.x, -t*v.x*v.y, -t*v.x*v.z, 0,
      -t*v.y*v.x, 1 - t*v.y*v.y, -t*v.y*v.z, 0,
      -t*v.z*v.x, -t*v.z*v.y, 1 - t*v.z*v.z, 0,
      0, 0, 0, 1
    );
    m.translate(-o.x, -o.y, -o.z);
  }
  m.scale(getReverseScale());
  applyMatrix(m);
  drawLattice(latticePoints, false);
  popMatrix();

  if (lastKeyTyped) {
    lastKeyTyped = false;
    if(!pressedKeyCodes.contains(ALT)) {
      if ('1' <= key && key < '1' + baseVectors.length) {
        beforeVector = currentVector;
        afterVector = baseVectors[key - '1'];
        changeMillis = millis();
      }
    } else {
      int k = key - '0';
      switch(k) {
        case 3:
        case 4:
        case 6:
          if(pointGroup != null && pointGroup.n == k) pointGroup = null;
          else pointGroup = new PointGroup(k);
          break;
        case 1: if(pointGroup != null) pointGroup.a ^= 1; break;
        case 2: if(pointGroup != null) pointGroup.b ^= 1; break;
        case 5: if(pointGroup != null) pointGroup.c ^= 1; break;
        case 7: if(pointGroup != null) pointGroup.d ^= 1; break;
      }
    }
    if (key == 'q') bravaisState = BravaisState.NONE;
    if (key == 'w') bravaisState = BravaisState.PRIMITIVE;
    if (key == 'e') bravaisState = BravaisState.BODY;
    if (key == 'r') bravaisState = BravaisState.FACE;
    if (key == 't') bravaisState = BravaisState.BASE;
    if (key == '0') showSurface = !showSurface;
    if ('x' <= key && key <= 'z' || 'X' <= key || key <= 'Z' || key == 'c') {
      if(pressedKeyCodes.contains(ALT)){
        mirrorScale = 0.0;
        if (key == 'x') mirrorVec.x = 1 - mirrorVec.x;
        if (key == 'y') mirrorVec.y = 1 - mirrorVec.y;
        if (key == 'z') mirrorVec.z = 1 - mirrorVec.z;
        if (key == 'c') {
          resetMirrorVectors();
        }
        println("mirror =", mirrorVec, mirrorOrig, mirrorScale);
      } else {
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
        reverseScale = 1.0;
      }
    }
    if (key == ',' || key == '.' || key == '/' || key == '_') {
      rotationMillis = millis();
      if(key == ',') rotationAngle = TAU / 2;
      if(key == '.') rotationAngle = TAU / 3;
      if(key == '/') rotationAngle = TAU / 4;
      if(key == '_') rotationAngle = TAU / 6;
    }
    if (key == 'm') {
      mirrorMillis = millis();
      mirrorScale = 2.0;
    }
    if (key == 'n') {
      reverseMillis = millis();
      reverseScale = -1.0;
    }
    if (key == 's') showMirror = !showMirror;
    if (key == ' ') {
       resetMirrorVectors();
       resetRotationVectors();
       resetReverseVectors();
       mirrorScale = 1.0;
       reverseScale = 1.0;
       rotationAngle = 0.0;
       showMirror = false;
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


// lps ... lattice points
PVector translateVec(PVector coef, PVector[] lps) {
  PVector ret = new PVector();
  for(int i = 0; i < 3; i++){
    ret.add(PVector.mult(lps[1<<i], coef.array()[i]));
  }
  return ret;
}
void drawAxis(PVector[] lps, PVector orig, PVector vec) {
  if(small(vec)) return;
  PVector o = translateVec(orig, lps), v = PVector.mult(translateVec(vec, lps), 100);
  PVector a = PVector.add(o, v), b = PVector.sub(o, v);
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

void drawLattice(PVector[] latticePoints, boolean thin){
  if(pointGroup == null) {
    pushMatrix();
    if (showSurface && !thin) fill(0, 0, 255, 64); 
    else noFill();
    strokeWeight(4);
    if(thin) stroke(64, 64, 0); else stroke(255, 255, 0);
    parallelepiped(latticePoints);
    popMatrix();
  } else {
    pointGroup.drawPointGroup(thin);
  }

  if(pointGroup == null) {
    noStroke();
    if(thin) fill(255, 0, 255, 32); else fill(255, 0, 255);
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
}

void drawAtoms(ArrayList<PVector> latticePoints) {
  for (PVector v : latticePoints) {
    pushMatrix();
    translate(v.x, v.y, v.z);
    sphere(5);
    popMatrix();
  }
}

boolean small(PVector vec) {
  return vec.mag() < 1e-3;
}
