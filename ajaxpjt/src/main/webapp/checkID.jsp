<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//request 안에 있는 문자열 전부 UTF-8 변환 (반드시 넣어줘야함)
	request.setCharacterEncoding("UTF-8"); 
	
	String id = request.getParameter("id"); // 클라이언트가 전송한 매개변수를 가져와 id에 할당
	
	Connection conn = null; // DB연결
	PreparedStatement psmt = null; // SQL 등록 및 실행
	ResultSet rs = null; // 조회 결과를 담음
	
	try{
		// DB연결 후 sql 실행 후 처리 작성 영역
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/board", "tester1", "ezen");	
		
		String sql = "select count(*) as cnt from user where uid =?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, id); // 쿼리 변수 등록
		
		rs = psmt.executeQuery();
		
		if(rs.next()) {
			int result = rs.getInt("cnt");
			if(result > 0) {
				out.print("isId"); // 아이디 존재 시 응답데이터
			} else {
				out.print("isNotId"); // 아이디 존재하지 않을 시 응답데이터
			}
		}
		
	} catch(Exception e) {
		e.printStackTrace();
		out.print("error"); // 오류 발생 시
	} finally {
		if(rs != null) {
			rs.close();
		}
		
		if(psmt != null) {
			psmt.close();
		}
		
		if(conn != null) {
			conn.close();	
		}
	}
%>