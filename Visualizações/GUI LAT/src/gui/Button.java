package gui;

import processing.core.PApplet;
import processing.core.PVector;

class Button {
	
	int x, y, width, height, textSize;
	String label;
	PApplet parent;
	int colorRect = 0;
	int colorText = 255;
	boolean clicado = false;
	
	public Button(String label, int x, int y, int width, int height, PApplet p) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.label = label;
		parent = p;
	}
	
	public boolean foiClicado() {
		PVector mouse = new PVector(parent.mouseX, parent.mouseY);
		return mouse.x > x && mouse.y > y && mouse.x < x + width && mouse.y < y + height;
	}
	
	public void draw() {
		if (clicado) {
			colorRect = 0;
			colorText = 255;
		} else {
			colorRect = 255;
			colorText = 0;
		}
		
		parent.fill(colorRect);
		parent.rect(x, y, width, height);
		parent.fill(colorText);
		parent.text(label, x + 10, y + 20);
		parent.fill(0);
	}
}