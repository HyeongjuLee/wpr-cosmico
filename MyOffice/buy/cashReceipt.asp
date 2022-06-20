<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	seq = gRequestTF("seq",True)
  'ONOFFKOREQ 2022-05-10
  Response.Redirect "https://store.onoffkorea.co.kr/api/receipt/cash.html?tran_seq="&seq
%>
