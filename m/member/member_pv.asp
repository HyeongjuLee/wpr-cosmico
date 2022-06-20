<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_MEMBER"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)


	'나의 총pv
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set HJRS = Db.execRs("HJP_TOTAL_PV",DB_PROC,arrParams,DB3)
	If Not HJRS.BOF And Not HJRS.EOF Then
		 MY_TOTAL_PV =	HJRS(0)
	ELSE
		 MY_TOTAL_PV =	0
	END If
	Call closeRS(HJRS)


	'[후원조직정보] (총대수, 후원하선 인원) 2013-04-10
	arrParams5 = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set HJRS = Db.execRs("HJP_SPON_DOWN_INFO",DB_PROC,arrParams5,DB3)
	If Not HJRS.BOF And Not HJRS.EOF Then
		 L_SPON_NAME		=	HJRS(0)
		 L_SPON_ID1			=	HJRS(1)
		 L_SPON_ID2			=	HJRS(2)
		 R_SPON_NAME		=	HJRS(3)
		 R_SPON_ID1			=	HJRS(4)
		 R_SPON_ID2			=	HJRS(5)
		 TOTAL_SPON_NUMBER  =	HJRS(6)		'총후원조직 인원
	END If
	Call closeRS(HJRS)

'	L_SPON_ID = L_SPON_ID1&"-"&Fn_MBID2(L_SPON_ID2)
'	R_SPON_ID = R_SPON_ID1&"-"&Fn_MBID2(R_SPON_ID2)
'
'	If IsNull(L_SPON_NAME) Or L_SPON_NAME = "" Then
'		L_SPON_NAME = "--"
'		L_SPON_ID = "없음"
'	End If
'
'	If IsNull(R_SPON_NAME) Or R_SPON_NAME = "" Then
'		R_SPON_NAME = "--"
'		R_SPON_ID = "없음"
'	End If


	RegYYYYMM	= Left(Replace(now,"-",""),6)   '201502
	RegYYYYMMDD = Left(Replace(now,"-",""),8)	'20150215
	THIS_MONTH  = Month(nowTime)&"월"

	'후원 좌실적 - 월별 : RegYYYYMM, 오늘 : RegYYYYMMDD
	arrParams = Array(_
		Db.makeParam("@RegYM",adVarChar,adParamInput,8,RegYYYYMMDD), _
		Db.makeParam("@SMBID1",adVarChar,adParamInput,20,L_SPON_ID1), _
		Db.makeParam("@SMBID2",adInteger,adParamInput,0,L_SPON_ID2) _
	)
	L_TOTAL_PV_MONTHLY = Db.execRsData("HJP_SPON_MONTHLY_PV",DB_PROC,arrParams,DB3)

	'후원 우실적 - 월별 : RegYYYYMM, 오늘 : RegYYYYMMDD
	arrParams = Array(_
		Db.makeParam("@RegYM",adVarChar,adParamInput,8,RegYYYYMMDD), _
		Db.makeParam("@SMBID1",adVarChar,adParamInput,20,R_SPON_ID1), _
		Db.makeParam("@SMBID2",adInteger,adParamInput,0,R_SPON_ID2) _
	)
	R_TOTAL_PV_MONTHLY = Db.execRsData("HJP_SPON_MONTHLY_PV",DB_PROC,arrParams,DB3)


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="member.css" />
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=CS_PV%> 현황</div>

<div id="member" class="member_modify">
	<table <%=tableatt%> class="width100">
		<col width="50%" />
		<col width="50%" />
		<tr>
			<th colspan="2">나의 총 <%=CS_PV%></th>
		</tr><tr>
			<td colspan="2" class="tcenter tweight red" ><%=num2cur(MY_TOTAL_PV)%><%=CS_PV%></td>
		</tr><tr>
			<th colspan="2">금일 하위매출 <%=CS_PV%> 발생현황</th>
		</tr><tr>
			<th class="th2" style="border-right:1px solid #ccc;">금일 나의 좌측 <%=CS_PV%></th>
			<th>금일 나의 우측 <%=CS_PV%></th>
		</tr><tr>
			<td class="tright tweight blue"><%=num2cur(L_TOTAL_PV_MONTHLY)%><%=CS_PV%></td>
			<td class="tright tweight blue"><%=num2cur(R_TOTAL_PV_MONTHLY)%><%=CS_PV%></td>
		</tr>
	</table>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->