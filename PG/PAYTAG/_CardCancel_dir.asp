<!-- #include virtual = "/_lib/strFunc.asp" -->
<!-- #include virtual = "/_lib/strPGFunc.asp" -->
<!-- #include virtual = "/_lib/json2.asp" -->
<!-- #include file = "PAYTAG_CONFIG.ASP"-->
<%
'PAYTAG 카드 직접취소!!

'	http://www.byonglobal.com/PG/PAYTAG/_CardCancel_dir.asp

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	If REAL_PAY_TF = "T" Then
		print "업체 실 결제키 사용중!! 취소주문 확인요망!!"
		Response.End
	End If



	Response.End
	Response.End

	isDirect = "T"
	GoodIDX = "2"
	chgPage = ""
	ThisMsg = "웹프로테스트취소입니다"

	shopcode		= TX_PAYTAG_shopcode
	loginid			= TX_PAYTAG_loginid
	api_key			= TX_PAYTAG_api_key

	recv_orderno    = "20210219837779"		'페이태그 주문번호		'YYYYMMDD000000
	recv_trandate   = "20210219"			'거래일 'YYYYMMDD
	recv_tran_amt	= 1002					'결제요청금액


	Call PG_PAYTAG_CANCEL(shopcode, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)		'recv_orderno로 취소!!


	Response.End


%>