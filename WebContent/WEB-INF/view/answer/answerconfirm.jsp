<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュール回答送信確認</title>
<style><%@include file="../../css/single.css" %></style>
<%@include file="../include/font.jsp" %>
</head>
<body>

<%@include file="../include/header.jsp" %>
	<main>
	<div id="honbun">
<h2>スケジュール回答送信確認</h2>
<h3>${ senderName }さんからの入力要求</h3>

	<table border="2" cellpadding="10">
		<tr>
			<th>日付</th>
			<th>1限</th>
			<th>2限</th>
			<th>3限</th>
			<th>4限</th>
			<th>5限</th>
		</tr>
		<% String[] times = {"first", "second", "third", "fourth", "fifth"}; %>
		<% for(int i = 0; i < (int)session.getAttribute("answersLength"); i++) { %>
		<tr>
			<th>
				<%= ((String[])session.getAttribute("date"))[i] %>
			</th>
			<% for(int j = 0; j < times.length; j++) { %>
			<td align="center" valign="top">
				<% if( ((String[])session.getAttribute(times[j]))[i].equals("0") ){ %>×<% } %>
				<% if( ((String[])session.getAttribute(times[j]))[i].equals("1") ){ %>△<% } %>
				<% if( ((String[])session.getAttribute(times[j]))[i].equals("2") ){ %>○<% } %>
			</td>
			<% } %>
		</tr>
		<% } %>
	</table>

	以上の内容でよろしいでしょうか？
	<form action="./AnswerSubmit" method="post">
		<input type="submit" value="送信"><input type="button" onClick="javascript:history.back();" value="戻る">
	</form>

	</div>
	</main>
    <%@include file="../include/footer.jsp" %>

</body>
</html>