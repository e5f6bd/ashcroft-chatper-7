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