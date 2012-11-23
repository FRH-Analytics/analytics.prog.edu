package gui;

import org.gicentre.utils.stat.XYChart;

public class ScatterPlot {
	private XYChart plot;
	
	public ScatterPlot(XYChart plot) {
		this.plot = plot;
	}

	public XYChart getScatterPlot() {
		return plot;
	}

	public void setScatterPlot(XYChart plot) {
		this.plot = plot;
	}
}
