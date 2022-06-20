<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 15
	If PAGE = "" Then PAGE = 1


	'하선기준회원 검색
	UnderID1 		= pRequestTF("UnderID1",False)
	UnderID2 		= pRequestTF("UnderID2",False)
	UnderName 		= pRequestTF("UnderName",False)
	M_Name 			= pRequestTF("M_Name",False)
	SearchCate 		= pRequestTF("SearchCate",False)
	SDATE 			= pRequestTF("SDATE",False)
	EDATE 			= pRequestTF("EDATE",False)
	viewID 			= pRequestTF("viewID",False)
	v_LEVEL			= pRequestTF("v_LEVEL",False)
	v_Sell_Mem_TF   = pRequestTF("v_Sell_Mem_TF",False)
	v_LeaveCheck    = pRequestTF("v_LeaveCheck",False)
	v_CurGrade      = pRequestTF("v_CurGrade",False)
	businesscode    = pRequestTF("businesscode",False)

	If UnderID1 = "" Then UnderID1 = DK_MEMBER_ID1
	If UnderID2 = "" Then UnderID2 = DK_MEMBER_ID2
	If UnderName = "" Then UnderName = DK_MEMBER_NAME
	If SearchCate = "" Then SearchCate = "03"

	If UnderID1 <> "" And UnderID2 <> "" Then
		ori_UnderID1 = UnderID1		'Ajax Paging
		ori_UnderID2 = UnderID2		'Ajax Paging

		'검색한 본인하선회원외 회원정보조회 방지!!
		'회원번호 위변조체크 #1
		If UnderID1 <> DK_MEMBER_ID1 Or Cstr(UnderID2) <> Cstr(DK_MEMBER_ID2)  Then
			' 본인이 아닐 경우 뒷자리 숫자로 변조체크(비암호화) / 초기화
			If Len(UnderID1) < 10 Or (IsEmpty(UnderID2) = false And IsNumeric(UnderID2) = true) Then
				UnderID1 = ""
				UnderID2 = ""
			End If
		End If
		On Error Resume Next
		Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
			If UnderID1 <> "" Then UnderID1 = Trim(StrCipher.Decrypt(UnderID1,EncTypeKey1,EncTypeKey2))
			If UnderID2 <> "" Then UnderID2 = Trim(StrCipher.Decrypt(UnderID2,EncTypeKey1,EncTypeKey2))
		Set StrCipher = Nothing
		On Error GoTo 0
		'회원번호 위변조체크 #2
		'복호화값 변조체크 / 초기화
		If Len(UnderID1)> 2 Or Len(UnderID2) > 8 Then
			UnderName = ""
			UnderID1 = ""
			UnderID2 = ""
		End if

	End If

