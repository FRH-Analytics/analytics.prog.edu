package math;

import java.util.Arrays;

public class RegressaoSimples {
	
	public static float[] regressaoSimples(float[] x, float[] y) {
		int n = x.length;
		float tmpX = 0, tmpY = 0;
		
		for (int i = 0; i < n; i++) {
			tmpX += x[i];
			tmpY += y[i];
		}
		
		float meanX = tmpX / n;
		float meanY = tmpY / n;
		
		float a = 0, b = 0;
		
		for (int i = 0; i < n; i++) {
			a += (x[i] - meanX) * (y[i] - meanY);
			b += (x[i] - meanX) * (x[i] - meanX);
		}
		
		float t2 = a / b;
		float t1 = meanY - t2 * meanX;
		
		return new float[] {t1, t2};
	}
	
	public static float[] getLine(float[] x, float[] y, float xMax, float yMax) {
		float[] ab = regressaoSimples(x, y);
		
		float a = ab[1];
		float b = ab[0];
		
//		y, x, ymax, xmax
		return new float[] { (0 - b) / a, b, a * xMax + b, (yMax - b) / a };
	}
	
	public static void main(String[] args) {
		float[] x = new float[] {1, -1};
		float[] y = new float[] {2, -6};
		
		System.out.println(Arrays.toString(getLine(x, y, 10, 10)));
		System.out.println(Arrays.toString(regressaoSimples(x, y)));
		
	}
}
