<%@ page pageEncoding="UTF-8" %>
<script>
	// 最初は非表示
		document.getElementById("blanktext").style.display = "none";
		document.getElementById("overEventName").style.display = "none";
		document.getElementById("overEventContent").style.display = "none";
		document.getElementById("remindRemarks").style.display = "none";

		var remindIndex = 1;
		var fileIndex = 1;
		var form = document.forms.newschedule;
		var table = document.getElementById("table");
		var remindDate = form.elements["remindDate[]"];
		var remindTime = form.elements["remindTime[]"];
		var remindTr = document.getElementById("reminder");
		var fileTr = document.getElementById("file");


		// とりあえず
		// 今から2日後を締め切り
		var deadline = new Date(Date.now() + 2 * 24 * 60 * 60000);
		var sampleDate = new Date(Date.now() + 4 * 24 * 60 * 60000);

		function addZero(n){
			if(n < 10){
				return "0" + n;
			} else {
				return n;
			}
		}

		// テスト用の自動入力ボタン
		function AutoInput(){
			form.eventName.value = "会議の開催日程について";
			var sampleContent = "会議をします。";
			form.eventContent.value = sampleContent + "\n\n"
									+ sampleContent.repeat(5) + "\n"
									+ sampleContent.repeat(3) + "\n"
									+ sampleContent.repeat(2) + "\n"
									+ sampleContent.repeat(1) + "\n\n"
									+ sampleContent.repeat(3) + "\n"
									+ sampleContent.repeat(2) + "\n"
									+ sampleContent.repeat(1);
			$("#targetEmailTextarea").val("s152017@eecs.tottori-u.ac.jp");
			addDate("" + sampleDate.getFullYear() + "/" + addZero(sampleDate.getMonth() + 1) + "/" + addZero(sampleDate.getDate()));
			form.eventDeadline.value = "" + deadline.getFullYear() + "/" + addZero(deadline.getMonth() + 1) + "/" + addZero(deadline.getDate())
										+ " " + "00:00";
		}

		function AutoInputFuyukai(){
			var emailStr = "s152017@eecs.tottori-u.ac.jp\n"
							+ "s152119@eecs.tottori-u.ac.jp\n"
							+ "s132029@ike.tottori-u.ac.jp\n"
							+ "s112052@ike.tottori-u.ac.jp\n"
							+ "takahashi@tottori-u.ac.jp\n";
			$("#targetEmailTextarea").val(emailStr);
		}

		function isSubmit(){
			if(isBlank() && isOverEventName() && isOverEventContent() && isOverRemind()){
				textAreaEmail();
				form.submit();
			}
		}

		// テキストエリアのメアドを格納、改行で分けてる、*が最初についたメアドをキーパーソンに
		function textAreaEmail(){
			var targetEmailTextarea = ($("#targetEmailTextarea").val()).split("\n");
				for(var i in targetEmailTextarea){
					if(targetEmailTextarea[i].slice(0, 1) == "*"){
						$("<input>", {
							type: 'hidden',
							name: 'key[]',
							value: i
						}).appendTo('#newschedule');
						$("<input>", {
							type: 'hidden',
							name: 'targetEmail[]',
							value: targetEmailTextarea[i].slice(1)
						}).appendTo('#newschedule');
					} else {
						$("<input>", {
							type: 'hidden',
							name: 'targetEmail[]',
							value: targetEmailTextarea[i]
						}).appendTo('#newschedule');
					}
				}
		}

		// 空欄があるかどうか、なくなったらsubmit
		function isBlank(){
			var blanktext = document.getElementById("blanktext");
			if (form.eventName.value == "" ||
				form.eventContent.value == "" ||
				$("#dateDiv").html() == "" ||
				form.eventDeadline.value == "") {
				if(emailIndex <= 1){
					if(email.value == ""){
						blanktext.style.display = "block";
						return false;
					}
				} else {
					if(email[0].value == ""){
						blanktext.style.display = "block";
						return false;
					}
				}
			} else {
				return true;
			}
		}

		// 文字数制限
		function isOverEventName(){
			if(form.eventName.value.length > 50){
				overEventName.style.display = "block";
				return false;
			}else{
				return true;
			}
		}
		function isOverEventContent(){
			if(form.eventContent.value.length > 1000){
				overEventContent.style.display = "block";
				return false;
			}else{
				return true;
			}
		}

		// リマインダーの範囲が正しいかどうか
		function isOverRemind(){
			remindDate = form.elements["remindDate[]"];
			remindTime = form.elements["remindTime[]"];
			if(remindIndex <= 1){
				if(remindDate.value < 0 || remindDate.value > 30 || remindTime.value < 0 || remindTime.value > 23){
					remindRemarks.style.display = "block";
					return false;
				} else {
					return true;
				}
			}else{
				for(var i = 0; i < remindIndex; i++){
					if(remindDate[i].value < 0 || remindDate[i].value > 30 || remindTime[i].value < 0 || remindTime[i].value > 23){
						remindRemarks.style.display = "block";
						return false;
					}
				}
				return true;
			}
		}

		function addRemind(){
			  remindIndex++;
			  var newTr = document.createElement("tr");
			  newTr.innerHTML = "<tr><td> "
			  + "締め切りの <input type=\"number\" min=\"0\" max=\"30\" name=\"remindDate[]\">日前の "
			  + "<input type=\"number\" min=\"0\" max=\"23\" name=\"remindTime[]\">時に再通知 </td></tr>";
			  table.children[0].insertBefore(newTr, document.getElementById("beforeAdd2"));
			  remindTr.children[0].setAttribute("rowspan", remindIndex);
			  remindTr.children[2].setAttribute("rowspan", remindIndex);
			  remindDate = form.elements["remindDate[]"];
			  remindTime = form.elements["remindTime[]"];
		}

		function addFile(){
			  fileIndex++;
			  var newTr = document.createElement("tr");
			  newTr.innerHTML = "<tr><td> "
			  + "<input type=\"file\" name=\"files\" multiple> " + "</td></tr>";
			  table.children[0].append(newTr);
			  fileTr.children[0].setAttribute("rowspan", fileIndex);
			  fileTr.children[2].setAttribute("rowspan", fileIndex);
		}

		// 開催条件のチェックを入れると数字を入れられるようになる
		function condition(isCheck){
			if (isCheck == true){
				form.eventConditionNumer.disabled = false;
				form.eventConditionDenom.disabled = false;
				form.eventConditionNumer.value = 1;
				form.eventConditionDenom.value = 1;
			} else {
				form.eventConditionNumer.disabled = true;
				form.eventConditionDenom.disabled = true;
			}
		}
		condition(form.isEventCondition.checked);

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
		  var dateId = date.replace(/\//g, "-");
		  var dateName = "@" + date;
		  var html = "<div id=\"" + dateId + "\"><input type=\"hidden\" name=\"date[]\" value=\"" + dateId + "\">" + date;
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