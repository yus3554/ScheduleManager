<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ログイン</title>
</head>
<body>
	<h1>スケジュール管理</h1>
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
		<input type="submit" value="ログイン"><input type="reset" value="リセット"><input type="button" value="test" onclick="AutoInput();">
	</form>

	<p><a href="./TopPage">トップページに戻る</a></p>

	<script type="text/javascript">
		function AutoInput(){
			var form = document.forms.loginform;
			form.email.value = "yus3554@gmail.com";
			form.password.value = "aaaa";
		}
	</script>
</body>
</html>