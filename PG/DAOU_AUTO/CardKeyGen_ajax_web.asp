<!--#include virtual = "/_lib/strFunc.asp"-->
<!-- #include file="DaouPayLib.asp" -->
<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	'마이오피스 오토쉽결제 카드인증(백낭, 2018-01-18)
	'/myoffice/buy/order_list_cms_mod.asp

	A_CardNumber      = request("A_CardNumber")
	A_Period1         = request("A_Period1")
	A_Period2         = request("A_Period2")
	A_Birth			  = request("A_Birth")



									' Parameter 정보					자리수(Byte이하)
	                                ' * 필수입력항목
	Dim CP_ID						' * CP_ID										20
	Dim PAYMETHOD					' 결제유형(SSL)                                 3

	Dim ORDERNO						' * 주문번호                                    50
	Dim PRODUCTTYPE                 ' * 상품구분(1: 디지털, 2: 실물)                2 (값:01~99)
	Dim BILLTYPE                    ' * 과금유형(14)               					2 (값:01~99)
	Dim AUTOMONTHS                  ' * 월 자동 개월(1~12, 99: 무제한)              10

	Dim USERID                      ' 고객 ID                                       30
	Dim PRODUCTCODE                 ' 상품코드                                      10

	Dim ENC_INFO                    ' 카드번호                                      30
	Dim ENC_DATA                    ' 유효기간      YYYYMM                          30

	Dim TRAN_CD						' TRAN_CD

	Dim CARDAUTH              		' 인증번호(주민/사업자번호)              		10
	Dim CARDPASSWORD              	' 카드비밀번호              					2


	Dim r_RESULTCODE                ' 결과코드(0000: 성공, 그 외: 실패)             4
	Dim r_ERRORMESSAGE              ' 오류 메시지                                   100
	Dim r_AUTOKEY                   ' 월 자동 키                                    20
	Dim r_GENDATE                 	' 생성일자(YYYYMMDDhh24miss)                    14
	Dim r_DAOURESERVED1             ' 예약항목1(내부에서 INDEX로 관리)              100
	Dim r_DAOURESERVED2             ' 예약항목2(내부에서 INDEX로 관리)              100



	'CP_ID		 = "CBN20620"				'request("CP_ID")  '"CTS14224" '
	CP_ID		 = ""				'request("CP_ID")  '"CTS14224" '
	PAYMETHOD	 = "SSL"					'request("PAYMETHOD")

	ORDERNO      = "ON_"&DK_MEMBER_ID		'request("ORDERNO")
	PRODUCTTYPE  = "1"						'request("PRODUCTTYPE")
	BILLTYPE     = "14"						'request("BILLTYPE")
	AUTOMONTHS   = "99"						'request("AUTOMONTHS")

	USERID       = DK_MEMBER_ID				'request("USERID")
	PRODUCTCODE  = "Web_code"				'request("PRODUCTCODE")

	ENC_INFO  	 = A_CardNumber				'request("ENC_INFO")
	ENC_DATA  	 = A_Period1&A_Period2		'request("ENC_DATA")
	TRAN_CD   	 = "00100500"
	CARDAUTH  	 = A_Birth					'request("CARDAUTH")
	CARDPASSWORD = "00"						'request("CARDPASSWORD")



