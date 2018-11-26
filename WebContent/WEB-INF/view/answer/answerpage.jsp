<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュール回答</title>
<style>
	<%@include file="../../css/double.css" %>
	textarea {
    overflow: auto;
    max-height: 300px;
    max-width: 600px;
    min-width: 350px;
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

	<% if(((String)request.getAttribute("isInput")).equals("0")) { %>
	<h4>未回答</h4>
	<% } else { %>
	<h4>回答済（変更日時：${ sendDate }）</h4>
	<% } %>
	セルをクリックするごとに、×→○→△の順で変わります。<br>

	<form action="../AnswerPage/<%= session.getAttribute("randomURL") %>" method="post" id="answerForm">
	<table id="table" border="2" cellpadding="10">
		<tr>
			<th>日付</th>
			<th>1限</th>
			<th>2限</th>
			<th>3限</th>
			<th>4限</th>
			<th>5限</th>
		</tr>
		<% String[] times = {"first", "second", "third", "fourth", "fifth"}; %>
		<% for(int i = 0; i < (int)session.getAttribute("answersLength"); i++) { %>
		<tr>
			<th>
				<%= request.getAttribute("date" + i) %>
				<input type="hidden" name="date<%= i %>" value="<%= request.getAttribute("date" + i) %>">
			</th>
			<% for(int j = 0; j < times.length; j++) { %>
			<td align="center" valign="top" id="<%= times[j] %>Td<%= i %>"><%
			if( request.getAttribute(times[j] + i).equals("0") ){ %>×<%
			} else if( request.getAttribute(times[j] + i).equals("1") ){ %>△<%
			} else if( request.getAttribute(times[j] + i).equals("2") ){ %>○<% } %></td>
			<input type="hidden" name="<%= times[j] + i %>" value="">
			<% } %>
		</tr>
		<% } %>
	</table>
	<br>[備考]<br>
	<textarea wrap="hard" maxlength="200" rows="3" cols="60" name="note">${ note }</textarea>200字まで<br>
	<div id="saveload"></div><br>
	<% if(request.getAttribute("isInput").equals("0")) { %>
	<input type="button" value="送信" onclick="answerSubmit();"/>
	<% } else { %>
	<input type="button" value="修正" onclick="answerSubmit();"/>
	<% } %>
	<input type="button" value="一時保存" onclick="save();"/>
	<input type="button" value="一時保存反映" onclick="load();"/>
	</form>

	</div>
	<div id="honbun2">
	<table>
		<h3>イベント内容</h3>
		<tr><th>イベント名：</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容：</th><td>${ eventContent }</td></tr>
		<% if((boolean)request.getAttribute("isInputInform")) { %>
		<tr><th>回答人数</th><td>${ targetNum }人中/${ inputCount }人</td></tr>
		<% } %>
	</table>
	</div>
	</main>
    <%@include file="../include/footer.jsp" %>

	<script><%@include file="../../js/jquery-3.3.1.min.js"%></script>
	<script>
		$("#saveload").hide();
		var table = document.getElementById("table");
		var cellclick = function(){
			if(this.innerHTML == "×"){
				this.innerHTML = "○";
			} else if(this.innerHTML == "△"){
				this.innerHTML = "×";
			} else if(this.innerHTML == "○"){
				this.innerHTML = "△";
			}
		}

		var tr = table.children;
		for(var i = 0; i < tr.length; i++){
			var td = tr[i].children;
			for(var j = 0; j < td.length; j++){
				var cell = td[j].children;
				for(var k = 0; k < cell.length; k++){
					cell[k].onclick = cellclick;
				}
			}
		}

		function answerSubmit(){
			var form = document.getElementById("answerForm");
			<% for(int i = 0; i < (int)session.getAttribute("answersLength"); i++) { %>
			<% for(int j = 0; j < times.length; j++){ %>
				var <%= times[j] %>tdText = document.getElementById("<%= times[j] %>Td<%= i %>").innerHTML;
				if( <%= times[j] %>tdText == "×"){
					document.getElementsByName("<%= times[j] + i %>")[0].value = "0";
				} else if( <%= times[j] %>tdText == "△" ){
					document.getElementsByName("<%= times[j] + i %>")[0].value = "1";
				} else {
					document.getElementsByName("<%= times[j] + i %>")[0].value = "2";
				}
			<% } %>
			<% } %>
			form.submit();
		}

		// 一時保存
		function save(){
			<% for(int i = 0; i < (int)session.getAttribute("answersLength"); i++) { %>
			<% for(int j = 0; j < times.length; j++){ %>
				var <%= times[j] %>tdText = document.getElementById("<%= times[j] %>Td<%= i %>").innerHTML;
				localStorage.setItem("<%= times[j] + i %>", <%= times[j] %>tdText);
			<% } %>
			<% } %>
			$("#saveload").html("一時保存しました。");
			$("#saveload").show();
		}

		// 一時保存の反映
		function load(){
			<% for(int i = 0; i < (int)session.getAttribute("answersLength"); i++) { %>
			<% for(int j = 0; j < times.length; j++){ %>
				document.getElementById("<%= times[j] %>Td<%= i %>").innerHTML = localStorage.getItem("<%= times[j] + i %>");
			<% } %>
			<% } %>
			$("#saveload").html("一時保存を反映しました。");
			$("#saveload").show();
		}
	</script>

</body>
</html>