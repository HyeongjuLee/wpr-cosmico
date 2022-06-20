<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->
<%
	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 200

	SponID1		= Trim(pRequestTF("SponID1",True))
	SponID2		= Trim(pRequestTF("SponID2",True))
	SponIDChk	= Trim(pRequestTF("SponIDChk",True))

'	Call ResRW(SponID1,"SponID1")
'	Call ResRW(SponID2,"SponID2")
'	Call ResRW(SponIDChk,"SponIDChk")

	If SponID1 = "" Or SponID2 = "" Then Call ALERTS(LNG_JS_SPONSOR&"1","BACK","")
	If SponIDChk <> "T" Then Call ALERTS(LNG_JS_SPONSOR&"2","BACK","")


	'▣▣▣GNG 후원인선택 (추천인의 후원조직중 선택, 20170512)▣▣▣
	arrParams2 = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams2,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_LineCnt			= DKRS("LineCnt")
		RS_N_LineCnt		= DKRS("N_LineCnt")
		RS_Saveid			= DKRS("Saveid")
		RS_Saveid2			= DKRS("Saveid2")
		RS_Top_Save			= DKRS("Top_Save")
		RS_Nominid			= DKRS("Nominid")
		RS_Nominid2			= DKRS("Nominid2")
		RS_LeaveCheck		= DKRS("LeaveCheck")
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)

	'▣승인된 매출 TOTALPV
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	MEMBER_APPROVED_TOTALPV = Db.execRsData("HJP_TOTALPV_APPROVED",DB_PROC,arrParams,DB3)

'	Call ResRW(MEMBER_APPROVED_TOTALPV,"TotalPV")
'	Call ResRW(RS_Nominid,"RS_Nominid")
'	Call ResRW(RS_Nominid2,"RS_Nominid2")

	If RS_Top_Save <> 0 Then Call ALERTS(LNG_POP_SPONSOR_JS03&"!","close","")												'후원인을 등록할 수 없는 회원입니다
	If Sell_Mem_TF <> 0 Then Call ALERTS(LNG_POP_SPONSOR_JS03&".","close","")												'후원인을 등록할 수 없는 회원입니다
	If (RS_Saveid <> "**" And RS_Saveid2 <> 0) Then Call ALERTS(LNG_POP_SPONSOR_JS04,"close","")							'이미 후원인이 등록되었습니다.
	If CDbl(MEMBER_APPROVED_TOTALPV) < CDbl(STANDARD_TOTALPV_4SPONSOR) Then Call ALERTS(LNG_POP_SPONSOR_JS05,"close","")	'후원인을 등록할 수 없습니다. (본인 누적매출 미달)


	'▣후원인 라인FULL 체크
	arrParams1 = Array(_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,SponID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,SponID2) _
	)
	ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
	If ThisDownLeg = "F" Then
		'Call ALERTS("더이상 후원인을 등록할 수 없는 회원입니다. 다시한번 확인해주세요.","BACK","")
		Call ALERTS(LNG_POP_SPONSOR_TEXT11,"BACK","")
	End If


	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@SponID1",adVarChar,adParamInput,20,SponID1), _
		Db.makeParam("@SponID2",adInteger,adParamInput,0,SponID2), _

		Db.makeParam("@Recordtime",adVarChar,adParamInput,50,Recordtime), _
		Db.makeParam("@THISMEMID1",adVarChar,adParamOutput,20,""), _
		Db.makeParam("@THISMEMID2",adInteger,adParamOutput,0,0), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,11,"") _
	)
	Call Db.exec("HJP_UPDATE_SPONSOR",DB_PROC,arrParams,DB3)

	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	THISMEMID1 = arrParams(UBound(arrParams)-2)(4)
	THISMEMID2 = arrParams(UBound(arrParams)-1)(4)


	Select Case OUTPUT_VALUE
		Case "OVERLAPID"	: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT03,"BACK","")
		Case "ERROR"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT05,"BACK","")
		Case "MORESPON"		: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT06,"BACK","")
		Case "FINISH"		: Call ALERTS(LNG_STRTEXT_TEXT03,"o_reloada","/buy/order_list.asp")					'정상처리
		'Case "FINISH"		: Call ALERTS("후원인의 회원번호가 "&THISMEMID1&"-"&Fn_MBID2(THISMEMID2)&"로 변경되었습니다.","o_reloada","/buy/order_list.asp")
		Case Else			: Call ALERTS(LNG_JOINFINISH_U_ALERT_OUTPUT08,"BACK","")
	End Select

%>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>