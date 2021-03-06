<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="schedule.model.ScheduleDate" %>
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
	td:empty {
  background: url('data:image/svg+xml,<svg preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><line fill="none" stroke="#000000" stroke-width="0.2" stroke-miterlimit="10" x1="0" y1="0" x2="10" y2="10"/></svg>') no-repeat;
  background-size: 100%;
    }
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
	<h2>スケジュールの削除</h2>

	<table>
		<tr><th>イベント名：</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容：</th><td>${ eventContent }</td></tr>
		<tr>
			<th>候補日程：</th>
			<td><% ArrayList<ScheduleDate> sdList = (ArrayList<ScheduleDate>)request.getAttribute("eventDates"); %>
				<table>
					<% for(ScheduleDate sd : sdList) { %>
						<%= sd.toString() %>
					<% } %>
				</table>
			</td>
		</tr>
		<tr><th>入力締切日：</th><td>${ eventDeadline }</td></tr>
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
	<p><a href="/ScheduleManager/RequestSchedules">スケジュール一覧に戻る</a></p>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script>
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>

	function deleteConfirm(){
		<% session.setAttribute("deleteConfirm", "true"); %>
	}
</script>
</body>
</html>