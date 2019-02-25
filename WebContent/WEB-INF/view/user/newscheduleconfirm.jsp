<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "schedule.model.ScheduleDate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規スケジュールの確認</title>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
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
	<h4 class="border-bottom">新規日程要求</h4>

	<table class="table border-bottom">
		<tr><th>イベント名</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容</th><td>${ eventContent }</td></tr>
		<tr>
			<th>候補日程</th>
			<td>
				<% ArrayList<ScheduleDate> sdList = (ArrayList<ScheduleDate>)session.getAttribute("eventDates"); %>
				<table style="border-style:solid">
				<thead class="thead-light"><tr><th>日付</th><td>1限</td><td>2限</td><td>3限</td><td>4限</td><td>5限</td></tr></thead>
				<tbody>
				<% for(ScheduleDate sd : sdList){ %>
					<%= sd.toString() %>
				<% } %>
				</tbody>
				</table>
			</td>
		</tr>
		<% int addressNum = ((ArrayList<String>)session.getAttribute("targetEmails")).size(); %>
		<tr>
			<th rowspan="<%= addressNum %>">対象者のアドレス</th>
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
		<tr><th>入力締切日時</th><td>${ eventDeadline }</td></tr>
		<% int remindDateTimesSize = ((ArrayList<int[]>)session.getAttribute("remindDateTimes")).size(); %>
		<tr>
			<th rowspan="<%= remindDateTimesSize %>">リマインダー日時</th>
			<td>
				<%= ((ArrayList<int[]>)session.getAttribute("remindDateTimes")).get(0) %>
			</td>
		</tr>
		<% for(int i = 1; i < remindDateTimesSize ; i++) { %>
		<tr>
			<td>
				<%= ((ArrayList<int[]>)session.getAttribute("remindDateTimes")).get(i) %>
			</td>
		</tr>
		<% } %>
		<tr>
			<th>開催条件</th>
			<td>
			<% if ((boolean)session.getAttribute("isEventCondition")) { %>
				${ eventConditionDenom }分の${ eventConditionNumer }以上
			<% } else { %>
				なし
			<% } %>
			</td>
		</tr>
		<% if((int)session.getAttribute("fileNum") != -1) { %>
			<tr>
				<th rowspan="<%= (int)session.getAttribute("fileNum") + 1 %>">添付ファイル</th>
				<td>${ fileName0 }</td>
			</tr>
			<% for(int i = 1; i < (int)session.getAttribute("fileNum") + 1 ; i++) { %>
				<tr>
					<td><%= (String)session.getAttribute("fileName" + i) %></td>
				</tr>
			<% } %>
		<% } %>
	</table>
	締め切りを過ぎた際にリマインダーを送る : <%= (boolean)session.getAttribute("isRemindDeadline") ? "有効" : "無効" %><br>
	回答者が現在の回答人数を分かるようにする：<%= (boolean)session.getAttribute("isInputInform") ? "有効" : "無効" %><br><br>

	以上の内容でよろしいでしょうか？
	<form action="./NewScheduleSubmit" method="post">
		<button type="button" class="btn btn-outline-secondary" onClick="history.back();">戻る</button>
		<button type="submit" class="btn btn-primary">送信</button>
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