<%@ page pageEncoding="UTF-8" %>
<script>
	// submitを一度でも押したか
	var submitFlg = false;
	//bootstrapのvaridation
	(function() {
		'use strict';
		window.addEventListener('load', function() {
			// Fetch all the forms we want to apply custom Bootstrap validation styles to
			var forms = document.getElementsByClassName('needs-validation');
			// Loop over them and prevent submission
			var validation = Array.prototype.filter.call(forms, function(form) {
				form.addEventListener('submit', function(event) {
					submitFlg = true;
					if (form.checkValidity() === false) {
						event.preventDefault();
						event.stopPropagation();
					}
					// 候補日程のvalidation
					if(dateType == 1) {
						if ($("#dateDiv1").html() == "") {
							$("#date1").removeClass("is-valid");
							$("#date1").addClass("is-invalid");
							$("#date-feedback").addClass("d-block");
							event.preventDefault();
							event.stopPropagation();
						} else {
							$("#date1").removeClass("is-invalid");
							$("#date1").addClass("is-valid");
							$("#date-feedback").removeClass("d-block");
						}
					}
					form.classList.add('was-validated');
					textAreaEmail();
				}, false);
			});
		}, false);

	})();

	function formatDate (date, format) {
		  format = format.replace(/yyyy/g, date.getFullYear());
		  format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
		  format = format.replace(/dd/g, ('0' + date.getDate()).slice(-2));
		  format = format.replace(/HH/g, ('0' + date.getHours()).slice(-2));
		  format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
		  format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
		  format = format.replace(/SSS/g, ('00' + date.getMilliseconds()).slice(-3));
		  return format;
		}

	var todayDate = new Date().getDate();
	// datetime用の変数
	var datetimeStr = formatDate(new Date, "yyyy/MM/dd HH:mm");
	$(function() {
		$('#date1').datetimepicker({
			dayViewHeaderFormat : "YYYY MMMM",
			format : 'YYYY/MM/DD',
			useCurrent : false,
			inline : true,
			sideBySide : true,
			minDate : new Date()
		});
		$("#date1").on("dp.change", function(e) {
			addDate(e.date.format("YYYY/MM/DD"), 1);
			if(submitFlg){
				$("#date1").removeClass("is-invalid");
				$("#date1").addClass("is-valid");
				$("#date-feedback").removeClass("d-block");
			}
		});
		$('#date2').datetimepicker({
			dayViewHeaderFormat : "YYYY MMMM",
			useCurrent : false,
			stepping : 15,
			inline : true,
			sideBySide : true,
			minDate : new Date()
		});
		$("#date2").on("dp.change", function(e) {
			datetimeStr = e.date.format("YYYY/MM/DD HH:mm");
			if(submitFlg){
				$("#date2").removeClass("is-invalid");
				$("#date2").addClass("is-valid");
				$("#date-feedback").removeClass("d-block");
			}
		});
		$("#eventDeadline").datetimepicker({
			dayViewHeaderFormat : "YYYY MMMM",
			useCurrent : false,
			sideBySide : true,
			minDate : new Date()
		});
		$("#eventDeadline").on("dp.change", function(e) {
			var deadline = new Date(e.date);
			var defaultRemind = new Date(deadline.setDate(deadline.getDate() - 1));
			defaultRemind = new Date(deadline.setHours(12));
			defaultRemind = new Date(deadline.setMinutes(0));
			$("#defaultRemind").val(formatDate(defaultRemind, "yyyy/MM/dd HH:mm"));
		});
	});

	function remindDateTimePicker(){
		$('input[name="remindDateTime[]"]').datetimepicker({
			dayViewHeaderFormat : "YYYY MMMM",
			useCurrent : false,
			sideBySide : true,
			minDate : new Date(),
			maxDate : new Date(new Date().setDate(todayDate + 30))
		});
	}
	remindDateTimePicker();

	$('input[name="eventName"]').maxlength({
		alwaysShow: true,
		warningClass: "label label-success",
        limitReachedClass: "label label-danger"
    });
	$('textarea#eventContent').maxlength({
		alwaysShow: true,
		warningClass: "label label-success",
        limitReachedClass: "label label-danger"
    });

	function Reset(){
		dateReset();
	}
	function dateReset() {
		$("#dateDiv").html("");
	}

	var target = document.getElementById("dateDiv");

	var dateType = 1; // 時間割と時分 1なら時間割, 2なら時分

	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		  var activated_tab = e.target // activated tab
		  var previous_tab = e.relatedTarget // previous tab

		  dateType = parseInt(activated_tab.href.slice(-1));
		  if(dateType == 2){
			  $("#dateDiv1").html("");
			  $("#datetime").prop('required',true);
		  } else {
			  $("#datetime").val("");
			  $("#datetime").prop('required',false);
		  }
		  $("#dateType").val(dateType);
	});

	// 時分の追加ボタン
	function addDateTime(){
		addDate(datetimeStr, 2);
	}
	// 時分の削除ボタン
	function deleteDateTime(){
		var text = $("#datetime").val().replace(/\r\n|\r/g, "\n");
		if(text.lastIndexOf("\n") != -1){
			$("#datetime").val(text.slice(0, text.lastIndexOf("\n")));
		} else {
			$("#datetime").val("");
		}
	}

	// typeが1なら時間割, 2なら時分
	function addDate(date, type) {
		if(type == 1){
			var dateId = date.replace(/\//g, "-");
			dateId = dateId.replace(/\s+/g, "");
			var html = "<div id=\"" + dateId + "\"><input type=\"hidden\" name=\"date[]\" value=\"" + dateId + "\">"
					+ date;
			if(type == 1){
				for (var i = 1; i <= 5; i++) {
					html += " <input type=\"checkbox\" value=\"" + i + "\" name=\"" + "#" + dateId + "[]" + "\" checked>"
							+ i + "限 ";
				}
			} else {
				html += "〜 ";
			}
			html += "<input type=\"button\" value=\"削除\" onclick=\'deleteDiv(\""
					+ dateId + "\");\'>";

			$("#dateDiv1").html($("#dateDiv1").html() + html + "</div>");
		} else {
			var text = $("#datetime").val();
			if(text != ""){
				text += "\n";
			}
			$("#datetime").val(text + date + "〜");
		}
	}

	function deleteDiv(str) {
		$("#" + str).remove();
	}

	// とりあえず
	// 今から2日後を締め切り
	var deadline = new Date(Date.now() + 2 * 24 * 60 * 60000);
	var remindDate = new Date(Date.now() + 1 * 24 * 60 * 60000);
	var sampleDate = new Date(Date.now() + 4 * 24 * 60 * 60000);

	function addZero(n) {
		if (n < 10) {
			return "0" + n;
		} else {
			return n;
		}
	}

	// テキストエリアのメアドを格納、改行で分けてる、*が最初についたメアドをキーパーソンに
	function textAreaEmail() {
		var targetEmailTextarea = ($("#targetEmailTextarea").val()).split("\n");
		for ( var i in targetEmailTextarea) {
			if (targetEmailTextarea[i].slice(0, 1) == "*") {
				$("<input>", {
					type : 'hidden',
					name : 'key[]',
					value : i
				}).appendTo('#newschedule');
				$("<input>", {
					type : 'hidden',
					name : 'targetEmail[]',
					value : targetEmailTextarea[i].slice(1)
				}).appendTo('#newschedule');
			} else {
				$("<input>", {
					type : 'hidden',
					name : 'targetEmail[]',
					value : targetEmailTextarea[i]
				}).appendTo('#newschedule');
			}
		}
	}

	// テスト用の自動入力ボタン
	function AutoInput() {
		$("#newschedule [name=eventName]").val("[デモ用]会議の開催日程について");
		var sampleContent = "太田です。\n\n会議の日程を決めようと思いますので、ご都合の良い日時の回答をお願いします。\n\nよろしくお願いします。";
		$("#newschedule [name=eventContent]").val(sampleContent);
		$("#targetEmailTextarea").val("s152017@eecs.tottori-u.ac.jp\na@example.com\nb@example.com");
		$("#eventDeadline").val(
				"" + deadline.getFullYear() + "/"
						+ addZero(deadline.getMonth() + 1) + "/"
						+ addZero(deadline.getDate()) + " " + "00:00");
		$("#defaultRemind").val("" + remindDate.getFullYear() + "/"
				+ addZero(remindDate.getMonth() + 1) + "/"
				+ addZero(remindDate.getDate()) + " " + "00:00");
	}

	function AutoInputFuyukai() {
		var emailStr = "s152017@eecs.tottori-u.ac.jp\n"
				+ "s152119@eecs.tottori-u.ac.jp\n"
				+ "s132029@ike.tottori-u.ac.jp\n"
				+ "s112052@ike.tottori-u.ac.jp\n"
				+ "takahashi@tottori-u.ac.jp\n";
		$("#targetEmailTextarea").val(emailStr);
	}

	function addRemind() {
		var newDiv = document.createElement("div");
		newDiv.innerHTML = "<input class=\"form-control\" name=\"remindDateTime[]\" autocomplete=\"off\">"
					+ "<div class=\"input-group-append\"> <span class=\"input-group-text\"> <i class=\"fas fa-calendar-alt\"></i>"
					+ "</span> </div>";
		newDiv.setAttribute("class", "input-group");
		$("#addButton").before(newDiv);
		remindDateTimePicker();
	}

	// 開催条件のチェックを入れると数字を入れられるようになる
	$('#condition').change(function() {
		condition($(this).prop('checked'))
	})
	function condition(isCheck) {
		if (isCheck == true) {
			$("#denom").prop('disabled', false);
			$("#numer").prop('disabled', false);
			$("#denom").val("1");
			$("#numer").val("1");
		} else {
			$("#denom").prop('disabled', true);
			$("#numer").prop('disabled', true);
		}
	}
	condition($("#condition").prop("checked"));

	function addFiles(){
		    $('#addFileBefore').before('<input type="file" class="form-control-file" name="files[]" multiple>');
	}
</script>