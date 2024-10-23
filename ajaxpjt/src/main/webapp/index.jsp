<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	// 사용변수 선언 영역
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;

	// try, catch, finally 영역
	try{
		// DB 연결 후 sql 실행 후 처리 작성 영역
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/board", "tester1", "ezen");
		
		String sql = "select * from notice_board";
		
		psmt = conn.prepareStatement(sql); // sql 쿼리를 실행
		rs = psmt.executeQuery(); // 쿼리 실행 후 notice_board의 모든 컬럼 데이터가 담겨있음
%>
		<!-- html 영역 -->
		<!DOCTYPE html>
		<html>
			<head>
				<meta charset="UTF-8">
				<title>Insert title here</title>
				<script src="js/jquery-3.7.1.js"></script>
			</head>
			<body>
				<h2>공지사항 페이지</h2>
				<table border="1">
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>등록일</th>
						<th>조회수</th>
						<th>상태변경</th>
					</tr>
<%
					while(rs.next()) {
						int nno = rs.getInt("nno");
						String title = rs.getString("title");
						String rdate = rs.getString("rdate");
						String hit = rs.getString("hit");
						String state = rs.getString("state");
%>
					<tr>
						<td><%= nno %></td>
						<td><a href="javascript:viewFn(<%= nno %>)"><%= title %></a></td>
						<td><%= rdate %></td>
						<td><%= hit %></td>
						<td>
							<select id="state" onchange="changeState(<%= nno %>, this.value)">
								<option value="E"<%= state.equals("E")? "selected": "" %>>활성화</option>
								<option value="D"<%= state.equals("D")? "selected": "" %>>비활성화</option>
							</select>
						</td>
					</tr>
<%
					}
%>
				</table>
				<div id="viewArea" sytle="margin:20px 0px; border:1px solid black;">
				
				</div>
				<script>
					function changeState(nno, value) {
						$.ajax({
							url : "changeState.jsp",
							type : "post",
							data : {noticeNo : nno, stateValue : value},
							success : function(data) {
								if(data.trim() == "1") {
									alert("상태가 변경되었습니다.");
								} else {
									alert("상태 변경에 실패했습니다.");
								}
							}
						});
					}
					
					function viewFn(nno) {
						$.ajax({
							url : "viewNotice.jsp",
							type : "get",
							data : {noticeNo : nno},
							success : function(data) {
								console.log(data);
								let json = JSON.parse(data.trim());
								console.log(json);
								
								let html = "";
								html += '<table border="1" width="100%">';
								
								html += "<tr>";
								html += "<th align='right'>글번호</th>";
								html += "<td>"+ json[0].nno +"</td>";
								html += "</tr>";
								
								html += "<tr>";
								html += "<th align='right'>제목</th>";
								html += "<td>"+ json[0].title +"</td>";
								html += "</tr>";
								
								html += "<tr>";
								html += "<th align='right'>작성자</th>";
								html += "<td>"+ json[0].uid +"</td>";
								html += "</tr>";
								
								html += "<tr>";
								html += "<th align='right'>상태</th>";
								html += "<td>"+ json[0].state +"</td>";
								html += "</tr>";
								
								html += "<tr>";
								html += "<th align='right'>내용</th>";
								html += "<td>"+ json[0].content +"</td>";
								html += "</tr>";
								
								html += "</table>";
								$("#viewArea").html(html);
							}
						});
					}
				</script>
			</body>
		</html>	
<%
	}catch(Exception e) {
		e.printStackTrace(); // 오류 시 오류내용이 찍히게 처리
	}finally {
		if(rs != null) rs.close();
		if(psmt != null) psmt.close();
		if(conn != null) conn.close();
	}
%>