<%@ page pageEncoding="UTF-8" %>
	// 最初は非表示
		document.getElementById("blanktext").style.display = "none";
		document.getElementById("overEventName").style.display = "none";
		document.getElementById("overEventContent").style.display = "none";

		var times = 1;
		var form = document.forms.newschedule;
		var table = document.getElementById("table");
		var email = form.elements["targetEmail[]"];
		var emailTr = document.getElementById("email");

		// とりあえず
		// 今から2日後を締め切り
		var deadline = new Date(Date.now() + 2 * 24 * 60 * 60000);
		var start = new Date(Date.now() + 4 * 24 * 60 * 60000);
		var end = new Date(Date.now() + 9 * 24 * 60 * 60000);

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
			form.eventContent.value = "会議をします。";
			if(times <= 1){
				email.value = "s152017@eecs.tottori-u.ac.jp";
			} else {
				email[0].value = "s152017@eecs.tottori-u.ac.jp";
			}
			form.eventStartDate.value = "" + start.getFullYear() + "-" + addZero(start.getMonth() + 1) + "-" + addZero(start.getDate());
			form.eventEndDate.value = "" + end.getFullYear() + "-" + addZero(end.getMonth() + 1) + "-" + addZero(end.getDate());
			form.eventDeadlineDate.value = "" + deadline.getFullYear() + "-" + addZero(deadline.getMonth() + 1) + "-" + addZero(deadline.getDate());
		}

		function AutoInputFuyukai(){
			for(var i = 0; i < 4; i++){
				addEmail();
			}

			email[0].value = "s152017@eecs.tottori-u.ac.jp"; // 太田
			email[1].value = "s152119@eecs.tottori-u.ac.jp"; // 山田
			email[2].value = "s132029@ike.tottori-u.ac.jp"; // 酒井
			email[3].value = "s112052@ike.tottori-u.ac.jp"; // 松永
			email[4].value = "takahashi@tottori-u.ac.jp"; // 高橋
		}

		function isSubmit(){
			if(isBlank() && isOverEventName() && isOverEventContent()){
				form.submit();
			}
		}

		// 空欄があるかどうか、なくなったらsubmit
		function isBlank(){
			var blanktext = document.getElementById("blanktext");
			if (form.eventName.value == "" ||
				form.eventContent.value == "" ||
				form.eventStartDate.value == "" ||
				form.eventEndDate.value == "" ||
				form.eventDeadlineDate.value == "") {
				if(times <= 1){
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
			}else{
				return true;
			}
		}
		function isOverEventContent(){
			if(form.eventContent.value.length > 1000){
				overEventContent.style.display = "block";
			}else{
				return true;
			}
		}

		function addEmail(){
			  times++;
			  var newTr = document.createElement("tr");
			  newTr.innerHTML = "<tr><td> "
			  + "<input type=\"checkbox\" name=\"key\" value=\"" + times + "\"> "
			  + "<input type=\"email\" size=\"32\" name=\"targetEmail[]\"> </td></tr>";
			  table.children[0].insertBefore(newTr, document.getElementById("beforeAdd"));
			  emailTr.children[0].setAttribute("rowspan", times);
			  emailTr.children[2].setAttribute("rowspan", times);
			  email = form.elements["targetEmail[]"];
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