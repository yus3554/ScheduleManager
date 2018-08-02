<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュール回答</title>
</head>
<body>

<h1>スケジュール管理</h1>
<h2>スケジュール回答</h2>

	<h3>${ senderName }さんからの入力要求</h3>

	<form action="../AnswerConfirm" method="post">
	<table border="2">
		<tr>
			<th>日付</th>
			<th>1限</th>
			<th>2限</th>
			<th>3限</th>
			<th>4限</th>
			<th>5限</th>
		</tr>
		<% for(int i = 0; i < (int)session.getAttribute("answersLength"); i++) { %>
		<tr>
			<th>
				<%= request.getAttribute("date" + i) %>
				<input type="hidden" name="date<%= i %>" value="<%= request.getAttribute("date" + i) %>">
			</th>
			<td>
				<select name="first<%= i %>">
					<option value="0" <% if( request.getAttribute("first" + i).equals("0") ){ %>selected<% } %>>×</option>
					<option value="1" <% if( request.getAttribute("first" + i).equals("1") ){ %>selected<% } %>>△</option>
					<option value="2" <% if( request.getAttribute("first" + i).equals("2") ){ %>selected<% } %>>○</option>
				</select>
			</td>
			<td>
				<select name="second<%= i %>">
					<option value="0" <% if( request.getAttribute("second" + i).equals("0") ){ %>selected<% } %>>×</option>
					<option value="1" <% if( request.getAttribute("second" + i).equals("1") ){ %>selected<% } %>>△</option>
					<option value="2" <% if( request.getAttribute("second" + i).equals("2") ){ %>selected<% } %>>○</option>
				</select>
			</td>
			<td>
				<select name="third<%= i %>">
					<option value="0" <% if( request.getAttribute("third" + i).equals("0") ){ %>selected<% } %>>×</option>
					<option value="1" <% if( request.getAttribute("third" + i).equals("1") ){ %>selected<% } %>>△</option>
					<option value="2" <% if( request.getAttribute("third" + i).equals("2") ){ %>selected<% } %>>○</option>
				</select>
			</td>
			<td>
				<select name="fourth<%= i %>">
					<option value="0" <% if( request.getAttribute("fourth" + i).equals("0") ){ %>selected<% } %>>×</option>
					<option value="1" <% if( request.getAttribute("fourth" + i).equals("1") ){ %>selected<% } %>>△</option>
					<option value="2" <% if( request.getAttribute("fourth" + i).equals("2") ){ %>selected<% } %>>○</option>
				</select>
			</td>
			<td>
				<select name="fifth<%= i %>">
					<option value="0" <% if( request.getAttribute("fifth" + i).equals("0") ){ %>selected<% } %>>×</option>
					<option value="1" <% if( request.getAttribute("fifth" + i).equals("1") ){ %>selected<% } %>>△</option>
					<option value="2" <% if( request.getAttribute("fifth" + i).equals("2") ){ %>selected<% } %>>○</option>
				</select>
			</td>
		</tr>
		<% } %>
	</table>
	<input type="submit" value="確認">
	</form>

</body>
</html>