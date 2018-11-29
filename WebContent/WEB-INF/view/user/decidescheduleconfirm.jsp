<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="schedule.model.ScheduleDate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>日時決定の送信確認</title>
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
	<h3>日時決定の送信確認</h3>

	<p><a href="../${ id }">スケジュール詳細に戻る</a></p>
	以下の内容でよろしいですか？<br><br>

		<table>
			<tr>
				<th>開催日時 : </th>
				<td>
					<table id="table" border="2" cellpadding="10">
						<tr>
							<th>日付</th>
							<th>1限</th>
							<th>2限</th>
							<th>3限</th>
							<th>4限</th>
							<th>5限</th>
						</tr>
						<% ArrayList<ScheduleDate> sdList = (ArrayList<ScheduleDate>)session.getAttribute("eventDates"); %>
						<% int[][] date = (int[][])session.getAttribute("date"); %>
						<% for(int i = 0; i < sdList.size(); i++) { %>
						<tr>
							<th>
								<%= sdList.get(i).getDate() %>
							</th>
							<% for(int j = 0; j < 5; j++) { %>
							<td><% if( date[i][j] == 1 ){%>●<% }
							else if ( sdList.get(i).getTime(j) == -1 ) {%><%
								} else { %> <% } %></td>
							<% } %>
						</tr>
						<% } %>
					</table>
				</td>
			</tr>
			<tr>
				<th>備考 : </th>
				<td>${ note } </td>
			</tr>
		</table>


	<form action="../DecideScheduleSubmit/${ id }" method="post">
	<input type="submit" value="送信"><input type="button" onClick="javascript:history.back();" value="戻る">
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