<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="schedule.model.ScheduleDate" %>
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
  padding: 5px;
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

#settingPopup {
  display:inline-block;
  background-color: #bbeecc;
  padding: 10px;
  border: #6495ed 3px ridge;
  position: absolute;
  z-index: 1;
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
      <p><a href="../RequestSchedules">スケジュール一覧に戻る</a></p>
	<h2>${ eventName }</h2>

	<table>
		<tr><th>イベント名</th><td>${ eventName }</td></tr>
		<% if( request.getAttribute("decideDate") != null) {%>
		<tr>
			<th>決定日時</th>
			<td>
				${ decideDate }
				<% if(((String)request.getAttribute("note")).length() != 0){ %>
					<h4>備考</h4>${ note }
				<% } %>
			</td>
		</tr>
		<% } %>
		<tr>
			<th>
				全体の回答状況<br>（○の数）
				<% if ((int)request.getAttribute("notInput") != 0 ) {%>
				<table>
					<tr>
						<th>未回答</th>
						<td>残り${ notInput }/${ targetLength }人</td>
					</tr>
				</table>
				<% } else { %>
				<br><div style="display:inline-block; padding: 5px; border: #000000 3px double;">${ targetLength }人全員回答済</div>
				<% } %>
			</th>
			<td>
			<input type="button" id="settingButton" value="セル色付け設定" style="float:right;">
			<a href="./DecideSchedule/${ id }">対象者に日時の決定を送信する</a>
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
					<% int[][] sdTimes = (int[][])request.getAttribute("sdTimes"); %>
					<% ArrayList<ArrayList<int[]>> targetsAnswers = (ArrayList<ArrayList<int[]>>)request.getAttribute("targetsAnswers"); %>
					<% for(int i = 0; i < (int)request.getAttribute("countLength"); i++) { %>
					<tr>
						<th><%= request.getAttribute("date" + i)%></th>
						<% for(int j = 0; j < 5; j++) { %>
						<td align="center" valign="top"><% if( sdTimes[i][j] != -1 ){ %><%= counts[i][j] %><% } %></td>
						<% } %>
					</tr>
					<% } %>
				</table>
			</td>
		</tr>
		<% int targetListLength = (int) request.getAttribute("targetListLength"); %>
		<tr>
			<th rowspan="<%= targetListLength %>">
				各対象者の回答状況
			</th>
			<td>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL0") %>">
					<%= request.getAttribute("targetEmail0") %>
				</a>
				<% if( request.getAttribute("key0").equals("1")){ %>
				(キーパーソン)
				<% } %>
				<% if( request.getAttribute("isInput0").equals("0")){ %>
				[未回答]
				<% } else { %>
				[回答済（最終更新：<%= request.getAttribute("sendDate0") %>）]
				<% } %>
			</td>
		</tr>
		<% for (int i = 1; i < targetListLength; i++) { %>
		<tr>
			<td>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL" + i) %>">
					<%= request.getAttribute("targetEmail" + i) %>
				</a>
				<% if( request.getAttribute("key" + i).equals("1")){ %>
				(キーパーソン)
				<% } %>
				<% if( request.getAttribute("isInput" + i).equals("0")){ %>
				[未回答]
				<% } else { %>
				[回答済（最終更新：<%= request.getAttribute("sendDate" + i) %>）]
				<% } %>
			</td>
		</tr>
		<% } %>
		<tr><th>イベント内容</th><td>${ eventContent }</td></tr>
		<tr>
			<th>開催条件</th>
			<td>
			<% if ((boolean)request.getAttribute("isEventCondition")) { %>
				${ eventConditionDenom }分の${ eventConditionNumer }以上
			<% } else { %>
				なし
			<% } %>
			</td>
		</tr>
		<tr><th>入力締切日時</th><td>${ eventDeadline }</td></tr>
	</table>
	<div id="popup">
      <p>
      	<table>
      		<% for(int i = 0; i < targetListLength; i++) { %>
      		<tr>
      			<th><%= request.getAttribute("targetEmail" + i) %></th>
      			<td class="popupTd"></td>
      		</tr>
      		<% } %>
      	</table>
      </p>
    </div>
	<div id="settingPopup">
	  	[セルの色付け]<br>
		<form id="cellColor">
			<input type="radio" name="rank" value="ranking" checked>多い順<br>
			<input type="radio" name="rank" value="over">○の数が<input type="number" min="1" max="<%= targetListLength %>" id="num" value="1" required>以上<br>
			<% if ((boolean)request.getAttribute("isEventCondition")) { %>
			<input type="radio" name="rank" value="condition">開催条件<br>
			<% } %>
			<span style="float:right;"><input type="checkbox" name="key" value="key">キーパーソン有り</span>
			<input type="button" value="適用" onclick="apply()">
			<input type="text" name="dummy" style="display:none;">
		</form>
	</div>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script type="text/javascript">
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>

