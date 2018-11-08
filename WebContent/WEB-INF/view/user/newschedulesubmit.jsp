<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規スケジュールの送信完了</title>
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
	<%@include file="./include/logoutpopup.jsp" %>
	<main>
	<%@include file="./include/nav.jsp" %>
	<div id="honbun">
	<h2>新規スケジュールの送信完了</h2>

	スケジュール入力要求を各対象者に送信しました。

	<p><a href="./UserPage">ユーザーページに戻る</a></p>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script>
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>
</script>

</body>
</html>