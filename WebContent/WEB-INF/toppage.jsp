<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュール管理</title>
<style><%@include file="./css/single.css" %></style>
<%@include file="./view/include/font.jsp" %>
</head>
<body>
	<%@include file="./view/include/header.jsp" %>
		<div id="description">スケジュールを調整・管理できるWebサイトです。</div>
	<main>
	<div id="honbun">

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

	<p id="signup"><a href="./SignUp">新規登録はこちら</a></p>

	</div>

	</main>
    <%@include file="./view/include/footer.jsp" %>
	<script type="text/javascript">
		// 最初は非表示
		document.getElementById("blanktext").style.display = "none";

		// テスト用の自動入力ボタン
		function loginAutoInput(){
			var form = document.forms.loginform;
			form.email.value = "yus3554@gmail.com";
			form.password.value = "aaaa";
		}

	</script>
</body>
</html>