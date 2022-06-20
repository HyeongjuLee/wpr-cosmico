<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 10
	If PAGE = "" Then PAGE = 1


	'하선기준회원 검색
	UnderID1 		= pRequestTF("UnderID1",False)
	UnderID2 		= pRequestTF("UnderID2",False)
	UnderName 		= pRequestTF("UnderName",False)
	M_Name 			= pRequestTF("M_Name",False)
	SearchCate 		= pRequestTF("SearchCate",False)
	SDATE 			= pRequestTF("SDATE",False)
	EDATE 			= pRequestTF("EDATE",False)
	v_LEVEL			= pRequestTF("v_LEVEL",False)
	v_Sell_Mem_TF   = pRequestTF("v_Sell_Mem_TF",False)
	v_LeaveCheck    = pRequestTF("v_LeaveCheck",False)
	v_CurGrade      = pRequestTF("v_CurGrade",False)
	businesscode    = pRequestTF("businesscode",False)

	sc = Right(PreviousURL,1)

	If UnderID1 = "" Then UnderID1 = DK_MEMBER_ID1
	If UnderID2 = "" Then UnderID2 = DK_MEMBER_ID2
	If UnderName = "" Then UnderName = DK_MEMBER_NAME
	If SearchCate = "" Then
		If NOM_MENU_USING Then SearchCate = "vd"
		If SAVE_MENU_USING Then SearchCate = "sd"
	End If

	If UnderID1 <> "" And UnderID2 <> "" Then
		ori_UnderID1 = UnderID1
		ori_UnderID2 = UnderID2

		'검색한 본인하선회원외 회원정보조회 방지!!
		'회원번호 위변조체크 #1
		If UnderID1 <> DK_MEMBER_ID1 Or Cstr(UnderID2) <> Cstr(DK_MEMBER_ID2)  Then
			' 본인이 아닐 경우 뒷자리 숫자로 변조체크(비암호화) / 초기화
			If Len(UnderID1) < 10 Or (IsEmpty(UnderID2) = false And IsNumeric(UnderID2) = true) Then
				UnderID1 = ""
				UnderID2 = ""
			End If
		End if
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

	'조회구분
	Select Case SearchCate
		Case "vd" : If NOM_MENU_USING Then MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_DIRECT_UNDER_VOTER"		'직대추천인
		Case "va" : If NOM_MENU_USING Then MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_ALL_UNDER_VOTER"		'추천조직산하
		Case "sd" :	If SAVE_MENU_USING Then	MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_DIRECT_UNDER_SPON"		'직대후원인
		Case "sa" :	If SAVE_MENU_USING Then	MEMBER_INFOS_PROC = "HJP_MEMBER_INFOS_ALL_UNDER_SPON"		'후원조직산하
		Case Else : Response.End
	End Select

	If UnderName = "" Or UnderID1 = "" Or UnderID2 = "" Then
		UnderMemberInfo = ""
	Else
		'UnderMemberInfo = " - <span style=""background: #fdfd96;"">"& UnderName &"("&UnderID1&"-"&UnderID2&")</span>"
		UnderMemberInfo = " - <span style=""background: #fdfd96;"">"& UnderName &"</span>"
	End If
%>
<%'sortTable%>
<link rel="stylesheet" href="/jscript/tablesorter/jquery.wprTablesorter.css">
<script type="text/javascript" src="/jscript/tablesorter/jquery.wprTablesorter.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#sortTable").wprTablesorter({
			firstColFix : true,	//첫번째열 고정
			//firstColasc : true,	//첫번째열 오름차순 여부	//firstColFix=true일 경우 필수값
			noSortColumns : [7]		//정렬안하는 컬럼
		});
	});
