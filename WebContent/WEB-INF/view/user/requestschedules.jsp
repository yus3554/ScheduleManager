<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Schedule List</title>
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
<%@include file="../include/font.jsp" %>
</head>
<body>
<%@include file="../include/header.jsp" %>
	<%@include file="./include/name.jsp" %>
	<main>
	<%@include file="./include/nav.jsp" %>
	<div id="honbun">
      <p><a href="./UserPage">ユーザーページに戻る</a></p>

	<table>
		<thead>
		<tr>
			<th>日時決定</th>
			<th>イベント名</th>
			<th>イベント内容</th>
			<th>候補日程</th>
			<th>入力締切日</th>
			<th>削除</th>
		</tr>
		</thead>
		<tbody>
	<% for (int i = (int) request.getAttribute("listLength") - 1; i >= 0; i--) { %>
		<tr>
			<td><% if( request.getAttribute("decideDate" + i) != null) {%>○<% } %></td>
			<td>
				<a href="./RequestSchedules/<%= request.getAttribute("id" + i) %>">
					<%= request.getAttribute("eventName" + i) %>
				</a>
			</td>
			<td>
				<% String eventContent = (String)request.getAttribute("eventContent" + i); %>
				<% if( eventContent.length() <= 15 ) { %>
				<%= eventContent %>
				<% } else { %>
				<%= eventContent.substring(0, 15) %> ...
				<% } %>
			</td>
			<td><%= request.getAttribute("eventStartDate" + i) %> 〜 <%= request.getAttribute("eventEndDate" + i) %></td>
			<td><%= request.getAttribute("eventDeadlineDate" + i) %></td>
			<td><a href="./RequestSchedules/DeleteConfirm/<%= request.getAttribute("id" + i) %>">[x]</a></td>
		</tr>
	<% } %>
	</tbody>
	</table>
</div>
	</main>
<%@include file="../include/footer.jsp" %>
</body>
</html>