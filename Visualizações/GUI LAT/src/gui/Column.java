package gui;

public class Column {
	
	private float[] valoresDasQuestoes;
	
	
	public Column(int qtdQuestoes) {
		valoresDasQuestoes = new float[qtdQuestoes];
	}
	
	public int columnColor() {
		float color = 0;
		
		for (float value : valoresDasQuestoes)
			color += value;
		
		return (int) color;
	}
	
	public float getValueAt(int questao) {
		return valoresDasQuestoes[questao];
	}
}
