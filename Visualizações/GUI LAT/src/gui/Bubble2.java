package gui;
import processing.core.PApplet;

public class Bubble2{
	  public float x, y, x_value, y_value;
	  int r = 4;
	  int perfil;
	  String id;
	  public int c1,c2,c3;
	  PApplet parent;
	  
	  public Bubble2(PApplet p ,float x_, float y_, String id_,int perfil_, float x_v, float y_v) {
	    this.parent = p;
		x = x_;
	    y = y_;
	    x_value = x_v;
	    y_value = y_v;
	    id = id_;
	    perfil = perfil_;
	    //mudar a cor de acordo com o perfil do usuario
	    if(perfil == 2){
	      c1 = 255;
	      c2 = 74;
	      c3 = 85;
	    }else if (perfil == 1){
	      c1 = 49;
	      c2 = 167;
	      c3 = 64;
	    }else if (perfil == 3){
	      c1 = 49;
	      c2 = 79;
	      c3 = 167;
	    }else{
	    	c1 = 253;
	    	c2 = 174;
	    	c3 = 97;
	    }
	}
	  
	public void display(int c1, int c2, int c3) {
		    if (parent.dist(parent.mouseX, parent.mouseY, x, y) <= r) {
		    	parent.fill(0);
		    } else {
		    	parent.fill(c1,c2,c3);
		    }
		    parent.noStroke();
		    parent.ellipse(x, y, r*2, r*2);
		  }
		
		public void displayLabel(String tx) {
		    if (parent.dist(parent.mouseX, parent.mouseY, x, y) <= r) {
		      String txt = "Aluno: " + id + "\n" + tx + y_value + ", Nota: " + x_value;
		      label(txt, parent.mouseX, parent.mouseY);
		    }
		  }
		
		public void label(String txt, float x, float y) {
		    float labelW = parent.textWidth(txt);
		     
		    if (x + labelW + 20 > parent.width) {
		      x -= labelW + 20;
		    }
		    parent.fill(255);
		   // parent.rectMode(parent.CORNER); // note: this is the default mode. confusing b/c similar to CORNERS (plural)
		    //parent.rect(x+10, y-30, labelW+10, 35);
		    parent.fill(0);
		    parent.text(txt, x+15, y-15);
		}

}
