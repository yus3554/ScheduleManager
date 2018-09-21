<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規スケジュールの確認</title>
<style>
<%@include file="../../css/user.css" %>
nav #new{
border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -webkit-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -moz-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
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
	<h2>新規スケジュールの確認</h2>

	<table>
		<tr><th>イベント名：</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容：</th><td>${ eventContent }</td></tr>
		<tr><th>候補日程：</th><td>${ eventStartDate } 〜 ${ eventEndDate }</td></tr>
		<% int addressNum = 5; %>
		<tr>
			<th rowspan="<%= addressNum %>">対象者のアドレス：</th>
			<td><%= ((String[])session.getAttribute("targetEmails"))[0] %></td>
		</tr>
		<% for(int i = 1; i < addressNum ; i++) { %>
		<tr><td><%= ((String[])session.getAttribute("targetEmails"))[i] %></td></tr>
		<% } %>
		<tr><th>入力締切日：</th><td>${ eventDeadlineDate }</td></tr>
	</table>

	以上の内容でよろしいでしょうか？
	<form action="./NewScheduleSubmit" method="post">
		<input type="submit" value="送信"><input type="button" onClick="javascript:history.back();" value="戻る">
	</form>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>
</body>
</html>