<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->
<%
	IMG_WIDTH  = "640"
	IMG_HEIGHT = "640"
%>
<link rel="stylesheet" href="/css/popStyle.css?v0" />
<style>
	#fileup {margin-top: 15px;}
	#fileup th {border:1px solid #ccc; padding:12px 7px; background-color:#eee;}
	#fileup td {border:1px solid #ccc; padding:5px 5px;}
	#fileup .btnArea {margin: 10px 0;}
</style>
<script type="text/javascript">

	function chkImg(f) {
		if (f.account.value == "") {
			alert("뿌리오 계정등록을 확인해주세요.");
			return false;
		}
		if (f.strImg.value == "") {
			alert("이미지를 선택해주세요.");
			f.strImg.focus();
			return false;
		} else {
			if (!checkFileName(f.strImg)) return false;
			if (!checkFileExt(f.strImg, "jpg,jpeg", "이미지(jpg(jpeg)) 파일만 선택해 주세요.")) return false;
		}
	}

	$(document).ready(function() {

		var fileTarget = $('.filebox .upload-hidden');

		fileTarget.on('change', function(){
			if(window.FileReader){ // 파일명 추출
				var filename = $(this)[0].files[0].name;
			} else { // Old IE 파일명 추출
				var filename = $(this).val().split('/').pop().split('\\').pop();
			};
			$(this).siblings('.upload-name').val(filename);
		});

	});

</script>
</head>
<body>
	<div id="fileup" class="width100">
		<div class="width100">
			<form name="ifrm" method="post" action="sms_fileUpOK.asp" enctype="multipart/form-data" onsubmit="return chkImg(this);">
				<input type="hidden" name="account" value="<%=PPURIO_ID%>" readonly="readonly" />
				<input type="hidden" name="mode" value="REGIST" readonly="readonly" />
				<input type="hidden" name="IMG_WIDTH" value="<%=IMG_WIDTH%>" readonly="readonly" />
				<input type="hidden" name="IMG_HEIGHT" value="<%=IMG_HEIGHT%>" readonly="readonly" />

				<table <%=tableatt%> class="width100">
					<col width="150" />
					<col width="*" />
					<tr>
						<th>뿌리오 계정</th>
						<td><%=PPURIO_ID%></td>
					</tr>
					<tr>
						<th>이미지</th>
						<td>
							<div class="filebox bs3-primary preview-image">
								<input class="upload-name" value="이미지 선택 (300 kbyte 이하의 jpg/jpeg))" disabled="disabled" style="width: 250px">
								<label for="strImg" class="ser">파일 선택</label>
								<input type="file" id="strImg" name="strImg" class="upload-hidden">
							</div>
						</td>
					</tr>
				</table>
				<div style="width: 100%; text-align: center; padding: 20px;" class=""><input type="submit" class="input_submit design3" value="등록" /></div>
			</form>
		</div>
	</div>
</body>
</html>
