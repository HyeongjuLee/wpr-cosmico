<!--#include virtual = "/_lib/strFunc.asp"-->
<!-- #include virtual = "/_lib/strPGFunc.asp" -->
<!-- #include virtual = "/_lib/json2.asp" -->
<!-- #include file = "PAYTAG_CONFIG.ASP"-->
<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	'마이오피스 오토쉽결제 카드인증(PAYTAG)

	A_CardNumber      = request("A_CardNumber")
	A_Period1         = request("A_Period1")
	A_Period2         = request("A_Period2")
	A_Birth			  = request("A_Birth")
	A_CardPass		  = request("A_CardPass")		'PAYTAG추가

	A_Card_Name_Number	= request("A_Card_Name_Number")
	A_CardPhoneNum		= request("A_CardPhoneNum")							'고객전화번호 필수
	A_CardType			= request("A_CardType")
	A_CardCode			= request("A_CardCode")

	order_hp = A_CardPhoneNum

'	SQL_MEM = "SELECT [M_Name],[hptel] FROM tbl_Memberinfo WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ?"
'	arrParams = Array(_
'		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
'		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
'	)
'	Set DKRS = Db.execRs(SQL_MEM,DB_TEXT,arrParams,DB3)
'	If Not DKRS.BOF And Not DKRS.EOF Then
'		order_hp	= DKRS("hptel")
'
'		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
'			objEncrypter.Key = con_EncryptKey
'			objEncrypter.InitialVector = con_EncryptKeyIV
'			On Error Resume Next
'				If order_hp	<> "" Then order_hp = objEncrypter.Decrypt(order_hp)
'			On Error GoTo 0
'		Set objEncrypter = Nothing
'
'	Else
'		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
'	End If
'	Call closeRS(DKRS)

%>
<%

	'★★★★ PAYTAG(자동결제) API  S ★★★★

	servicecode     =   "PAYTAG"		'   필수 : 고정값
	reqtype			=   "L"				'   필수 : 'L'-API연동 고정값
	restype			=   "J"				'   필수 : 'J'-JSON 결과 리턴
	cmdtype         =   "AUTOSHIP"		'   필수 : 고정값
	paytag_apiurl	=   "https://api.paytag.kr/auto/direct"	        ' 필수 : 고정값 ( rest 주소값 )

	' =========================================
	' 페이태그로 부터 부여받은 값			'	PAYTAG_CONFIG.ASP
	' -------------------------------------------------------------------
	shopcode        =   TX_PAYTAG_shopcode	'   필수 : 페이태그 가맹점 번호
	loginid			=   TX_PAYTAG_loginid	'   필수 : 페이태그 로그인ID
	api_key			=   TX_PAYTAG_api_key	'   필수 : 암호화 키값

	' ========================================
	' 자동결제동의 요청정보
	' -------------------------------------------------------------------
	order_name		=   DK_MEMBER_NAME			 		'   필수 : 주문자-이름
	order_hp		=   order_hp				 		'   필수 : 주문자 휴대폰번호
	order_birth		=   A_Birth					 		'   필수 : 주문자 생년월일
	cardno			=   A_CardNumber			 		'   필수 : 카드번호
	owner_type		=	"N"								'	본인카드유무			'‘Y’: 본인카드, ‘N’:타인카드
	e_expiry_yymm	=	Right(A_Period1,2)&A_Period2	'	등록할 카드 유효기간
	e_owner_id 		= 	order_birth						'	타인카드 경우 필수
	e_pin_2			=	A_CardPass						'	등록할 카드의 비밀번호 앞 2 자리

	' =======================================
	' 보안인증값생성
	' 가맹점마다의 key값으로 암호화 한다.
	' -------------------------------------------------------------------
	cert_str =	servicecode & "|" & _
					cmdtype & "|" & _
					order_hp & "|" & _
					order_birth & "|" & _
					cardno

	' ######################################################################
	' AES256 암/복호화 DLL
	' ######################################################################
	set aesCom = server.createobject("PayTagCom.EncryptDecrypt")
	certval = aesCom.Aes256Encrypt(cert_str, api_key)

	if Err.Number <> 0 then
		Err.Raise 9999, "error", err.description
		call onErrorCheckDefault()
	end if


	' ========================================
	' header 파라메터 정의
	' -------------------------------------------------------------------
	REQ_HEADER_STR  = "servicecode=" & servicecode & _
					"&reqtype=" & reqtype & _
					"&restype=" & restype & _
					"&shopcode=" & shopcode & _
					"&apiver=2" & _
					"&cmdtype=" & cmdtype & _
					"&certval=" & server.urlencode(certval)

	' ========================================
	' body 파라메터 정의
	' -------------------------------------------------------------------
	REQ_BODY_STR =  "loginid=" & server.urlencode(loginid) & _
					"&order_name=" & server.urlencode(order_name) & _
					"&order_birth=" & server.urlencode(order_birth) & _
					"&order_hp=" & order_hp & _
					"&owner_type=" & server.urlencode(owner_type) & _
					"&e_expiry_yymm=" & e_expiry_yymm & _
					"&e_owner_id=" & server.urlencode(e_owner_id) & _
					"&e_pin_2=" & server.urlencode(e_pin_2)

	'response.write "body:" & REQ_BODY_STR & "<br>"

