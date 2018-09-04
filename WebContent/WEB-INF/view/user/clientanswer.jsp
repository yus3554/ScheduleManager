<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ targetEmail }さんの入力状況</title>
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
		-moz-box-sizing: border-box;
   		-webkit-box-sizing: border-box;
   		-o-box-sizing: border-box;
   		-ms-box-sizing: border-box;
   		box-sizing: border-box;
		border: solid 1px #33aaaa;
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
	<h2>${ eventName }</h2>
	<h3>${ targetEmail }さんの入力状況</h3>

	<p><a href="../ScheduleList/${ id }">スケジュール詳細に戻る</a></p>

	<table border="2">
		<tr>
			<th>日付</th>
			<th>1限</th>
			<th>2限</th>
			<th>3限</th>
			<th>4限</th>
			<th>5限</th>
		</tr>
		<% for(int i = 0; i < (int)request.getAttribute("answersLength"); i++) { %>
		<tr>
			<th><%= request.getAttribute("date" + i) %></th>
			<td>
				<% if( request.getAttribute("first" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("first" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("second" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("second" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("third" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("third" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("fourth" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("fourth" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
			<td>
				<% if( request.getAttribute("fifth" + i).equals("0") ){  %>
				×
				<% } else if(request.getAttribute("fifth" + i).equals("1")) {%>
				△
				<% } else { %>
				○
				<% } %>
			</td>
		</tr>
		<% } %>
	</table>
</div>
    </main>
    <footer>
      Copyright &#169; Yusuke Ota
    </footer>

</body>
</html>