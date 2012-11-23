package uc;

import gui.Bar;
import gui.GraphicUC;

import java.text.DecimalFormat;
import java.text.NumberFormat;

import processing.core.PApplet;
import processing.core.PImage;

public class UC4 extends GraphicUC {
	
	private PImage bg,grid;
	private Bar[] allBars, bars;
	
	private int gx = 63;
	
	public UC4(PApplet p) {
		super(p);
		this.bg = parent.loadImage("bg_uc4.png");
		this.grid = parent.loadImage("grid2.png");
		
		generateValues();
		
		bars = new Bar[5];
	}

	@Override
	public void draw(int click) {
		updategrid(click);
		showbars(click);
	}
	
	//Bar(String id, float mtt, float mtp, float ex, float prova, int i)
	private void generateValues() {
		String[] data = parent.loadStrings("uc4.csv");
		allBars = new Bar[data.length];
		 
		for (int i = 1; i < 58; i++) {
			String[] temp= PApplet.split(data[i],",");
			String id = temp[1];
			float mtt = Float.parseFloat(temp[2]);
			float mtp =  Float.parseFloat(temp[3]);
			float ex = Float.parseFloat(temp[4]);
			float prova =  Float.parseFloat(temp[5]);
			float nota_final =  Float.parseFloat(temp[6]);
			allBars[i] = new Bar(id,mtt,mtp,ex,prova, i,nota_final);
		}
	}
	
	public Bar getBar(int i){
		return allBars[i];
	}
	
	public void updategrid(int click){
		parent.image(bg,0,100);
		
		if(click != 0)
			parent.image(grid,gx + (click * 19), 481);
		else
			parent.image(grid, gx, 481);
	 }
	  
	public void showbars(int click) {
		for (int i = 0; i < bars.length; i++)
			bars[i] = getBar(click + (i + 1));
		
		NumberFormat formatter = new DecimalFormat("#0.0");
		parent.noStroke();
			
		//barra mtt = nota total
		parent.fill(189,201,225);//mtt
		for (int i = 0; i < bars.length; i++)
			parent.rect(195 + (i * 95), 440, 115 + (i * 95), 476 - (bars[i].nota) * 35);
			
		//barra mtp = nota - mtt
		parent.fill(103,169,207);//mtp
		for (int i = 0; i < bars.length; i++)
			parent.rect(195 + (i * 95), 440, 115 + (i * 95), 467 - (bars[i].nota - bars[i].mtt) * 35);
			
		//barra provas = nota - (mtt + mtp)
		parent.fill(28,144,153);//provas
		for (int i = 0; i < bars.length; i++)
			parent.rect(195 + (i * 95), 440, 115 + (i * 95), 460 - (bars[i].ex + bars[i].prova) * 35);
		
		//barra exercicios
		parent.fill(1,108,89);
		for (int i = 0; i < bars.length; i++)
			parent.rect(195 + (i * 95), 440, 115 + (i * 95), 445 - (bars[i].ex) * 35);
		
		parent.fill(130,130,130);
		for (int i = 0; i < bars.length; i++) {
			parent.text(bars[i].id, 120 + (i * 96), 460);
			parent.text(formatter.format(bars[i].nota), 140 + (i * 96), (465 - (bars[i].nota) * 35));
		}
	}

	@Override
	public void mousePressed() {
		// TODO Auto-generated method stub
		
	}
}
