//static class Matrix {
//  float[][] a = new float[4][4];
//  static Matrix identity() {
//    Matrix m = new Matrix();
//    for(int i = 0; i < 4; i++){
//      m.a[i][i] = 1;
//    }
//    return m;
//  }
  
//  Matrix multiply(Matrix b){
//    Matrix a = this;
//    Matrix c = new Matrix();
//    for(int i = 0; i < 4; i++){
//      for(int j = 0; j < 4; j++){
//        for(int k = 0; k < 4; k++){
//          c.a[i][j] += a.a[i][k] * b.a[k][j];
//        }
//      }
//    }
//    return c;
//  }
  
//  static Matrix rotation(PVector n, float theta){
//    Matrix a = new Matrix();
//    float c = cos(theta), s = sin(theta);
//    a.a = new float[][]{
//      {c + n.x*n.x*(1-c), n.x*n.y*(1-c) - n.z*s, n.z*n.x*(1-c) + n.y*s, 0},
//      {n.x*n.y*(1-c) + n.z*s, c + n.y*n.y*(1-c), n.y*n.z*(1-c) - n.x*s, 0},
//      {n.z*n.x*(1-c) - n.y*s, n.y*n.z*(1-c) + n.x*s, c + n.z*n.z*(1-c), 0},
//      {0, 0, 0, 1},
//    };
//    return a;
//  }
//}

//void apply(Matrix m) {
//  applyMatrix(
//  );
//}

void printMatrix(PMatrix3D m){
  System.out.printf("%f %f %f %f%n", m.m00, m.m01, m.m02, m.m03);
  System.out.printf("%f %f %f %f%n", m.m10, m.m11, m.m12, m.m13);
  System.out.printf("%f %f %f %f%n", m.m20, m.m21, m.m22, m.m23);
  System.out.printf("%f %f %f %f%n", m.m30, m.m31, m.m32, m.m33);
}

PVector[] getPrependiculars(PVector v, float d) {
  v = v.copy().normalize();
  float[] a = v.array();
  float[] b = new float[3];
  for(int i = 0; i < 3; i++){
    int j = (i+1)%3, k = (i+2)%3;
    if(dist(0,0,a[j],a[k]) > 1e-3){
      b[i] = 0;
      b[j] = -a[k];
      b[k] = a[j];
    }
  }
  PVector u = new PVector(b[0], b[1], b[2]);
  return new PVector[] {u.copy().mult(d), u.copy().cross(v).mult(d)};
}
