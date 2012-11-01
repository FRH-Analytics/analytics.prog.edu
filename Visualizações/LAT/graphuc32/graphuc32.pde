/*
 *      sem título.java
 *      
 *      Copyright 2012 Iara <iara@atena>
 */
 
 class Bubble {
  float x, y, x_value;
  int y_value;
  int r = 4;
  int perfil;
  String id;
  color c;
  
  Bubble(float x_, float y_, String id_,int perfil_, float x_v, float y_v) {
    x = x_;
    y = y_;
    x_value = x_v;
    y_value = int(y_v);
    id = id_;
    perfil = perfil_;
    //mudar a cor de acordo com o perfil do usuario
    if(perfil == 1){
      c = color(352,74,85);
    }else if (perfil == 2){
      c = color(49,167,64);
    }else if (perfil == 3){
      c = color(49,79,167);
    }else{
      c = 200;
    }
      
  }
   
  void display() {

    if (dist(mouseX, mouseY, x, y) <= r) {
      fill(0);
    } else {
      fill(c);
    }
     
    noStroke();
    ellipse(x, y, r*2, r*2);
  }
   
  void displayLabel() {
    if (dist(mouseX, mouseY, x, y) <= r) {
      String txt = "Aluno: " + id + "\nQuant.:" + y_value + ", Nota: " + x_value;
      Label label = new Label(txt, mouseX, mouseY);
    }
  }
}

class Label {
   
  Label(String txt, float x, float y) {
     
    // get text width
    float labelW = textWidth(txt);
     
    // check if label would go beyond screen dims
    if (x + labelW + 20 > width) {
      x -= labelW + 20;
    }
     
    // draw bg
    fill(255);
    noStroke();
    rectMode(CORNER); // note: this is the default mode. confusing b/c similar to CORNERS (plural)
    rect(x+10, y-30, labelW+10, 35);
     
    // draw text
    fill(0);
    text(txt, x+15, y-15);
  }
}
class Point2D {
  float x, y;
   
  Point2D(float x_, float y_) {
    x = x_;
    y = y_;
  }
   
  float x() {
    return x;
  }
   
  float y() {
    return y;
  }
}
class Plot {
  Point2D topLeft, bottomRight;
  //color c;
  
  Plot(int x1_, int y1_, int x2_, int y2_, color c_) {
    topLeft = new Point2D(x1_, y1_);
    bottomRight = new Point2D(x2_, y2_);
   // c = c_;
  }
   
  Point2D topLeft() {
    return topLeft;
  }
   
  Point2D bottomRight() {
    return bottomRight;
  }
   
  float w() {
    return bottomRight.x - topLeft.x;
  }
   
  float h() {
    return bottomRight.y - topLeft.y;
  }
}

Plot plot;
Bubble[] bubbles = new Bubble[110];
 
int leftMargin = 20;
int rightMargin = 20;
int topMargin = 200;
int bottomMargin = 10;
PImage bg;
 
int minRadius = 10;
int maxRadius = 30;
 
void setup() {
  
  size(980, 680);
  bg = loadImage("uc3.2.png");

  // initialize plot
  plot = new Plot(leftMargin, topMargin, width-rightMargin, height-topMargin, color(235));
   
  // plot 5 bubbles
  generateValues();
}
 
void draw() {
  background(bg);
  fill(102);
  text("Notas", 480, 570); 
  text("Alunos por nota final e quantidade de exercícios submetidos", 310, 70); 
   
  // display bubbles
  for (int i = 1; i < bubbles.length; i++) {
    bubbles[i].display();
  }
   
  // display labels
  for (int i = 1; i < bubbles.length; i++) {
    bubbles[i].displayLabel();
  }
  
}
 
void generateValues() {
  String[] data = loadStrings("uc3.2.csv");
  for (int i = 1; i < bubbles.length; i++) {
    String[] temp=split(data[i],",");
    //println(temp);
    float x = float(temp[2]);
    float y = float(temp[3]);
    println(x);
    println(y);
    String id = temp[1];
    int perfil = int(temp[4]);
    bubbles[i] = new Bubble((95*x) - 55, (-2.4 *y) + 520, id,perfil,x,y);
  }
}


