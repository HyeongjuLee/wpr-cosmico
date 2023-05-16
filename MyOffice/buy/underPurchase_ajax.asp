<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	'하선구매내역 AJAX처리

	SDATE = pRequestTF_AJAX("SDATE",False)
	EDATE = pRequestTF_AJAX("EDATE",False)

	'underType = pRequestTF_AJAX("underType",True)
	underType = Right(PreviousURL,1)
	Select Case LCase(underType)
		Case "v"
			UNDER_MEMBER_PROC = "DKP_VOTER_MEMBER"
			UNDER_PURCHASE_SUMS_PROC = "HJP_VOTER_PURCHASE_SUMS"
			LNG_NO_UNDER_MEMBER_TEXT = LNG_CS_VOTERPURCHASE_TEXT21
		Case "s"
			UNDER_MEMBER_PROC = "DKP_SAVE_MEMBER"
			UNDER_PURCHASE_SUMS_PROC = "HJP_SAVE_PURCHASE_SUMS"
			LNG_NO_UNDER_MEMBER_TEXT = LNG_CS_SPONSPURCHASE_TEXT19
		Case Else
			Response.End
	End Select

	'하선기준회원 검색
	iniValue = pRequestTF("iniValue",False)
	If iniValue = "" Then iniValue = "1"

	Select Case iniValue
		Case "1"	'검색
			UnderID1 = pRequestTF("UnderID1",False)
			UnderID2 = pRequestTF("UnderID2",False)
			UnderName = pRequestTF("UnderName",False)
			SELLCODE = pRequestTF("SELLCODE",False)
			sLvl = pRequestTF("sLvl",False)

			'하선회원 외 검색 방지 암/복호화
			On Error Resume Next
			Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
				If UnderID1 <> "" Then UnderID1 = Trim(StrCipher.Decrypt(UnderID1,EncTypeKey1,EncTypeKey2))
				If UnderID2 <> "" Then UnderID2 = Trim(StrCipher.Decrypt(UnderID2,EncTypeKey1,EncTypeKey2))
			Set StrCipher = Nothing
			On Error GoTo 0

		Case "2"	'초기화
			UnderID1 = DK_MEMBER_ID1
			UnderID2 = DK_MEMBER_ID2
			UnderName = DK_MEMBER_NAME
			SDATE = ""
			EDATE = ""
			SELLCODE = ""
			sLvl = ""
			PRINT "<script>"
			PRINT "	$('#SDATE').val(''); "
			PRINT "	$('#EDATE').val(''); "
			PRINT "	$('#UnderID1').val('"&UnderID1&"'); "
			PRINT "	$('#UnderID2').val('"&UnderID2&"'); "
			PRINT "	$('#UnderName').val('"&UnderName&"'); "
			PRINT "	$('#SELLCODE').val(''); "
			PRINT "	$('#sLvl').val(''); "
			PRINT "</script>"
	End Select

	'If DK_MEMBER_NAME = "" Or UnderID1 = "" Or UnderID2 = "" Then
	'	UnderMemberInfo = ""
	'Else
	'	'UnderMemberInfo = " - <span style=""background: #fdfd96;"">"& UnderName &"("&UnderID1&"-"&UnderID2&")</span>"
	'	UnderMemberInfo = " - <span style=""background: #fdfd96;"">"& UnderName &"</span>"
	'End If
