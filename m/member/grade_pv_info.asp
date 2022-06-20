<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"
	Call FNC_ONLY_CS_MEMBER()


'	1.	직급관련 조회 기능 추가(2015-07-09)
'		A.	마이오피스 보여주기가 체크된 마지막 일일마감일자를 기준으로 직급누적값 표시(확정PV)
'		B.	마지막일일마감 일자 이후부터 검색당일의 하선 매출pv 값을 조회 처리(예상PV)
'			i.	(매출PV - 반품매출PV) 하여 표시
'		C.	누적자격이 없는 회원은 조회 금지
'			i.	본인직급 브론즈(20)이하인 회원은 조회 금지
'			ii.	에러 팝업 메시지 [ “아직 조회가 불가능한 직급입니다” ]

	'SDATE = Left(Date(),8)&"01"		'"2015-05-01"
	EDATE = date()

	G_Standard_Date_After = DateSerial(Left(G_Standard_Date,4), Mid(G_Standard_Date,5,2), Right(G_Standard_Date,2) + 1)


	'직후원 총하선PV -> GV(TotalCV)로 변경(2015-09-02)
	arrParams = Array(_
		Db.makeParam("@SMBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@SMBID2",adInteger,adParamInput,0,DK_MEMBER_ID2) ,_
		Db.makeParam("@SDATE",adVarChar,adParamInput,20,G_Standard_Date_After) ,_
		Db.makeParam("@EDATE",adVarChar,adParamInput,20,EDATE) _
	)
	Set HJRS = Db.execRs("HJP_SPON_PERIOD_PV_LR",DB_PROC,arrParams,DB3)
	If Not HJRS.BOF And Not HJRS.EOF Then
		 L_PERIOD_PV	=	HJRS(0)
		 R_PERIOD_PV	=	HJRS(1)

		 'MY_PERIOD_PV	=	HJRS(0)
		 'L_PERIOD_PV	=	HJRS(1)
		 'R_PERIOD_PV	=	HJRS(2)
	Else
		 L_PERIOD_PV	=	0
		 R_PERIOD_PV	=	0
	END If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/calendar.js"></script>

<script type="text/javascript">
 $(document).ready(
	function() {
		$("tbody.hid_tbody tr:last-child td").css("border-bottom", "2px solid #000");
	});
</script>

</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" >직급관련 누적 정보</div>
<div class="subTitle_s" class="tcenter text_noline" >직급관련 누적 합계</div>
	<div id="order" class="order_list">
		<table <%=tableatt%> class="width100 pays purchase">
			<col width="60" />
			<col width="*" />
			<col width="30%" />
			<col width="30%" />
			<%If nowGradeCnt >= 20 Then		'브론즈(20)이상 직급만 표출(2015-07-09)%>
			<tr>
				<th>구분</th>
				<th>적용일자</th>
				<th>1라인</th>
				<th>2라인</th>
			</tr><tr>
				<th>확정GV</th>
				<td class="tcenter"><%=date8to10(G_Standard_Date)%></td>
				<td class="tweight tright pR15"><%=num2cur(G_Cur_PV_LEFT)%></td>
				<td class="tweight tright pR15"><%=num2cur(G_Cur_PV_RIGTHT)%></td>
			</tr><tr>
				<th>예상GV</th>
				<td class="tcenter"><%=EDATE%></td>
				<td class="tweight tright pR15"><%=num2cur(L_PERIOD_PV)%></td>
				<td class="tweight tright pR15"><%=num2cur(R_PERIOD_PV)%></td>
			</tr><tr>
				<th colspan="2">직급 관련 누적 합계</th>
				<td class="tweight green tright pR15"><%=num2cur(G_Cur_PV_LEFT + L_PERIOD_PV)%></td>
				<td class="tweight blue2 tright pR15"><%=num2cur(G_Cur_PV_RIGTHT + R_PERIOD_PV)%></td>
			</tr>
		<%Else%>
			<tr>
				<td class="tweight red2" style="height:100px;">아직 조회가 불가능한 직급입니다.</td>
			</tr>
		<%End If%>
		</table>
	</div>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->