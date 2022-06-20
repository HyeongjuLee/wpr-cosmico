<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"

	Call FNC_ONLY_CS_MEMBER()


	schType = gRequestTF("stype", False)					'strScheduleType 추가

	ptype = ""
	ptype = gRequestTF("ptype", False)		'달력형, LIST형

	dates = gRequestTF("dates", False)
	syear = Left(dates,4)
	smonth = Mid(dates,6,2)
	sDate = Right(dates,2)


	'nowParams = "syear="&syear&"&smonth="&smonth
	nowParams = "syear="&syear&"&smonth="&smonth&"&stype="&schType


	'엘라이프2017 모바일 일정관리(2017-03-29)
	Select Case schType
		Case "oneday"
			SCHEDULE_TYPE_TXT = LNG_SCHEDULE_01
		Case "success"
			SCHEDULE_TYPE_TXT = LNG_SCHEDULE_02
		Case Else
		Call ALERTS(LNG_BOARD_LIST_TEXT02,"BACK","")
	End Select

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" type="text/css" href="schedule.css" />
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="scheduler" class="scheduler01">
	<div id="subTitle" class="width100 tcenter text_noline" ><%=SCHEDULE_TYPE_TXT%></div>
	<div id="mBtn" class="width100" style="margin:10px 0px;">
		<div class="fleft width100 btnList">
			<span class="fleft date" style="width:60%;"><%=syear%>.<%=Right("00"&smonth,2)%>.<%=sDate%></span>
			<span class="fleft" style="width:40%;"><a class="green" href="schedule<%=ptype%>.asp?<%=nowParams%>" data-ajax="false"><%=LNG_SCHEDULE_TEXT03_M%></a></span>
		</div>
	</div>
	<div id="listUp">
		<table <%=tableatt%> class="width100">
			<col width="70" />
			<col width="*" />

			<%
				arrParams3 = Array(_
					Db.makeParam("@Date",adVarChar,adParamInput,10,dates) ,_
					Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(LANG)), _
					Db.makeParam("@schType",adVarChar,adParamInput,30,schType) _
				)
				arrList3 = Db.execRsList("DKP_DIARY_DATE_LIST",DB_PROC,arrParams3,listLen3,Nothing)
				prevDate = ""
				prevLoca = ""
				If IsArray(arrList3) Then
					For i = 0  To listLen3
						arrList3_intIDX				= arrList3(0,i)
						arrList3_Date				= arrList3(1,i)
						arrList3_StartTime			= arrList3(2,i)
						arrList3_EndTime			= arrList3(3,i)
						arrList3_strSubject			= arrList3(4,i)
						arrList3_Place				= arrList3(5,i)
						arrList3_strContent			= arrList3(6,i)
						arrList3_RegDate			= arrList3(7,i)
						arrList3_strUserID			= arrList3(8,i)
						arrList3_strloctype			= arrList3(9,i)
			%>
			<tr>
				<!-- <td colspan="2" class="colspanTD"><%=(arrList3_strUserID)%> - <%=arrList3_strSubject%></td> -->
				<td colspan="2" class="colspanTD tcenter"><%=arrList3_strSubject%></td>
			<tr><tr>
				<td><%=LNG_SCHEDULE_TEXT10%></td>
				<td><%=arrList3_StartTime%> ~ <%=arrList3_EndTime%></td>
			</tr><tr>
				<td><%=LNG_SCHEDULE_TEXT11%></td>
				<td><%=arrList3_Place%></td>
			</tr><tr>
				<td><%=LNG_SCHEDULE_TEXT12%></td>
				<td><%=arrList3_strContent%></td>
			</tr><tr>
				<td colspan="2" class="spaceTD"></td>
			</tr>
			<%

					Next
				End If
			%>
		</table>
	</div>
	<!-- <div class="cleft width100 backBtn"><a href="schedule.asp?<%=nowParams%>" data-ajax="false" type="button" data-theme="w">일정표로 돌아가기</a></div> -->

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->
