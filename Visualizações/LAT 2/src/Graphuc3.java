	/*
	 *      GraphUC3.java
	 *      Estrutura o gráfico da UC3 com todas as classes necessárias
	 *      
	 *      Copyright 2012 Iara <iara@atena>
	 */

import java.awt.Color;

import processing.core.*;

public class Graphuc3{
	
	Bubble2[] bubbles = new Bubble2[57];
	PApplet parent;
	PImage bg;
	int r = 4;
	boolean opcao = true;
	
	public Graphuc3(PApplet p){
		this.parent = p;
		//setup();
	}
	 
	public void setup(boolean opcao) {
	  this.opcao = opcao;
	  // plot bubbles
	  
	  //mousePressed();
	  draw();
	}
	
	public void draw() {
		if(opcao){
			parent.image(parent.loadImage("uc3.1.png"),0,100);
			generateValues();
			  // display bubbles
			  for (int i = 1; i < bubbles.length; i++) {
				  bubbles[i].display(bubbles[i].c1, bubbles[i].c2, bubbles[i].c3);
			  }
			   
			  // display labels
			  for (int i = 1; i < bubbles.length; i++) {
					  bubbles[i].displayLabel("Ativi.:");  			    
			  }
		}else{
			parent.image(parent.loadImage("uc3.2.png"), 0, 100);
			generateValues2();
			  // display bubbles
			  for (int i = 1; i < bubbles.length; i++) {
			  //  bubbles[i].display();
				  bubbles[i].display(bubbles[i].c1, bubbles[i].c2, bubbles[i].c3);
			  }
			   
			  // display labels
			  for (int i = 1; i < bubbles.length; i++) {
				  bubbles[i].displayLabel("Quant.:");
			  }
		}
		
		parent.noStroke();
		parent.fill(240);
		parent.rect(345,145,555,110);
		parent.rect(580,145,775,110);
		parent.fill(250);
		parent.rect(345,140,550,110);
		parent.rect(580,140,770,110);

		parent.fill(130);
		parent.text("Atividade",420,130);
		parent.text("Quantidade de exercícios",600,130);
		
		

	}
	 
	public void generateValues() {
		String[] data = parent.loadStrings("AgrupamentoAtividade.csv");
	  for (int i = 1; i < bubbles.length; i++) {
		String[] temp= parent.split(data[i],",");
	    float x = Float.parseFloat(temp[5]);
	    float y = Float.parseFloat(temp[4]);
	    String id = temp[3];
	    int perfil = Integer.parseInt(temp[7]);
	    bubbles[i] = new Bubble2(parent,(168*x) - 497,(-345*y) + 515, id,perfil,x,y);
	  }
	}
	
	public void generateValues2() {
		String[] data = parent.loadStrings("AgrupamentoExercicios.csv");
	  
	  for (int i = 1; i < bubbles.length; i++) {
		String[] temp= parent.split(data[i],",");
	    float x = Float.parseFloat(temp[4]);
	    float y = Float.parseFloat(temp[3]);
	    String id = temp[2];
	    int perfil = Integer.parseInt(temp[6]);
	    bubbles[i] = new Bubble2(parent,(168*x) - 495,(Float.parseFloat("-2.5")*y) + 616, id,perfil,x,y);
	  }
	}
}
