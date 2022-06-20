<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "STATISTICS"
	INFO_MODE = "STATISTICS1-1"

%>
<link rel="stylesheet" href="/admin/css/style2.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<!-- 회원관련 S -->
	<%
		Set DKRS = Db.execRs("DKPA_MEMBER_DEFAULT",DB_PROC,Nothing,Nothing)

		TOTAL_MEMBER_CNT			= DKRS("TOTAL_MEMBER_CNT")
		TOTAL_MEMBER_101			= DKRS("TOTAL_MEMBER_101")
		REGIST_TODAY				= DKRS("REGIST_TODAY")
		REGIST_7DAY					= DKRS("REGIST_7DAY")
		REGIST_30DAY				= DKRS("REGIST_30DAY")

		LEAVE_TODAY					= DKRS("LEAVE_TODAY")
		LEAVE_ACCEPT_TODAY			= DKRS("LEAVE_ACCEPT_TODAY")

		LEAVE_7DAY					= DKRS("LEAVE_7DAY")
		LEAVE_ACCEPT_7DAY			= DKRS("LEAVE_ACCEPT_7DAY")

		LEAVE_30DAY					= DKRS("LEAVE_30DAY")
		LEAVE_ACCEPT_30DAY			= DKRS("LEAVE_ACCEPT_30DAY")

		TOTAL_LEAVE					= DKRS("TOTAL_LEAVE")
		TOTAL_LEAVE_ACCEPT			= DKRS("TOTAL_LEAVE_ACCEPT")

	%>
	<div id="member" class="fleft">
		<p class="titles">일반회원 현황</p>
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
			</tr>
			</tr><tr>
				<th>총 가입한 회원수</th>
				<td class="tright"><strong><%=num2cur(TOTAL_MEMBER_CNT)%></strong> 명</td>
			</tr>
		</table>
	</div>

	<%
'		Set DKRS = Db.execRs("DKPA_MEMBER_DEFAULT_CS",DB_PROC,Nothing,DB3)
'
'		CS_TOTAL_MEMBER_CNT			= DKRS("TOTAL_MEMBER_CNT")			'총 회원수
'		CS_TOTAL_MEMBER_CNT_SELLER		= DKRS("TOTAL_MEMBER_CNT_SELLER")	'총 회원수_판매원
'		CS_TOTAL_MEMBER_CNT_CONSUMER	= DKRS("TOTAL_MEMBER_CNT_CONSUMER")	'총 회원수_소비자(멤버쉽)
'		CS_TOTAL_MEMBER_NORMAL			= DKRS("TOTAL_MEMBER_NORMAL")		'총 정상회원
'		CS_TOTAL_MEMBER_LEAVE			= DKRS("TOTAL_MEMBER_LEAVE")		'총 탈퇴회원
'		'CS_TOTAL_MEMBER_101			= DKRS("TOTAL_MEMBER_101")
'		CS_REGIST_TODAY				= DKRS("REGIST_TODAY")
'		CS_REGIST_7DAY					= DKRS("REGIST_7DAY")
'		CS_REGIST_30DAY				= DKRS("REGIST_30DAY")
'
'		CS_LEAVE_TODAY					= DKRS("LEAVE_TODAY")
'		'CS_LEAVE_ACCEPT_TODAY			= DKRS("LEAVE_ACCEPT_TODAY")
'
'		CS_LEAVE_7DAY					= DKRS("LEAVE_7DAY")
'		'CS_LEAVE_ACCEPT_7DAY			= DKRS("LEAVE_ACCEPT_7DAY")
'
'		CS_LEAVE_30DAY					= DKRS("LEAVE_30DAY")
'		'CS_LEAVE_ACCEPT_30DAY			= DKRS("LEAVE_ACCEPT_30DAY")
'
'		CS_TOTAL_LEAVE					= DKRS("TOTAL_LEAVE")
'		'CS_TOTAL_LEAVE_ACCEPT			= DKRS("TOTAL_LEAVE_ACCEPT")
'
	%>
	<!-- <div id="member" class="fright">
		<p class="titles">CS회원 현황</p>
		<table <%=tableatt%> class="adminWidth490">
			<col width="40%" />
			<col width="60%" />
			<tr>
				<th>오늘 가입한 회원</th>
				<td class="tright"><strong><%=num2cur(CS_REGIST_TODAY)%></strong> 명</td>
			</tr><tr>
				<th>최근 7일간 가입한 회원</th>
				<td class="tright"><strong><%=num2cur(CS_REGIST_7DAY)%></strong> 명</td>
			</tr><tr>
				<th>최근 30일간 가입한 회원</th>
				<td class="tright"><strong><%=num2cur(CS_REGIST_30DAY)%></strong> 명</td>
			</tr><tr>
				<th>총 가입 회원수</th>
				<td class="tright"><strong><%=num2cur(CS_TOTAL_MEMBER_CNT)%></strong> 명</td>
			</tr>
		</table>
	</div> -->
<!-- 회원관련 E -->









<!-- 주문관련 S -->
	<%
	'	Set DKRS = Db.execRs("DKPA_DEFAULT_ORDER",DB_PROC,Nothing,Nothing)


	'	ORDER_TODAY				= DKRS("ORDER_TODAY")
	'	ORDER_7DAY				= DKRS("ORDER_7DAY")
	'	ORDER_30DAY				= DKRS("ORDER_30DAY")

	'	ORDER_PRICE_TODAY		= DKRS("ORDER_PRICE_TODAY")
	'	ORDER_PRICE_7DAY		= DKRS("ORDER_PRICE_7DAY")
	'	ORDER_PRICE_30DAY		= DKRS("ORDER_PRICE_30DAY")


	%>
	<!-- <div id="order" class="fleft">
		<p class="titles">주문 현황</p>
		<table <%=tableatt%> class="adminWidth490">
			<col width="40%" />
			<col width="40%" />
			<col width="20%" />
			<tr>
				<th>오늘 주문 금액(건)</th>
				<td class="tright"><strong><%=num2cur(ORDER_PRICE_TODAY)%></strong> 원</td>
				<td class="tright"><strong><%=num2cur(ORDER_TODAY)%></strong> 건</td>
			</tr>
				<th>최근 7일간 주문 금액(건)</th>
				<td class="tright"><strong><%=num2cur(ORDER_PRICE_7DAY)%></strong> 원</td>
				<td class="tright"><strong><%=num2cur(ORDER_7DAY)%></strong> 건</td>
			</tr>
				<th>최근 30일간 주문 금액(건)</th>
				<td class="tright"><strong><%=num2cur(ORDER_PRICE_30DAY)%></strong> 원</td>
				<td class="tright"><strong><%=num2cur(ORDER_30DAY)%></strong> 건</td>
			</tr>
		</table>
	</div> -->
<!-- 주문관련 E -->


<!--#include virtual = "/admin/_inc/copyright.asp"-->
