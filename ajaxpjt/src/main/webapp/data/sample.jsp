<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String data1Param = request.getParameter("data1");
	String data2Param = request.getParameter("data2");
	
	String result = data1Param + "_" + data2Param;
	// out.print(result);
%>
<%= result %>