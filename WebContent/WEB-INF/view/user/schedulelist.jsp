<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Schedule List</title>
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
      <p><a href="./UserPage">ユーザーページに戻る</a></p>

	<table>
		<thead>
		<tr>
			<th>イベント名</th>
			<th>イベント内容</th>
			<th>候補日程</th>
			<th>入力締切日</th>
			<th>削除</th>
		</tr>
		</thead>
		<tbody>
	<% for (int i = (int) request.getAttribute("listLength") - 1; i >= 0; i--) { %>
		<tr>
			<td>
				<a href="./ScheduleList/<%= request.getAttribute("id" + i) %>">
					<%= request.getAttribute("eventName" + i) %>
				</a>
			</td>
			<td>
				<% String eventContent = (String)request.getAttribute("eventContent" + i); %>
				<% if( eventContent.length() <= 15 ) { %>
				<%= eventContent %>
				<% } else { %>
				<%= eventContent.substring(0, 15) %> ...
				<% } %>
			</td>
			<td><%= request.getAttribute("eventStartDate" + i) %> 〜 <%= request.getAttribute("eventEndDate" + i) %></td>
			<td><%= request.getAttribute("eventDeadlineDate" + i) %></td>
			<td><a href="./ScheduleList/DeleteConfirm/<%= request.getAttribute("id" + i) %>">[x]</a></td>
		</tr>
	<% } %>
	</tbody>
	</table>
</div>
    </main>
    <footer>
      Copyright &#169; Yusuke Ota
    </footer>
</body>
</html>