// 全体表示のテーブル
var table = document.getElementById("table");
// テーブルにマウスかざすと誰がどんな回答しているかわかるポップアップ
var popup = document.getElementById("popup");
// ポップアップ内のテーブルのtd
var popupTd = document.getElementsByClassName("popupTd");
// セルの色を変えるポップアップ
var settingPopup = document.getElementById("settingPopup");
// そのポップアップのボタン
var settingButton = document.getElementById("settingButton");
// そのポップアップの〇〇以上のセルを色付けるやつの〇〇を入れるinput text
var numText = document.getElementById("num");
// そのポップアップのラジオボタンとかテキストのフォーム
var colorForm = document.getElementById("cellColor");
// そのポップアップのラジオボタンのリスト
var radioNodeList = colorForm.rank;

// ポップアップで使うtargetAnswerをjavaから受け取り、javascriptの変数に格納
var targetsAnswers = [];
// targetAnswersは対象者達、サイズは対象者の人数
<% for(int i = 0; i < targetsAnswers.size(); i++ ) { %>
	var target<%= i %> = [];
	// targetAnswerはそれぞれの対象者、サイズは候補日程の日数
	<% ArrayList<int[]> targetAnswer = targetsAnswers.get(i); %>
	<% for(int j = 0; j < targetAnswer.size(); j++) { %>
		var answer<%= i %><%= j %> = [];
		// k < 5は1から5限の5
		<% int[] answer = targetAnswer.get(j); %>
		<% for(int k = 0; k < 5; k++) { %>
			answer<%= i %><%= j %>.push(<%= answer[k] %>);
		<% } %>
		target<%= i %>.push(answer<%= i %><%= j %>);
	<% } %>
	targetsAnswers.push(target<%= i %>);
<% } %>

// 丸の数のjava側のcount配列と最大値、最大値-1をjavascriptの変数に格納
var circleCount = [];
var maxcount = <%= (int)request.getAttribute("max") %>;
var maxcount_1 = <%= (int)request.getAttribute("max_1") %>;
<% for(int i = 0; i < (int)request.getAttribute("countLength"); i++) { %>
	var count<%= i %> = [];
	<% for(int j = 0; j < 5; j++) { %>
		count<%= i %>.push(<%= counts[i][j] %>);
	<% } %>
	circleCount.push(count<%= i %>);
<% } %>

//sdTimesをjsの配列に落とす
var sdTimes = [];
<% for(int i = 0; i < sdTimes.length; i++) { %>
var sdTime<%= i %> = [];
<% for(int j = 0; j < 5; j++) { %>
	sdTime<%= i %>.push(<%= sdTimes[i][j] %>);
<% } %>
sdTimes.push(sdTime<%= i %>);
<% } %>
console.log(sdTimes);


// キーパーソンの回答の○をandする
// 1で全要素初期化し、その上からandしていく
var keyAnswers = [[2, 2, 2, 2, 2]];
for(var i = 1; i < circleCount.length; i++){
	keyAnswers.push([2, 2, 2, 2, 2]);
}
//targetAnswersは対象者達、サイズは対象者の人数
var keyPerson = [];
<% for(int i = 0; i < (int) request.getAttribute("targetListLength"); i++){ %>
	<% if( request.getAttribute("key" + i).equals("1") ) { %>
		keyPerson.push(<%= i %>);
	<% } %>
<% } %>
for(var i = 0; i < keyPerson.length; i++){
	var keyAnswer = targetsAnswers[keyPerson[i]];
	for(var j = 0; j < circleCount.length; j++){
		for(var k = 0; k < 5; k++){
			keyAnswers[j][k] = (keyAnswers[j][k] == 2 && (keyAnswers[j][k] == keyAnswer[j][k])) ? 2 : 0;
		}
	}
}

// ポップアップを最初は表示させない
popup.style.display = "none";
settingPopup.style.visibility = "hidden";

