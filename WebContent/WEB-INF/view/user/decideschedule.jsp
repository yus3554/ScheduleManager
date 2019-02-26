<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="schedule.model.ScheduleDate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>日時決定の送信</title>
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
	<h2>${ eventName }</h2>
	<h3>日時決定の送信</h3>

	<p><a href="../${ id }">スケジュール詳細に戻る</a></p>

	<form action="../DecideScheduleConfirm/${ id }" method="post">
		<table>
			<tr>
				<th>開催日時 : </th>
				<td>
					<table id="table" border="2" cellpadding="10">
					<% if ((int)session.getAttribute("dateType") == 1) { %>
							<tr>
								<th>日付</th>
								<th>1限</th>
								<th>2限</th>
								<th>3限</th>
								<th>4限</th>
								<th>5限</th>
							</tr>
							<% ArrayList<ScheduleDate> sdList = (ArrayList<ScheduleDate>)session.getAttribute("eventDates"); %>
							<% for(int i = 0; i < sdList.size(); i++) { %>
							<tr>
								<th>
									<%= sdList.get(i).getDate() %>
								</th>
								<% for(int j = 0; j < 5; j++) { %>
								<td><% if(sdList.get(i).getTime(j) != -1) {
								%><input type="checkbox" name="date" value="<%= i %>,<%= j %>"><%
										} %></td>
								<% } %>
							</tr>
							<% } %>
						<% } else { %>
							<% ArrayList<String> datetime = (ArrayList<String>)session.getAttribute("datetime"); %>
							<% for(int i = 0; i < datetime.size(); i++) { %>
							<tr>
								<th>
									<%= datetime.get(i) %>
								</th>
								<td><input type="checkbox" name="date" value="<%= i %>"></td>
							</tr>
							<% } %>
						<% } %>
					</table>
				</td>
			</tr>
			<tr>
				<th>備考 : </th>
				<td><textarea wrap="hard" maxlength="200" rows="10" cols="70" name="note"></textarea></td>
				<td>200字まで<td>
			</tr>
		</table>
		<input type="submit" value="確認"><input type="reset" value="リセット">
	</form>

	</div>
	</main>
<%@include file="../include/footer.jsp" %>
<script>
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>
</script>

</body>
</html>