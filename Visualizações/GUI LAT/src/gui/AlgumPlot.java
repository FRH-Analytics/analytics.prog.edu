package gui;

import java.util.Arrays;

import processing.core.PApplet;
import processing.core.PVector;

public class AlgumPlot {
	
	private PApplet parent;
	private int[] x, y;
	private int[] qtd;
	private int maxX, maxY;
	private int squareSpace;
	
	private int[][] data2;
	
	private final int X_CORD = 0;
	private final int Y_CORD = 1;
	private final int QTD = 2;
	public int[][][] data;
	
	
	public String eixoX = "";
	public String eixoY = "";
	public String eixoZ = "";
	public String eixoW = "";
	public String titulo = "";
	
	private int startAtY = 42, startAtX = 10;
	
	private boolean probabilidades = false;
	
	public AlgumPlot(PApplet p, int maxX, int maxY, int squareSpace) {
		parent = p;
		this.maxX = maxX;
		this.maxY = maxY;
		this.squareSpace = squareSpace;
	}
	
	public AlgumPlot(PApplet p, int maxX, int maxY, int squareSpace, boolean probabilidades) {
		parent = p;
		this.maxX = maxX;
		this.maxY = maxY;
		this.squareSpace = squareSpace;
		
		this.probabilidades = probabilidades;
	}
	
	public void setData(int[] x, int[] y, int[] qtd) {
		this.x = x;
		this.y = y;
		this.qtd = qtd;
		
		loadData();
	}
	
	private void loadData() {
		data2 = new int[maxX][maxY];

		for (int i = 0; i < x.length; i++)
			data2[x[i] - 1][y[i] - 1] = qtd[i];
		
		int qtdEixoX = 0;
		for (int i = 0; i < data2.length; i++)
			if (!arrayVazio(data2[i]))
				qtdEixoX++;
		
		int qtdEixoY = 0;
		for (int i = 0; i < data2[0].length; i++) {
			int[] temp = new int[data2.length];
			for (int j = 0; j < temp.length; j++)
				temp[j] = data2[j][i];
			if (!arrayVazio(temp))
				qtdEixoY++;
		}
		
		int[][][] data_temp = new int[qtdEixoX][maxY][3];
		
		int subtratorX = 0;
		for (int i = 0; i < data2.length; i++) {
			if (!arrayVazio(data2[i]))
				for (int j = 0; j < data2[i].length; j++) {
					int t = i - subtratorX;
					data_temp[t][j][X_CORD] = i;
					data_temp[t][j][Y_CORD] = j;
					
					if (data2[i][j] > 0)
						data_temp[t][j][QTD] = data2[i][j];
				}
			else
				subtratorX++;
		}
		
		
		data = new int[qtdEixoX][qtdEixoY][3];
		int subtratorY = 0;
		for (int j = 0; j < data_temp[0].length; j++) {
			int[] temp = new int[data_temp.length];
			for (int i = 0; i < temp.length; i++)
				temp[i] = data_temp[i][j][QTD];
			if (!arrayVazio(temp)) {
				for (int i = 0; i < data_temp.length; i++) {
					int t = j - subtratorY;
					data[i][t][X_CORD] = data_temp[i][j][X_CORD];
					data[i][t][Y_CORD] = j;
					if (data_temp[i][j][QTD] > 0) {
						data[i][t][QTD] = data_temp[i][j][QTD];
					}
				}
			} else
				subtratorY++;
		}
		
//		for (int i = 0; i < data.length; i++) {
//			System.out.println("i: " + i);
//			for (int j = 0; j < data[i].length; j++) {
//				System.out.print(Arrays.toString(data[i][j]) + " ");
//			}
//			System.out.println();
//		}
	}
	
	private boolean arrayVazio(int[] array) {
		for (int i = 0; i < array.length; i++)
			if (array[i] != 0)
				return false;
		return true;
	}
	
	public int high() {
		return startAtY + (maxX + 3) * squareSpace;
	}
	
	public void drawSquares() {
		for (int i = 0; i < data.length; i++) {
			for (int j = 0; j < data[i].length; j++) {
				float cor = 255 - ((float) data[3 - i][j][QTD] / 100) * 255;
				parent.fill(cor);
				parent.stroke(cor);
				parent.rect(startAtX + squareSpace + j * squareSpace, startAtY + (i + 1) * squareSpace, squareSpace, squareSpace);
				
				if (cor > 127)
					cor = 0;
				else
					cor = 255;
				
				parent.fill(cor);
				parent.text("" + data[3 - i][j][QTD], startAtX + squareSpace + j * squareSpace, startAtY + (i + 1) * squareSpace + squareSpace);
			}
		}
	}
	
