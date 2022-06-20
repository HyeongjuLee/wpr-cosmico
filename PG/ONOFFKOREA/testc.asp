<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/strPGFunc.asp"-->
<%

	IF webproIP<> "T" then Call WRONG_ACCESS()

	'https://dev.meta21g.com/pg/onoffkorea/testc.asp
	print TX_ONOFF_TID

	onfftid = TX_ONOFF_TID	'"OFPT000000016397"
	vBankAmt = "4000"
	HJRS_CSORDERNUM = "20220608100000001"

	'♠온오프코리아 현금영수증 발급(가상계좌 입금시)
	'Call PG_ONOFFKOREA_CASH_RECEIPT(TX_ONOFF_TID, vBankAmt, HJRS_CSORDERNUM)
%>
