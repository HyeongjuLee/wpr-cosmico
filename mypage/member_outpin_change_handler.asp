<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<!--#include virtual = "/_lib/KISA_SHA256.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)


	If Not checkRef(houUrl &"/mypage/member_outpin_change.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/mypage/member_outpin_change.asp")

	MODE = pRequestTF("mode",True)

	WebPassWord		= pRequestTF("WebPassWord",True)
	'▣웹패스워드 체크
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
			If WebPassWord	<> "" Then WebPassWord	= objEncrypter.Encrypt(WebPassWord)
	Set objEncrypter = Nothing

	If WebPassWord = "" Then Call alerts(LNG_JS_PASSWORD,"back","")
	If CONFIG_WebPassword <> WebPassWord Then Call alerts(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT07,"back","")

	Select Case MODE
		Case "INSERT"
			SendPassWord	= pRequestTF("SendPassWord",True)
			SendPassWord2	= pRequestTF("SendPassWord2",True)

			'사용자비번
			If Not checkPass(SendPassWord, CONST_OUTPIN_MINIMUM_CHAR, CONST_OUTPIN_MAXIMUM_CHAR) Then Call ALERTS(LNG_JS_MONEY_OUTPUT_PIN_FORM_CHECK &" -TRANS","back","")
			If SendPassWord <> SendPassWord2		Then Call ALERTS(LNG_JS_PASSWORD_CHECK &" -TRANS","back","")

			chgPass = UCase(SHA256_Encrypt(SendPassWord))
			'Call ResRw(chgPass,"chgPass")

		Case "MODIFY"
			SendPassWord		= pRequestTF("SendPassWord",True)
			newSendPassWord	= pRequestTF("newSendPassWord",True)
			newSendPassWord2	= pRequestTF("newSendPassWord2",True)

			'사용자비번
			If Not checkPass(newSendPassWord, CONST_OUTPIN_MINIMUM_CHAR, CONST_OUTPIN_MAXIMUM_CHAR) Then Call ALERTS(LNG_JS_MONEY_OUTPUT_PIN_FORM_CHECK &" -TRANS","back","")
			If newSendPassWord <> newSendPassWord2		Then Call ALERTS(LNG_JS_PASSWORD_CHECK &" -TRANS","back","")
			'▣출금핀 체크
			SendPassWord = UCase(SHA256_Encrypt(SendPassWord))

			If SendPassWord = "" Then Call alerts(LNG_JS_PASSWORD,"back","")
			If CONFIG_SendPassWord <> SendPassWord Then Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT07&"07","back","")

			chgPass = UCase(SHA256_Encrypt(newSendPassWord))
			'Call ResRw(chgPass,"chgPass")

		Case Else : Call ALERTS(LNG_TEXT_NOT_A_VALID_VALUE,"BACK","")
	End Select

	arrParams = Array(_
		Db.makeParam("@mbid",adVarWChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@chgPass",adVarWChar,adParamInput,100,chgPass),_
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("HJP_SENDPASSWORD_UPDATE",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR"		: Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT08,"BACK","")
		Case "FINISH"		: Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT09,"go","/mypage/member_info.asp")
		Case Else			: Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT10,"BACK","")
	End Select

%>
