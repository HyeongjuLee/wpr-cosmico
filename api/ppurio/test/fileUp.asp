<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	If WebproIP <> "T" Then CAll WRONG_ACCESS()

	'뿌리오 파일업 테스트 응답값 확인용!!
	'https://dev-api.bizppurio.com/v1/file 바로 던지면 결과 값 확인 가능
	'{"filekey":"1649942319_SL5168764231900000005.jpg"}		'metac21g_dev

	'/api/ppurio/fileUp.asp

	W1200 = "T"
	ADMIN_LEFT_MODE = "DESIGN"

%>
<link rel="stylesheet" href="design.css?v=2" />
<style>
	#design th {border:1px solid #ccc; padding:12px 0px; background-color:#eee;}
	#design td {border:1px solid #ccc; padding:5px 5px;}
	#design tr.trbg td {background-color:#e6f5ff;}
	#design .btnArea {margin: 10px 0;}
</style>
<script type="text/javascript" >

	function chkImg(f) {
			if (f.file.value == "") {
				alert("이미지를 선택해주세요.");
				f.file.focus();
				return false;
			} else {
				if (!checkFileName(f.file)) return false;
				if (!checkFileExt(f.file, "jpg,jpeg,gif,png", "이미지(jpg(jpeg), gif,png) 파일만 선택해 주세요.")) return false;
			}
	}
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="design" class="fleft width100">
	<div id="bannerRegistForm" class="width100">
		<p class="titles">이미지등록 </p>
		<form name="ifrm" method="post" action="https://dev-api.bizppurio.com/v1/file" enctype="multipart/form-data" onsubmit="return chkImg(this);">
			<input type="hidden" name="mode" value="REGIST" readonly="readonly" />
			<input type="hidden" name="account" value="<%=PPURIO_ID%>" readonly="readonly" />
			<input type="hidden" name="IMG_WIDTH" value="<%=IMG_WIDTH%>" readonly="readonly" />
			<input type="hidden" name="IMG_HEIGHT" value="<%=IMG_HEIGHT%>"  readonly="readonly"/>
			<table <%=tableatt%> class="width100 insert">
				<col width="150" />
				<col width="800" />
				<col width="*" />
				<tr>
					<th>뿌리오 Account</th>
					<td><%=PPURIO_ID%></td>
					<td></td>
				</tr>
				<tr>
					<th>이미지 첨부</th>
					<td><input type="file" name="file" class="input_file" style="width:450px" /></td>
					<td></td>
				</tr>
				<tr>
					<td colspan="3" class="tcenter"><input type="submit" class="input_submit design1" value="등록" /></td>
				</tr>
			</table>
		</form>

	</div>

</div>
<%
	'{"filekey":"1649942110_SL7516914211000000004.jpg"}		'account
	'{"filekey":"1649942319_SL5168764231900000005.jpg"}		'metac21g_dev
%>
