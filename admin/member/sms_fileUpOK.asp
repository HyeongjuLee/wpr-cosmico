<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/_lib/json2.asp"-->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache

	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize  = 0.292							'뿌리오 MMS 이미지 300kbyte 제한
	MaxDataSize1 = MaxDataSize * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage = 65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode				= upForm("mode",True)
	IMG_WIDTH		= upForm("IMG_WIDTH",True)
	IMG_HEIGHT	= upForm("IMG_HEIGHT",True)


	imgPath = REAL_PATH("MMS_O")
	imgPath1 = REAL_PATH("MMS_T")
	'print imgPath
	'print imgPath2
	Call ChkPathToCreate(VIR_PATH("MMS_O"))
	Call ChkPathToCreate(VIR_PATH("MMS_T"))

	strImg = FN_IMAGEUPLOAD("strImg","T",MaxDataSize1,imgPath,imgPath1,"T",IMG_WIDTH,IMG_HEIGHT,"","","","")

	If strImg <> "" Then strImg = backword(strImg)

	fileName = imgPath&"\"&strImg
	'Call ResRW(fileName,"fileName")

%>
<%
	' 발급받은 파일키는 당일 00시에 무효화됨 확인(1회성)
	'	MMS 전송 시마다 해당 이미지에 대한 파일키를 발급받아야함
	' 하단 내역 삭제처리

	'뿌리오 파일 업로드 설정 XXX
	'PPURIO_FILE_URL		= PPURIO_URL&"/v1/file"
	'Call ResRW(PPURIO_MODE,"PPURIO_MODE")
	'Call ResRW(PPURIO_ID,"PPURIO_ID")
	'Call ResRW(base64,"base64")
	'Call ResRW2(PPURIO_BASE64_AUTH,"PPURIO_BASE64_AUTH")
	'Call ResRW(PPURIO_FILE_URL,"PPURIO_FILE_URL")
	'Dim sendResult
	''PPURIO_ID = ""		'error test
	'PPURIO_FILE_BOUNDARY = "5d14GC42dS9N5BXQAKuhpRfd4VDV54RDDsTJO4"
	'PPURIO_FILE_CHARSET = "ISO-8859-1"
	'sendResult = FN_SendFileData(fileName, PPURIO_ID, PPURIO_FILE_URL, PPURIO_FILE_BOUNDARY, PPURIO_FILE_CHARSET)
	'Call ResRW(sendResult,"sendResult")
	'Dim json_message : Set json_message = JSON.parse(join(array(sendResult)))
	'On Error Resume Next
	'	'200 success
	'	r_filekey	= json_message.filekey
	'	Call ResRW(r_filekey,"r_filekey")
	'	'fail
	'	r_code	= json_message.code		'결과 코드
	'	r_description	= json_message.description		'결과 메시지
	'	If r_code <> "" Then
	'		Call Alerts("뿌리오 MMS 파일 등록 에러발생 \n\n errcode: "&r_code&"\n description : "&r_description ,"back","")
	'		Response.End
	'	End If
	'On Error GoTo 0

	result_image = ""
	'If strImg <> "" And r_filekey <> "" Then
	If strImg <> "" Then
		result_image = "<img src="""&IMG_ICON&"/icon_picT.gif"" class=""vmiddle"" />"
		result_image = result_image &" <span><a href="""&VIR_PATH("MMS_T")&"/"&strImg&""" target=""_blank"" class=""strImg"" >"&strImg&"</a></span>"
		result_image = result_image &" <input type=""button"" class=""a_submit design2"" id=""deleteImg"" onclick=""fnSmsImgDel();"" value=""삭제"" />"
	End If
%>
<script type="text/javascript">

	function getPpurioImageKey(fvalue) {
		//alert("등록이 완료되었습니다.")
		//parent.$("#filekey").val('<%=r_filekey%>');
		parent.$("#strImg").val('<%=strImg%>');
		parent.$("#result_image").html('<%=result_image%>');
		parent.$("#modal_view").dialog("close");
	}

</script>
<body onload="javascript: getPpurioImageKey();">
</body>
