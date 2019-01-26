<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>日程調整システム</title>
<link rel="stylesheet"
	href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.6.1/css/all.css"
	integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<style><%@include file="./css/single.css" %></style>
<%@include file="./view/include/font.jsp" %>
<style>
	#loginFailed{
		background-color: #F6CECE;
		padding: 0.5em 1em;
		margin: 2em 0;
		font-weight: bold;
		border: solid 3px #F78181;
	}
	#loginFailed p{
		margin: 0;
    	padding: 0;
	}
</style>
</head>
<body>
	<%@include file="./view/include/header.jsp" %>
		<div id="description">日程調整を管理できるWebサイトです。</div>
	<main>
	<div id="honbun">

		<div class="mt-3 container">
			<div class="row">
				<div class="col-sm-6 col-md-4">
					<h4 class="pb-2 mt-4 mb-2 border-bottom">ログイン</h4>

					<% if (session.getAttribute("status") != null) { %>
						<div id="loginFailed">
							<p>
								メールアドレスまたはパスワードが正しくありません
							</p>
						</div>
					<% session.setAttribute("status", null); %>
					<% } %>

					<form id="loginform" name="loginform" action="./LoginCheck" method="post">
						<fieldset>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">
										<i class="far fa-envelope"></i>
									</span>
								</div>
								<input type="email" placeholder="メールアドレス" class="form-control"
									name="email">
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">
										<i class="fas fa-key"></i>
									</span>
								</div>
								<input type="password" placeholder="パスワード" class="form-control"
									name="password">
							</div>
							<button type="submit" class="btn btn-primary" onClick="saveAddress();">ログイン</button>
						</fieldset>
					</form>
					<div class="mt-2">
						<small class="text-muted"> <!-- パスワードを忘れた方は<a href="#" onClick="">こちら</a>から<br> -->
							または<a href="./SignUp">アカウントを作成</a>
						</small>
					</div>
				</div>
			</div>
		</div>
		<input type="button" value="test" onclick="loginAutoInput();">
	</div>

	</main>
	<%@include file="./view/include/footer.jsp"%>
	<script type="text/javascript">
		$("#loginform [name=email]").val(localStorage.getItem("loginAddress"));

		// submitボタンが押された時にログインメールアドレスを保存
		function saveAddress(){
			localStorage.setItem("loginAddress", $("#loginform [name=email]").val());
		}

		// テスト用の自動入力ボタン
		function loginAutoInput() {
			var form = document.forms.loginform;
			form.email.value = "yus3554@gmail.com";
			form.password.value = "aaaa";
		}
	</script>
</body>
</html>