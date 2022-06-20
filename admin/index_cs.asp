<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "STATISTICS"
	INFO_MODE = "STATISTICS1-2"

%>
<link rel="stylesheet" href="/admin/css/style2.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<!-- 회원관련 S -->
	<%
		Set DKRS = Db.execRs("DKPA_MEMBER_DEFAULT_CS",DB_PROC,Nothing,DB3)


		TOTAL_MEMBER_CNT			= DKRS("TOTAL_MEMBER_CNT")			'총 회원수
		TOTAL_MEMBER_CNT_SELLER		= DKRS("TOTAL_MEMBER_CNT_SELLER")	'총 회원수_판매원
		TOTAL_MEMBER_CNT_CONSUMER	= DKRS("TOTAL_MEMBER_CNT_CONSUMER")	'총 회원수_소비자(멤버쉽)
		TOTAL_MEMBER_NORMAL			= DKRS("TOTAL_MEMBER_NORMAL")		'총 정상회원
		TOTAL_MEMBER_LEAVE			= DKRS("TOTAL_MEMBER_LEAVE")		'총 탈퇴회원
		'TOTAL_MEMBER_101			= DKRS("TOTAL_MEMBER_101")
		REGIST_TODAY				= DKRS("REGIST_TODAY")
		REGIST_7DAY					= DKRS("REGIST_7DAY")
		REGIST_30DAY				= DKRS("REGIST_30DAY")

		LEAVE_TODAY					= DKRS("LEAVE_TODAY")
		'LEAVE_ACCEPT_TODAY			= DKRS("LEAVE_ACCEPT_TODAY")

		LEAVE_7DAY					= DKRS("LEAVE_7DAY")
		'LEAVE_ACCEPT_7DAY			= DKRS("LEAVE_ACCEPT_7DAY")

		LEAVE_30DAY					= DKRS("LEAVE_30DAY")
		'LEAVE_ACCEPT_30DAY			= DKRS("LEAVE_ACCEPT_30DAY")

		TOTAL_LEAVE					= DKRS("TOTAL_LEAVE")
		'TOTAL_LEAVE_ACCEPT			= DKRS("TOTAL_LEAVE_ACCEPT")

	%>
	<div id="member" class="fleft">
		<p class="titles">CS회원 현황</p>
		<table <%=tableatt%> class="adminWidth490">
			<col width="40%" />
			<col width="60%" />
			<tr>
				<th>오늘 가입한 회원</th>
				<td class="tright"><strong><%=num2cur(REGIST_TODAY)%></strong> 명</td>
			</tr><tr>
				<th>최근 7일간 가입한 회원</th>
				<td class="tright"><strong><%=num2cur(REGIST_7DAY)%></strong> 명</td>
			</tr><tr>
				<th>최근 30일간 가입한 회원</th>
				<td class="tright"><strong><%=num2cur(REGIST_30DAY)%></strong> 명</td>
			</tr><tr>
				<th>총 가입 회원수</th>
				<td class="tright"><strong><%=num2cur(TOTAL_MEMBER_CNT)%></strong> 명</td>
			</tr>
		</table>
	</div>
<!-- 회원관련 E -->



<!--#include virtual = "/admin/_inc/copyright.asp"-->
