int MAX_LAYERS = 15;
int MAX_TREES_PER_LAYER = 8;

int SCENE_WIDTH = (int) (1920 * 3);
int SCENE_HEIGHT = (int) (1080 * 3);
float SCENE_SCALE = 4;

String SAVE_FILENAME;
 
float LOWER_BRANCH_WIDTH = 35 * SCENE_SCALE;
float UPPER_BRANCH_WIDTH = 40 * SCENE_SCALE;
float LOWER_TREE_HEIGHT = 6 * SCENE_HEIGHT / 10;
float UPPER_TREE_HEIGHT = 8 * SCENE_HEIGHT / 10;
float LOWER_BRANCH_DIVISIONS = 50;
float UPPER_BRANCH_DIVISIONS = 80;
float LOWER_BRANCHLESS = 0.30;
float UPPER_BRANCHLESS = 0.36;
float LOWER_BRANCHFRACTION = 0.4;
float UPPER_BRANCHFRACTION = 0.6;
float LOWER_GROWTH_MAX = PI/18;
float UPPER_GROWTH_MAX = PI/15;
float LOWER_SPLIT_MAX = PI/18;
float UPPER_SPLIT_MAX = PI/15;
float LOWER_BRANCHPERCENT = 0.15;
float UPPER_BRANCHPERCENT = 0.20;

color BG_COLOR = color(0);
color FOG_COLOR = color(200, 200, 200, 50);

void setup(){
  smooth();
  size(SCENE_WIDTH, SCENE_HEIGHT, P2D);
  noFill();
  noLoop();
  
  int save_file_index = 0;
  while (true)
  {
    SAVE_FILENAME = String.format("forest-%04d.png", save_file_index);
    File f = new File(dataPath(SAVE_FILENAME));
    if (f.exists())
      save_file_index ++;
    else
      break;
  }
}
 
void draw(){
  for (int l = 0; l < MAX_LAYERS; l ++) {
    println("layer " + l);

    // fog
    fill(FOG_COLOR);
    noStroke();
    rect(0, 0, width, height);

    //trees
    drawTrees();

    // floor
    fill(0);
    noStroke();
    rect(0, height - ((MAX_LAYERS - l) * 5), width, ((MAX_LAYERS - l) * 5));
  }
  saveFrame(dataPath(SAVE_FILENAME));
  println("done. " + ((millis() / 1000) + " seconds."));
}
 
void drawTrees(){
  int trees = (int) random(MAX_TREES_PER_LAYER / 2, MAX_TREES_PER_LAYER);
  println ("Making " + trees + " tree(s).");

  for (int t = 0; t < trees; t ++) {
    int sTime = millis();
    Branch trunk = new Branch (
                      random(50, width - 50),
                      (float) height,
                      -HALF_PI,
                      random(LOWER_BRANCH_WIDTH, UPPER_BRANCH_WIDTH),
                      random(LOWER_TREE_HEIGHT, UPPER_TREE_HEIGHT),
                      (int) abs(random(LOWER_BRANCH_DIVISIONS, UPPER_BRANCH_DIVISIONS)),
                      random(LOWER_BRANCHLESS, UPPER_BRANCHLESS),
                      random(LOWER_BRANCHFRACTION, UPPER_BRANCHFRACTION),
                      random(LOWER_GROWTH_MAX, UPPER_GROWTH_MAX),
                      random(LOWER_SPLIT_MAX, UPPER_SPLIT_MAX),
                      random(LOWER_BRANCHPERCENT, UPPER_BRANCHPERCENT),
                      color((int) random(55,60),40,0),
                      SCENE_SCALE);
    trunk.draw();
    int diffTime = millis() - sTime;
    
    println("");
    println("Tree " + t + " took " + (diffTime / 1000) + " seconds.");
  }
}

