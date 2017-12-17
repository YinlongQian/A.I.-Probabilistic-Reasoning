import java.util.ArrayList;

public class word {
	public String w;
	public int count;
	public double priorprob;
	public double posteriorprob;
	
	public word(String in1, int in2){
		w = in1;
		count = in2;
		priorprob = 0;
		posteriorprob = -1;
	}
	
	public word(String in1, int in2, double in3){
		w = in1;
		count = in2;
		priorprob = in3;
		posteriorprob = -1;
	}
}
