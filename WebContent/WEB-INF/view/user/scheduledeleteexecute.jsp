<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュールの削除完了</title>
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

	<% if ( session.getAttribute("deleteConfirm") != "") { %>
	<h2>スケジュールの削除完了</h2>

	スケジュールの削除が完了しました。
	<% } else { %>
	不正なアクセスです。
	<% } %>

	<% session.setAttribute("deleteConfirm", ""); %>

	<p><a href="/ScheduleManager/RequestSchedules">スケジュール一覧に戻る</a></p>
	<p><a href="/ScheduleManager/UserPage">ユーザーページに戻る</a></p>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>

</body>
</html>