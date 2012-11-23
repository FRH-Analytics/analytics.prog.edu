package gui;

import processing.core.PApplet;
import processing.core.PVector;

public class Botao {
	
	private int x, y, width, height;
	private String label;
	
	public Botao(String label, int x, int y, int width, int height) {
		this.x = x;
		this.y = y;
		this.width= width;
		this.height = height;
		
		this.label = label;
	}
	
	public void draw(PApplet p) {
		p.noStroke();
		p.fill(240);
		p.rect(x, y, x + width, y + height);
		p.fill(250);
		p.rect(x, y, x + width - 5, y + height - 5);

		p.fill(130);
		p.text(label,x + width / 2 - label.length() * 4, y + 20);
	}
	
	public boolean isHover(PApplet p) {
		PVector mouse = new PVector(p.mouseX, p.mouseY);
		return mouse.x > x && mouse.y > y && mouse.x < x + width && mouse.y < y + height;
	}
}
