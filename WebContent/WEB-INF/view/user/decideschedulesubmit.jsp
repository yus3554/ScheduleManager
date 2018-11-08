<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.time.LocalDate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>日時決定の送信完了</title>
<style>
	<%@include file="../../css/user.css" %>
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
	<h2>${ eventName }</h2>
	<h3>日時決定の送信完了</h3>

	日時決定の送信が完了しました。

	<p><a href="../${ id }">スケジュール詳細に戻る</a></p>

	</div>
	</main>
<%@include file="../include/footer.jsp" %>
<script>
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>
</script>

</body>
</html>