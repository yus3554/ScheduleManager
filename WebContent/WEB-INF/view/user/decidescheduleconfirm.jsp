<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.time.LocalDate" %>
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
						<% LocalDate ld = LocalDate.parse((String)session.getAttribute("eventStartDate")); %>
						<% int[][] date = (int[][])session.getAttribute("date"); %>
						<% for(int i = 0; i < (long)session.getAttribute("dateLength") + 1; i++) { %>
						<tr>
							<th>
								<%= ld.toString() %>
							</th>
							<% for(int j = 0; j < 5; j++) { %>
							<td>
							<% if( date[i][j] == 1 ){%>
							●
							<% } %>
							</td>
							<% } %>
							<% ld = ld.plusDays(1); %>
						</tr>
						<% } %>
					</table>
				</td>
			</tr>
			<tr>
				<th>備考 : </th>
				<td>${ note }</td>
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