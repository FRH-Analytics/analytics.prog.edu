package gui;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;

public class Menu {
	
	private List<Button> botoes;
	public int selected = 0;
	private String[] labels;
	private int x, y;
	private int width, height;
	private PApplet parent;
	
	private void loadButtons() {
		botoes = new ArrayList<Button>();
		for (int i = 0; i < labels.length; i++)
			botoes.add(new Button(labels[i], x, y + i * height, width, height, parent));
	}
	
	public Menu(String[] labels, int x, int y, int width, int height, PApplet p) {
		this.labels = labels;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		parent = p;
		
		loadButtons();
	}
	
	public void draw() {
		for (int i = 0; i < botoes.size(); i++) {
			if (selected == i)
				botoes.get(i).clicado = true;
			else
				botoes.get(i).clicado = false;
			
			botoes.get(i).draw();
		}
	}
	
	public void selectMenu(int i) {
		selected = i;
	}
	
	public void botaoClicado() {
		for (int i = 0; i < botoes.size(); i++)
			if (botoes.get(i).foiClicado())
				selected = i;
	}
}
