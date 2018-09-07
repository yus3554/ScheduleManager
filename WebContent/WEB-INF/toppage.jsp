<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュール管理</title>
<style><%@include file="./css/top.css" %></style>
<link href="https://fonts.googleapis.com/css?family=Comfortaa|Poiret+One" rel="stylesheet">
</head>
<body>
	<header>
		<h1><a href="../">Schedule Manager</a></h1>
	</header>
		<div id="description">スケジュールを調整・管理できるWebサイトです。</div>
	<main>
	<div id="new">
	<h2>新規登録</h2>

	<!-- 空欄がある状態でsubmitしたら表示 -->
	<p id="blanktext">確認パスワードが異なります。<br>
	再度、入力してください。</p>

	<form id="signup" action="./SignUp" method="post">
		<table>
			<tr><td>名前：</td><td><input type="text" size="32" name="userName"></td></tr>
			<tr><td>メールアドレス：</td><td><input type="email" size="32" name="email"></td></tr>
			<tr><td>パスワード：</td><td><input type="password" size="32" name="password"></td></tr>
			<tr><td>パスワードの確認：</td><td><input type="password" size="32" name="confirmPassword"></td></tr>
		</table>
		<input type="button" value="登録" onclick="isSubmit();"><input type="reset" value="リセット"><input type="button" value="test" onclick="newAutoInput();">
	</form>
	</div>
	<div id="login">

	<h2>ログイン</h2>

	<% if (session.getAttribute("status") != null) { %>
		<p>ログインに失敗しました。<br>
		再度、入力してください。</p>
		<% session.setAttribute("status", null); %>
	<% } %>

	<form name="loginform" action="./LoginCheck" method="post">
		<table>
			<tr><td>メールアドレス：</td><td><input type="email" size="32" name="email"></td></tr>
			<tr><td>パスワード：</td><td><input type="password" size="32" name="password"></td></tr>
		</table>
		<input type="submit" value="ログイン"><input type="reset" value="リセット"><input type="button" value="test" onclick="loginAutoInput();">
	</form>

	</div>

	</main>
    <footer>
      Copyright &#169; Yusuke Ota
    </footer>
	<script type="text/javascript">
		// 最初は非表示
		document.getElementById("blanktext").style.display = "none";

		var form = document.forms.signup;

		// テスト用の自動入力ボタン
		function newAutoInput(){
			form.userName.value = "名無し";
			form.email.value = "nanashi@test.com";
			form.password.value = "aaaa";
			form.confirmPassword.value = "aaaa";
		}
		function loginAutoInput(){
			var form = document.forms.loginform;
			form.email.value = "yus3554@gmail.com";
			form.password.value = "aaaa";
		}

		function isSubmit(){
			if (isPassSame()){
				form.submit();
			}
		}

		function isPassSame(){
			if (form.password.value == form.confirmPassword.value) {
				return true;
			}else {
				blanktext.style.display = "block";
				return false;
			}
		}
	</script>
</body>
</html>