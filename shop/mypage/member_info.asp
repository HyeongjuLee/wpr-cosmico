<!--#include virtual = "/_lib/strFunc.asp"-->

<%


	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)


	PAGE_SETTING = "SHOP"
	SHOP_MYPAGE	="T"

	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 1



%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="member_info.css" />
<script type="text/javascript" src="member_info.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="subTitle" class="" style="margin-left:20px;">
	<div class="fleft maps_title"><img src="<%=IMG_NAVI%>/mypage_member_info.png" alt="" /></div>
	<div class="fright maps_navi">SHOP > 마이페이지 > <span class="tweight last_navi">회원정보수정</span></div>
</div>
<%Select Case DK_MEMBER_TYPE%>
<%	Case "MEMBER","ADMIN","OPERATOR","SADMIN"%><!--#include file = "member_info_member.asp"-->
<%	Case "COMPANY"%><!--#include file = "member_info_company.asp"-->
<%	Case Else%>
<%End Select%>

<!--#include virtual = "/_include/copyright.asp"-->