%>

	<div>
		<p class="titles"><%=LNG_TEXT_LIST%> <%=UnderMemberInfo%></p>
		<table <%=tableatt%> class="table">
			<colgroup>
				<col width="18%" />
				<col width="20%" />
				<col width="6%" />
				<col width="6%" />
				<col width="20%" />
				<col width="20%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th><%=LNG_TEXT_MEMID%></th>
					<th><%=LNG_TEXT_NAME%>
					<!-- <th><%=LNG_MEMBER_LOGIN_TEXT12%></th> -->
					<th><%=LNG_TEXT_LEVEL%></th>
					<th><%=LNG_TEXT_LINE%></th>
					<th><%=LNG_TEXT_NORMAL%></th>
					<th><%=LNG_TEXT_RETURN%></th>
					<th><%=LNG_BTN_DETAIL%></th>
				</tr>
			</thead>
			<%
				TOT_SUMPV_P		= 0
				TOT_SUMPV_M		= 0
				TOT_SUMCV_P		= 0
				TOT_SUMCV_M		= 0
				TOT_SUMPrice_P	= 0
				TOT_SUMPrice_M	= 0

				arrParams = Array(_
					Db.makeParam("@mbid",adVarChar,adParamInput,20,UnderID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,0,UnderID2) _
				)
				arrList = Db.execRsList(UNDER_MEMBER_PROC,DB_PROC,arrParams,listLen,DB3)
				If IsArray(arrList) Then
					For i = 0 To listLen
						arr_mbid			= arrList(0,i)
						arr_mbid2			= arrList(1,i)
						arr_M_name			= arrList(2,i)
						arr_CurGrade		= arrList(3,i)
						arr_N_LineCnt		= arrList(4,i)
						arr_Sell_Mem_TF		= arrList(5,i)

						arrParams = Array(_
							Db.makeParam("@mbid",adVarChar,adParamInput,20,arr_mbid), _
							Db.makeParam("@mbid2",adInteger,adParamInput,0,arr_mbid2), _
							Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
							Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _
							Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,SELLCODE), _
							Db.makeParam("@sLvl",adChar,adParamInput,3,sLvl) _
						)
						Set HJRS = Db.execRs(UNDER_PURCHASE_SUMS_PROC,DB_PROC,arrParams,DB3)
						If Not HJRS.BOF And Not HJRS.EOF Then
							SUMPV_P = HJRS(0)
							SUMPV_M = HJRS(1)
							SUMCV_P = HJRS(2)
							SUMCV_M = HJRS(3)
							SUMPrice_P = HJRS(4)
							SUMPrice_M = HJRS(5)
						Else
							SUMPV_P = 0
							SUMPV_M = 0
							SUMCV_P = 0
							SUMCV_M = 0
							SUMPrice_P = 0
							SUMPrice_M = 0
						End If
						Call closeRS(HJRS)

						Tg_Onclick = "toggle_content('purchase"&i&"');"
						Tg_Onclick = Tg_Onclick &"javascript: underPurchase_ajax_view_N('"&arr_mbid&"','"&arr_mbid2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','underPurchase_detail"&i&"','1','underPurchase_detail.asp');"

			%>
			<tr class="trData">
				<td class="tcenter"><%=arr_mbid%>-<%=Fn_MBID2(arr_mbid2)%></td>
				<td class="tcenter"><%=arr_M_name%></td>
				<!-- <td><%=FN_SELL_MEM_TF(arr_Sell_Mem_TF)%></td> -->
				<td class="tcenter">1</td>
				<td class="tcenter"><%=arr_N_LineCnt%></td>
				<td class="price">
					<%=num2curINT(SUMPrice_P)%><span class="cur1"><%=Chg_CurrencyISO%></span>
					<br /><%=num2curINT(SUMPV_P)%><span class="cur2"><%=CS_PV%></span>
					<!-- <br /><%=num2curINT(SUMCV_P)%><span class="cur2"><%=CS_PV2%></span> -->
				</td>
				<td class="price">
					<%=num2curINT(SUMPrice_M)%><span class="cur1"><%=Chg_CurrencyISO%></span>
					<br /><%=num2curINT(SUMPV_M)%><span class="cur2"><%=CS_PV%></span>
					<!-- <br /><%=num2curINT(SUMCV_M)%><span class="cur2"><%=CS_PV2%></span> -->
				</td>
				<!-- <td><%=arr_CurGrade%></td> -->
				<td class="tcenter">
					<input type="button" class="detail_btn noline" value="<%=LNG_BTN_DETAIL%>" onclick="<%=Tg_Onclick%>" />
				</td>
			</tr>
			<tr style="display: none;" id="purchase<%=i%>">
				<td colspan="7" id="underPurchase_detail<%=i%>" class="underPurchase_detail">
					<div class="loadingUnderbuy" style="text-align: center;">
						<img src="<%=IMG%>/159.gif" width="60" alt=""/>
						<table <%=tableatt%> class="inTable1 width100" class="ins" >
						</table>
					</div>
				</td>
			</tr>
			<%
						TOT_SUMPV_P		= TOT_SUMPV_P + SUMPV_P
						TOT_SUMPV_M		= TOT_SUMPV_M + SUMPV_M
						TOT_SUMCV_P		= TOT_SUMCV_P + SUMCV_P
						TOT_SUMCV_M		= TOT_SUMCV_M + SUMCV_M
						TOT_SUMPrice_P	= TOT_SUMPrice_P + SUMPrice_P
						TOT_SUMPrice_M	= TOT_SUMPrice_M + SUMPrice_M
					Next
			%>
			<tfoot>
				<tr class="trData">
					<th colspan="4"><%=LNG_TEXT_TOTAL%></th>
					<th class="price">
						<%=num2curINT(TOT_SUMPrice_P)%><span class="cur1"><%=Chg_CurrencyISO%></span>
						<br /><%=num2curINT(TOT_SUMPV_P)%><span class="cur2"><%=CS_PV%></span>
						<!-- <br /><%=num2curINT(TOT_SUMCV_P)%><span class="cur2"><%=CS_PV2%></span> -->
					</th>
					<th class="price">
						<%=num2curINT(TOT_SUMPrice_M)%><span class="cur1"><%=Chg_CurrencyISO%></span>
						<br /><%=num2curINT(TOT_SUMPV_M)%><span class="cur2"><%=CS_PV%></span>
						<!-- <br /><%=num2curINT(TOT_SUMCV_M)%><span class="cur2"><%=CS_PV2%></span> -->
					</th>
					<th></th>
				</tr>
			</tfoot>
			<%
				Else
			%>
			<tr>
				<td colspan="7" class="notData"><%=LNG_NO_UNDER_MEMBER_TEXT%></td>
			</tr>
			<%
				End If
			%>
		</table>
	</div>
