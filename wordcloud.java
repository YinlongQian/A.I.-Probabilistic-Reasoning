import java.util.*;
import java.io.*;

public class wordcloud {
	ArrayList<word> list;
	double totalcount;
	
	public wordcloud() {
		list = new ArrayList<word>();
		totalcount = 0;
	}
	
	public void getWordsFromFile( String filename ) throws IOException {

		File sourcefile = new File(filename);
	    Scanner input = new Scanner(sourcefile);
	    String wordInFile;
	    String[] temp;
	    String wordname;
	    int wordcount;

	    //check if there is next word in the source file
	    while(input.hasNextLine()){

	    	//assign next word to a String variable
	    	wordInFile = input.nextLine();

	    	temp = wordInFile.split(" ");

	    	wordname = temp[0];
	    	wordcount = Integer.parseInt(temp[1]);
	    	
	    	this.totalcount += wordcount;
	    	
	    	this.list.add(new word(wordname, wordcount));
	    }

	    input.close();
	}
	
	public ArrayList<word> getmax(){
		ArrayList<word> max = new ArrayList<word>();
		ArrayList<word> wordlist = this.list;
		
		for(int i = 0; i < 15; i++){
			max.add(new word("",-1));
		}
		
		for(int i = 0; i < wordlist.size(); i++){
			int currindex = 14;
			
			while(currindex != -1 && wordlist.get(i).priorprob > max.get(currindex).priorprob){
				currindex--;
			}
			
			if(currindex != 14){
				max.add(currindex + 1, new word(wordlist.get(i).w, wordlist.get(i).count, wordlist.get(i).priorprob));
				max.remove(15);
			}
		}
		
		return max;
	}
	
	public ArrayList<word> getmin(){
		ArrayList<word> min = new ArrayList<word>();
		ArrayList<word> wordlist = this.list;
		
		for(int i = 0; i < 14; i++){
			min.add(new word("", 250, 1));
		}
		
		for(int i = 0; i < wordlist.size(); i++){
			int currindex = 13;
			
			while(currindex != -1 && wordlist.get(i).priorprob < min.get(currindex).priorprob){
				currindex--;
			}
			
			if(currindex != 13){
				min.add(currindex + 1, new word(wordlist.get(i).w, wordlist.get(i).count, wordlist.get(i).priorprob));
				min.remove(14);
			}
		}
		
		return min;
	}
	
	public void getpost(){
		double stillValidCount = 0;
		
		for(int i = 0; i < this.list.size(); i++){
			word curr = this.list.get(i);
			
			if(curr.w.charAt(0) == 'E' || curr.w.charAt(1) == 'E' || curr.w.charAt(2) == 'E' || curr.w.charAt(3) == 'E' || curr.w.charAt(4) == 'E'){
				curr.posteriorprob = 0;
			}
			else if(curr.w.charAt(0) == 'A' || curr.w.charAt(1) == 'A' || curr.w.charAt(2) == 'A' || curr.w.charAt(3) == 'A' || curr.w.charAt(4) == 'A'){
				curr.posteriorprob = 0;
			}
			else{
				stillValidCount += curr.count;
			}
		}
		System.out.println(stillValidCount);
		for(int i = 0; i < this.list.size(); i++){
			word curr = this.list.get(i);
			
			if(curr.posteriorprob != 0){
				curr.posteriorprob = curr.count / stillValidCount;
			}
		}
	}
	
	public double[] getLetterProb(){
		double[] letterProb = new double[26];
		
		for(int i = 0; i < 26; i++){
			double cumulate = 0;
			
			for(int j = 0; j < this.list.size(); j++){
				word curr = this.list.get(j);
				
				if(curr.posteriorprob != 0){
					if(curr.w.charAt(0) == (i + 65) || curr.w.charAt(1) == (i + 65) || curr.w.charAt(2) == (i + 65) || curr.w.charAt(3) == (i + 65) || curr.w.charAt(4) == (i + 65)){
						cumulate += curr.posteriorprob;
					}
				}
			}
			
			letterProb[i] = cumulate;
		}
		
		return letterProb;
	}
}
