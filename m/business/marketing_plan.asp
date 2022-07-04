<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BUSINESS"

	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	'Call ONLY_CS_MEMBER()
	Call ONLY_CS_MEMBER_ALL()											'◈(소비자) 조회 허용 DK_MEMBER_STYPE
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	If DK_MEMBER_STYPE = 1 Then Response.Redirect "/m/buy/order_list.asp"

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<!--#include virtual = "/m/_include/header.asp"-->

<link rel="stylesheet" href="/m/css/marketing_plan.css?">
<!--#include virtual = "/page/marketing_plan.asp"-->

	
<!--#include virtual = "/_include/copyright.asp"-->