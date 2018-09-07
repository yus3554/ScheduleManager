<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュールの削除</title>
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
	<header>
		<h1><a href="../">Schedule Manager</a></h1>
	</header>
	<div id="name">
		<p>${ userName }さん、こんにちは！</p>
	</div>
	<main>
      <nav>
        <div id="new">
          <a href="../NewSchedule" class="list">New Schedule</a>
        </div>
        <div id="list">
          <a href="../ScheduleList" class="list">Schedule List</a>
        </div>
        <div id="config">
          <a href="../Config" class="list">Config</a>
        </div>
        <div id="logout">
          <a href="../Logout" class="list">Logout</a>
        </div>
      </nav>
      <div id="honbun">
	<h2>スケジュールの削除</h2>

	<table>
		<tr><th>イベント名：</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容：</th><td>${ eventContent }</td></tr>
		<tr><th>候補日程：</th><td>${ eventStartDate } 〜 ${ eventEndDate }</td></tr>
		<tr><th>入力締切日：</th><td>${ eventDeadlineDate }</td></tr>
		<% int targetListLength = (int) request.getAttribute("targetListLength"); %>
		<tr>
			<th rowspan="<%= targetListLength %>">
				対象者：
			</th>
			<td><%= request.getAttribute("targetEmail0") %></td>
		</tr>
		<% for (int i = 1; i < targetListLength; i++) { %>
		<tr>
			<td><%= request.getAttribute("targetEmail" + i) %></td>
		</tr>
		<% } %>
	</table>

	<p><a href="../Delete/<%= request.getAttribute("id") %>" onclick="deleteConfirm();">削除する</a></p>
	<p><a href="/ScheduleManager/ScheduleList">スケジュール一覧に戻る</a></p>
	</div>
    </main>
    <footer>
      Copyright &#169; Yusuke Ota
    </footer>

<script>
	function deleteConfirm(){
		<% session.setAttribute("deleteConfirm", "true"); %>
	}
</script>
</body>
</html>