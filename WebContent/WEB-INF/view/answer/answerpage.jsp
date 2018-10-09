<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>スケジュール回答</title>
<style><%@include file="../../css/single.css" %></style>
<%@include file="../include/font.jsp" %>
</head>
<body>

	<%@include file="../include/header.jsp" %>
	<main>
	<div id="honbun">
<h2>スケジュール回答</h2>

	<h3>${ senderName }さんからの入力要求</h3>
	セルをクリックするごとに、×→○→△の順で変わります。<br>

	<form action="../AnswerConfirm" method="post" id="answerForm">
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
	<textarea wrap="hard" maxlength="200" rows="10" cols="70" name="note"></textarea>200字まで<br>
	<input type="button" value="確認" onclick="answerSubmit();"/>
	</form>

	</div>
	</main>
    <%@include file="../include/footer.jsp" %>

	<script>
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
	</script>

</body>
</html>