package gui;
import processing.core.*;

public class Bar{
	
  public float mtt, mtp, ex, prova,total, nota;
  int i,eixo_x,width_x,eixo_y;
  public String id;
  
  public Bar(String id, float mtt, float mtp, float ex, float prova, int i, float nota){
    this.mtt = mtt;
    this.mtp = mtp;
    this.ex = ex;
    this.prova = prova;
    this.id = id;
    this.i = i;
    this.nota = nota;
  }
  
  public float getNota(){
	  return this.nota;
  }
  
}