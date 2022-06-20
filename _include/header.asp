<%
	FAV_NAME = ""
	FAV_URL = "http://www."
%>
<a name="goTop" id="goTop"></a>
<%'If PAGE_SETTING = "SHOP" Then%>

<%If Left(PAGE_SETTING,4) = "SHOP" Then %><!--#include virtual = "/_include/header_shop.asp"-->
<%Else If PAGE_SETTING = "COMMUNITY" Then%><!--#include virtual = "/_include/header_community.asp"-->
<%Else If PAGE_SETTING = "MYOFFICE" Then%><!--#include virtual = "/_include/header_myoffice.asp"-->
<%Else%>
	<!--#include virtual = "/_include/header_home.asp"-->
	<%If PAGE_SETTING = "MYPAGE" Then%>
	<link rel="stylesheet" type="text/css" href="/css/mypage-myoffice.css?v0">
	<link rel="stylesheet" type="text/css" href="/css/mypage-common.css?v0">
	<%End If%>
<%End If%>
<%End If%>
<%End If%>