%>
<%
	'라인분기
	LINE_CNT    = pRequestTF("LINE_CNT",False)

	'본인 직후원 정보
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,UnderID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,UnderID2) _
	)
	Set HJRS = Db.execRs("HJP_UNDER_INFO",DB_PROC,arrParams,DB3)
	If Not HJRS.BOF And Not HJRS.EOF Then
		L_SAVENAME	=	HJRS(0)
		L_SAVEID1	=	HJRS(1)
		L_SAVEID2	=	HJRS(2)
		R_SAVENAME	=	HJRS(3)
		R_SAVEID1	=	HJRS(4)
		R_SAVEID2	=	HJRS(5)
	Else
		L_SAVENAME	=	""
		L_SAVEID1	=	""
		L_SAVEID2	=	0
		R_SAVENAME	=	""
		R_SAVEID1	=	""
		R_SAVEID2	=	0
	END If
	Call closeRS(HJRS)

	Select Case LINE_CNT
		Case "1"
			UnderID1 = L_SAVEID1
			UnderID2 = L_SAVEID2
			UnderName = L_SAVENAME
			BG_COLOR = "#fdfd96;"
			LINE_TEXT = LNG_TEXT_PAY_LINE1
		Case "2"
			UnderID1 = R_SAVEID1
			UnderID2 = R_SAVEID2
			UnderName = R_SAVENAME
			BG_COLOR = "#e8ff88;"
			LINE_TEXT = LNG_TEXT_PAY_LINE2
	End Select

	If UnderName = "" Or UnderID1 = "" Or UnderID2 = "" Then
		UnderMemberInfo = ""
	Else
		UnderMemberInfo = " - <span style=""background: "&BG_COLOR&""">"& UnderName &"("&UnderID1&"-"&UnderID2&")</span>"
	End If

	'조회구분
	'Select Case SearchCate
	'	Case "01" : MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_DIRECT_UNDER_SPON"    '직대후원인
	'	Case "02" : MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_DIRECT_UNDER_VOTER"   '직대추천인
	'	Case "03" : MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_ALL_UNDER_SPON"       '후원조직산하
	'	Case "04" : MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_ALL_UNDER_VOTER"      '추천조직산하
	'	Case Else : MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_DIRECT_UNDER_SPON"
	'End Select
	MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_ALL_UNDER_SPON_0"       '후원조직산하

	arrParams = Array(_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _

		Db.makeParam("@mbid1",adVarChar,adParamInput,20,UnderID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,UnderID2), _
		Db.makeParam("@M_Name",adVarWChar,adParamInput,100,M_Name), _

		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE), _

		Db.makeParam("@LEVEL",adChar,adParamInput,3,v_LEVEL), _

		Db.makeParam("@Sell_Mem_TF",adChar,adParamInput,1,v_Sell_Mem_TF), _
		Db.makeParam("@LeaveCheck",adChar,adParamInput,1,v_LeaveCheck), _
		Db.makeParam("@CurGrade",adVarChar,adParamInput,10,v_CurGrade), _
		Db.makeParam("@businesscode",adVarWChar,adParamInput,20,businesscode), _

		Db.makeParam("@ALL_Count",adInteger,adParamOutput,0,0) _
	)
	arrList =  Db.execRsList(MEMBER_INFOS_PROC,DB_PROC,arrParams,listLen,DB3)
	All_Count = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE))
	End If
%>
<script type="text/javascript">
	$(document).ready(function() {
		var isData = $("#fixedTable td:first").attr("class");
		//console.log(isData);
		if (isData != "notData") {
			$("#fTbl_D<%=LINE_CNT%> tr").each(function(index) {
				var cloneTR = $("<tr></tr>");
				$(this).find("th:lt(2)").clone().appendTo(cloneTR);
				$(this).find("td:lt(2)").clone().appendTo(cloneTR);
				$("#fTbl_O<%=LINE_CNT%>").append(cloneTR);
			});
		}
	});
</script>

	<div id="loadings<%=LINE_CNT%>" class="loadings"><div class="loadingsInner"><img src="<%=IMG%>/159.gif" width="60" alt="" /></div></div>
	<p class="titles lineCnt"><%=LINE_TEXT%> <%=UnderMemberInfo%> <span class="fright">(<%=LNG_TEXT_ALL_OVER%>&nbsp;<%=All_Count%>명)</span></p>
	<%'fixedTableWrap%>
	<div class="fixedTableWrap tcenter">
		<div id="fixedTable">
			<div class="fixedTable_Default">
				<table id="fTbl_D<%=LINE_CNT%>" <%=tableatt%> class="width100">
					<tr>
						<th class="first"><%=LNG_TEXT_LEVEL%></th>
						<th class="second"><%=LNG_TEXT_MEMID%></th>
						<th><%=LNG_LEFT_MEM_INFO_NAME%></th>
						<th><%=LNG_TEXT_REGTIME%></th>
						<th><%=LNG_TEXT_POSITION%></th>
						<th><%=CS_SPON%></th>
						<th><%=CS_NOMIN%></th>
					</tr>
					<%
						If IsArray(arrList) Then
							For i = 0 To listLen
								'ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
								ThisNum 				= arrList(0,i)
								arrList_mbid			= arrList(1,i)
								arrList_mbid2			= arrList(2,i)
								arrList_M_Name			= arrList(3,i)
								arrList_LineCnt	    	= arrList(4,i)
								arrList_N_LineCnt	    = arrList(5,i)
								arrList_businesscode	= arrList(6,i)
								arrList_Regtime		    = arrList(7,i)
								arrList_Saveid		    = arrList(8,i)
								arrList_Saveid2		    = arrList(9,i)
								arrList_Nominid		    = arrList(10,i)
								arrList_Nominid2		= arrList(11,i)
								arrList_LeaveCheck		= arrList(12,i)
								arrList_WebID		    = arrList(13,i)
								arrList_Sell_Mem_TF	    = arrList(14,i)
								arrList_CurGrade	    = arrList(15,i)
								arrList_CenterName		= arrList(16,i)
								arrList_Grade_Name	    = arrList(17,i)
								arrList_SaveName	    = arrList(18,i)
								arrList_NominName	    = arrList(19,i)
								arrList_lvl			    = arrList(20,i)

								If arrList_Grade_Name ="" Then
									arrList_Grade_Name = LNG_STRFUNCDATA_TEXT05
								End if

								'후원/추천 라인
								Select Case SearchCate
									Case "01","03"	: LineCnt = "("&arrList_LineCnt&")"
									Case "02","04"	: LineCnt = "("&arrList_N_LineCnt&")"
									Case Else 		: LineCnt = "("&arrList_LineCnt&")"
								End Select

								PRINT TABS(1) & "	<tr>"
								PRINT TABS(1) & "		<td>"&arrList_lvl&"</td>"
								PRINT TABS(1) & "		<td>"&arrList_mbid&"-"&arrList_mbid2&"</td>"
								PRINT TABS(1) & "		<td>"&arrList_M_Name&" "&LineCnt&"</td>"
								PRINT TABS(1) & "		<td>"&date8to10(arrList_Regtime)&"</td>"
								PRINT TABS(1) & "		<td>"&arrList_Grade_Name&"</td>"
								PRINT TABS(1) & "		<td>"&arrList_SaveName&"("&arrList_Saveid&"-"&arrList_Saveid2&")</td>"
								PRINT TABS(1) & "		<td>"&arrList_NominName&"("&arrList_Nominid&"-"&arrList_Nominid2&")</td>"
								'PRINT TABS(1) & "		<td>"&arrList_CurGrade&"</td>"
								'PRINT TABS(1) & "		<td>"&arrList_CenterName&"</td>"
								PRINT TABS(1) & "	</tr>"
							Next
						Else
							PRINT TABS(1) & "		<tr>"
							PRINT TABS(1) & "			<td colspan=""7"" class=""notData"">"&LNG_TEXT_NO_DATA&"</td>"
							PRINT TABS(1) & "		</tr>"
						End If
					%>
				</table>
			</div>
			<div class="fixedTable_overCell" >
				<table id="fTbl_O<%=LINE_CNT%>" <%=tableatt%> ></table>
			</div>
		</div>
	</div>
	<div class="pagingArea pagingNew3 userCWi 		dth2">
		<%Call Fn_PageList_UnderSpon(PAGE,PAGECOUNT	,ori_UnderID1,ori_UnderID2,UnderName,M_Name,SearchCate ,SDATE,EDATE,viewID ,v_LEVEL,v_Sell_Mem_TF,v_LeaveCheck,v_CurGrade,businesscode,LINE_CNT)%>
	</div>

<%
	' *****************************************************************************
	' Function Name : Fn_PageList_UnderSpon
	' Discription : 산하회원정보 AJAX페이징
	' *****************************************************************************
		Sub Fn_PageList_UnderSpon (ByVal page, ByVal total_page	_
															,ByVal UnderID1, ByVal UnderID2, ByVal UnderName, ByVal M_Name, ByVal SearchCate _
															,ByVal SDATE, ByVal EDATE, ByVal divID _
															,ByVal v_LEVEL, ByVal v_Sell_Mem_TF ,ByVal v_LeaveCheck ,ByVal v_CurGrade ,ByVal businesscodek,LINE_CNT)

			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			first_page = 1

			If next_part > total_page Then next_part = 0
			strPageList = ""
			If pre_part <> 0 Then strPageList = strPageList &"<span><a href=""javascript:fnPageList_underSpon_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&divID&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"','"&LINE_CNT&"'	,'"&first_page&"')""><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span><a href=""javascript:fnPageList_underSpon_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&divID&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"','"&LINE_CNT&"'	,'"&pre_part&"')""><</a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For
				If page_num = ccur(page) Then
					strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
				Else
					strPageList = strPageList & "<span><a href=""javascript:fnPageList_underSpon_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&divID&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"','"&LINE_CNT&"'	,'"&page_num&"')"">" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:fnPageList_underSpon_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&divID&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"','"&LINE_CNT&"'	,'"&next_part&"')"">></a></span>"
			If next_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:fnPageList_underSpon_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&divID&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"','"&LINE_CNT&"'	,'"&total_page&"')"">>></a></span>"

			If total_page <> 0 Then Response.Write strPageList

		End Sub

%>
<script type="text/javascript">
	//산하회원정보 AJAX페이징
	function fnPageList_underSpon_ajax(UnderID1,UnderID2,UnderName,M_Name,SearchCate	,SDATE,EDATE,viewID	,v_LEVEL,v_Sell_Mem_TF,v_LeaveCheck,v_CurGrade,businesscode,LINE_CNT ,ajax_page){

		$.ajax({
			type: "POST"
			,url: "member_UnderSpon_Ajax.asp"
			,beforeSend : function() {
				$("#"+viewID+" .loadings").show();
			}
			,data: {
				"PAGE"			: ajax_page,
				"UnderID1"		: UnderID1,
				"UnderID2"		: UnderID2,
				"UnderName" 	: UnderName,
				"M_Name" 		: M_Name,
				"SearchCate" 	: SearchCate,
				"SDATE"		: SDATE,
				"EDATE"		: EDATE,
				"viewID"		: viewID,
				"v_LEVEL" 		: v_LEVEL,
				"v_Sell_Mem_TF": v_Sell_Mem_TF,
				"v_LeaveCheck" : v_LeaveCheck,
				"v_CurGrade" 	: v_CurGrade,
				"businesscode" : businesscode,
				"LINE_CNT" 	: LINE_CNT		//라인분기
			}
			,success: function(data) {
				$("#"+viewID).html(data);
			}
			,error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
			,complete: function() {
				$("#"+viewID+" .loadings").hide();
			}
		});
	}

</script>
