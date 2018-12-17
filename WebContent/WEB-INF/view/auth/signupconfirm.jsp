<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規登録確認</title>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<style><%@include file="../../css/single.css" %></style>
<%@include file="../include/font.jsp" %>
</head>
<body>
	<%@include file="../include/header.jsp" %>
	<main>
	<div id="honbun">

		<div class="mt-3 container">
			<div class="row">
				<div class="col-sm-7 col-md-4">
					<h4 class="pb-2 mt-4 mb-2 border-bottom">新規登録確認</h4>
					<table class="table border-bottom">
						<tr>
							<th>名前</th>
							<td>${ userName }</td>
						</tr>
						<tr>
							<th>メールアドレス</th>
							<td>${ email }</td>
						</tr>
						<tr>
							<th>パスワード</th>
							<td>******</td>
						</tr>
					</table>
					以上で登録してもよろしいですか？
					<form action="./SignUpSubmit" method="post">
						<button type="button" class="btn btn-outline-secondary" onClick="javascript:history.back();">戻る</button>
						<button type="submit" class="btn btn-primary">登録</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	</main>
    <%@include file="../include/footer.jsp" %>
</body>
</html>