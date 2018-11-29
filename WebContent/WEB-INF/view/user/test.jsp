<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test</title>
<style><%@include file="../../css/single.css" %></style>
<%@include file="../include/font.jsp" %>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="https://code.jquery.com/ui/1.12.0/jquery-ui.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery-datetimepicker@2.5.20/build/jquery.datetimepicker.full.min.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jquery-datetimepicker@2.5.20/jquery.datetimepicker.css">
</head>
<body>
	<%@include file="../include/header.jsp" %>
	<main>
		<div id="honbun">
        	<div id="test">
        	</div>
			<input type="button" value="サーバー通信テスト" onclick="ajaxTest();">
			<form>
				<input type="" id="date"><br>
				<div id="dateDiv"></div>
			</form>
		</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script>
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
		      $("#test").html(response1 + response2);
		    },
		    error : function(XMLHttpRequest, textStatus, errorThrown) {
		      alert("リクエスト時になんらかのエラーが発生しました：" + textStatus +":\n" + errorThrown);
		    }
		  });

		}

	$(function(){
		  $('#date').datetimepicker({
		    format:"Y/m/d",
		    inline:true,
		    timepicker:false,
		    onChangeDateTime:function(dp,$input){
		      addDate($input.val());
		    }
		  })
		});

		function addDate(date){
		  var dateDivHtml = $("#dateDiv").html();
		  var dateId = date.replace(/\//g, "");
		  var dateName = "@" + date;
		  var html = "<div id=\"" + dateId + "\" name=\"" + dateName + "\">" + date;
		  for(var i = 1; i <= 5; i++){
		    html += " <input type=\"checkbox\" value=\"" + i + "\" name=\"" + "#" + dateId + "[]" + "\" checked>" + i + "限 ";
		  }
		  html += "<input type=\"button\" value=\"削除\" onclick=\'deleteDiv(\"" + dateId + "\");\'>";
		  $("#dateDiv").html(dateDivHtml + html +"</div>");
		}

		function deleteDiv(str){
		  $("#" + str).remove();
		}
</script>
</body>
</html>