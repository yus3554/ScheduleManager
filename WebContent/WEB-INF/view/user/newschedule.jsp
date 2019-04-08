<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>NewSchedule</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootswatch/4.0.0/flatly/bootstrap.min.css">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.6.1/css/all.css"
	integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP"
	crossorigin="anonymous">
<style><%@include file="./include/bootstrap-datetimepicker.min.css" %></style>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
	integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
	crossorigin="anonymous"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
	integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
	integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
	crossorigin="anonymous"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"
	type="text/javascript"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/locale/ja.js"
	type="text/javascript"></script>

<style><%@include file="../../css/user.css" %></style>
<script><%@include file="./include/bootstrap-datetimepicker.min.js" %></script>
<%@include file="../include/font.jsp" %>
<script><%@include file="./include/bootstrap-maxlength.js"%></script>
<style><%@include file="./include/bootstrap.fd.css" %></style>
<script><%@include file="./include/bootstrap.fd.js"%></script>

<style>
.custom-file-input:lang(ja) ~ .custom-file-label::after {
  content: "参照";
}

.custom-file {
  overflow: hidden;
}
.custom-file-label {
  white-space: nowrap;
}
</style>
</head>
<body>
	<%@include file="../include/header.jsp" %>
	<%@include file="./include/name.jsp"%>
	<%@include file="./include/logoutpopup.jsp"%>
	<main> <%@include file="./include/nav.jsp"%>
	<div id="honbun">
		<div class="container">
			<div class="row">
				<div class="col-sm-10 col-md-10">
					<h4 class="pb-2 mt-4 mb-2 border-bottom">新規日程要求</h4>
						<input type="button" onclick="AutoInput();" value="デモ用入力ボタン">
					<form id="newschedule" action="./NewScheduleConfirm" method="post" enctype="multipart/form-data"
						class="needs-validation" novalidate>
						<fieldset>
							<div class="form-group">
								<label>イベント名</label> <input type="text" maxlength="50"
									class="form-control" name="eventName" required>
								<div class="invalid-feedback">イベント名の入力は必須です</div>
								<p class="help-block">※50文字まで</p>
							</div>
							<div class="form-group">
								<label>イベント内容</label>
								<textarea wrap="hard" maxlength="1000" rows="10" id="eventContent"
									class="form-control" form="newschedule" name="eventContent"
									required></textarea>
								<div class="invalid-feedback">イベント内容の入力は必須です</div>
								<p class="help-block">※1000文字まで</p>
							</div>

							<div class="form-group">
								<label>候補日程</label>
								<!-- タブボタン部分 -->
								<ul class="nav nav-tabs">
									<li class="nav-item"><a href="#tab1"
										class="nav-link active" data-toggle="tab">時間割</a></li>
									<li class="nav-item"><a href="#tab2" class="nav-link"
										data-toggle="tab">時分</a></li>
								</ul>
								<div class="tab-content">
									<div id="tab1"
										class="tab-pane active border-bottom border-left border-right">
										<div class="container">
											<div class="row">
												<div class="col-sm-6 col-md-6">
													<div id="date1" class="form-control"></div>
												</div>
												<div class="col-sm-6 col-md-6" id="dateDiv1"></div>
											</div>
										</div>
									</div>
									<div id="tab2"
										class="tab-pane border-bottom border-left border-right">
										<div id="date2" class="form-control"></div>
										<button type="button" class="btn btn-outline-secondary" onclick="addDateTime();">追加</button>
										<div id="datetimeDiv"></div>
									</div>
									<input type="hidden" id="dateType" value="1" name="dateType">
							</div>

							<div id="date-feedback" class="invalid-feedback">候補日程の入力は必須です</div>
								<p class="help-block">※カレンダーをクリックして入力してください</p>
							</div>
							<div class="form-group">
									<label>対象者のメールアドレス</label>
									<textarea wrap="hard" rows="5" class="form-control"
										id="targetEmailTextarea" form="newschedule" required></textarea>
									<div class="invalid-feedback">対象者の入力は必須です</div>
									<p class="help-block">
										※アドレスを改行で分けて入力してください<br>キーパーソンには最初に*をつけてください
									</p>
								</div>
								<div class="form-group">
									<label>入力締切日時</label>
									<div class="input-group">
										<input id="eventDeadline" class="form-control"
											name="eventDeadline" required autocomplete="off">
										<div class="input-group-append">
											<span class="input-group-text"> <i
												class="fas fa-calendar-alt"></i>
											</span>
										</div>
										<div class="invalid-feedback">入力締切日時の入力は必須です</div>
									</div>
								</div>
								<div class="form-group">
									<label>リマインダー設定</label>
									<div id="remindDate"></div>
									<button type="button" class="btn btn-outline-secondary"
										id="addButton" onclick="addRemind();">+</button>
										<div id="remindDiv"></div>
									<div class="invalid-feedback">正しい値を入力してください</div>
								</div>
								<div class="form-group">
									<div class="form-check">
										<input class="form-check-input" type="checkbox"
											id="isRemindDeadline" name="isRemindDeadline" value="true">
										<label class="form-check-label" for="isRemindDeadline">
											締め切りを過ぎた際にリマインダーを送る </label>
									</div>
								</div>
								<div class="form-group">
									<label for="file">添付ファイル（複数選択可）</label> <input type="file"
										class="form-control-file" name="files[]" multiple>
									<button type="button" class="btn btn-outline-secondary"
										onclick="addFiles();" id="addFileBefore">+</button>
								</div>
								<div class="form-group">
									<div class="form-check">
										<input class="form-check-input" type="checkbox"
											id="isInputInform" name="isInputInform" value="true">
										<label class="form-check-label" for="isInputInform">
											回答者が現在の回答人数を分かるようにする </label>
									</div>
								</div>
								<button type="submit" class="btn btn-primary">確認</button>
								<button type="reset" class="btn btn-secondary"
									onclick="Reset();">リセット</button>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
	</main>
	<%@include file="../include/footer.jsp" %>
<%@include file="./include/newschedulejs.jsp" %>
<script><%@include file="./include/logoutpopupjs.jsp" %></script>
</body>
</html>