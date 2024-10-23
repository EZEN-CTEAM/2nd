<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.*"%>
<%
	String noticeNo = request.getParameter("noticeNo"); // index.jsp의 data 키값과 같아야함.
	System.out.println(noticeNo);
	if(noticeNo == null || noticeNo.equals("0")) {
		out.print("fail");
	}

	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;

	// try, catch, finally 영역
	try{
		// DB 연결 후 sql 실행 후 처리 작성 영역
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/board", "tester1", "ezen");
		
		String sql = "select n.*, u.uid from notice_board n inner join user u on n.uno = u.uno where nno = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1, Integer.parseInt(noticeNo));
		
		rs = psmt.executeQuery();
		
		JSONArray jArray = new JSONArray(); // []를 만듬
		
		if(rs.next()) { 
			int nno = rs.getInt("nno");
			String id = rs.getString("uid");
			String title = rs.getString("title");
			String content = rs.getString("content");
			String rdate = rs.getString("rdate");
			int hit = rs.getInt("hit");
			String state = rs.getString("state");
			String topYn = rs.getString("top_yn");
			
			JSONObject jObj = new JSONObject(); // {}를 만듬
			jObj.put("nno", nno);
			jObj.put("uid", id);
			jObj.put("title", title);
			jObj.put("content", content);
			jObj.put("rdate", rdate);
			jObj.put("hit", hit);
			jObj.put("state", state);
			jObj.put("top_yn", topYn); // {"nno", ?},"", ?....}
			
			jArray.add(jObj); // [{"nno": ?},"": ?....}]
		}
			out.print(jArray.toJSONString());
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs != null) rs.close();
		if(psmt != null) psmt.close();
		if(conn != null) conn.close();
	}

%>
