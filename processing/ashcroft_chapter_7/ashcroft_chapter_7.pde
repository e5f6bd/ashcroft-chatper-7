import java.util.HashSet;

void setup () {
  size(960, 960, P3D);
  ortho();
  setupBravis();
}

float cameraX = -140, // 235, 
      cameraY = -355, // -70, 
      cameraZ = 325; // 150;

      
void draw (){
  camera(cameraX, cameraY, cameraZ, 250, 250, 0, 0, 0, -1);
  bravais();
}

boolean lastKeyTyped = false;
HashSet<Integer> pressedKeyCodes = new HashSet();
void keyPressed () {
  lastKeyTyped = true;
  pressedKeyCodes.add(keyCode);
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
void keyReleased() {
  pressedKeyCodes.remove(keyCode);
}
