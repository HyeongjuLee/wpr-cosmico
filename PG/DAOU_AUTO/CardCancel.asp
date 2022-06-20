<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"



	Dim DAOUTRX             ' 다우거래번호                                  20
	Dim AMOUNT              ' 취소 금액                                     10
	Dim CANCELMEMO          ' 취소 사유                                     50
	Dim r_RESULTCODE        ' 결과코드(0000: 성공, 그 외: 실패)             4
	Dim r_ERRORMESSA        ' 오류 메시지                                   100
	Dim r_DAOUTRX           ' 다우거래번호                                  20
	Dim r_AMOUNT            ' 결제금액                                      10
	Dim r_CANCELDATE        ' 취소일자(YYYYMMDD24miss) 주1)                 14


	'OrderNo = Request("OrderNo")
	DAOUTRX = Request("PGTRX")
	AMOUNT = Request("Amount")
	CANCELMEMO = Request("CancelMemo")
	IPADDRESS       = Request.Servervariables("REMOTE_ADDR")

'	CP_ID		= "CBN20620"
	CP_ID		= ""
	'OrderNo		= "201712100100002"
	'DAOUTRX		= "cBN17112813505427628"
	'AMOUNT		= "1000"
	'CANCELMEMO	= "최종결제 테스트 취소"



Set daou = Server.CreateObject("CardAutoDaouPay.CardAgentAPI.1")


		ret = daou.CardAutoCancel(CP_ID       , _
			DAOUTRX     , _
			AMOUNT      , _
			CANCELMEMO  , _
			r_RESULTCODE, _
			r_ERRORMESSA, _
			r_DAOUTRX   , _
			r_AMOUNT    , _
			r_CANCELDATE)




	PRINT daou.GETERRORMSG(ret) & "<br />"
	PRINT r_RESULTCODE & "<br />"
	PRINT r_AMOUNT & "<br />"
	PRINT r_CANCELDATE & "<br />"
	PRINT r_DAOUTRX & "<br />"


%>
