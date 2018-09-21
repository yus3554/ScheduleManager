<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ eventName }</title>
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
	#popup {
 	position: absolute;
  padding: 10px;
  background-color: #ffadad;
  border: 2px solid #ca8888;
  z-index:1;
}

#popup::before{
	content: '';
  position: absolute;
  display: block;
  width: 0;
  height: 0;
  left: -15px;
  top: 10px;
  border-right: 15px solid #ca8888;
  border-top: 15px solid transparent;
  border-bottom: 15px solid transparent;
}

#popup::after{
  content: '';
  position: absolute;
  display: block;
  width: 0;
  height: 0;
  left: -12px;
  top: 10px;
  border-right: 15px solid #ffadad;
  border-top: 15px solid transparent;
  border-bottom: 15px solid transparent;
}

#popup p {
	margin: 0;
	padding: 0;
}
</style>
<%@include file="../include/font.jsp" %>
</head>
<body>
	<%@include file="../include/header.jsp" %>
	<%@include file="./include/name.jsp" %>
	<main>
	<%@include file="./include/nav.jsp" %>
	<div id="honbun">
      <p><a href="../RequestSchedules">スケジュール一覧に戻る</a></p>
	<h2>${ eventName }</h2>

	<table>
		<tr><th>イベント名：</th><td>${ eventName }</td></tr>
		<tr><th>イベント内容：</th><td>${ eventContent }</td></tr>
		<tr><th>候補日程：</th><td>${ eventStartDate } 〜 ${ eventEndDate }</td></tr>
		<tr><th>入力締切日：</th><td>${ eventDeadlineDate }</td></tr>
		<tr>
			<th>全体の回答状況：<br>（○の数）</th>
			<td>
			<a href="./">対象者に日時の決定を送信する</a>
				<table id="table" border="2">
					<tr>
						<th>日付</th>
						<th>1限</th>
						<th>2限</th>
						<th>3限</th>
						<th>4限</th>
						<th>5限</th>
					</tr>
					<% int[][] counts = (int[][])request.getAttribute("counts"); %>
					<% for(int i = 0; i < (int)request.getAttribute("countLength"); i++) { %>
					<tr>
						<th><%= request.getAttribute("date" + i)%></th>
						<% for(int j = 0; j < 5; j++) { %>
						<% if((int)request.getAttribute("max") == counts[i][j] && counts[i][j] != 0) { %>
						<td bgcolor="#FE9A2E" align="center" valign="top">
						<% } else if ((int)request.getAttribute("max_1") == counts[i][j] && counts[i][j] != 0){ %>
						<td bgcolor="#F4FA58" align="center" valign="top">
						<% } else { %>
						<td align="center" valign="top">
						<% } %>
						<%= counts[i][j] %></td>
						<% } %>
					</tr>
					<% } %>
				</table>
			</td>
		</tr>
		<% int targetListLength = (int) request.getAttribute("targetListLength"); %>
		<tr>
			<th rowspan="<%= targetListLength %>">
				各対象者の回答状況：
			</th>
			<td>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL0") %>">
					<%= request.getAttribute("targetEmail0") %>
				</a>
				<% if( request.getAttribute("isInput0").equals("0")){ %>
				[未回答]
				<% } else { %>
				[回答済]
				<% } %>
			</td>
		</tr>
		<% for (int i = 1; i < targetListLength; i++) { %>
		<tr>
			<td>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL" + i) %>">
					<%= request.getAttribute("targetEmail" + i) %>
				</a>
				<% if( request.getAttribute("isInput" + i).equals("0")){ %>
				[未回答]
				<% } else { %>
				[回答済]
				<% } %>
			</td>
		</tr>
		<% } %>
	</table>
	<div id="popup">
      <p></p>
    </div>

	</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script type="text/javascript">
var table = document.getElementById("table");
var popup = document.getElementById("popup");

// ポップアップを最初は表示させない
popup.style.display = "none";

var text = "このセルのinnerHTMLは<br>";
var text2 = "<br>です。";

// セルにマウスカーソルを重ねた時
var cellMouseOver = function(){
  // p内のテキストだけに干渉したい
  (popup.children)[0].innerHTML = text + this.innerHTML + text2;
  // セルの座標と幅を取得
  var coordinates = this.getBoundingClientRect();
  var width = this.clientWidth;
  // 座標と現在のスクロール量と幅を使ってポップアップの位置を指定
  // 15はcssの吹き出しの三角のleft-15pxから
  popup.style.left = window.pageXOffset + coordinates.left + width + 15 + "px";
  popup.style.top = window.pageYOffset + coordinates.top  + "px";
  popup.style.display = "inline-block";
}

// セルからマウスカーソルを離した時
var cellMouseOut = function(){
  popup.style.display = "none";
}

var tr = table.children;
for(var i = 0; i < tr.length; i++){
  var td = tr[i].children;
  for(var j = 1; j < td.length; j++){
    var cell = td[j].children;
    for(var k = 1; k < cell.length; k++){
      cell[k].onmouseover = cellMouseOver;
      cell[k].onmouseout = cellMouseOut;
    }
  }
}

</script>

</body>
</html>