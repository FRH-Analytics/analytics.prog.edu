import processing.core.*;

public class GUI extends PApplet {
	int rectSize = 90;
	boolean opcao = true;
	boolean opcao1 = false;
	boolean opcao2 = false;
	boolean opcao3 = false;
	boolean opcao4 = false;
	int click = 0;
	GraphUC1 g1;
	Graphuc3 g3;
	GraphUC4 g4;
	 int gx = 16;

  public void setup() {
    size(1200,600);
   // g4.generateValues();
    g3 = new Graphuc3(this);
    g4 = new GraphUC4(this);
    g1 = new GraphUC1(this);
  }

  public void draw() {
	  background(255);
	  fill(245,245,245);
	  rectMode(CORNERS);
	  stroke(245,245,245);
	  rect(0, 0, width, rectSize);
	  
	  //Definindo os retangulos das opcoes
	  
	  fill(240,240,240);
	  rect(115,70,320,28);
	  rect(340,70,555,28);
	  rect(580,70,775,28);
	  rect(810,70,1020,28);
	  
	  if(opcao1) {
		    fill(255);		    
		    g1.draw(click);
	  } else {
		    fill(252,252,252);
	  }
	  rect(115,65,315,29);
	  
	  if(opcao2) {
		    fill(255);
	  } else {
		    fill(252,252,252);
	  }
	  rect(340,65,550,29);
	  
	  if(opcao3){
		    fill(255);
		    g3.setup(opcao);
		    fill(255);
	  } else {
		    fill(252,252,252);
	  }
	  rect(580,65,770,29);
	  
	  if(opcao4) {
		    fill(255);
		    g4.draw(click);
		    fill(255);
	  } else {
		    fill(252,252,252);
	  }
	  rect(810,65,1015,29);
	  
	  fill(130,130,130);
	  text("Exercícios relevantes",155,50);
	  text("Correlação Exercícios e Notas",350,50);
	  text("Agrupamento",630,50);
	  text("Composição das Notas",850,50);
  }
  
  public void mousePressed() {
	  if(overRect(115,30,200,30)) {
		  click = 0;
		  opcao1 = true;
		  opcao2 = false;
		  opcao3 = false;
		  opcao4 = false;
	  }else if(overRect(340,30,210,30)){
		  opcao1 = false;
		  opcao2 = true;
		  opcao3 = false;
		  opcao4 = false;
		      
	  }else if(overRect(580,30,200,30)){
		  opcao1 = false;
		    opcao2 = false;
		    opcao3 = true;
		    opcao4 = false;
		    
	  }else if(overRect(820,30,200,30)){
		  click = 0;
		  opcao1 = false;
		    opcao2 = false;
		    opcao3 = false;
		    opcao4 = true;
	  }
	  
	  //atualiza o grid da uc1
	  if(opcao1 & overRect(505,260,70,100)){
		  if (click < 77){
			  click += 1;
		  } 
	  }else if(opcao1 & overRect(60,260,70,100)){
		  if (click >= 1){
			  click -= 1;
		  }
	  }
	  //atualiza o grid da uc4 
	  if(opcao4 & overRect(575,265,49,60)){
		  if (click < 52){
			  click += 1;
		  } 
	  }else if(opcao4 & overRect(63,265,49,60)){
		  if (click >= 1){
			  click -= 1;
		  }
	  }
	  
	  if(opcao3 & overRect(350,120,205,35)) {
		  opcao = true;
	  }else if(opcao3 & overRect(580,120,205,35)){
		  opcao = false;
	  }
	  
	}  
  
  public boolean overRect(int x, int y, int width, int height)  {
	  if (mouseX >= x && mouseX <= x+width && 
	      mouseY >= y && mouseY <= y+height) {
	    return true;
	  } else {
	    return false;
	  }
	}
}