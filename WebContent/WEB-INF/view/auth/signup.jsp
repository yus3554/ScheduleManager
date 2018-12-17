<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規登録</title>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<style><%@include file="../../css/single.css" %></style>
<%@include file="../include/font.jsp" %>
</head>
<body>
	<%@include file="../include/header.jsp" %>
	<main>
	<div id="honbun">

	<!-- 空欄がある状態でsubmitしたら表示 -->
	<p id="blanktext">確認パスワードが異なります。<br>
	再度、入力してください。</p>

		<div class="mt-3 container">
			<div class="row">
				<div class="col-sm-6 col-md-4">
					<h4 class="pb-2 mt-4 mb-2 border-bottom">新規登録</h4>
					<form id="signup" action="./SignUpConfirm" method="post" class="needs-validation" novalidate>
						<fieldset>
							<div class="form-group">
								<label>名前</label> <input type="text" placeholder="名前"
									class="form-control" name="userName" required>
								<div class="invalid-feedback">名前の入力は必須です</div>
							</div>
							<div class="form-group">
								<label>メールアドレス</label> <input type="email" placeholder="メールアドレス"
									class="form-control" name="email" required>
								<div class="invalid-feedback">メールアドレスが正しく入力されていません</div>
							</div>
							<div class="form-group">
								<label>パスワード</label> <input type="password" placeholder="パスワード"
									class="form-control" id="password-input" name="password" required>
								<div class="invalid-feedback">パスワードの入力は必須です</div>
							</div>
							<div class="form-group">
								<label>確認用パスワード</label> <input type="password"
									placeholder="パスワードの確認" class="form-control"
									id="password-confirmation-input" name="confirmPassword" required>
								<div class="invalid-feedback">確認用パスワードが入力されていないか一致しません</div>
							</div>
							<a class="btn btn-outline-secondary" href="./TopPage" role="button">戻る</a>
							<button type="submit" class="btn btn-primary">確認</button>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	<input type="button" value="test" onclick="newAutoInput();">
	</div>

	</main>
    <%@include file="../include/footer.jsp" %>
	<script type="text/javascript">
		// password-inputの値とpattern属性を連動させる
		$('#password-input').on('input', function(){
	  		$('#password-confirmation-input').prop('pattern', $(this).val())
		});

		// bootstrapのvaridation
		(function() {
			'use strict';
			window.addEventListener('load',
					function() {
						// Fetch all the forms we want to apply custom Bootstrap validation styles to
						var forms = document
								.getElementsByClassName('needs-validation');
						// Loop over them and prevent submission
						var validation = Array.prototype.filter.call(forms,
								function(form) {
									form.addEventListener('submit', function(
											event) {
										if (form.checkValidity() === false) {
											event.preventDefault();
											event.stopPropagation();
										}
										form.classList.add('was-validated');
									}, false);
								});
					}, false);
		})();

		// 最初は非表示
		document.getElementById("blanktext").style.display = "none";

		var form = document.forms.signup;

		// テスト用の自動入力ボタン
		function newAutoInput() {
			form.userName.value = "名無し";
			form.email.value = "nanashi@test.com";
			form.password.value = "aaaa";
			form.confirmPassword.value = "aaaa";
		}
	</script>
</body>
</html>