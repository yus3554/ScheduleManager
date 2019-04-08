<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.ArrayList" %>
     <%@ page import="java.util.Iterator" %>
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
    background: url('data:image/svg+xml;charset=utf8,%3csvg%20preserveAspectRatio%3d%22none%22%20xmlns%3d%22http%3a%2f%2fwww%2ew3%2eorg%2f2000%2fsvg%22%20viewBox%3d%220%200%2010%2010%22%3e%3cline%20fill%3d%22none%22%20stroke%3d%22%23000000%22%20stroke%2dwidth%3d%220%2e2%22%20stroke%2dmiterlimit%3d%2210%22%20x1%3d%2210%22%20y1%3d%220%22%20x2%3d%220%22%20y2%3d%2210%22%2f%3e%3c%2fsvg%3e') no-repeat;
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

	<table border="1">
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
			<form id="form" action="./DecideSchedule/${ id }" method="post">
			<% if ( request.getAttribute("decideDate") != null ) { %>
				<a href="#" onclick="decideSchedule();">決定日時を修正する</a>
			<% } else { %>
				<a href="#" onclick="decideSchedule();">対象者に日時の決定を送信する</a>
			<% } %>
			</form>
				<% int dateType = (int)request.getAttribute("dateType"); %>

				<% if(dateType == 1){ // 時間割%>
					<table id="table" border="2">
						<tr>
							<th>日付</th>
							<th>1限</th>
							<th>2限</th>
							<th>3限</th>
							<th>4限</th>
							<th>5限</th>
						</tr>
						<% int[][] dateCounts = (int[][])session.getAttribute("counts"); %>
						<% int[][] sdTimes = (int[][])session.getAttribute("sdTimes"); %>
						<% for(int i = 0; i < (int)request.getAttribute("countLength"); i++) { %>
						<tr>
							<th><%= request.getAttribute("date" + i)%></th>
							<% for(int j = 0; j < 5; j++) { %>
							<td align="center" valign="top"><% if( sdTimes[i][j] != -1 ){ %><%= dateCounts[i][j] %><% } %></td>
							<% } %>
						</tr>
						<% } %>
					</table>
				<% } else { %>
					<table id="table" border="2">
					<% ArrayList<String> datetime = (ArrayList<String>)request.getAttribute("datetime"); %>
					<% int[] datetimeCounts = (int[])session.getAttribute("counts"); %>
					<% for(int i = 0; i < datetime.size(); i++){ %>
						<tr>
							<th><%= datetime.get(i) %></th>
							<td align="center" valign="top"><%= datetimeCounts[i] %></td>
						</tr>
					<% } %>
					</table>
				<% } %>
			</td>
		</tr>
		<% int targetListLength = (int) request.getAttribute("targetListLength"); %>
		<tr>
			<th rowspan="<%= targetListLength %>">
				各対象者の回答状況<br>(キーパーソンにはチェック)
			</th>
			<td>
				<input type="checkbox" name="key[]" value="0" <% if( request.getAttribute("key0").equals("1")){ %>checked<% } %>>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL0") %>">
					<%= request.getAttribute("targetEmail0") %>
				</a>
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
				<input type="checkbox" name="key[]" value="<%= i %>" <% if( request.getAttribute("key" + i).equals("1")){ %>checked<% } %>>
				<a href="../ClientAnswer/<%= request.getAttribute("randomURL" + i) %>">
					<%= request.getAttribute("targetEmail" + i) %>
				</a>
				<% if( request.getAttribute("isInput" + i).equals("0")){ %>
				[未回答]
				<% } else { %>
				[回答済（最終更新：<%= request.getAttribute("sendDate" + i) %>）]
				<% } %>
			</td>
		</tr>
		<% } %>
		<tr><th>イベント内容</th><td>${ eventContent }</td></tr>
		<tr><th>入力締切日時</th><td>${ eventDeadline }</td></tr>
		<% if ((boolean) request.getAttribute("isRemindDates")) { %>
		<tr>
			<th>リマインダー日時</th>
			<td>
				<% for(Iterator<String> i = ((ArrayList<String>)request.getAttribute("remindDates")).iterator(); i.hasNext();) { %>
				<%= i.next() %><br>
				<% } %>
			</td>
		</tr>
		<% } %>
		<% if ((boolean) request.getAttribute("isRequestFile")) { %>
		<tr>
			<th>添付ファイル</th>
			<td>
				<% for(Iterator<String> i = ((ArrayList<String>)request.getAttribute("requestFileNameList")).iterator(); i.hasNext();) { %>
				<% String fileName = i.next(); %>
				<a href="/ScheduleManager/Download/request/${ id }/${ email }/<%= fileName %>"><%= fileName %></a><br>
				<% } %>
			</td>
		</tr>
		<% } %>
	</table>
	<div id="popup" style="visibility:hidden;">
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
	<div id="settingPopup" style="visibility:hidden;">
	  	[セルの色付け]<br>
		<form id="cellColor">
			<input type="radio" name="rank" value="ranking" checked>多い順<br>
			<input type="radio" name="rank" value="over">○の数が<input type="number" min="1" max="<%= targetListLength %>" id="num" value="1" required>以上<br>
			<span style="float:right;"><input type="checkbox" name="key">キーパーソン有り</span>
			<input type="button" value="更新" onclick="apply()">
			<input type="text" name="dummy" style="display:none;">
		</form>
	</div>
	</div>
	</main>
