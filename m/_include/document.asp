<%
'	If TX_ONLY_MEMBER_SITE = "T" Then
'		If NO_MEMBER_REDIRECT <> "F" Then
'			If DK_MEMBER_LEVEL < 1 Then
'				Response.Redirect "/m/common/member_login.asp"
'				Response.End
'			End If
'		End If
'	End If

If webproIP <>"T" Then  Response.Redirect "/index.asp"

'	If Request.ServerVariables("HTTPS") = "off" Then
'		Response.Redirect "https://www.starcomps.co.kr:4455/m"
'	End If

''	If strHostA <> "www" Then
''		Response.Redirect("http://www.stellarsnp.co.kr"&ThisPageURL)
''	End If

%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<title><%=LNG_SITE_TITLE%> Mobile Site</title>

<!-- <script type="text/javascript" src="@string.Format("/m/css/style_<%=LANG%>.css?v={0}", DateTime.Now.Ticks)"></script> -->
<script type="text/javascript" src="/m/js/js.js?v3"></script>
<script type="text/javascript" src="/m/js/check.js?v1.0"></script>
<script type="text/javascript" src="/jscript/ajax.js"></script>
<!-- <script type="text/javascript" src="/jscript/common.js"></script> -->

<link href="/css/a_BtnCss.css" rel="stylesheet">
<link href="/css/fontawesome.5.12.1.css" rel="stylesheet"><!--load all styles -->

<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard-dynamic-subset.css" />
<!-- <link rel="stylesheet" type="text/css" href="/css/pretendard.css" /> -->
<link rel="stylesheet" type="text/css" href="/m/css/default.css?v4" />
<!-- <link rel="stylesheet" type="text/css" href="/m/css/style_<%=LANG%>.css?v2" /> -->
<!-- <link rel="stylesheet" type="text/css" href="/m/css/style_<%=LCase(DK_MEMBER_LNG_CODE)%>.css?v2" /><%'언어선택%> -->

<!-- <link rel="stylesheet" type="text/css" href="/m/css/style2.css?v2.0" /> -->
<%If Left(PAGE_SETTING,4) = "SHOP" Then %>
<link rel="stylesheet" type="text/css" href="/m/css/shop_style.css?6" />
<link rel="stylesheet" href="/m/css/shop_style_<%=LCase(DK_MEMBER_LNG_CODE)%>.css?v1" /><%'언어선택%>
<%Else%>
<link rel="stylesheet" type="text/css" href="/m/css/style.css?v4.4" />
<link rel="stylesheet" href="/m/css/style_<%=LCase(DK_MEMBER_LNG_CODE)%>.css?v1" /><%'언어선택%>
<%End if%>
<link rel="stylesheet" type="text/css" href="/css/NotoSansKR.css" />
<!-- <link rel="stylesheet" type="text/css" href="/css/Roboto.css" /> -->
<link rel="stylesheet" href="/fontello/css/icon-font.css?v0">

<%If ISSCROLL = "T" Then%>
<%Else%>
	<style>
	::-webkit-scrollbar {display: none;}
	</style>
<%End if%>