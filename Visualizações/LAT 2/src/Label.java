import java.awt.Color;

import processing.core.*;

public class Label extends PApplet {
	   
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
	    fill(0);
	    text(txt, x+15, y-15);
	  }
	}


