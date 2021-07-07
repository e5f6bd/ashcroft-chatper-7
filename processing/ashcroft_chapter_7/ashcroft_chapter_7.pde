void setup () {
  size(960, 540, P3D);
  ortho();
}

float cameraX = -140, // 235, 
      cameraY = -355, // -70, 
      cameraZ = 325; // 150;

      
void draw (){
  camera(cameraX, cameraY, cameraZ, 400, 400, 0, 0, 0, -1);
  bravais();
}

boolean lastKeyTyped = false;
void keyPressed () {
  lastKeyTyped = true;
  float d = 15;
  if(key == 'h') cameraX -= d;
  if(key == 'l') cameraX += d;
  if(key == 'j') cameraY -= d;
  if(key == 'k') cameraY += d;
  if(key == 'u') cameraZ -= d;
  if(key == 'i') cameraZ += d;
  if(key == 'o') ortho();
  if(key == 'p') perspective();
  System.out.printf("camera = (%f, %f, %f)%n", cameraX, cameraY, cameraZ);
}
