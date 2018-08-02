<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ targetEmail }さんの入力状況</title>
</head>
<body>

	<h1>スケジュール管理</h1>
	<h2>${ eventName }</h2>
	<h3>${ targetEmail }さんの入力状況</h3>

	<p><a href="../ScheduleList/${ id }">スケジュール詳細に戻る</a></p>
	<p><a href="../ScheduleList">スケジュール一覧に戻る</a></p>
	<p><a href="../UserPage">ユーザーページに戻る</a></p>

	<table border="2">
		<tr>
			<th>日付</th>
			<th>1限</th>
			<th>2限</th>
			<th>3限</th>
			<th>4限</th>
			<th>5限</th>
		</tr>
		<% for(int i = 0; i < (int)request.getAttribute("answersLength"); i++) { %>
		<tr>
			<th><%= request.getAttribute("date" + i) %></th>
			<td>
				<% if( request.getAttribute("first" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("first" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("second" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("second" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("third" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("third" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("fourth" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("fourth" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("fifth" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("fifth" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
		</tr>
		<% } %>
	</table>


</body>
</html>