%>
<!--#include file="aspJSON1.17.asp" -->
<%
	Set xmlClient = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0")
	xmlClient.setTimeouts 5000, 5000, 30000, 30000

	xmlClient.open "POST", paytag_apiurl, FALSE

	xmlClient.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlClient.setRequestHeader "CharSet", "UTF-8"
	xmlClient.setRequestHeader "Accept-Language","ko"
	xmlClient.send REQ_HEADER_STR&"&"&REQ_BODY_STR


	' 서버 다운이나.. 없는 도메인일 경우
	If Err.Number = 0 Then

		server_status = xmlClient.Status

		If server_status >= 400 And server_status <= 599 Then

			Err.Raise 1020, "error", "결제서버오류["&server_status&"]"
			call onErrorCheckDefault()
		else

			Set responseStrm = CreateObject("ADODB.Stream")
			responseStrm.Open
			responseStrm.Position = 0
			responseStrm.Type = 1
			responseStrm.Write xmlClient.responseBody
			responseStrm.Position = 0
			responseStrm.Type = 2
			responseStrm.Charset = "UTF-8"
			resultStr = responseStrm.ReadText

			responseStrm.Close
			Set responseStrm = Nothing

			'response.write resultstr


			Set oJSON = New aspJSON
			oJSON.loadJSON(resultstr)

			recv_resultcode      =  oJSON.data("resultcode")		'결과코드 0000' or '00' 정상
			recv_errmsg          =  oJSON.data("errmsg")			'에러내용(실패시 오류내용)
			recv_AC_BILLKEY      =  oJSON.data("AC_BILLKEY")		'자동결제 빌키값

		End If


	Else
		Err.Raise 9999, "error", err.description
		call onErrorCheckDefault()
	End If

	Set xmlClient = Nothing

	'★★★★ PAYTAG(자동결제) API  E ★★★★

	'print resultstr
	'print "<hr>"

