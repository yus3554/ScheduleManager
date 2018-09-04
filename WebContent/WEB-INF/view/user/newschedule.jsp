<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>New Schedule</title>
<style>
<%@include file="../../css/user.css" %>
nav #new{
border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -webkit-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
  -moz-border-radius: 5px 5px 0 0 / 5px 5px 0 0;
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
	<!-- 空欄がある状態でsubmitしたら表示 -->
	<p id="blanktext">空欄があります。<br>
	再度、入力してください。</p>

	<form id="newschedule" name="newschedule" action="./NewScheduleConfirm" method="post">
	<table>
		<tr>
			<td>イベント名：</td>
			<td><input type="text" maxlength="50" size="50" name="eventName"></td>
			<td>
				50字まで
				<p id="overEventName">※文字数オーバーです。</p>
			</td>
		</tr>
		<tr>
			<td>イベント内容：</td>
			<td><textarea wrap="hard" maxlength="1000" rows="20" cols="70" form="newschedule" name="eventContent"></textarea></td>
			<td>
				1000字まで
				<p id="overEventContent">※文字数オーバーです。</p>
			</td>
		</tr>
		<tr><td>候補日程：</td><td><input type="date" name="eventStartDate"> 〜 <input type="date" name="eventEndDate"></td><td></td></tr>
		<tr><td rowspan="5">対象者のアドレス：</td><td><input type="email" size="32" name="targetEmail1"></td><td></td></tr>
		<tr><td><input type="email" size="32" name="targetEmail2"></td><td></td></tr>
		<tr><td><input type="email" size="32" name="targetEmail3"></td><td></td></tr>
		<tr><td><input type="email" size="32" name="targetEmail4"></td><td></td></tr>
		<tr><td><input type="email" size="32" name="targetEmail5"></td><td></td></tr>
		<tr><td>入力締切日：</td><td><input type="date" name="eventDeadlineDate"></td><td></td></tr>
	</table>
		<input type="button" value="確認" onclick="isSubmit();"><input type="reset" value="リセット"><input type="button" value="test" onclick="AutoInput();">
	</form>
	</div>
	</main>
	<footer>
      Copyright &#169; Yusuke Ota
    </footer>

	<script type="text/javascript">
		// 最初は非表示
		document.getElementById("blanktext").style.display = "none";
		document.getElementById("overEventName").style.display = "none";
		document.getElementById("overEventContent").style.display = "none";

		var form = document.forms.newschedule;

		// とりあえず
		// 今から1日後を締め切り
		var deadline = new Date(Date.now() + 1 * 24 * 60 * 60000);
		var start = new Date(Date.now() + 3 * 24 * 60 * 60000);
		var end = new Date(Date.now() + 8 * 24 * 60 * 60000);

		function addZero(n){
			if(n < 10){
				return "0" + n;
			} else {
				return n;
			}
		}

		// テスト用の自動入力ボタン
		function AutoInput(){
			form.eventName.value = "会議の開催日程について";
			form.eventContent.value = "会議をします。";
			form.targetEmail1.value = "s152017@eecs.tottori-u.ac.jp";
			form.targetEmail2.value = "yus3554@gmail.com";
			form.eventStartDate.value = "" + start.getFullYear() + "-" + addZero(start.getMonth() + 1) + "-" + addZero(start.getDate());
			form.eventEndDate.value = "" + end.getFullYear() + "-" + addZero(end.getMonth() + 1) + "-" + addZero(end.getDate());
			form.eventDeadlineDate.value = "" + deadline.getFullYear() + "-" + addZero(deadline.getMonth() + 1) + "-" + addZero(deadline.getDate());
		}

		function isSubmit(){
			if(isBlank() && isOverEventName() && isOverEventContent()){
				form.submit();
			}
		}

		// 空欄があるかどうか、なくなったらsubmit
		function isBlank(){
			var blanktext = document.getElementById("blanktext");
			if (form.eventName.value == "" ||
				form.eventContent.value == "" ||
				form.eventStartDate.value == "" ||
				form.eventEndDate.value == "" ||
				(form.targetEmail1.value == "" &&
				 form.targetEmail2.value == "" &&
				 form.targetEmail3.value == "" &&
				 form.targetEmail4.value == "" &&
				 form.targetEmail5.value == "") ||
				form.eventDeadlineDate.value == "") {
				blanktext.style.display = "block";
				return false;
			} else {
				return true;
			}
		}

		// 文字数制限
		function isOverEventName(){
			if(form.eventName.value.length > 50){
				overEventName.style.display = "block";
			}else{
				return true;
			}
		}
		function isOverEventContent(){
			if(form.eventContent.value.length > 1000){
				overEventContent.style.display = "block";
			}else{
				return true;
			}
		}
	</script>
</body>
</html>