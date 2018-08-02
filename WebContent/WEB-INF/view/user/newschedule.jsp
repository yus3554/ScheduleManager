<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規スケジュール</title>
</head>
<body>

	<h1>スケジュール管理</h1>
	<h2>新規スケジュール</h2>

	<p><a href="./UserPage">ユーザーページに戻る</a></p>

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
			<td><textarea wrap="hard" maxlength="1000" rows="20" cols="100" form="newschedule" name="eventContent"></textarea></td>
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

	<script type="text/javascript">
		// 最初は非表示
		document.getElementById("blanktext").style.display = "none";
		document.getElementById("overEventName").style.display = "none";
		document.getElementById("overEventContent").style.display = "none";

		var form = document.forms.newschedule;

		// テスト用の自動入力ボタン
		function AutoInput(){
			form.eventName.value = "会議の開催日程について";
			form.eventContent.value = "会議をします。";
			form.targetEmail1.value = "s152017@eecs.tottori-u.ac.jp";
			form.targetEmail2.value = "yus3554@gmail.com";
			form.eventStartDate.value = "2018-09-01";
			form.eventEndDate.value = "2018-09-03";
			form.eventDeadlineDate.value = "2018-08-20";
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