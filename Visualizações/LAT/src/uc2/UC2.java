package uc2;

import elements.Menu;
import graphic.AlgumPlot;
import graphic.ScatterPlot;

import java.util.ArrayList;
import java.util.List;

import org.gicentre.utils.stat.XYChart;

import processing.core.PApplet;
import processing.core.PVector;

public class UC2 extends PApplet {
	
//	private List<ScatterPlot> scatterPlot;
	private List<AlgumPlot> algumPlot;
	private Menu menu;
	
	private List<List<Float>> dadosNotas;
	private List<List<Float>> dadosExercicios;
	private List<List<Integer>> qtd;
	private List<List<Float>> confianca;
	
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
		dadosNotas = new ArrayList<List<Float>>();
		dadosNotas.add(new ArrayList<Float>());
		dadosNotas.add(new ArrayList<Float>());
		dadosNotas.add(new ArrayList<Float>());
		
		dadosExercicios = new ArrayList<List<Float>>();
		dadosExercicios.add(new ArrayList<Float>());
		dadosExercicios.add(new ArrayList<Float>());
		dadosExercicios.add(new ArrayList<Float>());
		
		qtd = new ArrayList<List<Integer>>();
		qtd.add(new ArrayList<Integer>());
		qtd.add(new ArrayList<Integer>());
		qtd.add(new ArrayList<Integer>());
		
		confianca = new ArrayList<List<Float>>();
		confianca.add(new ArrayList<Float>());
		confianca.add(new ArrayList<Float>());
		confianca.add(new ArrayList<Float>());
		
		String lines[][] = loadCSV("Exercicios.csv");
		
		for (int i = 1; i < lines.length; i++) {
			int length = lines[i].length;
			float[] tmp = new float[length - 1];
			
			for (int j = 1; j < length; j++) {	
				tmp[j-1] = Float.valueOf(lines[i][j].trim());
			}
			
			dadosNotas.get(0).add(tmp[0]);
			dadosNotas.get(1).add(tmp[1]);
			dadosNotas.get(2).add(tmp[2]);
			dadosExercicios.get(0).add(tmp[3]);
			dadosExercicios.get(1).add(tmp[4]);
			dadosExercicios.get(2).add(tmp[5]);
			qtd.get(0).add((int) tmp[6]);
			qtd.get(1).add((int) tmp[7]);
			qtd.get(2).add((int) tmp[8]);
			confianca.get(0).add(tmp[9]);
			confianca.get(1).add(tmp[10]);
			confianca.get(2).add(tmp[11]);
		}
	}
	
	private float[] toFloat(List<Float> list) {
		float[] tmp = new float[list.size()];
		
		for (int i = 0; i < list.size(); i++)
			tmp[i] = list.get(i);
		
		return tmp;
	}
	
	private ScatterPlot loadScatterPlot(List<Float> notas, List<Float> qtdQuestoes) {
		XYChart plot = new XYChart(this);
		plot.setData(toFloat(qtdQuestoes), toFloat(notas));
		
		plot.showXAxis(true);
		plot.showYAxis(true);
		
		plot.setMinX(0);
		plot.setMinY(0);
		
		plot.setMaxX(100);
		plot.setMaxY(10);
		
		plot.setPointSize(5);
		
		plot.setXAxisLabel("Quantidade de Questões Enviadas");
		plot.setYAxisLabel("Nota na Prova");
		
		return new ScatterPlot(plot);
	}
	
	private int[] toInt(List<Integer> list) {
		int[] tmp = new int[list.size()];
		
		for (int i = 0; i < list.size(); i++)
			tmp[i] = list.get(i);
		
		return tmp;
	}
	
	private AlgumPlot loadAlgumPlot(List<Float> qtdQuestoes, List<Float> notas, List<Integer> qtds) {
		AlgumPlot plot = new AlgumPlot(this, 100, 10, 10);
		plot.setData(toFloat(qtdQuestoes), toFloat(notas), toInt(qtds));
		plot.eixoX = "Nota na Prova";
		plot.eixoY = "Quantidade de Questões Resolvidas do Exercício";
		plot.eixoZ = "Quantidade de Alunos";
		plot.eixoW = "Valor de Confiança";
		plot.titulo = "Relação entre a quantidade dos exercicios resolvidos com a nota na prova";
		
		return plot;
	}
	
	private void initAll() {
		loadData();
		
//		scatterPlot = new ArrayList<ScatterPlot>();
//		scatterPlot.add(loadScatterPlot(dadosNotas.get(0), dadosExercicios.get(0)));
//		scatterPlot.add(loadScatterPlot(dadosNotas.get(1), dadosExercicios.get(1)));
//		scatterPlot.add(loadScatterPlot(dadosNotas.get(2), dadosExercicios.get(2)));
		
		algumPlot = new ArrayList<AlgumPlot>();
		algumPlot.add(loadAlgumPlot(dadosExercicios.get(0), dadosNotas.get(0), qtd.get(0)));
		algumPlot.add(loadAlgumPlot(dadosExercicios.get(1), dadosNotas.get(1), qtd.get(1)));
		algumPlot.add(loadAlgumPlot(dadosExercicios.get(2), dadosNotas.get(2), qtd.get(2)));
		
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
		textSize(12);
		text("UC 2", 300, 20);
//		scatterPlot.get(menu.selected).getScatterPlot().draw(10, 40, 500, 500);
		algumPlot.get(menu.selected).draw(10, 40, 500, 500);
		textSize(16);
		menu.draw();
		hover();
		int i = algumPlot.get(menu.selected).getSquareIndex(new PVector(mouseX, mouseY));
		if (i > -1)
			algumPlot.get(menu.selected).hover(confianca.get(menu.selected).get(i));
	}
	
	private void hover() {
		algumPlot.get(menu.selected).hover();
//		PVector mouse = new PVector(mouseX, mouseY);
//		PVector chartBar = scatterPlot.get(menu.selected).getScatterPlot().getScreenToData(mouse);
		
//		float[] dataX = scatterPlot.get(menu.selected).getScatterPlot().getXData();
//		float[] dataY = scatterPlot.get(menu.selected).getScatterPlot().getYData();
//		PVector[] points = new PVector[dataX.length * dataY.length];
		
//		if (chartBar != null) {
//			for (int i = 0; i < dataX.length; i++) {
//				for (int j = 0; j < dataY.length; j++) {
//					System.out.println(scatterPlot.get(menu.selected).getScatterPlot().getDataToScreen(new PVector(dataX[i], dataY[j])));
//				}
//			}
			
//			System.out.println(scatterPlot.get(menu.selected).getScatterPlot().getDataToScreen());
//			chartBar.x = scatterPlot.get(menu.selected).getScatterPlot().getNumBars() - chartBar.x - 1;
//			System.out.println("DEBUG: " + chartBar.x + "," + chartBar.y + ": " + 
//					Arrays.toString(scatterPlot.get(menu.selected).getScatterPlot().getXData()));
			
//			float barValue = scatterPlot.get(menu.selected).getScatterPlot().getData()[(int) chartBar.x];
			
			fill(0);
			String lbl = "";
//			text(lbl + ": " + barValue, width / 2 - 200, height - 60);
//		}
	}
	
	@Override
	public void mouseReleased() {
		super.mouseReleased();
		
		menu.botaoClicado();
	}
}