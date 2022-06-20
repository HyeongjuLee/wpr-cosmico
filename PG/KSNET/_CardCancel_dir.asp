<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/strPGFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	If webproIP <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

'KSNET 카드 직접취소!!

'	https://starcomps.co.kr:4455/PG/KSNET/_CardCancel_dir.asp

	Response.End
	Response.End


	'Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	'TX_KSNET_TID = "2999199999"		'테스트 아이디 2999199999
	'TX_KSNET_TID = "2001106378"			'코드블럭 실거래 아이디

	TX_KSNET_TID = ""

	PGorderNum = "175880060285"			'= rTransactionNo		: 175740050546
	isDirect = "T"
	GoodIDX = "49"
	chgPage = ""
	ThisMsg = "웹프로테스트취소입니다"

	Call PG_KSNET_CANCEL(TX_KSNET_TID,PGorderNum,GoodIDX,isDirect,chgPage, ThisMsg)

	Response.End

'	175800191790
'	175800191793
'	175800191794
%>