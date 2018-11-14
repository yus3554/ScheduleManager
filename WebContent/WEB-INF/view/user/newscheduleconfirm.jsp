<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規スケジュールの確認</title>
<style>
<%@include file="../../css/user.css" %>
nav #new{
border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -webkit-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -moz-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
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
	<h2>新規スケジュールの確認</h2>

	<table>
		<tr><th>イベント名：</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容：</th><td>${ eventContent }</td></tr>
		<tr><th>候補日程：</th><td>${ eventStartDate } 〜 ${ eventEndDate }</td></tr>
		<% int addressNum = ((ArrayList<String>)session.getAttribute("targetEmails")).size(); %>
		<tr>
			<th rowspan="<%= addressNum %>">対象者のアドレス：</th>
			<td>
				<%= ((ArrayList<String>)session.getAttribute("targetEmails")).get(0) %>
				<% if(((ArrayList<Boolean>)session.getAttribute("keys")).get(0)){ %>
				(キーパーソン)
				<% } %>
			</td>
		</tr>
		<% for(int i = 1; i < addressNum ; i++) { %>
		<tr>
			<td>
				<%= ((ArrayList<String>)session.getAttribute("targetEmails")).get(i) %>
				<% if(((ArrayList<Boolean>)session.getAttribute("keys")).get(i)){ %>
				(キーパーソン)
				<% } %>
			</td>
		</tr>
		<% } %>
		<tr><th>入力締切日時：</th><td>${ eventDeadline }</td></tr>
		<% int remindDatesSize = ((ArrayList<int[]>)session.getAttribute("remindDates")).size(); %>
		<tr>
			<th rowspan="<%= remindDatesSize %>">リマインダー日時：</th>
			<td>
				締め切り日時の<%= ((ArrayList<int[]>)session.getAttribute("remindDates")).get(0) %>日前の
				<%= ((ArrayList<int[]>)session.getAttribute("remindTimes")).get(0) %>時
			</td>
		</tr>
		<% for(int i = 1; i < remindDatesSize ; i++) { %>
		<tr>
			<td>
				締め切り日時の<%= ((ArrayList<int[]>)session.getAttribute("remindDates")).get(i) %>日前の
				<%= ((ArrayList<int[]>)session.getAttribute("remindTimes")).get(i) %>時
			</td>
		</tr>
		<% } %>
		<tr>
			<th>開催条件：</th>
			<td>
			<% if ((boolean)session.getAttribute("isEventCondition")) { %>
				${ eventConditionDenom }分の${ eventConditionNumer }以上
			<% } else { %>
				なし
			<% } %>
			</td>
		</tr>
		<tr><th>添付ファイル：</th><td>${ fileName }</td></tr>
	</table>
	回答者が現在の回答人数を分かるようにする：<%= (boolean)session.getAttribute("isInputInform") ? "有効" : "無効" %><br><br>

	以上の内容でよろしいでしょうか？
	<form action="./NewScheduleSubmit" method="post">
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