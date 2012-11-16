package graphic;

import processing.core.PApplet;
import processing.core.PVector;

public class Plot {
	
	private PApplet parent;
	private float[] x, y;
	private int[] qtd;
	private int maxX, maxY;
	private int squareSpace;
	
	private int startAtY = 42, startAtX = 10;
	
	private int maxQtd() {
		int max = qtd[0];
		for (int i = 0; i < qtd.length; i++)
			if (qtd[i] > max)
				max = qtd[i];
		
		return max;
	}
	
	public Plot(PApplet p, int maxX, int maxY, int squareSpace) {
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
		return startAtY + (maxY + 2) * squareSpace;
	}
	
	public void draw(int x, int y, int width, int height) {
		parent.fill(120);
		
		parent.textSize(20);
		parent.text("Influencia das questões dos exercicios em relação às questões da prova", startAtX, startAtY - 22);
		parent.textSize(10);
		parent.text("Questões da Prova x Questões dos Exercícios", startAtX, startAtY - 10);
		
		parent.textSize(squareSpace / 2);
		for (int i = 0; i < maxY; i++) {
			parent.text("" + (maxY - i), startAtX, startAtY + (i + 2) * squareSpace);
			parent.text("" + (maxY - i), startAtX + (maxX + 2) * squareSpace, startAtY + (i + 2) * squareSpace);
		}
		
		for (int i = 0; i < maxX; i++) {
			parent.text("" + (i + 1), startAtX + (i + 1) * squareSpace, startAtY + squareSpace / 2);
			parent.text("" + (i + 1), startAtX + (i + 1) * squareSpace, startAtY + (maxY + 2) * squareSpace);
		}
		
		for (int i = 0; i < this.x.length; i++) {
			parent.fill(255 - ((float) qtd[i] / 100) * 255);
//			parent.stroke(255 - ((float) qtd[i] / 100) * 255, 0, 0);
			parent.rect(startAtX + squareSpace + (this.x[i] - 1) * squareSpace, startAtY + (maxY + 1 - this.y[i]) * squareSpace, squareSpace, squareSpace);
		}
	}
	
	public float[] getSquare(PVector mouse) {
		for (int i = 0; i < this.x.length; i++)
			if (mouse.x >= startAtX + squareSpace + (this.x[i] - 1) * squareSpace && mouse.x <= startAtX + squareSpace + (this.x[i] - 1) * squareSpace + squareSpace)
				if (mouse.y >= startAtY + (maxY + 1 - this.y[i]) * squareSpace && mouse.y <= startAtY + (maxY + 1 - this.y[i]) * squareSpace + squareSpace)
					return new float[] {this.x[i], this.y[i], this.qtd[i]};
		
		return null;
	}
	
	public void hover() {
		PVector mouse = new PVector(parent.mouseX, parent.mouseY);
		float[] ponto = getSquare(mouse);
		if (ponto != null) {
			parent.textSize(16);
			parent.text("Questão da Prova: " + (int) ponto[1], 200, high() + 16);
			parent.text("Questão do Exercício: " + (int) ponto[0], 200, high() + 32);
			parent.text("Quantidade de Alunos: " + (int) ponto[2], 200, high() + 48);
		}
	}
}
