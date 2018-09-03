<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ eventName }</title>
</head>
<body>
	<h1>スケジュール管理</h1>
	<h2>${ eventName }</h2>

	<p><a href="../ScheduleList">スケジュール一覧に戻る</a></p>
	<p><a href="../UserPage">ユーザーページに戻る</a></p>

	<table>
		<tr><th>イベント名：</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容：</th><td>${ eventContent }</td></tr>
		<tr><th>候補日程：</th><td>${ eventStartDate } 〜 ${ eventEndDate }</td></tr>
		<tr><th>入力締切日：</th><td>${ eventDeadlineDate }</td></tr>
		<tr>
			<th>全体の回答状況：<br>（○の数）</th>
			<td>
				<table border="2">
					<tr>
						<th>日付</th>
						<th>1限</th>
						<th>2限</th>
						<th>3限</th>
						<th>4限</th>
						<th>5限</th>
					</tr>
					<% int[][] counts = (int[][])request.getAttribute("counts"); %>
					<% for(int i = 0; i < (int)request.getAttribute("countLength"); i++) { %>
					<tr>
						<th><%= request.getAttribute("date" + i)%></th>
						<% for(int j = 0; j < 5; j++) { %>
						<% if((int)request.getAttribute("max") == counts[i][j] && counts[i][j] != 0) { %>
						<td bgcolor="#FE9A2E">
						<% } else if ((int)request.getAttribute("max_1") == counts[i][j] && counts[i][j] != 0){ %>
						<td bgcolor="#F4FA58">
						<% } else { %>
						<td>
						<% } %>
						<%= counts[i][j] %></td>
						<% } %>
					</tr>
					<% } %>
				</table>
			</td>
		</tr>
		<% int targetListLength = (int) request.getAttribute("targetListLength"); %>
		<tr>
			<th rowspan="<%= targetListLength %>">
				各対象者の回答状況：
			</th>
			<td>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL0") %>">
					<%= request.getAttribute("targetEmail0") %>
				</a>
				<% if( request.getAttribute("isInput0").equals("0")){ %>
				[未回答]
				<% } else { %>
				[回答済]
				<% } %>
			</td>
		</tr>
		<% for (int i = 1; i < targetListLength; i++) { %>
		<tr>
			<td>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL" + i) %>">
					<%= request.getAttribute("targetEmail" + i) %>
				</a>
				<% if( request.getAttribute("isInput" + i).equals("0")){ %>
				[未回答]
				<% } else { %>
				[回答済]
				<% } %>
			</td>
		</tr>
		<% } %>
	</table>

	<p><a href="../ScheduleList">スケジュール一覧に戻る</a></p>
	<p><a href="../UserPage">ユーザーページに戻る</a></p>

</body>
</html>