// セルにマウスカーソルを重ねた時
var cellMouseOver = function(){
	<% for(int i = 0; i < targetListLength; i++) { %>
		// 未回答
		<% if( request.getAttribute("isInput" + i).equals("0")){ %>
			popupTd[<%= i %>].innerHTML = "未回答";
		<% } else { %>
			var targetAnswer<%= i %> = targetsAnswers[<%= i %>][this.parentNode.rowIndex - 1][this.cellIndex - 1];
			if ( targetAnswer<%= i %> == 0 ) {
				popupTd[<%= i %>].innerHTML = "×";
			} else if ( targetAnswer<%= i %> == 1 ){
				popupTd[<%= i %>].innerHTML = "△";
			} else {
				popupTd[<%= i %>].innerHTML = "○";
			}
		<% } %>
	<% } %>
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

// セルのいろ変えるポップアップを表示
function colorSetting(){
	var buttonPoint = settingButton.getBoundingClientRect();
	settingPopup.style.top = window.pageYOffset + buttonPoint.top + settingButton.clientHeight + "px";
	settingPopup.style.left = window.pageXOffset + buttonPoint.left + settingButton.clientWidth - settingPopup.offsetWidth + "px";
	settingPopup.style.visibility = "visible";
}

// ページを開いた時、多い順で色をあらかじめつけておく
rankingCellColor();

// セルの色変える
var keyCheck = false;
function apply(){
	$('input:checked').each(function(){
		if( "key" == $(this).val()){
			keyCheck = true;
		}
	});
	var num = numText.value;
	var radioCheck = radioNodeList.value;
	if(radioCheck == "ranking"){
		rankingCellColor();
	} else if (radioCheck == "over") {
		overCellColor(num);
	} else {
		conditionCellColor();
	}
	keyCheck = false;
	settingPopup.style.visibility = "hidden";
}

// セルの色変えるやつの多い順のやつ
function rankingCellColor(){
	var tr = table.children;
	for(var i = 0; i < tr.length; i++){
	  var td = tr[i].children;
	  for(var j = 1; j < td.length; j++){
	    var cell = td[j].children;
	    for(var k = 1; k < cell.length; k++){
	    	if(!keyCheck){
		    	if(maxcount == circleCount[j-1][k-1] && circleCount[j-1][k-1] != 0){
		    		cell[k].style.backgroundColor = "#FE9A2E";
		    	} else if(maxcount_1 == circleCount[j-1][k-1] && circleCount[j-1][k-1] != 0) {
		    		cell[k].style.backgroundColor = "#F4FA58";
		    	} else {
		    		cell[k].style.backgroundColor = "#ffffff";
		    	}
	    	} else {
	    		if(keyAnswers[j-1][k-1] == 2) {
		    		if(maxcount == circleCount[j-1][k-1] && circleCount[j-1][k-1] != 0 ){
			    		cell[k].style.backgroundColor = "#FE9A2E";
			    	} else if(maxcount_1 == circleCount[j-1][k-1] && circleCount[j-1][k-1] != 0) {
			    		cell[k].style.backgroundColor = "#F4FA58";
			    	} else {
			    		cell[k].style.backgroundColor = "#ffffff";
			    	}
	    		} else {
		    		cell[k].style.backgroundColor = "#ffffff";
		    	}
	    	}
	    }
	  }
	}
}
// セルの色変えるやつの〇〇以上のやつ
// ただし0の場合は色をつけない
function overCellColor(num){
	var tr = table.children;
	for(var i = 0; i < tr.length; i++){
	  var td = tr[i].children;
	  for(var j = 1; j < td.length; j++){
	    var cell = td[j].children;
	    for(var k = 1; k < cell.length; k++){
	    	if(!keyCheck){
		    	if(num <= circleCount[j-1][k-1] && circleCount[j-1][k-1] != 0){
		    		cell[k].style.backgroundColor = "#FE9A2E";
		    	} else {
		    		cell[k].style.backgroundColor = "#ffffff";
		    	}
	    	} else {
	    		if(keyAnswers[j-1][k-1] == 2) {
		    		if(num <= circleCount[j-1][k-1] && circleCount[j-1][k-1] != 0){
			    		cell[k].style.backgroundColor = "#FE9A2E";
			    	} else {
			    		cell[k].style.backgroundColor = "#ffffff";
			    	}
	    		} else {
		    		cell[k].style.backgroundColor = "#ffffff";
		    	}
	    	}
	    }
	  }
	}
}

<% if ((boolean)request.getAttribute("isEventCondition")) { %>
//セルの色変えるやつの開催条件のやつ
//ただし0の場合は色をつけない
// 分母
var denom = ${ eventConditionDenom };
// 分子
var numer = ${ eventConditionNumer };
var condition = Number(numer) / Number(denom);
function conditionCellColor(){
	var tr = table.children;
	for(var i = 0; i < tr.length; i++){
	  var td = tr[i].children;
	  for(var j = 1; j < td.length; j++){
	    var cell = td[j].children;
	    for(var k = 1; k < cell.length; k++){
	    	if(condition * Number(${ targetLength }) <= circleCount[j-1][k-1] && circleCount[j-1][k-1] != 0){
	    		cell[k].style.backgroundColor = "#FE9A2E";
	    	} else {
	    		cell[k].style.backgroundColor = "#ffffff";
	    	}
	    }
	  }
	}
}
<% } %>


// 全体表示の表にマウスオーバーでポップアップ出せるようにしたり
// マウスアウトでポップアップしまったり
// tr.lengthは1で、td.lengthは表の縦の数、cell.lengthは5限の5なので、最初のiはforである必要がない
var tr = table.children;
for(var i = 0; i < tr.length; i++){
  var td = tr[i].children;
  for(var j = 1; j < td.length; j++){
    var cell = td[j].children;
    for(var k = 1; k < cell.length; k++){
    	if(sdTimes[j-1][k-1] != -1){
    	      cell[k].onmouseover = cellMouseOver;
    	      cell[k].onmouseout = cellMouseOut;
    	}
    }
  }
}

// 全体のクリックイベントを取得して、settingPopup以外をクリックしたらsettingPopupを隠す
$(document).on('click touchend', function(event) {
	  if (!$(event.target).closest('div#settingPopup').length && !$(event.target).closest("input#settingButton").length) {
		  settingPopup.style.visibility = "hidden";
	  } else if($(event.target).closest('input#settingButton').length){
		  colorSetting();
	  }
});
</script>

</body>
</html>