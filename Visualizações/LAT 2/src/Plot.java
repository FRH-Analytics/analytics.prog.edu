import java.awt.Color;

import processing.core.*;

public class Plot extends PApplet{
		  Point2D topLeft, bottomRight;
		  //color c;
		  
		  Plot(int x1_, int y1_, int x2_, int y2_) {
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
