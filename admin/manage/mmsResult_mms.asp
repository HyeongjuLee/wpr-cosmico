<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<!--#include file = "mmsConfig.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE9-4"

	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	PAGE		= pRequestTF("PAGE",False)
'	PAGESIZE	= pRequestTF("PAGESIZE",False)
	strUserID	= pRequestTF("strUserID",False)
	strMobile	= pRequestTF("strMobile",False)

	If PAGE			= "" Then PAGE = 1
	If PAGESIZE		= "" Then PAGESIZE = 20
	If SDATE		= "" Then SDATE = ""
	If EDATE		= "" Then EDATE = ""
	If strUserID	= "" Then strUserID = ""


	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@TRANID",adVarChar,adParamInput,20,MSG_strComName),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@strDomain",adVarChar,adParamInput,20,strUserID),_
		Db.makeParam("@strMobile",adVarChar,adParamInput,50,strMobile),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_MMS_RESULT_MMS",DB_PROC,arrParams,listLen,DB5)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<link rel="stylesheet" href="mms.css" />
<script type="text/javascript">
<!--

function toggle_mms_td(ids) {
	$(".htbodys").not("#"+ids).css({"display":"none"});
	$("#"+ids).toggle();

}

//-->
</script>
<script type="text/javascript" src="/jscript/calendar.js"></script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="sms" class="">
<div id="sms" class="list">
	<form name="dateFrm" action="mmsResult_mms.asp" method="post">
		<table <%=tableatt%> class="width100 table1">
			<col width="200" />
			<col width="*" />
			<tr>
				<th>보낸 아이디</th>
				<td><input type='text' name="strUserID" value="<%=strUserID%>" class='input_text' style="width:400px" /></td>
			</tr><tr>
				<th>전송/콜백번호</th>
				<td><input type='text' name="strMobile" value="<%=strMobile%>" class='input_text' style="width:400px" /></td>
			</tr><tr>
				<th>날짜검색</th>
				<td>
					<strong>시작일</strong> : <input type='text' name='SDATE' value="<%=SDATE%>" class='input_text' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" />
					부터
					<strong>종료일</strong> : <input type='text' name='EDATE' value="<%=EDATE%>" class='input_text' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" />
					까지
					<input type="submit" class="input_submit design1" value="검색" />
				</td>
			</tr>
		</table>
	</form>

	<p class="titles">리스트 (총 <%=num2cur(ALL_COUNT)%> 건)</p>
		<table <%=tableatt%> class="width100 list">
			<col width="80" />
			<col width="100" />
			<col width="120" />
			<col width="150" />
			<col width="150" />
			<col width="200" />
			<col width="*" />
			<col width="150" />
			<tr>
				<th>번호</th>
				<th>전송타입</th>
				<th>전송아이디</th>
				<th>전송번호</th>
				<th>콜백번호</th>
				<th>전송일자</th>
				<th>결과값</th>
				<th>기능</th>
			</tr>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						ThisNum				= ALL_COUNT - CInt(arrList(0,i)) + 1
						tran_id				= arrList(1,i)
						tran_refkey			= arrList(2,i)
						tran_phone			= arrList(3,i)
						tran_callback		= arrList(4,i)
						tran_date			= arrList(5,i)
						tran_msg			= arrList(6,i)
						tran_rslt			= arrList(7,i)
						tran_etc1			= arrList(8,i)
						tran_etc2			= arrList(9,i)
						tran_etc3			= arrList(10,i)
						tran_etc4			= arrList(11,i)
						tran_type			= arrList(12,i)
						mms_body			= arrList(13,i)
						mms_subject			= arrList(14,i)
						file_type1			= arrList(15,i)
						file_name1			= Replace(arrList(16,i),REAL_PATH("MMS"),VIR_PATH("MMS"))

			%>
			<tr>
				<td><%=ThisNum%></td>
				<td><%=tran_refkey%></td>
				<td><%=tran_etc1%></td>
				<td><%=tran_phone%></td>
				<td><%=tran_callback%></td>
				<td><%=tran_date%></td>
				<td><%=SMS_STATUS(tran_rslt)%></td>
				<td><span class="button medium" style="margin-top:-3px;"><a href="javascript:toggle_mms_td('tr<%=i%>');">상세보기</a></span></td>
			</tr>
			<tbody id="tr<%=i%>" style="display:none;" class="htbodys">
				<tr>
					<th colspan="2">MMS 제목</th>
					<td colspan="6" class="tleft"><%=mms_subject%></td>
				</tr><tr>
					<th colspan="2">MMS 내용</th>
					<td colspan="6" class="tleft lheight18px"><%=convSql(mms_body)%></td>
				</tr><tr>
					<th colspan="2">MMS 첨부</th>
					<td colspan="6" class="tleft lheight18px"><a href="<%=file_name1%>" target="_blank"><%=file_name1%></a></td>
				</tr>
			</tbody>
			<%		Next
				Else
			%>
			<tr>
				<td colspan="8" class="notData"></td>
			</tr>
			<%	End If%>
		</table>
	</div>
	<div class="paging_area">
		<%Call pageList(PAGE,PAGECOUNT)%>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
			<input type="hidden" name="SDATE" value="<%=SEARCHTERM%>" />
			<input type="hidden" name="EDATE" value="<%=convSql(SEARCHSTR)%>" />
			<input type="hidden" name="strUserID" value="<%=strUserID%>" />
		</form>
	</div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
