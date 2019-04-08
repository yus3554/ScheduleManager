<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ page import="java.util.ArrayList" %>
     <%@ page import="java.util.Iterator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュール回答</title>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
	integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
	crossorigin="anonymous"></script>
<script src="https://cdn.bootcss.com/garlic.js/1.4.2/garlic.min.js"></script>
<style>
	<%@include file="../../css/single.css" %>
	textarea {
    overflow: auto;
    max-height: 300px;
    max-width: 600px;
    min-width: 350px;
	}
	td:empty {
  background: url('data:image/svg+xml,<svg preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><line fill="none" stroke="#000000" stroke-width="0.2" stroke-miterlimit="10" x1="0" y1="0" x2="10" y2="10"/></svg>') no-repeat;
  background-size: 100%;
    }
    #submitPopup {
  visibility: hidden;
  background-color: #fff;
  color: #000;
  padding: 10px;
  border: #6495ed 3px ridge;
  position: absolute;
  z-index: 2;
   text-align: center;
}
#grayPanel{
	background : #000;
	opacity  : 0.5;
	width : 100%;
	height : 120%;
	position : fixed;
	top : 0;
	left : 0;
	display : none;
	z-index : 1;
}
#notSendAnswer, #notSendNote, #notSendFile{
	display: none;
	color: red;
}
</style>
<%@include file="../include/font.jsp" %>
</head>
<body>

	<%@include file="../include/header.jsp" %>
	<main>
	<div id="honbun">
		<h2>スケジュール回答</h2>

		<h3>${ senderName }さんから${ targetEmail }さんへの入力要求</h3>

		<%
			if (((String) request.getAttribute("isInput")).equals("0")) {
		%>
		<h4>未回答</h4>
		<%
			} else {
		%>
		<h4 style="color: red;">回答済（変更日時：${ sendDate }）</h4>
		<%
			}
		%>

		<hr>
		<table border="1">
			<h3>イベント内容</h3>
			<tr>
				<th>イベント名：</th>
				<td>${ eventName }</td>
			</tr>
			<tr>
				<th>イベント内容：</th>
				<td>${ eventContent }</td>
			</tr>
			<tr>
				<th>回答締め切り：</th>
				<td>${ eventDeadline }</td>
			</tr>
			<%
				if ((boolean) request.getAttribute("isRequestFile")) {
			%>
			<tr>
				<th>添付ファイル</th>
				<td>
					<% for(Iterator<String> i = ((ArrayList<String>)request.getAttribute("requestFileNameList")).iterator(); i.hasNext();) { %>
					<% String fileName = i.next(); %>
					<a href="/ScheduleManager/Download/request/${ id }/${ senderEmail }/<%= fileName %>"><%= fileName %></a><br>
					<% } %>
				</td>
			</tr>
			<% } %>
			<%
				if ((boolean) request.getAttribute("isInputInform")) {
			%>
			<tr>
				<th>回答人数</th>
				<td>${ targetNum }人中/${ inputCount }人</td>
			</tr>
			<% } %>
		</table>
		<hr>
		<h3>回答</h3>
		<div id="notSendAnswer">
			送信ボタンを押すまで回答・修正は反映されません。
		</div>
		クリックするごとに、×→○→△の順で変わります。<br>

		<form action="../AnswerPage/<%=session.getAttribute("randomURL")%>"
			method="post" id="answerForm" enctype="multipart/form-data">
			<% String[] times = { "first", "second", "third", "fourth", "fifth" }; %>
			<% if( (int)session.getAttribute("dateType") == 1) { %>
			<table id="table" border="2" cellpadding="10">
				<tr>
					<th>日付</th>
					<th>1限</th>
					<th>2限</th>
					<th>3限</th>
					<th>4限</th>
					<th>5限</th>
				</tr>
				<%
					for (int i = 0; i < (int) session.getAttribute("answersLength"); i++) {
				%>
				<tr>
					<th><%=request.getAttribute("date" + i)%> <input type="hidden"
						name="date[]" value="<%=request.getAttribute("date" + i)%>"></th>
					<%
						for (int j = 0; j < times.length; j++) {
					%>
					<td align="center" valign="top" id="<%=times[j]%>Td<%=i%>"><%
							if (request.getAttribute(times[j] + i).equals("0")) {
						%>×<%
							} else if (request.getAttribute(times[j] + i).equals("1")) {
						%>△<%
							} else if (request.getAttribute(times[j] + i).equals("2")) {
						%>○<%
							} else if (request.getAttribute(times[j] + i).equals("-1")) {
						%><%
							}
						%></td>
					<input type="hidden" name="<%=times[j]%>[]" value="">
					<%
						}
					%>
				</tr>
				<%
					}
				%>
			</table>
			<% } else { %>
				<table id="table" border="2" cellpadding="10">
				<% for (int i = 0; i < (int) session.getAttribute("answersLength"); i++) { %>
				<tr>
					<th><%=request.getAttribute("date" + i)%> <input type="hidden"
						name="date[]" value="<%=request.getAttribute("date" + i)%>"></th>
					<td align="center" valign="top" id="answerTd<%=i%>"><%
							if (request.getAttribute("answer" + i).equals("0")) {
						%>×<%
							} else if (request.getAttribute("answer" + i).equals("1")) {
						%>△<%
							} else if (request.getAttribute("answer" + i).equals("2")) {
						%>○<%
							} else if (request.getAttribute("answer" + i).equals("-1")) {
						%><%
							}
						%></td>
					<input type="hidden" name="answer[]" value="">
				</tr>
				<% } %>
				</table>
			<% } %>
			<h4>添付ファイル</h4>
			<div id="notSendFile">
				送信ボタンを押すまで回答・修正は反映されません。
			</div>
			<div id="uploadedFileNameList">
				<%
					for (Iterator<String> i = ((ArrayList<String>) request.getAttribute("uploadFileNameList")).iterator(); i
							.hasNext();) {
				%>
				<%
					String fileName = i.next();
				%>
				<a href="/ScheduleManager/Download/target/${ randomURL }/<%= fileName %>"><%=fileName%></a>
				<input type="button" id="<%= fileName %>" value="削除"
					onclick="deleteFile('/ScheduleManager/AnswerUpdateFileDelete', {'fileName':this.id, 'randomURL':'${ randomURL }'});"><br>
				<%
					}
				%>
			</div>
			<br> <input type="file" name="files" id="files" multiple><br>
			<h4>備考</h4>
			<div id="notSendNote">
				送信ボタンを押すまで回答・修正は反映されません。
			</div>
			<textarea wrap="hard" maxlength="200" rows="3" cols="60" name="note"
				id="note">${ note }</textarea>
			200字まで<br>

			何度でも回答の修正が可能です<br>
			<div id="saveText" style="display:none;"></div>
			<%
				if (request.getAttribute("isInput").equals("0")) {
			%>
			<input type="button" id="submitButton" value="回答内容を送信"
				onclick="answerSubmit();">
				<input type="button" id="saveButton" value="一時保存"
				onclick="save();">
			<%
				} else {
			%>
			<input type="button" id="submitButton" value="修正内容を送信"
				onclick="answerSubmit();" />
			<%
				}
			%>
			<%
				if (((String) request.getAttribute("isInput")).equals("0")) {
			%>
			未回答
			<%
				} else {
			%>
			<font color="red">回答済（変更日時：${ sendDate }）</font>
			<%
				}
			%>
		</form>

	</div>
	</main>
	<%@include file="../include/footer.jsp"%>

	<script><%@include file="../../js/jquery-3.3.1.min.js"%></script>
	<script>
		// 備考が変更された時に反映されません的な
		$('#note').change(function() {
			$("#notSendNote").show();
		});
		// 添付ファイルが変更された時に反映されません的な
		$(function() {
			$('#files').on("change", function() {
				var file = this.files[0];
				if (file != null) {
					$("#notSendFile").show();
				}
			});
		});

		$('#table td').on('click', function() {
			$("#notSendAnswer").show();
			if($(this).html() == "×"){
				$(this).html("○");
			} else if($(this).html() == "△"){
				$(this).html("×");
			} else if($(this).html() == "○"){
				$(this).html("△");
			}
		});

		// 一時保存 Ajaxを用いてサーバーに送る予定
		function save(){
			$("#saveText").show();
			$("#saveText").html("保存中");
			var answer = initAnswer();

			//リクエストJSON
			var request = {};

			request["answers"] = { rowSize : answer.length };

			console.log(request);

			  //ajaxでservletにリクエストを送信
			  $.ajax({
			    type    : "GET",          //GET / POST
			    url     : "/ScheduleManager/AjaxTest",  //送信先のServlet URL
			    data    : JSON.stringify(request),        //リクエストJSON
			    async   : true,           //true:非同期(デフォルト), false:同期
			    success : function(data) {
			      //通信が成功した場合に受け取るメッセージ
			      responseMsg = data["responseMsg"];

			      $("#saveText").html("保存完了しました");
			    },
			    error : function(XMLHttpRequest, textStatus, errorThrown) {
			      alert("リクエスト時になんらかのエラーが発生しました：" + textStatus +":\n" + errorThrown);
			      $("#saveText").html("保存失敗しました");
			    }
			  });
		}

		function initAnswer(){
			var answers = [];
			<% for(int i = 0; i < (int)session.getAttribute("answersLength"); i++) { %>
				<% if((int)session.getAttribute("dateType") == 1) { %>
					var answer = [];
					<% for(int j = 0; j < times.length; j++){ %>
						var <%= times[j] %>tdText = $("#<%= times[j] %>Td<%= i %>").html();
						if( <%= times[j] %>tdText.trim() == "×"){
							answer.push(0);
						} else if( <%= times[j] %>tdText.trim() == "△" ){
							answer.push(1);
						} else if( <%= times[j] %>tdText.trim() == "○" ){
							answer.push(2);
						} else {
							answer.push(-1);
						}
					<% } %>
					answers.push(answer);
				<% } else { %>
					var answerTdText = $("#answerTd<%= i %>").html();
					if( answerTdText.trim() == "×"){
						answers.push(0);
					} else if( answerTdText.trim() == "△" ){
						answers.push(1);
					} else if( answerTdText.trim() == "○" ){
						answers.push(2);
					} else {
						answers.push(-1);
					}
				<% } %>
			<% } %>
			return answers;
		}

		function answerSubmit(){
			var form = document.getElementById("answerForm");
			var answers = initAnswer();

			var times = ["first", "second", "third", "fourth", "fifth"];

			for(var i = 0; i < answers.length; i++){
				if (answers[i].length == null){
					$('input[name="answer[]"]').eq(i).val(answers[i]);
				} else {
					for(var j = 0; j < answers[i].length; j++){
						$('input[name="' + times[j] + '[]"]').eq(i).val(answers[i][j]);
					}
				}
			}
			form.submit();
		}

		// ファイル削除
		function deleteFile(action, data) {
			// フォームの生成
			var form = document.createElement("form");
			form.setAttribute("action", action);
			form.setAttribute("method", "post");
			form.style.display = "none";
			document.body.appendChild(form);
			// パラメタの設定
			if (data !== undefined) {
				for (var paramName in data) {
					var input = document.createElement('input');
					input.setAttribute('type', 'hidden');
					input.setAttribute('name', paramName);
					input.setAttribute('value', data[paramName]);
					form.appendChild(input);
				}
			}
			// submit
			form.submit();
		}

	</script>

</body>
</html>