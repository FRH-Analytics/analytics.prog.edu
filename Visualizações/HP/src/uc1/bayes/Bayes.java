package uc1.bayes;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;

public class Bayes extends PApplet {
	
	private List<List<Integer>> exerciciosProvaUm;
	private List<List<Float>> probabilidadeExerciciosProvaUm;
	
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
		exerciciosProvaUm = new ArrayList<List<Integer>>();
		exerciciosProvaUm.add(new ArrayList<Integer>());
		exerciciosProvaUm.add(new ArrayList<Integer>());
		exerciciosProvaUm.add(new ArrayList<Integer>());
		exerciciosProvaUm.add(new ArrayList<Integer>());
		
		probabilidadeExerciciosProvaUm = new ArrayList<List<Float>>();
		probabilidadeExerciciosProvaUm.add(new ArrayList<Float>());
		probabilidadeExerciciosProvaUm.add(new ArrayList<Float>());
		probabilidadeExerciciosProvaUm.add(new ArrayList<Float>());
		probabilidadeExerciciosProvaUm.add(new ArrayList<Float>());
		
		String lines[][] = loadCSV("UC1-Resultado.csv");
		
		for (int i = 1; i < lines.length; i++) {
			int length = lines[i].length;
			float[] tmp = new float[length];
			
			for (int j = 0; j < length; j++)
				tmp[j] = Float.valueOf(lines[i][j].trim());
			
//			System.out.println(Arrays.toString(lines[i]));
			probabilidadeExerciciosProvaUm.get(Integer.valueOf(lines[i][0]) - 1).add(Float.valueOf(lines[i][1]));
			exerciciosProvaUm.get(Integer.valueOf(lines[i][0]) - 1).add(Integer.valueOf(lines[i][2]));
//			questoesProva.get(0).add(tmp[0]);
//			questoesExercicios.get(0).add(tmp[1]);
//			qtd.get(0).add((int) tmp[2]);
		}
		
//		System.out.println(exerciciosProvaUm);
//		System.out.println(probabilidadeExerciciosProvaUm);
	}
	
	public static void main(String[] args) {
		Bayes b = new Bayes();
		b.loadData();
	}
}
