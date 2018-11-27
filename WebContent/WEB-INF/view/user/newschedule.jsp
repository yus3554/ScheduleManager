<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>New Schedule</title>

<script><%@include file="../../js/jquery-3.3.1.min.js" %></script>
<script><%@include file="./include/jquery.datetimepicker.full.js" %></script>

<style>
<%@include file="./include/jquery.datetimepicker.css"%>
<%@include file="../../css/user.css" %>
nav #new{
border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -webkit-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -moz-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
		background-color: #71DCB5;
	}
	th{
	text-align: center;
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

      <p><a href="./UserPage">ユーザーページに戻る</a></p>
	<!-- 空欄がある状態でsubmitしたら表示 -->
	<p id="blanktext">空欄があります。<br>
	再度、入力してください。</p>

	<form id="newschedule" name="newschedule" enctype="multipart/form-data" action="./NewScheduleConfirm" method="post">
	<table id="table">
		<tr>
			<th>イベント名</th>
			<td><input type="text" maxlength="50" size="50" name="eventName"></td>
			<td>
				50字まで
				<p id="overEventName">※文字数オーバーです。</p>
			</td>
		</tr>
		<tr>
			<th>イベント内容</th>
			<td><textarea wrap="hard" maxlength="1000" rows="20" cols="70" form="newschedule" name="eventContent"></textarea></td>
			<td>
				1000字まで
				<p id="overEventContent">※文字数オーバーです。</p>
			</td>
		</tr>
		<tr>
			<th>候補日程</th>
			<td>
				<input type="date" name="eventStartDate"> 〜 <input type="date" name="eventEndDate"><br>
				<textarea wrap="hard" maxlength="1000" rows="20" cols="70" form="newschedule" name="eventDate"></textarea>
			</td>
			<td></td>
		</tr>
		<tr id="email">
			<th>対象者のアドレス</th>
			<td>
				<input type="checkbox" name="key" value="1">
				<input type="email" size="32" name="targetEmail[]">
				<input type="button" id="addButton" onclick="addEmail();" value="+">
			</td>
			<td>キーパーソンにはチェックを入れてください。</td>
		</tr>
		<tr id="beforeAdd1"><th>入力締切日時</th><td><input id="eventDeadline" name="eventDeadline" autocomplete="off"></td><td></td></tr>
		<tr id="reminder">
			<th>リマインダー設定</th>
			<td>
				締め切りの
				<input type="number" min="0" max="30" name="remindDate[]" value="1">日前の
				<input type="number" min="0" max="23" name="remindTime[]" value="12">時に再通知
				<input type="button" id="addButton" onclick="addRemind();" value="+">
			</td>
			<td><span id="remindRemarks">日数は0~30日、時間は0~23時で指定してください。</span></td>
		</tr>
		<tr id="beforeAdd2">
			<th>開催条件</th>
			<td>
				<input type="checkbox" name="isEventCondition" value="true" onclick="condition(this.checked);">
				対象人数の
				<input type="number" min="1" name="eventConditionDenom">分の
				<input type="number" min="1" name="eventConditionNumer">以上
			</td>
		</tr>
		<tr id="file">
			<th>添付ファイル</th>
			<td>
				<input type="file" name="files" multiple>
				<input type="button" id="addButton" onclick="addFile();" value="+">
			</td>
		</tr>
	</table>
		<input type="checkbox" name="isInputInform" value="true">回答者が現在の回答人数を分かるようにする<br>
		<input type="button" value="確認" onclick="isSubmit();">
		<input type="reset" value="リセット">
		<input type="button" value="test" onclick="AutoInput();">
		<input type="button" value="不愉快" onclick="AutoInputFuyukai();">
	</form>

	</div>
	</main>
<%@include file="../include/footer.jsp" %>

	<script type="text/javascript">
	<%@include file="./include/logoutpopupjs.jsp" %>
	<%@include file="./include/newschedulejs.jsp" %>
	$("#eventDeadline").datetimepicker();
	</script>
</body>
</html>