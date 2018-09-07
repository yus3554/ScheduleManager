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
<link href="https://fonts.googleapis.com/css?family=Comfortaa|Poiret+One" rel="stylesheet">
</head>
<body>
	<header>
		<h1><a href="./">Schedule Manager</a></h1>
	</header>
	<div id="name">
		<p>${ userName }さん、こんにちは！</p>
	</div>
	<main>
      <nav>
        <div id="new">
          <a href="./NewSchedule" class="list">New Schedule</a>
        </div>
        <div id="list">
          <a href="./ScheduleList" class="list">Schedule List</a>
        </div>
        <div id="config">
          <a href="./Config" class="list">Config</a>
        </div>
        <div id="logout">
          <a href="./Logout" class="list">Logout</a>
        </div>
      </nav>
      <div id="honbun">
	<h2>新規スケジュールの送信完了</h2>

	スケジュール入力要求を各対象者に送信しました。

	<p><a href="./UserPage">ユーザーページに戻る</a></p>
	</div>
	</main>
	<footer>
      Copyright &#169; Yusuke Ota
    </footer>
</body>
</html>