'	If webproIP = "T" Or DK_MEMBER_WEBID= "test" Then
	If webproIP = "T" Then
		PRINT "<span style=""color:blue;font-weight:bold"">정상 인증처리 되었습니다.</span>"
		PRINT "<input type=""hidden"" name=""cardCheck"" id=""cardCheck"" value=""T"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_CardNumber"" value="""&A_CardNumber&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period1"" value="""&A_Period1&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period2"" value="""&A_Period2&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Birth"" value="""&A_Birth&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" id=""chkA_Card_Dongle""  value=""1111"" readonly=""readonly"" />"
		Response.End
	End If


	' LogWrite( "---- CardAutoKeyGen Request Param ----------")
	' LogWrite( "CP_ID=" 		& CP_ID		 )
	' LogWrite( "PAYMETHOD=" 		& PAYMETHOD	 )
	' LogWrite( "ORDERNO=" 		& ORDERNO        )
	' LogWrite( "PRODUCTTYPE=" 	& PRODUCTTYPE    )
	' LogWrite( "BILLTYPE=" 		& BILLTYPE       )
	' LogWrite( "AUTOMONTHS=" 	& AUTOMONTHS     )
	' LogWrite( "USERID=" 		& USERID         )
	' LogWrite( "PRODUCTCODE=" 	& PRODUCTCODE    )
	' LogWrite( "ENC_INFO="		& ENC_INFO 	 )
	' LogWrite( "ENC_DATA="		& ENC_DATA 	 )
	' LogWrite( "CARDAUTH="		& CARDAUTH 	 )
	' LogWrite( "-------------------------------------")

	Set daou = Server.CreateObject("CardAutoDaouPay.CardAgentAPI.1")
	 LogWrite( "---- CardAutoKeyGen return value [WEB]----------")

	ret = daou.CardAutoKeyGen(CP_ID	 , _
			 PAYMETHOD	 , _
			ORDERNO         , _
			 PRODUCTTYPE     , _
			 BILLTYPE        , _
			 AUTOMONTHS      , _
			 USERID          , _
			 PRODUCTCODE     , _

			 ENC_INFO  	 , _
			 ENC_DATA  	 , _
			 TRAN_CD  	 , _
			 CARDAUTH  	 , _
			 CARDPASSWORD  	 , _
			 r_RESULTCODE    , _
			 r_ERRORMESSAGE  , _
			 r_AUTOKEY       , _
			 r_GENDATE     	 , _
			 r_DAOURESERVED1 , _
			 r_DAOURESERVED2 )
	 LogWrite("CP_ID	    = " & CP_ID    )
	 LogWrite("PAYMETHOD	    = " & PAYMETHOD    )
	 LogWrite("ORDERNO            = " & ORDERNO            )
	 LogWrite("PRODUCTTYPE        = " & PRODUCTTYPE        )
	 LogWrite("BILLTYPE           = " & BILLTYPE           )
	 LogWrite("AUTOMONTHS         = " & AUTOMONTHS         )
	 LogWrite("USERID             = " & USERID             )
	 LogWrite("PRODUCTCODE        = " & PRODUCTCODE        )
	 'LogWrite("ENC_INFO			  = " & ENC_INFO     )
	 'LogWrite("ENC_DATA			  = " & ENC_DATA     )
	 LogWrite("TRAN_CD			  = " & TRAN_CD  	   )
	 'LogWrite("CARDAUTH			 = " & CARDAUTH     )
	 'LogWrite("CARDPASSWORD  	    = " & CARDPASSWORD  	    )
	 LogWrite("r_RESULTCODE       = " & r_RESULTCODE       )
	 LogWrite("r_ERRORMESSAGE     = " & r_ERRORMESSAGE     )
	 LogWrite("r_AUTOKEY          = " & r_AUTOKEY          )
	 LogWrite("r_GENDATE     	  = " & r_GENDATE     	    )
	 LogWrite("r_DAOURESERVED1    = " & r_DAOURESERVED1    )
	 LogWrite("r_DAOURESERVED2    = " & r_DAOURESERVED2    )



	 LogWrite("ret		  = " & ret & "[" & daou.GETERRORMSG(ret) & "]" )
	 LogWrite("r_RESULTCODE    = " & r_RESULTCODE    )
	 LogWrite("r_ERRORMESSAGE  = " & r_ERRORMESSAGE  )
	 LogWrite("r_AUTOKEY       = " & r_AUTOKEY       )
	 LogWrite("r_GENDATE      = " & r_GENDATE    )
	 LogWrite("r_DAOURESERVED1 = " & r_DAOURESERVED1)
	 LogWrite("r_DAOURESERVED2 = " & r_DAOURESERVED2)
	 LogWrite( "-----------------------------------")
	 LogWrite( "")

	'if  ret <> 0  Then
	'	retMsg = daou.GETERRORMSG(ret)
	'	ErrorUrl = "CardError.asp?errcode=" 	& ret
	'	ErrorUrl = ErrorUrl & "&errmsg=" 	& retMsg
	'	ErrorUrl = ErrorUrl & "&email=" 	& EMAIL
	'	response.redirect ErrorUrl
	'	Response.Write "ret"
	'	Response.Write "F|00000000"
	'	response.end
	'end if

	If  r_ResultCode <> "0000"  then
		'ErrorUrl = "CardError.asp?errcode=" 	& r_RESULTCODE
		'ErrorUrl = ErrorUrl & "&errmsg=" 	& r_ERRORMESSAGE
		'ErrorUrl = ErrorUrl & "&email=" 	& EMAIL
		'response.redirect ErrorUrl
		'Response.write "rs"

		'Response.Write "F|"&r_RESULTCODE&"|"&daou.GETERRORMSG(ret)&"|"&r_ERRORMESSAGE

		If daou.GETERRORMSG(ret) = "CP_ID 정보오류" Then
			PG_MSG = " (미등록PG사)"
		End If

		PRINT "<span style=""color:red;font-weight:bold"">"&r_ERRORMESSAGE&" "&daou.GETERRORMSG(ret)& PG_MSG&"</span>"
		PRINT "<input type=""hidden"" name=""cardCheck"" value=""F"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_CardNumber"" value="""&A_CardNumber&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period1"" value="""&A_Period1&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period2"" value="""&A_Period2&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Birth"" value="""&A_Birth&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" value="""" readonly=""readonly"" />"
		Response.End
	End  If

	' LogWrite( "---- CardAutoKeyGen return value ----------")
	' LogWrite("ret		  =" & ret & "[" & daou.GETERRORMSG(ret) & "]" )
	' LogWrite("r_RESULTCODE    =" & r_RESULTCODE    )
	' LogWrite("r_ERRORMESSAGE  =" & r_ERRORMESSAGE  )
	' LogWrite("r_AUTOKEY       =" & r_AUTOKEY       )
	' LogWrite("r_GENDATE      =" & r_GENDATE    )
	' LogWrite("r_DAOURESERVED1=" & r_DAOURESERVED1)
	' LogWrite("r_DAOURESERVED2=" & r_DAOURESERVED2)
	' LogWrite( "-----------------------------------")

	'카드승인시
		'''Response.Write "T|"&r_AUTOKEY
		PRINT "<span style=""color:blue;font-weight:bold"">정상 인증처리 되었습니다.</span>"
		PRINT "<input type=""hidden"" name=""cardCheck"" id=""cardCheck"" value=""T"" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_CardNumber"" value="""&A_CardNumber&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period1"" value="""&A_Period1&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Period2"" value="""&A_Period2&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Birth"" value="""&A_Birth&""" readonly=""readonly"" />"
		PRINT "<input type=""hidden"" name=""chkA_Card_Dongle"" id=""chkA_Card_Dongle""  value="""&r_AUTOKEY&""" readonly=""readonly"" />"
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
