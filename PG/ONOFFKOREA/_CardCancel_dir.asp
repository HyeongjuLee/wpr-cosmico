<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/strPGFunc.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	If webproIP <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")
'response.end
'ONOFFKOREA 카드 직접취소!!

'	/PG/ONOFFKOREA/_CardCancel_dir.asp

	Response.End
	Response.End

	onfftid = TX_ONOFF_TID


	PGorderNum		= "22071817350306945351"	'transeq	거래번호(ONOFFKOREA)
	orderNum		= "DM221996323843_2"			'order_no
	totalPrice		= "1050"					'tot_amt
	PGAcceptNum		= "19250226"				'auth_no	신용카드 승인번호
	PGAcceptDate	= "20220718"				'app_dt		원승인일자

	isDirect = "F"
	GoodIDX = ""
	chgPage = ""
	ThisMsg = "웹프로 테스트취소W6"

	Call PG_ONOFFKOREA_CANCEL(onfftid, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
	Response.End

%>