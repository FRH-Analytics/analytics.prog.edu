package graphic;

import processing.core.PApplet;
import processing.core.PVector;

public class OLDAlgumPlot {
	
	private PApplet parent;
	private float[] x, y;
	private int[] qtd;
	private int maxX, maxY;
	private int squareSpace;
	
	public String eixoX = "";
	public String eixoY = "";
	public String eixoZ = "";
	public String eixoW = "";
	public String titulo = "";
	
	private int startAtY = 42, startAtX = 10;
	
	private int maxQtd() {
		int max = qtd[0];
		for (int i = 0; i < qtd.length; i++)
			if (qtd[i] > max)
				max = qtd[i];
		
		return max;
	}
	
	public OLDAlgumPlot(PApplet p, int maxX, int maxY, int squareSpace) {
		parent = p;
		this.maxX = maxX;
		this.maxY = maxY;
		this.squareSpace = squareSpace;
	}
	
	public void setData(float[] x, float[] y, int[] qtd) {
		this.x = x;
		this.y = y;
		this.qtd = qtd;
	}
	
	public int high() {
		return startAtY + (maxY + 3) * squareSpace;
	}
	
	public void draw(int x, int y, int width, int height) {
		parent.fill(120);
		
		parent.textSize(20);
		parent.text(titulo, startAtX, startAtY - 22);
		parent.textSize(10);
		parent.text(eixoX + " x " + eixoY, startAtX, startAtY - 10);
		
		parent.textSize(squareSpace / 2);
		for (int i = 0; i <= maxY; i++) {
			parent.text("" + (maxY - i), startAtX, startAtY + (i + 2) * squareSpace);
			parent.text("" + (maxY - i), startAtX + (maxX + 2) * squareSpace, startAtY + (i + 2) * squareSpace);
		}
		
		for (int i = 0; i <= maxX; i++) {
			parent.text("" + (i), startAtX + (i + 1) * squareSpace, startAtY + squareSpace / 2);
			parent.text("" + (i), startAtX + (i + 1) * squareSpace, startAtY + (maxY + 3) * squareSpace);
		}
		
		for (int i = 0; i < this.x.length; i++) {
			parent.fill(255 - ((float) qtd[i] / 100) * 255);
//			parent.stroke(255 - ((float) qtd[i] / 100) * 255, 0, 0);
			parent.rect(startAtX + squareSpace + (this.x[i]) * squareSpace, startAtY + (maxY + 1 - this.y[i]) * squareSpace, squareSpace, squareSpace);
		}
	}
	
	public float[] getSquare(PVector mouse) {
		for (int i = 0; i < this.x.length; i++)
			if (mouse.x >= startAtX + squareSpace + (this.x[i]) * squareSpace && mouse.x <= startAtX + squareSpace + (this.x[i]) * squareSpace + squareSpace)
				if (mouse.y >= startAtY + (maxY + 1 - this.y[i]) * squareSpace && mouse.y <= startAtY + (maxY + 1 - this.y[i]) * squareSpace + squareSpace)
						return new float[] {this.x[i], this.y[i], this.qtd[i]};
		
		return null;
	}
	
	public int getSquareIndex(PVector mouse) {
		for (int i = 0; i < this.x.length; i++)
			if (mouse.x >= startAtX + squareSpace + (this.x[i]) * squareSpace && mouse.x <= startAtX + squareSpace + (this.x[i]) * squareSpace + squareSpace)
				if (mouse.y >= startAtY + (maxY + 1 - this.y[i]) * squareSpace && mouse.y <= startAtY + (maxY + 1 - this.y[i]) * squareSpace + squareSpace)
					return i;
		
		return -1;
	}
	
	public void hover() {
		PVector mouse = new PVector(parent.mouseX, parent.mouseY);
		float[] ponto = getSquare(mouse);
		if (ponto != null) {
			parent.textSize(16);
			parent.text(eixoY + ": " + (int) ponto[0], 200, high() + 16);
			parent.text(eixoX + ": " + (int) ponto[1], 200, high() + 32);
			parent.text(eixoZ + ": " + (int) ponto[2], 200, high() + 48);
		}
	}
	
	public void hover(float w) {
		parent.textSize(16);
		parent.text(eixoW + ": " + w, 200, high() + 64);
	}
}
