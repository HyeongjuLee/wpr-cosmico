<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	'마이오피스 오토쉽결제 카드인증(온오프코리아)
	' 1. 데이터 받기
	' 2. DB에서 주문번호 확인(온오프 중복 검사용)
	' 3. 빌키 받아오기
	' 4. 데이터 리턴

	'▣ 데이터 Request S
		A_CardNumber		= request("A_CardNumber")
		A_Period1			= request("A_Period1")'		: A_Period1 =
		A_Period2			= request("A_Period2")
		A_Birth				= request("A_Birth")

		A_Card_Name_Number	= request("A_Card_Name_Number")
		A_CardPhoneNum		= request("A_CardPhoneNum")							'고객전화번호 필수
		A_CardType			= request("A_CardType")
		A_CardCode			= request("A_CardCode")
	'▣ 데이터 Request E

	'▣ 주문번호 체크 S
		arrParams = Array(_
			Db.makeParam("@TODAY_DATE",adVarChar,adParamInput,10,Date()), _
			Db.makeParam("@ORDERNUMBER",adVarChar,adParamOutput,20,"") _
		)
		Call Db.exec("[DKSP_ONOFF_KEYGEN_ORDERNUM_CHECK]",DB_PROC,arrParams,DB3)
		ORDERNUMBER = arrParams(Ubound(arrParams))(4)
	'▣ 주문번호 체크 E


		If webproIP = "T" Then
			viewType = "hidden"
		Else
			viewType = "hidden"
		End If

	'▣ 데이터 조합 S
		printData = ""
		printData = printData & "<input type="""&viewType&""" name=""chkA_CardCode"" value="""&A_CardCode&""" readonly=""readonly"" />"
		printData = printData & "<input type="""&viewType&""" name=""chkA_CardNumber"" value="""&A_CardNumber&""" readonly=""readonly"" />"
		printData = printData & "<input type="""&viewType&""" name=""chkA_Period1"" value="""&A_Period1&""" readonly=""readonly"" />"
		printData = printData & "<input type="""&viewType&""" name=""chkA_Period2"" value="""&A_Period2&""" readonly=""readonly"" />"
		printData = printData & "<input type="""&viewType&""" name=""chkA_Birth"" value="""&A_Birth&""" readonly=""readonly"" />"
		printData = printData & "<input type="""&viewType&""" name=""chkA_Card_Name_Number"" value="""&A_Card_Name_Number&""" readonly=""readonly"" />"
		printData = printData & "<input type="""&viewType&""" name=""chkA_CardType"" value="""&A_CardType&""" readonly=""readonly"" />"
		printData = printData & "<input type="""&viewType&""" name=""chkA_CardPhoneNum"" value="""&A_CardPhoneNum&""" readonly=""readonly"" />"
	'▣ 데이터 조합 E

	If TX_ONOFF_AUTOSHIP = "" Then
		PRINT "<span style=""color:red;font-weight:bold"" class=""dtexton"">TID 등록 확인 바랍니다.</span>"
		PRINT "<input type=""hidden"" name=""cardCheck"" value=""F"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" value="""" readonly=""readonly"" />"
		PRINT printData
		Response.End
	End If

	'If webproIP = "T" Then
	'	PRINT "<span class=""dtexton"" style=""color:blue;font-weight:bold"">정상 인증처리 되었습니다.</span>"
	'	PRINT "<input type="""&viewType&""" name=""cardCheck"" id=""cardCheck"" value=""T"" readonly=""readonly"" />"
	'	PRINT "<input type="""&viewType&""" name=""chkA_Card_Dongle"" id=""chkA_Card_Dongle""  value=""1111"" readonly=""readonly"" />"
	'	PRINT printData
	'	Response.End
	'End If

	'▣ 데이터 전송 S
		oXmlParam = ""
		oXmlParam = oXmlParam & "onfftid="&TX_ONOFF_AUTOSHIP
		oXmlParam = oXmlParam & "&pay_type=fixKey"
		oXmlParam = oXmlParam & "&method=request"
		oXmlParam = oXmlParam & "&order_no="&ORDERNUMBER
		oXmlParam = oXmlParam & "&user_nm="&A_Card_Name_Number
		oXmlParam = oXmlParam & "&user_phone2="&A_CardPhoneNum
		oXmlParam = oXmlParam & "&product_nm=CS_Product"
		oXmlParam = oXmlParam & "&card_no="&A_CardNumber
		oXmlParam = oXmlParam & "&expire_date="&Right(A_Period1,2)&A_Period2
		oXmlParam = oXmlParam & "&auth_value="&A_Birth
		oXmlParam = oXmlParam & "&card_user_type="&A_CardType
		oXmlParam = oXmlParam & "&tot_amt=1000"

		oXmlURL = "http://store.onoffkorea.co.kr/fix/index.php"
		'oXmlURL = "http://www.llife365.com/PG/ONOFFKOREA/xmlT.asp"

		set oXmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")

		oXmlhttp.setOption 2, 13056
		oXmlhttp.open "POST", oXmlURL, False
		oXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;"
		oXmlhttp.setRequestHeader "Accept-Language","UTF-8"
		oXmlhttp.setRequestHeader "CharSet", "UTF-8"
		oXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
		oXmlhttp.setRequestHeader "Content-Length", Len(oXmlParam)

		oXmlhttp.send oXmlParam											'작업 시간을 초과했습니다.
		sResponse = oXmlhttp.responseText
		xmlStatus = oXmlhttp.status

		LogFolder = "/PG/ONOFFKOREA/keygen/log"
		Call FN_TraceLog(LogFolder,"키젠 리턴값 S ==========")
		Call FN_TraceLog(LogFolder,"STATUS : "& xmlStatus)
		Call FN_TraceLog(LogFolder,"RESPONSE : "& sResponse)
		Call FN_TraceLog(LogFolder,"RESPONSE : "& oXmlParam)
		Call FN_TraceLog(LogFolder,"키젠 리턴값 E ==========")

		If xmlStatus <> "200" Then
			PRINT "<span style=""color:red;font-weight:bold"" class=""dtexton"">PG 서버와 통신중 오류가 발생하였습니다. STATUS CODE : "&xmlStatus&"</span>"
			PRINT "<input type=""hidden"" name=""cardCheck"" value=""F"" readonly=""readonly"" />"
			PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" value="""" readonly=""readonly"" />"
			PRINT printData
			Response.End
		End If

		'▣▣ XML 파싱 S
			Set oDOM = Server.CreateObject("Microsoft.XMLDOM")
			oDOM.Async = False ' 동기식 호출
			oDOM.validateOnParse = false
			oDomXML = oDOM.loadXML(sResponse)

			If oDomXML = False Or sResponse = "" Then
				PRINT "<span style=""color:red;font-weight:bold"" class=""dtexton"">카드인증 전문 오류</span>"	'tid 등 전문값확인
				PRINT "<input type=""hidden"" name=""cardCheck"" value=""F"" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" value="""" readonly=""readonly"" />"
				PRINT printData
				Response.End
			End If

			Set r_result_cd			= oDOM.selectNodes("//result_cd")
			Set r_result_msg		= oDOM.selectNodes("//result_msg")
			Set r_onfftid			= oDOM.selectNodes("//onfftid")
			Set r_order_no			= oDOM.selectNodes("//order_no")
			Set r_card_num			= oDOM.selectNodes("//card_num")
			Set r_card_user_type	= oDOM.selectNodes("//card_user_type")
			Set r_product_nm		= oDOM.selectNodes("//product_nm")
			Set r_tot_amt			= oDOM.selectNodes("//tot_amt")
			Set r_user_phone2		= oDOM.selectNodes("//user_phone2")
			Set r_fix_key			= oDOM.selectNodes("//fix_key")
			Set r_auth_dt			= oDOM.selectNodes("//auth_dt")
			Set r_result_status		= oDOM.selectNodes("//result_status")

			result_cd		= r_result_cd(0).Text
			result_msg		= r_result_msg(0).Text
			onfftid			= r_onfftid(0).Text
			order_no		= r_order_no(0).Text
			card_num		= r_card_num(0).Text
			card_user_type	= r_card_user_type(0).Text
			product_nm		= r_product_nm(0).Text
			tot_amt			= r_tot_amt(0).Text
			user_phone2		= r_user_phone2(0).Text
			fix_key			= r_fix_key(0).Text
			auth_dt			= r_auth_dt(0).Text
			result_status	= r_result_status(0).Text

			Set oDOM = Nothing

			If  result_cd <> "0000"  then
				PRINT "<span style=""color:red;font-weight:bold"" class=""dtexton"">"&result_msg&"</span>"
				PRINT "<input type=""hidden"" name=""cardCheck"" value=""F"" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" value="""" readonly=""readonly"" />"
				PRINT printData
				Response.End
			End If
		'▣▣ XML 파싱 S

%>
<%
		'임시테이블 동글저장 (오토쉽 정보 저장 시 동글키 위변조 검증용)
		IDENTITY = ""
		If result_cd = "0000" And fix_key <> "" Then

			A_Card_Dongle = fix_key
			IDENTITY = 0

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If A_Card_Dongle <> "" Then A_Card_Dongle = objEncrypter.Encrypt(A_Card_Dongle)
				On Error GoTo 0
			Set objEncrypter = Nothing

			If DK_MEMBER_ID1 <> "" And DK_MEMBER_ID2 <> "" Then
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
			End If

			If IDENTITY <> "" Then
				On Error Resume Next
				Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
					IDENTITY = Trim(StrCipher.Encrypt(IDENTITY,EncTypeKey1,EncTypeKey2))
				Set StrCipher = Nothing
				On Error GoTo 0
			End If

		End If
%>
<%
	'카드승인시
		'''Response.Write "T|"&r_AUTOKEY
		PRINT "<span style=""color:blue;font-weight:bold"" class=""dtexton"">정상 인증처리 되었습니다.</span>"
		PRINT "<input type=""hidden"" name=""cardCheck"" id=""cardCheck"" value=""T"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" value="""&fix_key&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_DongleIDX"" value="""&IDENTITY&""" readonly=""readonly"" />"
		PRINT printData
		Response.End

'	Response.Write("ORDERNO=" 		& ORDERNO)
'	Response.Write("<br>")
'	Response.Write("<br>")
'	Response.Write("ret		  =" & ret & "[" & daou.GETERRORMSG(ret) & "]")
'	Response.Write("<br>")
'	Response.Write("r_RESULTCODE    =" & r_RESULTCODE    )
'	Response.Write("<br>")
'	Response.Write("r_ERRORMESSAGE  =" & r_ERRORMESSAGE  )
'	Response.Write("<br>")
'	Response.Write("r_AUTOKEY       =" & r_AUTOKEY       )
'	Response.Write("<br>")
'	Response.Write("r_GENDATE      =" & r_GENDATE    )
'	Response.Write("<br>")
'	Response.Write("r_DAOURESERVED1=" & r_DAOURESERVED1)
'	Response.Write("<br>")
'	Response.Write("r_DAOURESERVED2=" & r_DAOURESERVED2)
'	Response.Write("<br>")
%>
