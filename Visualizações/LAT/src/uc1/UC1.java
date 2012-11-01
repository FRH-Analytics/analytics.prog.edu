package uc1;

import elements.Menu;
import graphic.AlgumPlot;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;

public class UC1 extends PApplet {
	
	private AlgumPlot plot;
	
	private List<AlgumPlot> algumPlot;
	private Menu menu;
	
	private List<List<Float>> questoesProva;
	private List<List<Float>> questoesExercicios;
	private List<List<Integer>> qtd;
	
	private String[][] loadCSV(String filename){
		String lines[] = loadStrings(filename);
		String [][] csv;
		int csvWidth=0;

		//calculate max width of csv file
		for (int i=0; i < lines.length; i++) {
		  String [] chars=split(lines[i],',');
		  if (chars.length>csvWidth){
		    csvWidth=chars.length;
		  }
		}

		//create csv array based on # of rows and columns in csv file
		csv = new String [lines.length][csvWidth];

		//parse values into 2d array
		for (int i=0; i < lines.length; i++) {
		  String [] temp = new String [lines.length];
		  temp= split(lines[i], ',');
		  for (int j=0; j < temp.length; j++){
		   csv[i][j]=temp[j];
		  }
		}
		
		return csv;
	}
	
	private void loadData() {
		questoesProva = new ArrayList<List<Float>>();
		questoesProva.add(new ArrayList<Float>());
		questoesProva.add(new ArrayList<Float>());
		questoesProva.add(new ArrayList<Float>());
		
		questoesExercicios = new ArrayList<List<Float>>();
		questoesExercicios.add(new ArrayList<Float>());
		questoesExercicios.add(new ArrayList<Float>());
		questoesExercicios.add(new ArrayList<Float>());
		
		qtd = new ArrayList<List<Integer>>();
		qtd.add(new ArrayList<Integer>());
		qtd.add(new ArrayList<Integer>());
		qtd.add(new ArrayList<Integer>());
		
		String lines[][] = loadCSV("UC1.csv");
		
		for (int i = 1; i < lines.length; i++) {
			int length = lines[i].length;
			float[] tmp = new float[length];
			
			for (int j = 0; j < length; j++)
				tmp[j] = Float.valueOf(lines[i][j].trim());
			
			questoesProva.get(0).add(tmp[0]);
			questoesProva.get(1).add(tmp[3]);
			questoesProva.get(2).add(tmp[6]);
			questoesExercicios.get(0).add(tmp[1]);
			questoesExercicios.get(1).add(tmp[4]);
			questoesExercicios.get(2).add(tmp[7]);
			qtd.get(0).add((int) tmp[2]);
			qtd.get(1).add((int) tmp[5]);
			qtd.get(2).add((int) tmp[8]);
		}
	}
	
	private float[] toFloat(List<Float> list) {
		float[] tmp = new float[list.size()];
		
		for (int i = 0; i < list.size(); i++)
			tmp[i] = list.get(i);
		
		return tmp;
	}
	
	private int[] toInt(List<Integer> list) {
		int[] tmp = new int[list.size()];
		
		for (int i = 0; i < list.size(); i++)
			tmp[i] = list.get(i);
		
		return tmp;
	}
	
	private AlgumPlot loadAlgumPlot(List<Float> notas, List<Float> qtdQuestoes, List<Integer> qtds) {
		AlgumPlot plot = new AlgumPlot(this, 100, 10, 10);
		plot.setData(toFloat(qtdQuestoes), toFloat(notas), toInt(qtds));
		plot.eixoX = "Questão da Prova";
		plot.eixoY = "Questão do Exercício";
		plot.eixoZ = "Quantidade de Alunos";
		plot.titulo = "Influencia das questões dos exercicios em relação às questões da prova";
		
		return plot;
	}
	
	private void initAll() {
		loadData();
		
		algumPlot = new ArrayList<AlgumPlot>();
		algumPlot.add(loadAlgumPlot(questoesProva.get(0), questoesExercicios.get(0), qtd.get(0)));
		algumPlot.add(loadAlgumPlot(questoesProva.get(1), questoesExercicios.get(1), qtd.get(1)));
		algumPlot.add(loadAlgumPlot(questoesProva.get(2), questoesExercicios.get(2), qtd.get(2)));
		
		menu = new Menu(new String[] {"Prova 1", "Prova 2", "Prova 3"}, 10, algumPlot.get(0).high() + 10, 150, 30, this);
	}
	
	@Override
	public void setup() {
		size(1080,600);
		smooth();
		
		initAll();
	}
	
	@Override
	public void draw() {
		background(255);
		
		algumPlot.get(menu.selected).draw(10, 10, 500, 500);
		
		textSize(16);
		menu.draw();
		
		hover();
	}
	
	private void hover() {
		algumPlot.get(menu.selected).hover();
	}
	
	@Override
	public void mouseReleased() {
		super.mouseReleased();
		
		menu.botaoClicado();
	}
}
