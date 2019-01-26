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
					if ($("#dateDiv").html() == "") {
						$("#date").removeClass("is-valid");
						$("#date").addClass("is-invalid");
						$("#date-feedback").addClass("d-block");
						event.preventDefault();
						event.stopPropagation();
					} else {
						$("#date").removeClass("is-invalid");
						$("#date").addClass("is-valid");
						$("#date-feedback").removeClass("d-block");
					}
					form.classList.add('was-validated');
					textAreaEmail();
				}, false);
			});
		}, false);

	})();

	$(function() {
		$('#date').datetimepicker({
			dayViewHeaderFormat : "YYYY MMMM",
			format : 'YYYY/MM/DD',
			useCurrent : false,
			inline : true,
			sideBySide : true
		});
		$("#date").on("dp.change", function(e) {
			addDate(e.date.format("YYYY/MM/DD"));
			if(submitFlg){
				$("#date").removeClass("is-invalid");
				$("#date").addClass("is-valid");
				$("#date-feedback").removeClass("d-block");
			}
		});
		$("#eventDeadline").datetimepicker({
			dayViewHeaderFormat : "YYYY MMMM",
			useCurrent : false,
			sideBySide : true
		});
	});

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

	function dateReset() {
		$("#dateDiv").html("");
	}

	var target = document.getElementById("dateDiv");

	function addDate(date) {
		var dateDivHtml = $("#dateDiv").html();
		var dateId = date.replace(/\//g, "-");
		var html = "<div id=\"" + dateId + "\"><input type=\"hidden\" name=\"date[]\" value=\"" + dateId + "\">"
				+ date;
		for (var i = 1; i <= 5; i++) {
			html += " <input type=\"checkbox\" value=\"" + i + "\" name=\"" + "#" + dateId + "[]" + "\" checked>"
					+ i + "限 ";
		}
		html += "<input type=\"button\" value=\"削除\" onclick=\'deleteDiv(\""
				+ dateId + "\");\'>";
		$("#dateDiv").html(dateDivHtml + html + "</div>");
	}

	function deleteDiv(str) {
		$("#" + str).remove();
	}

	// とりあえず
	// 今から2日後を締め切り
	var deadline = new Date(Date.now() + 2 * 24 * 60 * 60000);
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
		$("#newschedule [name=eventName]").val("会議の開催日程について");
		var sampleContent = "会議をします。";
		$("#newschedule [name=eventContent]").val(
				sampleContent + "\n\n" + sampleContent.repeat(5) + "\n"
						+ sampleContent.repeat(3) + "\n"
						+ sampleContent.repeat(2) + "\n"
						+ sampleContent.repeat(1) + "\n\n"
						+ sampleContent.repeat(3) + "\n"
						+ sampleContent.repeat(2) + "\n"
						+ sampleContent.repeat(1));
		$("#targetEmailTextarea").val("s152017@eecs.tottori-u.ac.jp");
		addDate("" + sampleDate.getFullYear() + "/"
				+ addZero(sampleDate.getMonth() + 1) + "/"
				+ addZero(sampleDate.getDate()));
		$("#eventDeadline").val(
				"" + deadline.getFullYear() + "/"
						+ addZero(deadline.getMonth() + 1) + "/"
						+ addZero(deadline.getDate()) + " " + "00:00");
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
		newDiv.innerHTML = "締め切りの <input type=\"number\" class=\"form-control\" min=\"0\" max=\"30\" name=\"remindDate[]\">日前の "
				+ "<input type=\"number\" class=\"form-control\" min=\"0\" max=\"23\" name=\"remindTime[]\">時に再通知";
		newDiv.setAttribute("class", "col-sm-10 col-md-7 form-inline");
		$("#reminder")[0].appendChild(newDiv);
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

	$('.custom-file-input').on('change', handleFileSelect);
	function handleFileSelect(evt) {
		$('#preview').remove();// 繰り返し実行時の処理
		$(this).parents('.input-group').after('<div id="preview"></div>');
		var files = evt.target.files;

		for (var i = 0, f; f = files[i]; i++) {

			var reader = new FileReader();

			reader.onload = (function(theFile) {
				return function(e) {
					if (theFile.type.match('image.*')) {
						var $html = [
								'<div class="d-inline-block mr-1 mt-1"><img class="img-thumbnail" src="',
								e.target.result,
								'" title="',
								escape(theFile.name),
								'" style="height:100px;" /><div class="small text-muted text-center">',
								escape(theFile.name), '</div></div>' ].join('');// 画像では画像のプレビューとファイル名の表示
					} else {
						var $html = [
								'<div class="d-inline-block mr-1"><span class="small">',
								escape(theFile.name), '</span></div>' ]
								.join('');//画像以外はファイル名のみの表示
					}

					$('#preview').append($html);
				};
			})(f);

			reader.readAsDataURL(f);
		}

		$(this).next('.custom-file-label')
				.html(+files.length + '個のファイルを選択しました');
	}

	//ファイルの取消
	$('.reset').click(
			function() {
				$(this).parent().prev().children('.custom-file-label').html(
						'ファイル選択...');
				$('.custom-file-input').val('');
				$('#preview').remove('');
			})
</script>