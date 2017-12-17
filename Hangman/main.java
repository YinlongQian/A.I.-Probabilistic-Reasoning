import java.util.*;
import java.io.*;

public class main {

	public static void main(String[] args) throws IOException {
		String filename = args[0];
		
		wordcloud data = new wordcloud();
		
		data.getWordsFromFile(filename);
		
		for(int i = 0; i < data.list.size(); i++){
			data.list.get(i).priorprob = data.list.get(i).count / data.totalcount;
		}
		
		/*
		ArrayList<word> maxlist = data.getmax();
		
		System.out.println("Here is the list of the fifteen most frequent 5-letter words:");
		
		for(int i = 0; i < maxlist.size(); i++){
			System.out.println(maxlist.get(i).w + " ");
			//System.out.print(maxlist.get(i).count + " ");
			//System.out.println(maxlist.get(i).priorprob);
		}
		
		ArrayList<word> minlist = data.getmin();
		
		System.out.println("\nHere is the list of the fourteen least frequent 5-letter words:");
		
		for(int i = 0; i < minlist.size(); i++){
			System.out.println(minlist.get(i).w + " ");
			//System.out.print(minlist.get(i).count + " ");
			//System.out.println(minlist.get(i).priorprob);
		}
		*/
		
		data.getpost();
		
		double[] letterList = data.getLetterProb();
		
		double biggest = 0;
		int bestindex = 0;
		for(int i = 0; i < letterList.length; i++){
			
			if(letterList[i] > biggest){
				biggest = letterList[i];
				bestindex = i;
			}
			
			System.out.println(letterList[i]);
		}
		
		System.out.println("Best next guess is " + biggest + "   " + (char)(bestindex + 65));
	}
	
}
