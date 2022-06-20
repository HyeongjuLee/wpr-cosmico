<!-- #include file="DaouPayLib.asp" -->

<%
					' Parameter 정보					자리수(Byte이하)
	                                ' * 필수입력항목
	Dim CP_ID			' * CP_ID					20

	Dim REBATCHFLAG			' * 재결제여부(Y:재결제)                        1
	Dim ORDERNO			' * 주문번호                                    50
	Dim PRODUCTTYPE                 ' * 상품구분(1: 디지털, 2: 실물)                2 (값:01~99)
	Dim TAXFREECD                   ' * 과세 비과세 여부(00:과세 01:비과세)        	2
	Dim AMOUNT                  	' * 결제금액              			10
	Dim AUTOKEY			' * 월 자동 키              			20
	Dim QUOTA			' * 할부개월					2
	Dim USERID                      ' * 고객 ID                                     30
	Dim PRODUCTCODE                 ' * 상품코드                                    10

	Dim EMAIL                    	' 고객 E-MAIL(결제결과 통보 Default)		100
	Dim USERNAME                    ' 고객명					50
	Dim PRODUCTNAME			' 상품명					50
	Dim RESERVEDSTRING              ' 예약항목					100


	Dim r_RESULTCODE                ' 결과코드(0000: 성공, 그 외: 실패)             4
	Dim r_ERRORMESSAGE              ' 오류 메시지                                   100
	Dim r_ORDERNO                   ' 주문번호                                    	50
	Dim r_AMOUNT                    ' 결제금액                                    	50
	Dim r_DAOUTRX                   ' 다우거래번호                                  20
	Dim r_AUTHNO                    ' 승인번호                                   	8
	Dim r_NOINTFLAG                 ' 무이자여부(Y/N)                               1
	Dim r_QUOTA                 	' 할부개월                    			2
	Dim r_AUTHDATE             	' 결제일자(YYYYMMDDhh24miss)              	14
	Dim r_CPNAME            	' 가맹점 명(Email 내용)              		50
	Dim r_CPURL             	' 가맹점 홈페이지 주소(Email 내용)              50
	Dim r_CPTELNO             	' 가맹점 고객센터(Email 내용)              	15

