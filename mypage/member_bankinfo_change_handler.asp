<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	If Not checkRef(houUrl &"/mypage/member_bankinfo_change.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/mypage/member_bankinfo_change.asp")

	MODE = pRequestTF("mode",True)
	previousURL = pRequestTF("previousURL",True)

	WebPassWord		= pRequestTF("WebPassWord",True)
	bankCode	 = pRequestTF("bankCode",False)
	bankOwner	 = pRequestTF("bankOwner",False)
	bankNumber	 = pRequestTF("bankNumber",False)

	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If WebPassWord	<> "" Then WebPassWord	= objEncrypter.Encrypt(WebPassWord)
		If bankNumber	<> "" Then bankNumber	= objEncrypter.Encrypt(bankNumber)
	Set objEncrypter = Nothing

	If WebPassWord = "" Then Call alerts(LNG_JS_PASSWORD,"back","")
	If CONFIG_WebPassword <> WebPassWord Then Call alerts(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT07,"back","")

	'▣ CS 계좌번호중복체크
	If bankCode <> "" And bankNumber <> "" Then
		SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [bankcode] = ? AND [bankaccnt] = ? AND NOT ([mbid] = ? AND [mbid2] = ?) "
		arrParams = Array(_
			Db.makeParam("@strBankCode",adVarChar,adParamInput,10,bankCode), _
			Db.makeParam("@bankaccnt",adVarchar,adParamInput,100,bankNumber), _
			Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
		)
		BANKACCNT_COUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

		If BANKACCNT_COUNT > 0 Then
			Call ALERTS("이미 CS에 등록된 계좌정보가 존재합니다! 본인이 등록하지 않았다면 본사로 문의해주세요.","BACK","")
		End If
	End If


	arrParams = Array(_
		Db.makeParam("@mbid",adVarWChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2),_

		Db.makeParam("@bankCode",adVarChar,adParamInput,10,bankCode), _
		Db.makeParam("@bankOwner",adVarWChar,adParamInput,50,bankOwner), _
		Db.makeParam("@bankNumber",adVarChar,adParamInput,200,bankNumber), _

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("HJP_BANKINFO_UPDATE",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR"		: Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT08,"BACK","")
		Case "FINISH"
			If previousURL <> "" Then
				Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT09,"go",previousURL)
			Else
				Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT09,"go","/mypage/member_info.asp")
			End If
		Case Else			: Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT10,"BACK","")
	End Select

%>
