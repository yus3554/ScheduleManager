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
	}
</style>
<%@include file="../include/font.jsp" %>
</head>
<body>
	<%@include file="../include/header.jsp" %>
	<%@include file="./include/name.jsp" %>
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
		<tr id="email">
			<td>対象者のアドレス：</td>
			<td>
				<input type="checkbox" name="key" value="1">
				<input type="email" size="32" name="targetEmail[]">
				<span id="emailDelete1">×</span>
				<input type="button" id="addButton" onclick="addEmail();" value="+">
			</td>
			<td>キーパーソンにはチェックを入れてください。</td>
		</tr>
		<tr id="beforeAdd"><td>入力締切日：</td><td><input type="date" name="eventDeadlineDate"></td><td></td></tr>
		<tr><td>添付ファイル</td><td><input type="file" name="file"/></td></tr>
	</table>
		<input type="button" value="確認" onclick="isSubmit();">
		<input type="reset" value="リセット">
		<input type="button" value="test" onclick="AutoInput();">
		<input type="button" value="不愉快" onclick="AutoInputFuyukai();">
	</form>

	</div>
	</main>
<%@include file="../include/footer.jsp" %>

	<script type="text/javascript">
		// 最初は非表示
		document.getElementById("blanktext").style.display = "none";
		document.getElementById("overEventName").style.display = "none";
		document.getElementById("overEventContent").style.display = "none";

		var times = 1;
		var form = document.forms.newschedule;
		var table = document.getElementById("table");
		var email = form.elements["targetEmail[]"];
		var emailTr = document.getElementById("email");

		// とりあえず
		// 今から2日後を締め切り
		var deadline = new Date(Date.now() + 2 * 24 * 60 * 60000);
		var start = new Date(Date.now() + 4 * 24 * 60 * 60000);
		var end = new Date(Date.now() + 9 * 24 * 60 * 60000);

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
			if(times <= 1){
				email.value = "s152017@eecs.tottori-u.ac.jp";
			} else {
				email[0].value = "s152017@eecs.tottori-u.ac.jp";
			}
			form.eventStartDate.value = "" + start.getFullYear() + "-" + addZero(start.getMonth() + 1) + "-" + addZero(start.getDate());
			form.eventEndDate.value = "" + end.getFullYear() + "-" + addZero(end.getMonth() + 1) + "-" + addZero(end.getDate());
			form.eventDeadlineDate.value = "" + deadline.getFullYear() + "-" + addZero(deadline.getMonth() + 1) + "-" + addZero(deadline.getDate());
		}

		function AutoInputFuyukai(){
			email[0].value = "s152017@eecs.tottori-u.ac.jp"; // 太田
			email[1].value = "s152119@eecs.tottori-u.ac.jp"; // 山田
			email[2].value = "s132029@ike.tottori-u.ac.jp"; // 酒井
			email[3].value = "s112052@ike.tottori-u.ac.jp"; // 松永
			email[4].value = "takahashi@tottori-u.ac.jp"; // 高橋
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
				form.eventDeadlineDate.value == "") {
				if(times <= 1){
					if(email.value == ""){
						blanktext.style.display = "block";
						return false;
					}
				} else {
					if(email[0].value == ""){
						blanktext.style.display = "block";
						return false;
					}
				}
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

		function addEmail(){
			  times++;
			  var newTr = document.createElement("tr");
			  newTr.innerHTML = "<tr><td>"
			  + "<input type=\"checkbox\" name=\"key\" value=\"" + times + "\">"
			  + "<input type=\"email\" size=\"32\" name=\"targetEmail[]\">"
			  + "<span id=\"emailDelete" + times + "\">×</span></td></tr>";
			  newTr.children[0].appendChild(document.getElementById("addButton"));
			  table.children[0].insertBefore(newTr, document.getElementById("beforeAdd"));
			  emailTr.children[0].setAttribute("rowspan", times);
			  emailTr.children[2].setAttribute("rowspan", times);
			  document.getElementById("emailDelete" + times).onmousedown = emailReset;
			  email = form.elements["targetEmail[]"];
			}

		// emailリセットボタン
		var emailReset = function(){
			var idNum = this.id.slice(-1);
		  if(times <= 1){
		    email.value = "";
		  }
			email[Number(idNum) - 1].value = "";
		}
		document.getElementById("emailDelete1").onmousedown = emailReset;
	</script>
</body>
</html>