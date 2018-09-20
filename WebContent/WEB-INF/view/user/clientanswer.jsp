<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ targetEmail }さんの入力状況</title>
<style>
	<%@include file="../../css/user.css" %>
	table th{
		padding: 10px;
	}
	table td{
		padding: 10px;
	}
	nav #list{
		background-color: #71DCB5;
	}
</style>
<link href="https://fonts.googleapis.com/css?family=Comfortaa|Poiret+One" rel="stylesheet">
</head>
<body>

	<%@include file="../include/header.jsp" %>
	<%@include file="./include/name.jsp" %>
	<main>
	<%@include file="./include/nav.jsp" %>
	<div id="honbun">
	<h2>${ eventName }</h2>
	<h3>${ targetEmail }さんの入力状況</h3>

	<p><a href="../RequestSchedules/${ id }">スケジュール詳細に戻る</a></p>

	<table border="2">
		<tr>
			<th>日付</th>
			<th>1限</th>
			<th>2限</th>
			<th>3限</th>
			<th>4限</th>
			<th>5限</th>
		</tr>
		<% String[] times = {"first", "second", "third", "fourth", "fifth"}; %>
		<% for(int i = 0; i < (int)request.getAttribute("answersLength"); i++) { %>
		<tr>
			<th><%= request.getAttribute("date" + i) %></th>
			<% for(int j = 0; j < times.length; j++){ %>
			<td align="center" valign="top" >
				<% if( request.getAttribute(times[j] + i).equals("0") ){  %>×<% } %>
				<% if(request.getAttribute(times[j] + i).equals("1")) {%>△<% } %>
				<% if(request.getAttribute(times[j] + i).equals("2")) { %>○<% } %>
			</td>
			<% } %>
		</tr>
		<% } %>
	</table>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>

</body>
</html>