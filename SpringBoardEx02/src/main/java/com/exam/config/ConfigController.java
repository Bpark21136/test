package com.exam.config;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import model1.BoardListTO;
import model1.BoardTO;
import model1.CommentTO;

@Controller
public class ConfigController {
	
	@Autowired
	private DataSource dataSource;
	
	// private String uploadPath = "/home/master/apache-tomcat-9.0.37/webapps/SpringBoardEx02/upload/";
	private String uploadPath = "C:\\Users\\Hoon\\JSP\\eclipse-workspace\\SpringBoardEx02\\src\\main\\webapp\\upload\\";
	@RequestMapping(value = "/list.do")
	public ModelAndView listRequest(HttpServletRequest request) {
		int cpage = 1;
		if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}

		BoardListTO listTO = new BoardListTO();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int recordPerPage = listTO.getRecordPerPage();
		int blockPerPage = listTO.getBlockPerPage();
		
		
		try{
			conn = this.dataSource.getConnection();			
			String sql = "SELECT i.seq, subject, i.writer, mail, i.password, i.content, filename, hit, DATE_FORMAT(i.wdate, '%Y-%m-%d') fdate, DATEDIFF(NOW(), i.wdate) wgap, COUNT(c.seq) AS COUNT\r\n" + 
					"FROM image_board1 i\r\n" + 
					"LEFT OUTER\r\n" + 
					"JOIN comment c ON (i.seq = c.pseq)\r\n" + 
					"GROUP BY i.seq\r\n" + 
					"ORDER BY i.seq DESC";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			rs.last();
			listTO.setTotalRecord(rs.getRow());
			rs.beforeFirst();
			
			listTO.setTotalPage( ( ( listTO.getTotalRecord() - 1 ) / recordPerPage ) + 1 );
			
			int skip = ((cpage - 1) * recordPerPage);
			if(skip != 0) {
				rs.absolute(skip);
			}
			BoardTO to = new BoardTO();
			
			
			ArrayList<BoardTO> lists = new ArrayList<BoardTO>();
			for(int i = 0; i < recordPerPage && rs.next(); i++) {
				to = new BoardTO();

				to.setSeq(rs.getString("seq"));				
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
				to.setWdate(rs.getString("fdate"));
				to.setFilename(rs.getString("filename"));
				to.setHit(rs.getString("hit"));
				to.setWgap(rs.getInt("wgap"));
				to.setCommentCount(rs.getString("count"));
				
				lists.add(to);
			}
			
			listTO.setBoardList(lists);
			listTO.setStartBlock( ( ( cpage-1 ) / blockPerPage ) * blockPerPage + 1 );
			listTO.setEndBlock( ( ( cpage-1 ) / blockPerPage ) * blockPerPage + blockPerPage );
			if( listTO.getEndBlock() >= listTO.getTotalPage() ) {
				listTO.setEndBlock(listTO.getTotalPage());
			}
			
			
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( rs != null ) try{ rs.close(); } catch(SQLException e) {}
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}
		
		int totalRecord = listTO.getTotalRecord();	
		int totalPage = listTO.getTotalPage();	
		
		blockPerPage = listTO.getBlockPerPage();
		int startBlock = listTO.getStartBlock();
		int endBlock = listTO.getEndBlock();
		
		ArrayList<BoardTO> boardLists = listTO.getBoardList();
		