</script>
<style>
	.sticky-wrap {
		margin: auto;
		overflow: auto;
		white-space: nowrap;
	}
	.sticky-wrap th:nth-child(1),
	.sticky-wrap td:nth-child(1){
		position: -webkit-sticky;
		position: sticky;
		left: 0px;
		width: 40px;
		min-width: 40px;
	}
	.sticky-wrap th:nth-child(2),
	.sticky-wrap td:nth-child(2){
		position: -webkit-sticky;
		position: sticky;
		left: 0px;
		width: 50px;
		min-width: 50px;
		box-shadow: inset -4px 0px 3px -4px rgba(131, 131, 131, 0.5);
	}
	.sticky-wrap td:nth-child(1) { background: #ffffff; }
	.sticky-wrap td:nth-child(2) { background: #ffffff; }
</style>


	<p class="titles"><%=LNG_TEXT_LIST%> <%=UnderMemberInfo%></p>
	<div class="sticky-wrap">
		<table id="sortTable" <%=tableatt%> class="width100 board">
			<thead>
				<tr>
					<th class="first"><%=LNG_TEXT_NUMBER%> </th>
					<th class="second"><%=LNG_TEXT_MEMID%></th>
					<th><%=LNG_LEFT_MEM_INFO_NAME%></th>
					<th><%=LNG_TEXT_LEVEL%></th>
					<th><%=LNG_TEXT_REGTIME%></th>
					<th><%=LNG_TEXT_POSITION%></th>
					<%If SAVE_MENU_USING Then%>
					<th><%=CS_SPON%></th>
					<%End If%>
					<%If NOM_MENU_USING Then%>
					<th><%=CS_NOMIN%></th>
					<%End If%>
				</tr>
			</thead>
			<%
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
							Case "sd","sa"	: LineCnt = "("&arrList_LineCnt&")"
							Case "vd","va"	: LineCnt = "("&arrList_N_LineCnt&")"
							Case Else 		: LineCnt = "("&arrList_LineCnt&")"
						End Select

						PRINT TABS(1) & "	<tr>"
						PRINT TABS(1) & "		<td>"&ThisNum&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_mbid&"-"&arrList_mbid2&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_M_Name&" "&LineCnt&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_lvl&"</td>"
						PRINT TABS(1) & "		<td>"&date8to10(arrList_Regtime)&"</td>"
						PRINT TABS(1) & "		<td>"&arrList_Grade_Name&"</td>"
						If SAVE_MENU_USING Then
							PRINT TABS(1) & "		<td>"&arrList_SaveName&"("&arrList_Saveid&"-"&arrList_Saveid2&")</td>"
						End If
						If NOM_MENU_USING Then
							PRINT TABS(1) & "		<td>"&arrList_NominName&"("&arrList_Nominid&"-"&arrList_Nominid2&")</td>"
						End If
						'PRINT TABS(1) & "		<td>"&arrList_CenterName&"</td>"
						PRINT TABS(1) & "	</tr>"
					Next
				Else
					PRINT TABS(1) & "		<tr>"
					PRINT TABS(1) & "			<td colspan=""8"" class=""notData"">"&LNG_TEXT_NO_DATA&"</td>"
					PRINT TABS(1) & "		</tr>"
				End If

			%>
		</table>
	</div>


	<div class="pagingArea pagingNew3">
		<%Call Fn_PageList_UnderInfo_Mob(PAGE,PAGECOUNT	,ori_UnderID1,ori_UnderID2,UnderName,M_Name,SearchCate ,SDATE,EDATE ,v_LEVEL,v_Sell_Mem_TF,v_LeaveCheck,v_CurGrade,businesscode)%>
	</div>



<%
	' *****************************************************************************
	' Function Name : Fn_PageList_UnderInfo_Mob
	' Discription : 산하회원정보 AJAX페이징
	' *****************************************************************************
		Sub Fn_PageList_UnderInfo_Mob (ByVal page, ByVal total_page	_
					,ByVal UnderID1, ByVal UnderID2, ByVal UnderName, ByVal M_Name, ByVal SearchCate _
					,ByVal SDATE, ByVal EDATE _
					,ByVal v_LEVEL, ByVal v_Sell_Mem_TF ,ByVal v_LeaveCheck ,ByVal v_CurGrade ,ByVal businesscode)

			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 5 Then

				pageFix  = Fix(page/5)						'소숫점이하제거
				pre_page = Left(pageFix,Len(pageFix))

				If (page Mod 5) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 6
			Else
				pre_part   = ( pre_page * 5 ) -	4
				next_part  = ( pre_page * 5 ) + 6
			End If

			first_page = 1

			If next_part > total_page Then next_part = 0
			strPageList = ""
			'If pre_part <> 0 Then strPageList = strPageList &"<span><a href=""javascript:fnPageList_underinfo_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"'	,'"&first_page&"')""><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span class=""arrow left margin""><a href=""javascript:fnPageList_underinfo_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"'	,'"&pre_part&"')""><i class=""icon-angle-left""></i></a></span>"

			For i=1 To 5
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 5) + i
				End If

				If total_page < page_num Then Exit For
				If page_num = ccur(page) Then
					strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
				Else
					strPageList = strPageList & "<span><a href=""javascript:fnPageList_underinfo_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"'	,'"&page_num&"')"">" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class=""arrow right margin""><a href=""javascript:fnPageList_underinfo_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"'	,'"&next_part&"')""><i class=""icon-angle-right""></i></a></span>"
			'If next_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:fnPageList_underinfo_ajax('"&UnderID1&"','"&UnderID2&"','"&UnderName&"','"&M_Name&"','"&SearchCate&"'	,'"&SDATE&"','"&EDATE&"','"&v_LEVEL&"','"&v_Sell_Mem_TF&"','"&v_LeaveCheck&"','"&v_CurGrade&"','"&businesscode&"'	,'"&total_page&"')"">>></a></span>"

			If total_page <> 0 Then Response.Write strPageList

		End Sub

%>
<script type="text/javascript">
	//산하회원정보 AJAX페이징
	function fnPageList_underinfo_ajax(UnderID1,UnderID2,UnderName,M_Name,SearchCate	,SDATE,EDATE,v_LEVEL,v_Sell_Mem_TF,v_LeaveCheck,v_CurGrade,businesscode ,ajax_page){

		var ch = $("#buy").height();
		$("#loadings").show();
		$("#loadings_lmenu").show();
		$("#loadings").css({"height":ch+"px"});

		$.ajax({
			type: "POST"
			,url: "member_UnderInfo_Ajax.asp"
			,data: {
				 "PAGE"			: ajax_page
				,"UnderID1"		: UnderID1
				,"UnderID2"		: UnderID2
				,"UnderName" 	: UnderName
				,"M_Name" 		: M_Name
				,"SearchCate" 	: SearchCate
				,"SDATE"		: SDATE
				,"EDATE"		: EDATE
				,"v_LEVEL" 		: v_LEVEL
				,"v_Sell_Mem_TF": v_Sell_Mem_TF
				,"v_LeaveCheck" : v_LeaveCheck
				,"v_CurGrade" 	: v_CurGrade
				,"businesscode" : businesscode
			}
			,beforeSend : function() {
				$("#loading").show();
			}
			,success: function(data) {
				$("#AjaxContent").html(data);
				$("#loadings").hide();
				$("#loadings_lmenu").hide();
			}
			,error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
			,complete: function() {
				$("#loading").hide();
			}

		});
	}

</script>

