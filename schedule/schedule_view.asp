<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = 3
	mNum = 4

	param = gRequestTF("param",True)


	If Not IsDate(date8to10(param)) Then
		Call ALERTS("데이터값이 올바르지 않습니다.","BACK","")
	Else
		param = date8to10(param)
	End If

'	print param

	arrParams = Array(_
		Db.makeParam("@DATE",adVarChar,adParamInput,10,param)_
	)
	arrList = Db.execRsList("DKP_SCHEDULER_DATE_LIST",DB_PROC,arrParams,listLen,Nothing)


	ThisDate = Year(param)&"년 "&Right("00"&Month(param),2)&"월 "&Right("00"&Day(param),2)&"일"

%>
<!--#include virtual = "/_include/document.asp"-->

<link rel="stylesheet" href="schedule.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->

<div id="schedule" class="dateList">
<p><%=viewImg(IMG_CONTENT&"/customer_03_tit.jpg",780,140,"")%></p>
	<h2><%=ThisDate%> 일정표</h2>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
				PRINT TABS(1)& "	<div class=""dlist"">"
				PRINT TABS(1)& "		<p class=""title"">"&backword(arrList(4,i))&"</p>"
				PRINT TABS(1)& "		<table "&tableatt&" class=""userCWidth"">"
				PRINT TABS(1)& "			<col width=""180"">"
				PRINT TABS(1)& "			<col width=""700"">"
				PRINT TABS(1)& "			<tr>"
				PRINT TABS(1)& "				<th>일정명</th>"
				PRINT TABS(1)& "				<td>"&backword(arrList(4,i))&"</td>"
				PRINT TABS(1)& "			</tr><tr>"
				PRINT TABS(1)& "				<th>일자/시간</th>"
				PRINT TABS(1)& "				<td>"&ThisDate&" / "&arrList(2,i)&" 부터 "&arrList(3,i)&" 까지</td>"
				PRINT TABS(1)& "			</tr><tr>"
				PRINT TABS(1)& "				<th>장소</th>"
				PRINT TABS(1)& "				<td>"&arrList(5,i)&"</td>"
				PRINT TABS(1)& "			</tr><tr>"
				PRINT TABS(1)& "				<th>일정내용</th>"
				PRINT TABS(1)& "				<td class=""lheight160"">"&arrList(6,i)&"</td>"
				PRINT TABS(1)& "			</tr>"
				PRINT TABS(1)& "		</table>"
			Next
		Else
			PRINT TABS(1)& "	<div class=""notSchedule"">"
			PRINT TABS(1)& "		등록된 일정이 없습니다."
			PRINT TABS(1)& "	</div>"
		End If
	%>
	<div class="btn_area tcenter"><%=aImg("schedule.asp?syear="&Year(param)&"&amp;smonth="&Month(param),"./images/btn_schedule_return_list.gif",200,42,"")%></div>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
