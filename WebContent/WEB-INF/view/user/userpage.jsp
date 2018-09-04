<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ユーザーページ</title>
<style><%@include file="../../css/user.css" %></style>
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
        このウェブサイトは、スケジュールを管理するためのシステムです。<br>
        みなさんぜひつかってくださいね！<br><br>

        今現在期間内であるスケジュールを表示しています。
      </div>
    </main>
    <footer>
      Copyright &#169; Yusuke Ota
    </footer>

</body>
</html>