	public void drawSquaresAt(int comeco, int qtd, int x, int y, int squareX, int squareY) {
		for (int i = 0; i < data.length; i++) {
			for (int j = comeco; j < comeco + qtd; j++) {
				
				int quantidade = data[3 - i][j][QTD];
				float cor = 255 - ((float) quantidade / 100) * 255;
				
				parent.fill(cor);
				parent.stroke(cor);
				int atX = x + (j - comeco) * squareX;
				int atY = y + i * squareY;
				parent.rect(atX, atY, atX + squareX, atY + squareY);
				
				if (cor > 127)
					cor = 0;
				else
					cor = 255;
				
				parent.fill(cor);
				if (probabilidades)
					parent.text("" + quantidade  + "%", atX + 30, atY + 30);
				else
					parent.text("" + quantidade, atX + 30, atY + 30);
//				parent.text("" + data[3 - i][j][QTD], startAtX + squareSpace + j * squareSpace, startAtY + (i + 1) * squareSpace + squareSpace);
			}
		}
	}
	
	public int[] getSquareAt(PVector mouse, int comeco, int qtd, int x, int y, int squareX, int squareY) {
		for (int i = 0; i < data.length; i++) {
			
			if (mouse.y >= y + (data.length - i - 1) * squareY &&
					mouse.y <= y + (data.length - i - 1) * squareY + squareY) {
				
				for (int j = 0; j < qtd; j++) {
					
					if (mouse.x >= x + j * squareX && 
							mouse.x <= x + j * squareX + squareX) {
						return new int[] {data[i][comeco + j][X_CORD] + 1, data[i][comeco + j][Y_CORD] + 1, data[i][comeco + j][QTD]};
					}
					
				}
				
			}
			
		}
//			if (mouse.y >= startAtY + (data.length - i) * squareSpace && mouse.y <= startAtY + (data.length - i) * squareSpace + squareSpace)
//				for (int j = 0; j < data[i].length; j++)
//					if (mouse.x >= startAtX + squareSpace + j * squareSpace && mouse.x <= startAtX + squareSpace + j * squareSpace + squareSpace)
//						return new int[] {data[i][j][X_CORD] + 1, data[i][j][Y_CORD] + 1, data[i][j][QTD]};
		return null;
	}
	
	public void drawXAxis() {
		for (int i = 0; i < data[0].length; i++)
			parent.text("" + (data[0][i][Y_CORD] + 1), startAtX + (i + 1) * squareSpace, startAtY + (data[0][i].length + 3) * squareSpace);
	}
	
	public void drawYAxis() {
		for (int i = 0; i < data.length; i++)
			parent.text("" + (data.length - i), startAtX, startAtY + (i + 2) * squareSpace);
	}
	
	public void draw(int x, int y, int width, int height) {
		parent.fill(120);
		
		parent.textSize(20);
		parent.text(titulo, startAtX, startAtY - 22);
		parent.textSize(10);
		parent.text(eixoX + " x " + eixoY, startAtX, startAtY - 10);
		
		parent.textSize(squareSpace / 2);
		
		drawYAxis();
		drawXAxis();
		drawSquares();
	}
	
	public int[] getSquare(PVector mouse) {
		for (int i = 0; i < data.length; i++)
			if (mouse.y >= startAtY + (data.length - i) * squareSpace && mouse.y <= startAtY + (data.length - i) * squareSpace + squareSpace)
				for (int j = 0; j < data[i].length; j++)
					if (mouse.x >= startAtX + squareSpace + j * squareSpace && mouse.x <= startAtX + squareSpace + j * squareSpace + squareSpace)
						return new int[] {data[i][j][X_CORD] + 1, data[i][j][Y_CORD] + 1, data[i][j][QTD]};
		return null;
	}
	
	public void hover() {
		PVector mouse = new PVector(parent.mouseX, parent.mouseY);
		int[] ponto = getSquare(mouse);
		if (ponto != null && ponto[QTD] > 0) {
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
