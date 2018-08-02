<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュールの削除完了</title>
</head>
<body>

	<h1>スケジュール管理</h1>

	<% if ( session.getAttribute("deleteConfirm") != "") { %>
	<h2>スケジュールの削除完了</h2>

	スケジュールの削除が完了しました。
	<% } else { %>
	不正なアクセスです。
	<% } %>

	<% session.setAttribute("deleteConfirm", ""); %>

	<p><a href="/ScheduleManager/ScheduleList">スケジュール一覧に戻る</a></p>
	<p><a href="/ScheduleManager/UserPage">ユーザーページに戻る</a></p>

</body>
</html>