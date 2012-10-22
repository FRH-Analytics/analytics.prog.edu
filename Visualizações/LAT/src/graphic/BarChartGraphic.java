package graphic;

import org.gicentre.utils.stat.BarChart;

public class BarChartGraphic {
	
	private BarChart barChart;
	private String[] labels;
	
	public BarChartGraphic(BarChart barChart, String[] labels) {
		this.barChart = barChart;
		this.labels = labels;
	}

	public BarChart getBarChart() {
		return barChart;
	}

	public void setBarChart(BarChart barChart) {
		this.barChart = barChart;
	}

	public String[] getLabels() {
		return labels;
	}

	public void setLabels(String[] labels) {
		this.labels = labels;
	}
}
