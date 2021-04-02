package com.test.ex01;

import java.io.IOException;
import java.util.HashSet;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class UrlCrawling {
	
	private HashSet<String> links;
	String docu;

    public UrlCrawling() {
        links = new HashSet<String>();
    }

    public void getPage(String URL) {
        if (!links.contains(URL)) {
    		Document doc = null;        //Document에는 페이지의 전체 소스가 저장된다

    		try {
    			doc = Jsoup.connect(URL).get();
    		} catch (IOException e) {
    			e.printStackTrace();
    		}
    		/*
    		System.out.println(doc.text());
    		System.out.println("================================절취선======================================");
    		String str = "";
    		str = doc.text().replaceAll("[^a-zA-Z0-9]", "");
    		System.out.println(str);
    		System.out.println("==========끝==========");
    		*/
    		//System.out.println(doc.text());
    		System.out.println("================================절취선======================================");
    		// StringBuffer str = new StringBuffer();
    		// StringBuilder str = new StringBuilder();
    		// str.append(doc.html().replaceAll("[^a-zA-Z0-9]", ""));
    		String str = "";
    		str = doc.html().replaceAll("[^a-zA-Z0-9]", "");
    		System.out.printf("%s", str);
    		System.out.println("==========끝==========");
    		
        }
    }

    public static void main(String[] args) {
    	
        new UrlCrawling().getPage("https://www.daum.net/");
    }
}
