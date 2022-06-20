<!--#include virtual = "/_lib/strFunc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title><%=DKCONF_SITE_TITLE%> <%=LNG_MYOFFICE_CHART_05%></title>
<script type="text/javascript" src="/jscript/jquery.min.1.7.1.js"></script>
<script type="text/javascript">
	opener.location.href = '/myoffice/member/memberSponsor.asp';
</script>
<link rel="stylesheet" href="/css/common2.css?v1" />
<%


	Call ONLY_CS_MEMBER_CLOSE()
'	DK_MEMBER_ID1 = "ZZ"
'		DK_MEMBER_ID2 = "6412"

	SDK_MEMBER_ID1 = gRequestTF("sid1",False)
	SDK_MEMBER_ID2 = gRequestTF("sid2",False)



	'chk_mbid			= pRequestTF("mbid",False)
	'chk_name			= pRequestTF("chk_name",False)
	chk_regDate			= pRequestTF("chk_regDate",False)
	chk_center			= pRequestTF("chk_center",False)
	chk_grade			= pRequestTF("chk_grade",False)
	chk_sponID			= pRequestTF("chk_sponID",False)
	chk_sponName		= pRequestTF("chk_sponName",False)
	chk_voteID			= pRequestTF("chk_voteID",False)
	chk_voteName		= pRequestTF("chk_voteName",False)
	chk_lastOrder		= pRequestTF("chk_lastOrder",False)
	chk_sumPV			= pRequestTF("chk_sumPV",False)
	chk_datePV			= pRequestTF("chk_datePV",False)
	SDATE				= pRequestTF("SDATE",False)
	EDATE				= pRequestTF("EDATE",False)
	chk_pvColor			= pRequestTF("chk_pvColor",False)
	chkPV				= pRequestTF("chkPV",False)

	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2
	If SDATE = "" Then SDATE = ""
	If EDATE = "" Then EDATE = ""

	chk_name = "T"

'	PRINT DK_MEMBER_ID1
'	PRINT DK_MEMBER_ID2
'	PRINT SDK_MEMBER_ID1
'	PRINT SDK_MEMBER_ID2

'	arrParams = Array(_
'		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
'		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
'		Db.makeParam("@SDK_MEMBER_ID",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
'		Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2)_
'	)
'	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK",DB_PROC,arrParams,DB3))
'	If arrChkData < 1 Then
'		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
'	End If
%>

<link rel="stylesheet" href="P1_E_Tree.css" />
<script type="text/javascript" src="P1_E_Tree.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>

</head>
<body>
<div id="top_line">
	<div id="leftOff"><span class="button large vmiddle" style="margin-top:3px;"><span class="delete"></span><a href="javascript:aaa();"><%=LNG_TEXT_TREE_CLOSE_MENU%></a></span></div>
	<div id="leftOn"><span class="button large vmiddle" style="margin-top:3px;"><span class="add"></span><a href="javascript:bbb();"><%=LNG_TEXT_TREE_OPEN_MENU%></a></span></div>
	<span class="span1"><%=DKCONF_SITE_TITLE%> : <%=LNG_MYOFFICE_CHART_05%></span><span class="span2"><!-- <a href="http://www.webpro.kr" target="_blank"><%=LNG_BY_WEBPRO%></a> --></span>
