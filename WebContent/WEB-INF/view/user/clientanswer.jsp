<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.ArrayList" %>
     <%@ page import="java.util.Iterator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ targetEmail }さんの入力状況</title>
<style>
	<%@include file="../../css/user.css" %>
	table th{
		padding: 10px;
	}
	table td{
		padding: 10px;
	}
	nav #list{
		background-color: #71DCB5;
	}
	td:empty {
  background: url('data:image/svg+xml,<svg preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><line fill="none" stroke="#000000" stroke-width="0.2" stroke-miterlimit="10" x1="0" y1="0" x2="10" y2="10"/></svg>') no-repeat;
  background-size: 100%;
    }
</style>
<%@include file="../include/font.jsp" %>
</head>
<body>

	<%@include file="../include/header.jsp" %>
	<%@include file="./include/name.jsp" %>
	<%@include file="./include/logoutpopup.jsp" %>
	<main>
	<%@include file="./include/nav.jsp" %>
	<div id="honbun">
	<h2>${ eventName }</h2>
	<h3>
		<% if((request.getAttribute("key").equals("1"))){ %>
		[キーパーソン]
		<% } %>
		${ targetEmail }さんの入力状況
	</h3>


	<h4>
	<% if( request.getAttribute("isInput").equals("0")){ %>未回答<%
		} else {
	%>回答済（最終更新：${ sendDate }）<%
	} %>
	</h4>

	<p><a href="../RequestSchedules/${ id }">スケジュール詳細に戻る</a></p>

	<table border="2">
		<tr>
			<th>日付</th>
			<th>1限</th>
			<th>2限</th>
			<th>3限</th>
			<th>4限</th>
			<th>5限</th>
		</tr>
		<% String[] times = {"first", "second", "third", "fourth", "fifth"}; %>
		<% for(int i = 0; i < (int)request.getAttribute("answersLength"); i++) { %>
		<tr>
			<th><%= request.getAttribute("date" + i) %></th>
			<% for(int j = 0; j < times.length; j++){ %>
			<td align="center" valign="top" ><%
				if( request.getAttribute(times[j] + i).equals("0") ){  %>×<% } %><%
				if(request.getAttribute(times[j] + i).equals("1")) {%>△<% } %><%
				if(request.getAttribute(times[j] + i).equals("2")) { %>○<% } %><%
				if(request.getAttribute(times[j] + i).equals("-1")) { %><% }%></td>
			<% } %>
		</tr>
		<% } %>
	</table>
	<h4>添付ファイル</h4>
	<div id="uploadedFileNameList">
	<% for(Iterator<String> i = ((ArrayList<String>)request.getAttribute("uploadFileNameList")).iterator(); i.hasNext();) { %>
	<% String fileName = i.next(); %>
	<a href="/ScheduleManager/Download/target/${ randomURL }/<%= fileName %>"><%= fileName %></a><br>
	<% } %>
	</div>
	<h4>備考</h4>
	<% String note = (String)request.getAttribute("note"); %>
	<%= note == null ? "" : note %>
	<br>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>
<script>
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>

</script>

</body>
</html>