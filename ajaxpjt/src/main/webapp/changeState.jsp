<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String noticeNo = request.getParameter("noticeNo");
	String stateValue = request.getParameter("stateValue");
	
	Connection conn = null;
	PreparedStatement psmt = null;

	// try, catch, finally 영역
	try{
		// DB 연결 후 sql 실행 후 처리 작성 영역
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/board", "tester1", "ezen");
		
		String sql = "update notice_board set state = ? where nno = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, stateValue);
		psmt.setInt(2, Integer.parseInt(noticeNo));
		
		int result = psmt.executeUpdate();
		
		out.print(result);
		
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(psmt != null) psmt.close();
		if(conn != null) conn.close();
	}
%>