</div>
<%

	Response.Buffer = true
	Response.Write("<table id='waiting' height='100%' width='100%'" )
	Response.Write("style='position:absolute; visibility:hidden'> ")
	Response.Write("<tr><td align=""center"" style='font-size:9pt; background:#FFFFFF;'>")
	Response.Write("<img src=""/images_kr/159.gif"" width=""128"" height=""128"" alt="""" /><br>")
	Response.Write("<center><span style=""color:black"">Data Loading<br />"&LNG_TEXT_TAKE_TIME_TO_LOAD&"</span></center>")
	Response.Write("</td></tr></table> ")

	Response.Write("<script type=""text/javascript""> ")
	Response.Write("waiting.style.visibility='visible' ")
	Response.Write("</script>")
	Response.Flush() '여기까지의 내용을 일단 Flush

%>


<div id="treeview">
	<ul id="tree">
		<%
			arrParams = Array(_
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
				Db.makeParam("@mbid2",adInteger,adParamInput,4,SDK_MEMBER_ID2),_
				Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
				Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE)_
			)
			arrList = Db.execRsList("DKP_E_TREE_SS_V1",DB_PROC,arrParams,listLen,DB3)

			If IsArray(arrList) Then
				prevLvL = 0
				MaxLvL = 0
				arrLvL = ""

				prevLine = 0
				arrLine = ""
				lineCnt = 0

				For i = 0 To listLen
					arrList_Mbid			= arrList(0,i)
					arrList_Mbid2			= arrList(1,i)
					arrList_idx_Save		= arrList(2,i)
					arrList_idx_Save2		= arrList(3,i)
					arrList_idx_Nomin		= arrList(4,i)
					arrList_idx_Nomin2		= arrList(5,i)
					arrList_M_Name			= arrList(6,i)
					arrList_B_Name			= arrList(7,i)
					arrList_C_Name			= arrList(8,i)
					arrList_lvl				= arrList(9,i)
					arrList_Save_Cur		= arrList(10,i)
					arrList_Level_Cnt		= arrList(11,i)
					arrList_MaxLevel		= arrList(12,i)
					arrList_TGrade			= arrList(13,i)
					arrList_TTGrade			= arrList(14,i)
					arrList_RegDate			= arrList(15,i)
					arrList_TS_Date			= arrList(16,i)
					arrList_TB_Name			= arrList(17,i)
					arrList_TB_Code			= arrList(18,i)
					arrList_TCpno			= arrList(19,i)
					arrList_SumPV			= arrList(20,i)
					arrList_DatePV			= arrList(21,i)
					arrList_TreeCur			= arrList(22,i)
					arrList_LeaveCheck		= arrList(23,i)
					arrList_WEBID			= arrList(24,i)
					arrList_Na_Code			= arrList(25,i)

					dateFlagColor = ""

					If chk_pvColor = "T" Then
						If CLng(arrList_DatePV) < CLng(chkPV) Then
							dateFlagColor = " dateFlagColor"
						End If
					End If


					printTree = ""
					If i = 0 Then Borders = "tweight " Else Borders = "" End If
					If arrList_LeaveCheck = "0" Then
						mLineCss = " mline"
						leaveTxt = "["&LNG_TEXT_TREE_RESIGNED_MEMBER&"]"
						dateFlagColor = " leaveFontColor"
					Else
						mLineCss = ""
						leaveTxt = ""
						dateFlagColor = dateFlagColor
					End If
					printTree = printTree & "<li id="""&arrList_Mbid&arrList_Mbid2&"""><a href=""javascript:nextChild('"&arrList_Mbid&arrList_Mbid2&"');"" class="""&Borders& mLineCss &" minus ""><span class="""&dateFlagColor&""">["&arrList_Save_Cur&"]"&leaveTxt&arrList_Mbid&"-"&Fn_MBID2(arrList_mbid2)

					'If chk_name			= "T" Then	printTree = printTree & " / "& arrList_WEBID
					If chk_name			= "T" Then	printTree = printTree & " / "& arrList_M_Name
					If chk_regDate		= "T" Then	printTree = printTree & " / "& date8to10(arrList_RegDate)
					If chk_center		= "T" Then	printTree = printTree & " / "& arrList_TB_Name
					If chk_grade		= "T" Then	printTree = printTree & " / "& arrList_TTGrade
					If chk_sponID		= "T" Then	printTree = printTree & " / "& arrList_idx_Save&"-"&Fn_MBID2(arrList_idx_Save2)
					If chk_sponName		= "T" Then	printTree = printTree & " / "& arrList_B_Name
					If chk_voteID		= "T" Then	printTree = printTree & " / "& arrList_idx_Nomin&"-"&Fn_MBID2(arrList_idx_Nomin2)
					If chk_voteName		= "T" Then	printTree = printTree & " / "& arrList_C_Name
					If chk_lastOrder	= "T" Then	printTree = printTree & " / "& date8to10(arrList_TS_Date)
					If chk_sumPV		= "T" Then	printTree = printTree & " / "& num2curINT(arrList_SumPV)
					If chk_datePV		= "T" Then	printTree = printTree & " / "& num2curINT(arrList_DatePV)

					printTree = printTree & "</span></a>"


					If i = 0 Then
						Response.Write printTree
						prevLine = prevLine
						arrLine = arrLine
						lineCnt = lineCnt
					Else
						If arrList_lvl < prevLvL Then
							loops = CInt(prevLvl) - CInt(arrList_lvl)
							For j = 1 To loops
								print "</li></ul>"&VbCrLf
							Next
							Response.Write "</li>"&printTree
						ElseIf arrList_lvl = prevLvL Then
							Response.Write "</li>"&printTree
						ElseIf arrList_lvl > prevLvL Then
							Response.Write VbCrlf&"<ul class=""onoff"">"&printTree
						End If


						nowLine = Right(Left(arrList_TreeCur,3),2)
						If nowLine > prevLine Then
							arrLine = arrLine & ","&lineCnt
							lineCnt = 1
						Else
							lineCnt = lineCnt + 1
						End If

						If i = listLen Then arrLine = arrLine & ","&lineCnt

						prevLine = nowLine

					End If
					prevLvL = arrList_lvl

					If MaxLvL < arrList_lvl Then
						arrLvL = arrLvL & ","&arrList_Level_Cnt
						MaxLvL = arrList_lvl
					Else
						MaxLvL = MaxLvL
					End If


				Next
			End If

		%>
		</li>
	</ul>


</div>
<div id="leftMenu">
	<div class="tcenter">
		<span class="button medium vmiddle"><span class="add"></span><a href="javascript:allToggleB();"><%=LNG_TEXT_TREE_EXPAND_ALL%></a></span>
		<span class="button medium vmiddle"><span class="delete"></span><a href="javascript:allToggleH();"><%=LNG_TEXT_TREE_HIDE_ALL%></a></span>
	</div>

	<div class="wraps title"><%=LNG_TEXT_TREE_DETAIL_INFO%></div>
	<div class="wraps chkBox">
		<form name="chkBox" action="P1_E_Tree_ss.asp" method="post">
			<!-- <label><input type="checkbox" class="input_checkbox" name="chk_name" value="T" <%=isChecked(chk_name,"T")%> /> <%=LNG_TEXT_NAME%></label><br /> -->
			<label><input type="checkbox" class="input_checkbox" name="chk_regDate" value="T" <%=isChecked(chk_regDate,"T")%> /> <%=LNG_TEXT_REGTIME%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_center" value="T" <%=isChecked(chk_center,"T")%> /> <%=LNG_TEXT_CENTER%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_grade" value="T" <%=isChecked(chk_grade,"T")%> /> <%=LNG_TEXT_POSITION%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_sponID" value="T" <%=isChecked(chk_sponID,"T")%> /> <%=LNG_TEXT_TREE_SPON_MEMID%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_sponName" value="T" <%=isChecked(chk_sponName,"T")%> /> <%=LNG_TEXT_TREE_SPON_NAME%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_voteID" value="T" <%=isChecked(chk_voteID,"T")%> /> <%=LNG_TEXT_TREE_NOMIN_MEMID%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_voteName" value="T" <%=isChecked(chk_voteName,"T")%> /> <%=LNG_TEXT_TREE_NOMIN_NAME%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_lastOrder" value="T" <%=isChecked(chk_lastOrder,"T")%> /> <%=LNG_TEXT_TREE_FINAL_SALES_DATE%></label><br />
			<label><input type="checkbox" class="input_checkbox" name="chk_sumPV" value="T" <%=isChecked(chk_sumPV,"T")%> /> <%=LNG_TEXT_TREE_FINAL_TOTAL_SALES_PV%></label><br />
			<!-- <label><input type="checkbox" class="input_checkbox" name="chk_sumCV" value="T" <%=isChecked(chk_sumCV,"T")%> /> <%=LNG_TEXT_TREE_FINAL_TOTAL_SALES_PV%></label><br /> -->

			<p style="margin-top:5px; border-top:1px solid #ccc; padding-top:10px;">
				<label><input type="checkbox" class="input_checkbox" name="chk_datePV" value="T" <%=isChecked(chk_datePV,"T")%> /> <%=LNG_TEXT_TREE_FINAL_PERIOD_SALES_PV%></label><br />
				<span class="button small vmiddle" style="margin-right:20px;margin-left:85px;"><span class="calendar"></span><a href="javascript:dateReset();"><%=LNG_TEXT_TREE_DATE_INITIALIZATION%></a></span><br />

				<p style="margin-left:7px; margin-top:10px; line-height:15px;">
				<%=LNG_TEXT_TREE_PERIOD%> : <input type='text' name='SDATE' value="<%=SDATE%>" class='input_text readonly tcenter' style="width: 85px;" onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" />
				<!-- <%=LNG_TEXT_TREE_FROM%> --> ~ <input type='text' name='EDATE' value="<%=EDATE%>" class='input_text readonly tcenter' style="width: 85px;" onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" /> <!-- <%=LNG_TEXT_TREE_TO%> -->
				</p>
				<p style="margin-left:7px; margin-top:10px; line-height:15px;">
				<%=LNG_TEXT_TREE_IN_THE_PERIOD%> <input type='text' name='chkPV' value="<%=chkPV%>" class='input_text readonly' style="width:90px;" <%=ONLYKEYS%> maxlength="9" />
				<label style="line-height:15px;"><%=LNG_TEXT_TREE_DISPLAY_COLOR%> <input type="checkbox" class="input_checkbox" name="chk_pvColor" value="T" <%=isChecked(chk_pvColor,"T")%> /> </label><br />
				</p>
			</p><br />
			<div class="tcenter"><span class="button medium vmiddle"><span class="refresh"></span><input type="submit" value="<%=LNG_TEXT_TREE_REDISPLAY_CHECKED%>" /></span></div>

		</form>
	</div>

	<div class="wraps title"><%=LNG_TEXT_TREE_MEMBER_BY_LINE%></div>
	<div class="tables_wrap spec1">
		<table <%=tableatt%> style="width:260px;">
			<col width="50%" />
			<col width="50%" />
			<tr>
				<td class="tweight tcenter bg1"><%=LNG_TEXT_TREE_LINE%></td>
				<td class="tweight tcenter bg1"><%=LNG_TEXT_TREE_MEMBER_NUMBER%></td>
			</tr>
			<%
				arrLine_s = Split(arrLine,",")
				arrLine_u = Ubound(arrLine_s)
				For j = 2 To arrLine_u
					PRINT "	<tr>"
					PRINT "		<td class=""tcenter bg1"">"&num2cur(j-1)&"</td>"
					PRINT "		<td class=""tright tweight""><span>"&num2cur(arrLine_s(j))&" <!-- 명 --></span></td>"
					PRINT "	</tr>"
				Next
			'arrLvL
			%>

		</table>
	</div>

	<div class="wraps title"><%=LNG_TEXT_TREE_MEMBER_BY_LEVEL%></div>
	<div class="tables_wrap spec1">
		<table <%=tableatt%> style="width:260px;">
			<col width="50%" />
			<col width="50%" />
			<tr>
				<td class="tweight tcenter bg1"><%=LNG_TEXT_TREE_LEVEL%></td>
				<td class="tweight tcenter bg1"><%=LNG_TEXT_TREE_MEMBER_NUMBER%></td>
			</tr>
			<%
				arrLvl_s = Split(arrLvL,",")
				arrLvl_u = Ubound(arrLvl_s)
				For j = 1 To arrLvL_u
					PRINT "	<tr>"
					PRINT "		<td class=""tcenter bg1"">"&num2cur(j+1)&"</td>"
					PRINT "		<td class=""tright tweight""><span>"&num2cur(arrLvl_s(j))&" <!-- 명 --></span></td>"
					PRINT "	</tr>"
				Next
			'arrLvL

			%>
		</table>
	</div>
</div>
<script type="text/javascript" >
	waiting.style.visibility="hidden"

</script>

</body>



</html>
<%Response.Flush()%>
