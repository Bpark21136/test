package model1;

import java.util.ArrayList;

public class CommentTO {
	private String seq;
	private String pseq;
	private String writer;
	private String password;
	private String content;
	private String wdate;
	private ArrayList<CommentTO> commentList;
	
	public ArrayList<CommentTO> getCommentList() {
		return commentList;
	}
	public void setCommentList(ArrayList<CommentTO> commentList) {
		this.commentList = commentList;
	}
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getPseq() {
		return pseq;
	}
	public void setPseq(String pseq) {
		this.pseq = pseq;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWdate() {
		return wdate;
	}
	public void setWdate(String wdate) {
		this.wdate = wdate;
	}
	
	
}
