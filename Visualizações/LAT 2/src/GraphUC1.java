import processing.core.*;

public class GraphUC1{
	PImage bg,grid;
	PApplet parent;
	int gx = 16;
	
	
	public GraphUC1(PApplet p){
		this.parent = p;
	}

	public void draw(int click){
		this.bg = parent.loadImage("bg_uc1.png");
		this.grid = parent.loadImage("grid.png");
		updategrid(click);
	}
	
	
	
	public void updategrid(int click){
		if(click != 0){
			parent.image(bg,0,100);
			parent.image(grid,gx + (click*14),506);
		}else{
			parent.image(bg,0,100);
			parent.image(grid,gx,506);
		}
	}
}