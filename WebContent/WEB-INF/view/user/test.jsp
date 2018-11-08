<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test</title>
<style><%@include file="../../css/single.css" %></style>
<%@include file="../include/font.jsp" %>
</head>
<body>
	<%@include file="../include/header.jsp" %>
	<main>
		<div id="honbun">
        	<div id="test">
        	</div>
        	<input type="button" value="サーバー通信テスト" onclick="ajaxTest();">
    	</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script>
<%@include file="../../js/jquery-3.3.1.min.js" %>
	var text = document.getElementById("test");
	function ajaxTest() {

		  //リクエストJSON
		  var request = {
		    param1 : "param",
		    param2 : 12345
		  };

		  //ajaxでservletにリクエストを送信
		  $.ajax({
		    type    : "GET",          //GET / POST
		    url     : "./TestAjax",  //送信先のServlet URL
		    data    : request,        //リクエストJSON
		    async   : true,           //true:非同期(デフォルト), false:同期
		    success : function(data) {
		      //通信が成功した場合に受け取るメッセージ
		      response1 = data["response1"];
		      response2 = data["response2"];
		      console.log(response1 + response2);
		    },
		    error : function(XMLHttpRequest, textStatus, errorThrown) {
		      alert("リクエスト時になんらかのエラーが発生しました：" + textStatus +":\n" + errorThrown);
		    }
		  });

		}
</script>
</body>
</html>