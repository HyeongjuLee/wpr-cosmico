<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CBOARD"
	INFO_MODE = "CBOARD-0"

%>
</head>
<body>
<div>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%If DK_MEMBER_LEVEL > 10 And WebproIP="T" Then%>
<p class="red">WebproIP view</p>
<p>admin</p>
<p>> headerData</p>
<p>> left</p>
<p>/cboard>board_config > ADMIN_LEFT_MODE, INFO_MODE 값 확인</p>
<p>업체별 커스텀 확인</p>
<%End If%>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