<%@include file="../include/footer.jsp" %>

<script type="text/javascript">
<%@include file="../../js/jquery-3.3.1.min.js" %>
<%@include file="./include/logoutpopupjs.jsp" %>

	<%--------------------------------- 対象者の回答をjsの変数に格納 ---------------------------------%>

	var targetsAnswers = [];
	<% ArrayList<ArrayList<int[]>> targetsDateAnswers = (ArrayList<ArrayList<int[]>>)request.getAttribute("targetsAnswers"); %>

	// 時間割
	<% if( dateType == 1 ) {%>
		// targetAnswersは対象者達、サイズは対象者の人数

		<% for(int i = 0; i < targetsDateAnswers.size(); i++ ) { %>
			var target<%= i %> = [];
			// targetAnswerはそれぞれの対象者、サイズは候補日程の日数
			<% ArrayList<int[]> targetAnswer = targetsDateAnswers.get(i); %>
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

	// 時分
	<% } else { %>
		<% for(int i = 0; i < targetsDateAnswers.size(); i++ ) { %>

			var target<%= i %> = [];
			// targetAnswerはそれぞれの対象者、サイズは候補日程の日数
			<% ArrayList<int[]> targetAnswer = targetsDateAnswers.get(i); %>
			<% for(int j = 0; j < targetAnswer.size(); j++) { %>
				target<%= i %>.push(<%= targetAnswer.get(j) %>);
			<% } %>
			targetsAnswers.push(target<%= i %>);
		<% } %>
	<% } %>

	<%--------------------------------- 丸の数をとか最大値とかをjsの変数に格納 ---------------------------------%>

	var circleCount = [];
	var maxcount = <%= (int)request.getAttribute("max") %>;
	var maxcount_1 = <%= (int)request.getAttribute("max_1") %>;
	// 時間割
	<% if( dateType == 1 ) {%>
		<% int[][] dateCounts = (int[][])session.getAttribute("counts"); %>
		<% for(int i = 0; i < (int)request.getAttribute("countLength"); i++) { %>
			var count<%= i %> = [];
			<% for(int j = 0; j < 5; j++) { %>
				count<%= i %>.push(<%= dateCounts[i][j] %>);
			<% } %>
			circleCount.push(count<%= i %>);
		<% } %>
	// 時分
	<% } else { %>
		<% int[] dateCounts = (int[])session.getAttribute("counts"); %>
		<% for(int i = 0; i < (int)request.getAttribute("countLength"); i++) { %>
			circleCount.push(<%= dateCounts[i] %>);
		<% } %>
	<% } %>

	<%--------------------------------- 日時が存在しているかをjsの変数に格納 ---------------------------------%>

	<% if( dateType == 1 ) {%>
		<% int[][] sdTimes = (int[][])session.getAttribute("sdTimes"); %>
		var sdTimes = [];
		<% for(int i = 0; i < sdTimes.length; i++) { %>
			var sdTime<%= i %> = [];
			<% for(int j = 0; j < 5; j++) { %>
				sdTime<%= i %>.push(<%= sdTimes[i][j] %>);
			<% } %>
			sdTimes.push(sdTime<%= i %>);
		<% } %>
	<% } %>

	<%--------------------------------- キーパーソンを変数に格納 ---------------------------------%>

	// キーパーソンの回答の○をandする
	// 2で全要素初期化し、その上からandしていく
	<% if( dateType == 1 ) {%>
		var keyAnswers = [[2, 2, 2, 2, 2]];
		function keyAnswersInit(){
			keyAnswers = [[2, 2, 2, 2, 2]];
			for(var i = 1; i < circleCount.length; i++){
				keyAnswers.push([2, 2, 2, 2, 2]);
			}
		}
	<% } else { %>
		var keyAnswers = [2];
		function keyAnswersInit(){
			keyAnswers = [2];
			for(var i = 1; i < circleCount.length; i++){
				keyAnswers.push(2);
			}
		}
	<% } %>
	keyAnswersInit();

	function keyPersonInit(){
		keyPerson = [];
		$('input[name="key[]"]:checked').each(function() {
		    keyPerson.push(parseInt($(this).val()));
		  });
		for(var i = 0; i < keyPerson.length; i++){
			var keyAnswer = targetsAnswers[keyPerson[i]];
			for(var j = 0; j < circleCount.length; j++){
				<% if( dateType == 1 ) {%>
					for(var k = 0; k < 5; k++){
						keyAnswers[j][k] = (keyAnswers[j][k] == 2 && (keyAnswers[j][k] == keyAnswer[j][k])) ? 2 : 0;
					}
				<% } else { %>
					keyAnswers[j] = (keyAnswers[j] == 2 && (keyAnswers[j] == keyAnswer[j])) ? 2 : 0;
				<% } %>
			}
		}
	}
	keyPersonInit();

	$('input[name="key[]"]').change(function() {
		keyAnswersInit();
		keyPersonInit();
	});

	<%--------------------------------- セル色付け設定ボタンを押した時 ---------------------------------%>

	//セルのいろ変えるポップアップを表示
	function colorSetting(){
		$('#settingPopup').offset({
			top: $('#settingButton').offset().top + $('#settingButton').outerHeight(),
			left: $('#settingButton').offset().left + $('#settingButton').outerWidth() - $('#settingPopup').outerWidth()
		});
		$('#settingPopup').css('visibility','visible');
	}

	// 全体のクリックイベントを取得して、settingPopup以外をクリックしたらsettingPopupを隠す
	$(document).on('click touchend', function(event) {
		  if (!$(event.target).closest('div#settingPopup').length && !$(event.target).closest("input#settingButton").length) {
			  $('#settingPopup').css('visibility','hidden');
		  } else if($(event.target).closest('input#settingButton').length){
			  colorSetting();
		  }
	});

	<%--------------------------------- 全体表示の表にマウスオーバーでポップアップ出す時 ---------------------------------%>

	$("#table td").mouseover(function(e){
		var col = $(this).index() - 1;
		var row = $(this).closest('tr').index();

		<% for(int i = 0; i < targetListLength; i++) { %>
			// 未回答
			<% if( request.getAttribute("isInput" + i).equals("0")){ %>
				$(".popupTd").eq(<%= i %>).html("未回答");
			// 回答済
			<% } else { %>
				// 時間割
				<% if( dateType == 1 ) { %>
					var targetAnswer<%= i %> = targetsAnswers[<%= i %>][row - 1][col];
				// 時分
				<% } else { %>
					var targetAnswer<%= i %> = targetsAnswers[<%= i %>][row];
				<% } %>

				if ( targetAnswer<%= i %> == 0 ) {
					$(".popupTd").eq(<%= i %>).html("×");
				} else if ( targetAnswer<%= i %> == 1 ){
					$(".popupTd").eq(<%= i %>).html("△");
				} else {
					$(".popupTd").eq(<%= i %>).html("○");
				}
			<% } %>
		<% } %>

		$('#popup').offset({
			top: $(this).offset().top,
			left: $(this).offset().left + $(this).outerWidth() + 15
		});

		// 日時がないならポップアップを出さない
		if( !(<%= dateType %> == 1 && sdTimes[row-1][col] == -1) ) {
			$("#popup").css('visibility','visible');
		}
	}).mouseout(function(){
		$("#popup").css('visibility','hidden');
	});

	<%--------------------------------- セルの色を変える ---------------------------------%>
	// ページを開いた時、多い順で色をあらかじめつけておく
	rankingCellColor();

	// セルの色変える
	var keyCheck = false;
	function apply(){
		if ($("[name=key]").prop("checked") ){
			keyCheck = true;
		}
		var num = $("#num").val();
		var radioCheck = $('input[name=rank]:checked').val();
		if(radioCheck == "ranking"){
			rankingCellColor();
		} else if (radioCheck == "over") {
			overCellColor(num);
		}
		$('#settingPopup').css('visibility','hidden');
	}

	// セルの色変えるやつの多い順のやつ
	function rankingCellColor(){
		$('#table td').each(function(index , elm){
			// 時間割
			<% if( dateType == 1 ) {%>
				var col = index % 5;
				var row = Math.floor(index / 5);
				if( keyCheck && keyAnswers[row][col] == 0 ){
					$(elm).css('background-color',"#FFFFFF");
				} else {
					if( maxcount == circleCount[row][col] && circleCount[row][col] != 0 ){
						$(elm).css('background-color', "#FE9A2E");
			    	} else if( maxcount_1 == circleCount[row][col] && circleCount[row][col] != 0 ) {
			    		$(elm).css('background-color', "#F4FA58");
			    	} else {
			    		$(elm).css('background-color',"#FFFFFF");
			    	}
				}
			// 時分
			<% } else { %>
				if( keyCheck && keyAnswers[index] == 0 ){
					$(elm).css('background-color',"#FFFFFF");
				} else {
					if( maxcount == circleCount[index] && circleCount[index] != 0 ){
						$(elm).css('background-color', "#FE9A2E");
			    	} else if( maxcount_1 == circleCount[index] && circleCount[index] != 0 ) {
			    		$(elm).css('background-color', "#F4FA58");
			    	} else {
			    		$(elm).css('background-color',"#FFFFFF");
			    	}
				}
			<% } %>
        });
	}

	// セルの色変えるやつの〇〇以上のやつ
	// ただし0の場合は色をつけない
	function overCellColor(num){
		$('#table td').each(function(index , elm){
			// 時間割
			<% if( dateType == 1 ) {%>
				var col = index % 5;
				var row = Math.floor(index / 5);
				if( keyCheck && keyAnswers[row][col] == 0 ){
					$(elm).css('background-color',"#FFFFFF");
				} else {
					if(num <= circleCount[row][col] && circleCount[row][col] != 0){
						$(elm).css('background-color', "#FE9A2E");
					} else {
						$(elm).css('background-color',"#FFFFFF");
					}
				}
			// 時分
			<% } else { %>
				if( keyCheck && keyAnswers[index] == 0 ){
					$(elm).css('background-color',"#FFFFFF");
				} else {
					if(num <= circleCount[index] && circleCount[index] != 0){
						$(elm).css('background-color', "#FE9A2E");
					} else {
						$(elm).css('background-color',"#FFFFFF");
					}
				}
			<% } %>
		});
	}

	<%--------------------------------- 日時決定ページにセルの色を送る用 ---------------------------------%>
	// ここで色のデータをpostでdecidescheduleとかに送る
	function decideSchedule(){
		$('#table td').each(function(index , elm){
			var color = $(elm).css('background-color');
			// 白
			if( color == "rgb(255, 255, 255)"){
				$('#form').append('<input type="hidden" name="color" value="0">');
			// 黄色
			} else if( color == "rgb(244, 250, 88)"){
				$('#form').append('<input type="hidden" name="color" value="1">');
			// オレンジ
			} else {
				$('#form').append('<input type="hidden" name="color" value="2">');
			}
		});
		$("#form").submit();
	}

</script>

</body>
</html>