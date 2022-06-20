<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/_lib/json2.asp"-->
<%


	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","-1"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "cache-control", "no-store"

	If DK_MEMBER_TYPE <> "ADMIN" Then
		PRINT "{""result"" : ""error"", ""resultMsg"" : ""권한이 없습니다. 다시 로그인 후 이용 바랍니다.""}"
		Response.End
	End If

	strSubject = Request.Form("strSubject")
	smsContent = Request.Form("smsContent")
	strCate = Request.Form("strCate")
	kakaoTemplatecode = Request.Form("kakaoTemplatecode")
	kakaoButtonJson = Trim(Request.Form("kakaoButtonJson"))

	isJsonPage = "T"
%>
<!--#include file = "smsCONFIG.asp"-->
<%

	If smsContent = "" Then
		PRINT "{""result"" : ""error"", ""resultMsg"" : ""내용이 없습니다.""}"
		Response.End
	End If

	If strType_at = "T" Then
		If kakaoTemplatecode = "" Then
			PRINT "{""result"" : ""error"", ""resultMsg"" : ""카카오 템플릿코드를 입력해주세요.""}"
			Response.End
		End If
		If kakaoButtonJson = "" Then
			PRINT "{""result"" : ""error"", ""resultMsg"" : ""kakaoButtonJson내용이 없습니다.""}"
			Response.End
		End If
	End If

	'뿌리오 MMS 이미지
	If PPURIO_USE_TF = "T" And PPURIO_MMS_TF = "T" Then
		strImg = Request.Form("strImg")
	Else
		strImg = ""
	End If



	SELECT_SQL = " SELECT smsContent,strImg FROM DK_SMS_CONTENT WHERE delTF = 'F' "
	SELECT_SQL = SELECT_SQL & " AND strCate = ? "
	arrParams = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
	Set DKRS = Db.execRs(SELECT_SQL,DB_TEXT,arrParams,DB3)

	If Not DKRS.EOF And Not DKRS.BOF Then '데이터 있으면 기존 꺼 삭제 후 INSERT
		UPDATE_SQL = " UPDATE DK_SMS_CONTENT SET delTF = 'T' WHERE delTF = 'F' "
		UPDATE_SQL = UPDATE_SQL & " AND strCate = ? "
		arrParams = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
		Call Db.exec(UPDATE_SQL,DB_TEXT,arrParams,DB3)

		'수정전 이미지 삭제
		strImg_ori = DKRS("strImg")
		Call sbDeleteFiles(REAL_PATH("MMS_O")&"\"&backword(strImg_ori))
		Call sbDeleteFiles(REAL_PATH("MMS_T")&"\"&backword(strImg_ori))
	End If
	Call CloseRS(DKRS)


	SELECT_SQL = " SELECT * FROM DK_SMS_CONTENT WHERE delTF = 'F' AND strCate = ? "
	arrParams = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
	Set DKRS = Db.execRs(SELECT_SQL,DB_TEXT,arrParams,DB3)
	If Not DKRS.EOF And Not DKRS.BOF Then
		'strImg 공백처리
		UPDATE_SQL = " UPDATE DK_SMS_CONTENT SET [strImg] = '' WHERE delTF = 'F' "
		UPDATE_SQL = UPDATE_SQL & " AND strCate = ? "
		arrParams = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
		Call Db.exec(UPDATE_SQL,DB_TEXT,arrParams,DB3)
	End If
	Call CloseRS(DKRS)


	'INSERT_SQL = " INSERT INTO DK_SMS_CONTENT (smsContent, delTF, recordTime) VALUES (?, 'F', CONVERT(VARCHAR, GETDATE(), 120)) "
	INSERT_SQL = " INSERT INTO DK_SMS_CONTENT (strSubject, smsContent, strCate, strImg, kakaoTemplatecode,  kakaoButtonJson , delTF, recordTime) "
	INSERT_SQL = INSERT_SQL & " VALUES (?, ?, ?, ?, ?, ?, 'F', CONVERT(VARCHAR, GETDATE(), 120)) "
	arrParams = Array( _
		Db.makeParam("@strSubject",adVarWChar,adParamInput,80,strSubject), _
		Db.makeParam("@smsContent",adLongVarWChar,adParamInput,10000,smsContent), _
		Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate), _
		Db.makeParam("@strImg",adVarWChar,adParamInput,500,strImg), _
		Db.makeParam("@kakaoTemplatecode",adVarChar,adParamInput,32,kakaoTemplatecode), _
		Db.makeParam("@kakaoButtonJson",adLongVarWChar,adParamInput,10000,kakaoButtonJson) _
	)
	Call Db.exec(INSERT_SQL,DB_TEXT,arrParams,DB3)


	PRINT "{""result"" : ""success"", ""resultMsg"" : ""처리되었습니다.""}"
	Response.End
%>