		request.setAttribute("cpage", cpage);
		request.setAttribute("listTO", listTO);
		request.setAttribute("totalRecord", totalRecord);
		request.setAttribute("totalPage", totalPage);
		request.setAttribute("totalRecord", totalRecord);
		request.setAttribute("blockPerPage", blockPerPage);
		request.setAttribute("startBlock", startBlock);
		request.setAttribute("endBlock", endBlock);
		request.setAttribute("boardLists", boardLists);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_list1");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/view.do")
	public ModelAndView viewRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		
		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));

		CommentTO cto = new CommentTO();
		cto.setPseq(request.getParameter("seq"));
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = this.dataSource.getConnection();

			String sql = "update image_board1 set hit=hit+1 where seq=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			pstmt.executeUpdate();
			
			sql = "select subject, writer, mail, wip, wdate, hit, content, filename from image_board1 where seq=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
				to.setMail(rs.getString("mail"));
				to.setWip(rs.getString("wip"));
				to.setFilename(rs.getString("filename"));
				to.setWdate(rs.getString("wdate"));
				to.setHit(rs.getString("hit"));
				to.setContent(rs.getString("content") == null ? "" : rs.getString("content").replaceAll("\n", "<br />"));
			}
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( rs != null ) try{ rs.close(); } catch(SQLException e) {}
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}
		
		ArrayList<CommentTO> lists = new ArrayList<CommentTO>();
		
		try{
			conn = this.dataSource.getConnection();
			String sql = "select seq, pseq, writer, date_format(wdate, '%Y-%m-%d %H:%i') wdate, content from comment where pseq=? order by seq desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cto.getPseq());
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				cto = new CommentTO();
				cto.setSeq(rs.getString("seq"));
				cto.setWriter(rs.getString("writer"));
				cto.setWdate(rs.getString("wdate"));
				cto.setContent(rs.getString("content"));
				cto.setPseq(rs.getString("pseq"));
				
				lists.add(cto);
			}
			
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( rs != null ) try{ rs.close(); } catch(SQLException e) {}
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}
		
		request.setAttribute("cpage", cpage);
		request.setAttribute("to", to);
		request.setAttribute("cto", cto);
		request.setAttribute("commentLists", lists);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_view1");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/write.do")
	public ModelAndView writeRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		
		request.setAttribute("cpage", cpage);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_write1");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/write_ok.do")
	public ModelAndView write_okRequest(HttpServletRequest request) {
		int maxFileSize = 1024 * 1024 * 5;
		String encType = "utf-8";
		
		BoardTO to;
		to = new BoardTO();
		try {
			MultipartRequest multi = new MultipartRequest( request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());

			String filename = multi.getFilesystemName("upload");
			File file = multi.getFile("upload");
			
			to.setSubject(multi.getParameter("subject"));
			to.setWriter(multi.getParameter("writer"));
			to.setMail("");
			if(!multi.getParameter("mail1").equals("") && !multi.getParameter("mail2").equals("")) {
				to.setMail(multi.getParameter("mail1") + "@" + multi.getParameter("mail2"));
			}
			to.setPassword(multi.getParameter("password"));
			to.setContent(multi.getParameter("content"));
			to.setFilename(filename);
			if(file != null) {
				to.setFilesize(file.length());
			}
			to.setWip(request.getRemoteAddr());
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		Connection conn = null;
		PreparedStatement pstmt = null;		
		
		int flag = 1;
		
		try{
			conn = this.dataSource.getConnection();
			
			String sql = "insert into image_board1 values( 0, ?, ?, ?, ?, ?, ?, ?, 0, ?, now())";

			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, to.getSubject());
			pstmt.setString(2, to.getWriter());
			pstmt.setString(3, to.getMail());
			pstmt.setString(4, to.getPassword());
			pstmt.setString(5, to.getContent());
			pstmt.setString(6, to.getFilename());
			pstmt.setLong(7, to.getFilesize());
			pstmt.setString(8, to.getWip());
			
			int result = pstmt.executeUpdate();
			if(result == 1) {
				flag = 0;
			}
			
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}
		
		request.setAttribute("flag", flag);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_write1_ok");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/delete.do")
	public ModelAndView deleteRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");

		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = this.dataSource.getConnection();
			
			String sql = "select subject, writer from image_board1 where seq=?";
			pstmt = conn.prepareStatement(sql);			
			pstmt.setString(1, to.getSeq());
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
			}
		}catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( rs != null ) try{ rs.close(); } catch(SQLException e) {}
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}		

		request.setAttribute("cpage", cpage);
		request.setAttribute("to", to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_delete1");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/delete_ok.do")
	public ModelAndView delete_okRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");

		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		to.setPassword(request.getParameter("password"));
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int flag = 2;
		try{
			conn = this.dataSource.getConnection();
			
			String sql = "select password, filename from image_board1 where seq=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			
			String password = null;
			String filename = null;
			if(rs.next()) {
				filename = rs.getString("filename");
				password = rs.getString("password");
			}
			
			int result1 = 2;
			if( password.equals(to.getPassword()) ) {
				sql = "delete from comment where pseq= ? ";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, to.getSeq());
				result1 = pstmt.executeUpdate();
				if(result1 > 1) {
					result1 = 1;
				}
			} else {
				result1 = 0;
			}
			
			sql = "delete from image_board1 where seq= ? and password=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, to.getSeq());
			pstmt.setString(2, to.getPassword());
			
			int result2 = pstmt.executeUpdate();
			if(result1 == 0 && result2 == 0) {
				flag = 1;
			} else if( (result1 == 1 && result2 == 1) == true || (result1 == 0 && result2 == 1) == true) {
				// 정상
				flag = 0;
				if(filename != null) {
					File file = new File(uploadPath + filename);
					file.delete();
				}
			}			
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}
		
		request.setAttribute("cpage", cpage);
		request.setAttribute("flag", flag);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_delete1_ok");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/modify.do")
	public ModelAndView modifyRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		
		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {			
			conn = this.dataSource.getConnection();
			
			String sql = "select subject, writer, mail, wip, wdate, hit, content, password, filename from image_board1 where seq=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
				to.setMail(rs.getString("mail"));
				to.setPassword(rs.getString("password"));
				to.setFilename(rs.getString("filename"));
				to.setContent(rs.getString("content").replaceAll("\n", "<br />"));
			}
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( rs != null ) try{ rs.close(); } catch(SQLException e) {}
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}

		request.setAttribute("cpage", cpage);
		request.setAttribute("to", to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_modify1");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/modify_ok.do")
	public ModelAndView modify_okRequest(HttpServletRequest request) {
		int maxFileSize = 1024 * 1024 * 5;
		String encType = "utf-8";

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		BoardTO to = new BoardTO();
		int flag = 2;
		String cpage = "";
		try {		
			MultipartRequest multi = new MultipartRequest( request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());
			
			cpage = multi.getParameter("cpage");
			
			String filename = multi.getFilesystemName("upload");
			File file = multi.getFile("upload");
			
			to.setSeq(multi.getParameter("seq"));
			to.setSubject(multi.getParameter("subject"));
			to.setWriter(multi.getParameter("writer"));
			if(!multi.getParameter("mail1").equals("") && !multi.getParameter("mail2").equals("")) {
				to.setMail(multi.getParameter("mail1") + "@" + multi.getParameter("mail2"));
			} else {
				to.setMail("");
			}
			if(file != null) {
				to.setFilesize(file.length());
			}
			to.setPassword(multi.getParameter("password"));
			to.setFilename(filename);
			to.setContent(multi.getParameter("content"));
			
			conn = this.dataSource.getConnection();
	
			String sql = "select filename from image_board1 where seq=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			
			String filenameOri = null;
			if(rs.next()) {
				filenameOri = rs.getString("filename");
			}
			
			
			if(to.getFilename() != null) {
				sql = "update image_board1 set subject = ?, mail = ?, content = ?, filename = ?, filesize = ? where seq=? and password=?";
	
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, to.getSubject());
				pstmt.setString(2, to.getMail());
				pstmt.setString(3, to.getContent());
				pstmt.setString(4, to.getFilename());
				pstmt.setLong(5, to.getFilesize());
				pstmt.setString(6, to.getSeq());
				pstmt.setString(7, to.getPassword());
			} else {
				sql = "update image_board1 set subject = ?, mail = ?, content = ?  where seq=? and password=?";
	
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, to.getSubject());
				pstmt.setString(2, to.getMail());
				pstmt.setString(3, to.getContent());
				pstmt.setString(4, to.getSeq());
				pstmt.setString(5, to.getPassword());
			}
			
			int result = pstmt.executeUpdate();
			
			if(result == 0) {
				// 비밀 번호를 잘못 기입한 경우
				flag = 1;
			} else if( result == 1) {
				// 정상
				flag = 0;
				if(to.getFilename() != null && filenameOri != null) {
					File fileD = new File(uploadPath + filenameOri);
					fileD.delete();
				}
			}
			
			
			to.setSeq(multi.getParameter("seq"));
			to.setPassword(multi.getParameter("password"));
			to.setSubject(multi.getParameter("subject"));
			if(!multi.getParameter("mail1").equals("") && !multi.getParameter("mail2").equals("")) {
				to.setMail(multi.getParameter("mail1") + "@" + multi.getParameter("mail2"));
			} else {
				to.setMail("");
			}
			to.setContent(multi.getParameter("content"));
			to.setFilename(filename);

		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
			if( rs != null ) try{ rs.close(); } catch(SQLException e) {}
		}
		
		request.setAttribute("flag", flag);
		request.setAttribute("seq", to.getSeq());
		request.setAttribute("cpage", cpage);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("board_modify1_ok");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/commentWrite_ok.do")
	public ModelAndView commentWriteOkRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		String seq = request.getParameter("seq");

		CommentTO to = new CommentTO();
		to.setPseq(request.getParameter("seq"));
		to.setWriter(request.getParameter("cwriter"));
		to.setPassword(request.getParameter("cpassword"));
		to.setContent(request.getParameter("ccontent"));
		
		Connection conn = null;
		PreparedStatement pstmt = null;		
		
		int flag = 1;
		
		try{
			conn = this.dataSource.getConnection();
			
			String sql = "insert into comment values( 0, ?, ?, ?, ?, now())";

			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, to.getPseq());
			pstmt.setString(2, to.getWriter());
			pstmt.setString(3, to.getPassword());
			pstmt.setString(4, to.getContent());
			
			int result = pstmt.executeUpdate();
			if(result == 1) {
				flag = 0;
			}
			
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}
		
		request.setAttribute("cpage", cpage);
		request.setAttribute("seq", seq);
		request.setAttribute("flag", flag);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("comment_write1_ok");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/commentDelete.do")
	public ModelAndView commentDeleteRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		String cSeq = request.getParameter("cSeq");
		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		
		request.setAttribute("cpage", cpage);
		request.setAttribute("cSeq", cSeq);
		request.setAttribute("to", to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("comment_delete1");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/commentDelete_ok.do")
	public ModelAndView commentDeleteOkRequest(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");

		BoardTO to = new BoardTO();
		CommentTO cto = new CommentTO();
		to.setSeq(request.getParameter("seq"));
		cto.setPassword(request.getParameter("cpassword"));
		cto.setSeq(request.getParameter("cSeq"));
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		int flag = 2;
		try{
			conn = this.dataSource.getConnection();
			
			
			String sql = "delete from comment where seq= ? and password=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, cto.getSeq());
			pstmt.setString(2, cto.getPassword());
			
			int result = pstmt.executeUpdate();
			if(result == 0) {
				flag = 1;
			} else if( result == 1 ) {
				// 정상
				flag = 0;
			}			
		} catch( SQLException e) {
			System.out.println( "[에러] : " + e.getMessage() );		
		} finally{
			if( pstmt != null ) try{ pstmt.close(); } catch(SQLException e) {}
			if( conn != null ) try{ conn.close(); } catch(SQLException e) {}
		}
		
		request.setAttribute("cpage", cpage);
		request.setAttribute("to", to);
		request.setAttribute("cto", cto);
		request.setAttribute("flag", flag);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("comment_delete1_ok");
		modelAndView.addObject("lists", request);
		
		return modelAndView;
	}
}
