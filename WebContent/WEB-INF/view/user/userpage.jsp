<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ユーザーページ</title>
</head>
<body>
	<h1>スケジュール管理</h1>
	<h2>ユーザーページ</h2>
	<p>${ userName }さん、こんにちは！</p>

	<p><a href="./NewSchedule">新規スケジュール</a></p>
	<p><a href="./ScheduleList">要求スケジュール一覧</a></p>

	<p><a href="./Logout">ログアウト</a></p>

</body>
</html>