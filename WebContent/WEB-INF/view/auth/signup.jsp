<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規登録確認</title>
</head>
<body>
	<h1>スケジュール管理</h1>
	<h2>新規登録確認</h2>

	<table>
		<tr><td>名前：</td><td>${ userName }</td></tr>
		<tr><td>メールアドレス：</td><td>${ email }</td></tr>
		<tr><td>パスワード：</td><td>${ pass }</td></tr>
	</table>

	以上で登録してもよろしいですか？


	<p><a href="./TopPage">トップページに戻る</a></p>
</body>
</html>