'	CP_ID			= "CBN20620" 'request("CP_ID")  '"CTS14224" '
	CP_ID			= "CTS14224" 'request("CP_ID")  '"CTS14224" '
	REBATCHFLAG		= request("REBATCHFLAG")
	ORDERNO         = request("ORDERNO")
	PRODUCTTYPE     = "1" 'request("PRODUCTTYPE")
	TAXFREECD       = request("TAXFREECD")
	AMOUNT      	= request("AMOUNT")
	AUTOKEY      	= request("AUTOKEY")
	QUOTA      		= request("QUOTA")
	USERID          = request("USERID")
	PRODUCTCODE     = request("PRODUCTCODE")

	EMAIL     		= request("EMAIL")
	USERNAME     	= request("USERNAME")
	PRODUCTNAME     = request("PRODUCTNAME")
	RESERVEDSTRING  = request("RESERVEDSTRING")

	 LogWrite( "---- CardAutoBatch Request Param ----------")
	 LogWrite( "CP_ID=" 		& CP_ID		 )
	 LogWrite( "REBATCHFLAG=" 	& REBATCHFLAG	 )
	 LogWrite( "ORDERNO=" 		& ORDERNO        )
	 LogWrite( "PRODUCTTYPE=" 	& PRODUCTTYPE    )
	 LogWrite( "TAXFREECD=" 	& TAXFREECD      )
	 LogWrite( "AMOUNT=" 		& AMOUNT     	 )
	 LogWrite( "AUTOKEY=" 		& AUTOKEY        )
	 LogWrite( "QUOTA=" 		& QUOTA     	 )
	 LogWrite( "USERID=" 		& USERID         )
	 LogWrite( "PRODUCTCODE=" 	& PRODUCTCODE    )
	 LogWrite( "EMAIL="		& EMAIL 	 )
	 LogWrite( "USERNAME="		& USERNAME 	 )
	 LogWrite( "PRODUCTNAME="	& PRODUCTNAME	 )
	 LogWrite( "RESERVEDSTRING="	& RESERVEDSTRING	 )
	' LogWrite( "-------------------------------------")

	Set daou = Server.CreateObject("CardAutoDaouPay.CardAgentAPI.1")
	' LogWrite( "---- CardAutoBatch return value ----------")

	ret = daou.CardAutoBatch(CP_ID	, _
			 REBATCHFLAG	, _
			 ORDERNO        , _
			 PRODUCTTYPE    , _
			 TAXFREECD      , _
			 AMOUNT      	, _
			 AUTOKEY      	, _
			 QUOTA      	, _
			 USERID         , _
			 PRODUCTCODE    , _
			 EMAIL  	, _
			 USERNAME  	, _
			 PRODUCTNAME  	, _
			 RESERVEDSTRING , _
			 r_RESULTCODE   , _
			 r_ERRORMESSAGE , _
			 r_ORDERNO      , _
			 r_AMOUNT      , _
			 r_DAOUTRX , _
			 r_AUTHNO , _
			 r_NOINTFLAG , _
			 r_QUOTA , _
			 r_AUTHDATE , _
			 r_CPNAME , _
			 r_CPURL , _
			 r_CPTELNO )

	'if  ret <> 0  Then
	'	'retMsg = daou.GETERRORMSG(ret)
	'	'ErrorUrl = "CardError.asp?errcode=" 	& ret
	'	'ErrorUrl = ErrorUrl & "&errmsg=" 	& retMsg
	'	'ErrorUrl = ErrorUrl & "&email=" 	& EMAIL
	'	'response.redirect ErrorUrl
	'	Response.Write "F|00000000"
	'	response.end
	'end if


	 LogWrite("ret		  =" & ret & "[" & daou.GETERRORMSG(ret) & "]" )
	 LogWrite("r_RESULTCODE    =" & r_RESULTCODE    )
	 LogWrite("r_ERRORMESSAGE  =" & r_ERRORMESSAGE  )
	 LogWrite("r_ORDERNO  	  =" & r_ORDERNO  )
	 LogWrite("r_AMOUNT  	  =" & r_AMOUNT  )
	 LogWrite("r_DAOUTRX  	  =" & r_DAOUTRX  )
	 LogWrite("r_AUTHNO  	  =" & r_AUTHNO  )
	 LogWrite("r_NOINTFLAG  	  =" & r_NOINTFLAG  )
	 LogWrite("r_QUOTA  	  =" & r_QUOTA  )
	 LogWrite("r_AUTHDATE  	  =" & r_AUTHDATE  )
	 LogWrite("r_CPNAME  	  =" & r_CPNAME  )
	 LogWrite("r_CPURL  	  =" & r_CPURL  )
	 LogWrite("r_CPTELNO  	  =" & r_CPTELNO  )
	 LogWrite( "-----------------------------------")


	if  r_ResultCode <> "0000"  then
		'ErrorUrl = "CardError.asp?errcode=" 	& r_RESULTCODE
		'ErrorUrl = ErrorUrl & "&errmsg=" 	& r_ERRORMESSAGE
		'ErrorUrl = ErrorUrl & "&email=" 	& EMAIL
		'response.redirect ErrorUrl
		Response.Write "F|"&r_RESULTCODE&"|"&daou.GETERRORMSG(ret)&"|"&r_ERRORMESSAGE
		response.end
	end if


	Response.Write "T|"&r_DAOUTRX&"|"&r_AUTHNO


'	Response.Write("ORDERNO=" 		& ORDERNO)
'	Response.Write("<br>")
'	Response.Write("<br>")
'	Response.Write("ret		  =" & ret & "[" & daou.GETERRORMSG(ret) & "]")
'	Response.Write("<br>")
'	Response.Write("r_RESULTCODE    =" & r_RESULTCODE    )
'	Response.Write("<br>")
'	Response.Write("r_ERRORMESSAGE  =" & r_ERRORMESSAGE  )
'	Response.Write("<br>")
'	Response.Write("r_ORDERNO  	  =" & r_ORDERNO  )
'	Response.Write("<br>")
'	Response.Write("r_AMOUNT  	  =" & r_AMOUNT  )
'	Response.Write("<br>")
'	Response.Write("r_DAOUTRX  	  =" & r_DAOUTRX  )
'	Response.Write("<br>")
'	Response.Write("r_AUTHO  	  =" & r_AUTHNO  )
'	Response.Write("<br>")
'	Response.Write("r_NOINTFLAG  	  =" & r_NOINTFLAG  )
'	Response.Write("<br>")
'	Response.Write("r_QUOTA  	  =" & r_QUOTA  )
'	Response.Write("<br>")
'	Response.Write("r_AUTHDATE  	  =" & r_AUTHDATE  )
'	Response.Write("<br>")
'	Response.Write("r_CPNAME  	  =" & r_CPNAME  )
'	Response.Write("<br>")
'	Response.Write("r_CPURL  	  =" & r_CPURL  )
'	Response.Write("<br>")
'	Response.Write("r_CPTELNO  	  =" & r_CPTELNO  )
%>
