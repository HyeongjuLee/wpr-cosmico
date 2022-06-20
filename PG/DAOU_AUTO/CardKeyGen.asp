<!-- #include file="DaouPayLib.asp" -->
<%
					' Parameter 정보					자리수(Byte이하)
	                                ' * 필수입력항목
	Dim CP_ID			' * CP_ID					20
	Dim PAYMETHOD			' 결제유형(SSL)                                 3

	Dim ORDERNO			' * 주문번호                                    50
	Dim PRODUCTTYPE                 ' * 상품구분(1: 디지털, 2: 실물)                2 (값:01~99)
	Dim BILLTYPE                    ' * 과금유형(14)               			2 (값:01~99)
	Dim AUTOMONTHS                  ' * 월 자동 개월(1~12, 99: 무제한)              10

	Dim USERID                      ' 고객 ID                                       30
	Dim PRODUCTCODE                 ' 상품코드                                      10

	Dim ENC_INFO                    ' 카드번호                                      30
	Dim ENC_DATA                    ' 유효기간      YYYYMM                           30

	Dim TRAN_CD			' TRAN_CD

	Dim CARDAUTH              	' 인증번호(주민/사업자번호)              	10
	Dim CARDPASSWORD              	' 카드비밀번호              			2


	Dim r_RESULTCODE                ' 결과코드(0000: 성공, 그 외: 실패)             4
	Dim r_ERRORMESSAGE              ' 오류 메시지                                   100
	Dim r_AUTOKEY                   ' 월 자동 키                                    20
	Dim r_GENDATE                 	' 생성일자(YYYYMMDDhh24miss)                    14
	Dim r_DAOURESERVED1             ' 예약항목1(내부에서 INDEX로 관리)              100
	Dim r_DAOURESERVED2             ' 예약항목2(내부에서 INDEX로 관리)              100

'	CP_ID			= "CBN20620" 'request("CP_ID")  '"CTS14224" '
	CP_ID			= "" 'request("CP_ID")  '"CTS14224" '
	PAYMETHOD	= "SSL" 'request("PAYMETHOD")

	ORDERNO         = request("ORDERNO")
	PRODUCTTYPE     = "1" 'request("PRODUCTTYPE")
	BILLTYPE        = "14" 'request("BILLTYPE")
	AUTOMONTHS      = request("AUTOMONTHS")

	USERID          = request("USERID")
	PRODUCTCODE     = request("PRODUCTCODE")

	ENC_INFO  	= request("ENC_INFO")
	ENC_DATA  	= request("ENC_DATA")
	TRAN_CD   	= "00100500"
	CARDAUTH  	= request("CARDAUTH")
	CARDPASSWORD = request("CARDPASSWORD")

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
	 LogWrite( "---- CardAutoKeyGen return value ----------")

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
	 LogWrite("PAYMETHOD	    =" & PAYMETHOD    )
	 LogWrite("ORDERNO            =" & ORDERNO            )
	 LogWrite("PRODUCTTYPE        =" & PRODUCTTYPE        )
	 LogWrite("BILLTYPE           =" & BILLTYPE           )
	 LogWrite("AUTOMONTHS         =" & AUTOMONTHS         )
	 LogWrite("USERID             =" & USERID             )
	 LogWrite("PRODUCTCODE        =" & PRODUCTCODE        )
	 'LogWrite("ENC_INFO			  =" & ENC_INFO     )
	 'LogWrite("ENC_DATA			  =" & ENC_DATA     )
	 LogWrite("TRAN_CD			  =" & TRAN_CD  	   )
	 'LogWrite("CARDAUTH			 =" & CARDAUTH     )
	 'LogWrite("CARDPASSWORD  	    =" & CARDPASSWORD  	    )
	 LogWrite("r_RESULTCODE       =" & r_RESULTCODE       )
	 LogWrite("r_ERRORMESSAGE     =" & r_ERRORMESSAGE     )
	 LogWrite("r_AUTOKEY          =" & r_AUTOKEY          )
	 LogWrite("r_GENDATE     	    =" & r_GENDATE     	    )
	 LogWrite("r_DAOURESERVED1    =" & r_DAOURESERVED1    )
	 LogWrite("r_DAOURESERVED2    =" & r_DAOURESERVED2    )



	 LogWrite("ret		  =" & ret & "[" & daou.GETERRORMSG(ret) & "]" )
	 LogWrite("r_RESULTCODE    =" & r_RESULTCODE    )
	 LogWrite("r_ERRORMESSAGE  =" & r_ERRORMESSAGE  )
	 LogWrite("r_AUTOKEY       =" & r_AUTOKEY       )
	 LogWrite("r_GENDATE      =" & r_GENDATE    )
	 LogWrite("r_DAOURESERVED1=" & r_DAOURESERVED1)
	 LogWrite("r_DAOURESERVED2=" & r_DAOURESERVED2)
	 LogWrite( "-----------------------------------")

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

	if  r_ResultCode <> "0000"  then
		'ErrorUrl = "CardError.asp?errcode=" 	& r_RESULTCODE
		'ErrorUrl = ErrorUrl & "&errmsg=" 	& r_ERRORMESSAGE
		'ErrorUrl = ErrorUrl & "&email=" 	& EMAIL
		'response.redirect ErrorUrl
		'Response.write "rs"
		Response.Write "F|"&r_RESULTCODE&"|"&daou.GETERRORMSG(ret)&"|"&r_ERRORMESSAGE
		response.end
	end if

	' LogWrite( "---- CardAutoKeyGen return value ----------")
	' LogWrite("ret		  =" & ret & "[" & daou.GETERRORMSG(ret) & "]" )
	' LogWrite("r_RESULTCODE    =" & r_RESULTCODE    )
	' LogWrite("r_ERRORMESSAGE  =" & r_ERRORMESSAGE  )
	' LogWrite("r_AUTOKEY       =" & r_AUTOKEY       )
	' LogWrite("r_GENDATE      =" & r_GENDATE    )
	' LogWrite("r_DAOURESERVED1=" & r_DAOURESERVED1)
	' LogWrite("r_DAOURESERVED2=" & r_DAOURESERVED2)
	' LogWrite( "-----------------------------------")

		Response.Write "T|"&r_AUTOKEY
		response.end



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
