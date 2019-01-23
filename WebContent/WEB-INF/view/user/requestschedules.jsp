<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Schedule List</title>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
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
	<%@include file="./include/logoutpopup.jsp" %>
	<main>
	<%@include file="./include/nav.jsp" %>
	<div id="honbun">

	<table class="table table-bordered">
		<thead class="thead-light">
		<tr>
			<th>イベント名</th>
			<th>イベント内容</th>
			<th>回答締切日</th>
			<th>回答人数</th>
			<th>削除</th>
		</tr>
		</thead>
		<tbody>
	<% for (int i = (int) request.getAttribute("listLength") - 1; i >= 0; i--) { %>
		<% if( request.getAttribute("decideDate" + i) != null) {%>
		<tr class="table-active">
		<% } else { %>
		<tr>
		<% } %>
			<td>
				<% if( request.getAttribute("decideDate" + i) != null) {%>[日時決定済] <% } %>
				<a href="./RequestSchedules/<%= request.getAttribute("id" + i) %>">
					<%= request.getAttribute("eventName" + i) %>
				</a>
			</td>
			<td>
				<% String eventContent = ((String)request.getAttribute("eventContent" + i)).replace("<br>", "  "); %>
				<% if( eventContent.length() <= 15 ) { %>
				<%= eventContent %>
				<% } else { %>
				<%= eventContent.substring(0, 15) %> ...
				<% } %>
			</td>
			<td><%= request.getAttribute("eventDeadline" + i) %></td>
			<td><%= request.getAttribute("isInputNum" + i) %> / <%= request.getAttribute("targetNum" + i) %>人</td>
			<td><a href="./RequestSchedules/DeleteConfirm/<%= request.getAttribute("id" + i) %>">[x]</a></td>
		</tr>
	<% } %>
	</tbody>
	</table>
</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script>
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>
</script>

</body>
</html>