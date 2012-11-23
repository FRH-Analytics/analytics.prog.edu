package gui;

import processing.core.PApplet;

public abstract class GraphicUC {
	
	protected PApplet parent;
	
	public GraphicUC(PApplet p){
		this.parent = p;
	}
	
	public abstract void draw(int click);
	
	public abstract void mousePressed();
	
	protected boolean overRect(int x, int y, int width, int height)  {
	  return (parent.mouseX >= x && parent.mouseX <= x+width && parent.mouseY >= y && parent.mouseY <= y+height);
	}
}
