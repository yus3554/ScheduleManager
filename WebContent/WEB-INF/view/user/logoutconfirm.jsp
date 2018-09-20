<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Logout</title>
<style>
<%@include file="../../css/user.css" %>
nav #logout{
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

	<h2>ログアウト確認</h2>
	ログアウトしますか？
	<p><a href="./Logout">ログアウト</a></p>
	<p><a href="javascript:history.back()">前のページに戻る</a></p>


	</div>
	</main>
<%@include file="../include/footer.jsp" %>

</body>
</html>