%>
<%
	If recv_resultcode = "0000" Or recv_resultcode = "00" Then		'PAYTAG(코드블럭)

		A_Card_Dongle = recv_AC_BILLKEY

		SQLD = "DELETE FROM [HJ_tbl_Memberinfo_A_Dongle_Chk] WHERE [MBID] = ? AND [MBID2] = ? AND [regDate] < GETDATE() - 3 "
		arrParamsD = Array( _
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
		)
		Call Db.exec(SQLD,DB_TEXT,arrParamsD,DB3)

		SQLA = "INSERT INTO [HJ_tbl_Memberinfo_A_Dongle_Chk] ( "
		SQLA = SQLA & " [MBID],[MBID2],[A_Card_Dongle] "
		SQLA = SQLA & " ) VALUES ( "
		SQLA = SQLA & " ?,?,? "
		SQLA = SQLA & " ); "
		SQLA = SQLA & "SELECT ? = @@IDENTITY"
		arrParamsA = Array( _
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
			Db.makeParam("@A_Card_Dongle",adVarWchar,adParamInput,100,A_Card_Dongle), _
			Db.makeParam("@IDENTITY",adInteger,adParamOutput,0,0) _
		)
		Call Db.exec(SQLA,DB_TEXT,arrParamsA,DB3)
		IDENTITY = arrParamsA(UBound(arrParamsA))(4)

		If IDENTITY <> "" Then
			On Error Resume Next
			Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
				IDENTITY = Trim(StrCipher.Encrypt(IDENTITY,EncTypeKey1,EncTypeKey2))
			Set StrCipher = Nothing
			On Error GoTo 0
		End If
	End If


	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		On Error Resume Next
			If order_hp <> "" Then order_hp_ENC = objEncrypter.Encrypt(order_hp)
		On Error GoTo 0
	Set objEncrypter = Nothing

	On Error Resume Next
		Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
		Dim LogPath2 : LogPath2 = Server.MapPath ("/PG/PAYTAG/autoship/autoship_") & Replace(Date(),"-","") & ".log"
		Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

		Sfile2.WriteLine chr(13)
		Sfile2.WriteLine "--- CardAutoKeyGen Request Param -----------------------"
		Sfile2.WriteLine "Date		: "	& now()
		Sfile2.WriteLine "Domain		: "	& Request.ServerVariables("HTTP_HOST")
		Sfile2.WriteLine "mbid1		 : " & DK_MEMBER_ID1
		Sfile2.WriteLine "mbid2		 : " & DK_MEMBER_ID2
		Sfile2.WriteLine "order_name	 : " & order_name
		Sfile2.WriteLine "shopcode	: " & shopcode
		Sfile2.WriteLine "loginid		: "	& loginid
		Sfile2.WriteLine "owner_type		: "	& owner_type
		Sfile2.WriteLine "order_hp_ENC	: "	& order_hp_ENC
		Sfile2.WriteLine "server_status  : "	& server_status
		Sfile2.WriteLine "recv_resultcode  : "	& recv_resultcode
		Sfile2.WriteLine "recv_errmsg      : "	& recv_errmsg
		Sfile2.WriteLine "recv_AC_BILLKEY    : "	& Left(recv_AC_BILLKEY,15)&" ....."
		Sfile2.WriteLine "IDENTITY_ENC    : "	& IDENTITY
		Sfile2.WriteLine "---------------------------------------------"
		Sfile2.Close
		Set Fso2= Nothing
		Set objError= Nothing
	On Error Goto 0


		PRINT "<input type=""hidden"" name=""chkA_CardType"" id=""chkA_CardType""  value="""&A_CardType&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_CardCode"" id=""chkA_CardCode""  value="""&A_CardCode&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_CardNumber"" value="""&A_CardNumber&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period1"" value="""&A_Period1&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period2"" value="""&A_Period2&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Name_Number"" id=""chkA_Card_Name_Number"" value="""&A_Card_Name_Number&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Birth"" id=""chkA_Birth"" value="""&A_Birth&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_CardPhoneNum"" id=""chkA_CardPhoneNum"" value="""&A_CardPhoneNum&""" readonly=""readonly"" />"

	If recv_resultcode = "0000" Or recv_resultcode = "00" Then		'PAYTAG(코드블럭)
		PRINT "<span style=""color:blue;font-weight:bold"">정상 인증처리 되었습니다.</span>"
		PRINT "<input type=""hidden"" name=""cardCheck"" id=""cardCheck"" value=""T"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" id=""chkA_Card_Dongle""  value="""&A_Card_Dongle&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_DongleIDX"" id=""chkA_Card_DongleIDX""  value="""&IDENTITY&""" readonly=""readonly"" />"
		Response.End
	Else
		recv_errmsg = recv_resultcode&":"&recv_errmsg
		'If order_hp = "" Then
		'	recv_errmsg = "마이페이지에서 휴대전화를 등록해주세요."
		'End if

		PRINT "<span style=""color:red;font-weight:bold"">"&recv_errmsg&"</span>"
		PRINT "<input type=""hidden"" name=""cardCheck"" value=""F"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" value="""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_DongleIDX"" id=""chkA_Card_DongleIDX""  value="""" readonly=""readonly"" />"
		Response.End
	End If



%>
