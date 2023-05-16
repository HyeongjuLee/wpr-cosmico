<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	v = "12.4"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><%=DKCONF_SITE_TITLE%> <%=LNG_MYOFFICE_CHART_02%> <%=LNG_BY_WEBPRO%></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<script src="jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="Oc.js"></script>
<script type="text/javascript" src="calendar.js"></script>
<link rel="stylesheet" href="T_tree_ss_V10.css?v=<%=v%>">
<link rel="stylesheet" href="bootstrap.css">
<!-- <script type="text/javascript" src="T_tree_vt_V10.js?v=<%=v%>"></script> -->
<!--#include file = "T_tree_vt_V11.js.asp"--><%'JS%>
<%

	Call ONLY_CS_MEMBER_CLOSE()


	SEARCH_CHECK = 0

	SDK_MEMBER_ID1 = Request("sid1")
	SDK_MEMBER_ID2 = Request("sid2")
	toStartDate	   = request("toStartDate")
	toEndDate	   = request("toEndDate")

	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2
	If toStartDate = "" Then toStartDate = "" Else SEARCH_CHECK = SEARCH_CHECK + 1 End If
	If toEndDate = "" Then toEndDate = "" Else SEARCH_CHECK = SEARCH_CHECK + 1 End If

'	PRINT DK_MEMBER_ID1
'	PRINT DK_MEMBER_ID2
'	PRINT SDK_MEMBER_ID1
'	PRINT SDK_MEMBER_ID2

	arrParams = Array(_
		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@SDK_MEMBER_ID",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2)_
	)
	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK_VT",DB_PROC,arrParams,DB3))
	If arrChkData < 1 Then
		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
	End If

	cName			= Request("cName")
	cID				= Request("cID")
	cRegdate		= Request("cRegdate")

	cGrade			= Request("cGrade")
	cCenter			= Request("cCenter")
	cSaveInfo		= Request("cSaveInfo")			'Save Info
	cPeriodPV		= Request("cPeriodPV")
	cPeriodCV		= Request("cPeriodCV")
	cPeriodDownPV	= Request("cPeriodDownPV")
	cPeriodDownCV	= Request("cPeriodDownCV")
	cShopURL		= Request("cShopURL")
	cSellMemTF		= Request("cSellMemTF")

	cLvl			= Request("cLvl")
	cZoom			= Request("cZoom")

	If cName		= ""	Then cName 		= 0
	If cID			= ""	Then cID		= 0
	If cRegdate		= ""	Then cRegdate	= 0

	If cGrade		= ""	Then cGrade		= 0
	If cCPoint		= ""	Then cCPoint	= 0		'등급
	If cCenter		= ""	Then cCenter	= 0
	If cSaveInfo		= ""	Then cSaveInfo	= 0
	If cPeriodPV	= ""	Then cPeriodPV  = 0
	If cPeriodCV	= ""	Then cPeriodCV  = 0
	If cPeriodDownPV	= ""	Then cPeriodDownPV  = 0
	If cPeriodDownCV	= ""	Then cPeriodDownCV  = 0
	If cShopURL	= ""	Then cShopURL  = 1
	If cSellMemTF	= ""	Then cSellMemTF  = 0
	If cLvl = "" Then cLvl = 5
	If cZoom = "" Then cZoom = 100


	faTF = False
	SQL_FA = "SELECT [strFavorite] FROM [DKT_TREE_FAVORITE_VOTE] WITH(NOLOCK) WHERE MBID = ? AND MBID2 = ?"
	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
	)
	DKRSD_strFavorite = Db.execRsData(SQL_FA,DB_TEXT,arrParams,DB3)
	'PRINT DKRSD_strFavorite
	If DKRSD_strFavorite <> "" Then
		faTF = True
		S_DKRSD_strFavorite = Split(DKRSD_strFavorite,",")
		U_DKRSD_strFavorite = UBound(S_DKRSD_strFavorite)
	End If

	'PRINT fa
	'PRINT U_DKRSD_strFavorite
	'PRINT DKRSD_strFavorite

	'For FA = 0 To U_DKRSD_strFavorite
	'	PRINT S_DKRSD_strFavorite(FA)
	'Next

	If SEARCH_CHECK > 0 Then SEARCHCSS = "display:block" Else SEARCHCSS = "display:none" End If

	If IS_LIMIT_LEVEL Then
		cLvl = CS_LIMIT_LEVEL
	End IF

	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,cLvl),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,20,toStartDate) ,_
		Db.makeParam("@EDATE",adVarChar,adParamInput,20,toEndDate), _
		Db.makeParam("@v_MaxLvl",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKSP_TREE_VOTER_DETAIL_V11",DB_PROC,arrParams,listLen,DB3)
	MAX_LVL_OUT = arrParams(Ubound(arrParams))(4)

	If IS_LIMIT_LEVEL Then
		If MAX_LVL_OUT > CS_LIMIT_LEVEL Then
			MAX_LVL_OUT = CS_LIMIT_LEVEL
		End If
	End If
%>
<script>
  window.onpageshow = function(event) {
      if ( event.persisted || (window.performance && window.performance.navigation.type == 2)) {
        alert("<%=LNG_TEXT_CHART_MAY_NOT_DISPLAY_PROPERLY%>");
      }
  }
</script>
</head>
<body>
<div class="SearchLayer2">
	<div id="search_wrap">
		<div class="cleft">
			<a href="T_tree_vt_V11.asp" class="a_submit design4"><%=LNG_TEXT_INITIALIZATION%></a>
			<a href="javascript:self.close();" class="a_submit design4"><%=LNG_BTN_CLOSE%></a>
			<a href="javascript:fnCheckSearch();" class="a_submit design8" id="etcBtn"><%=LNG_TEXT_FUNCTION_OPEN%></a>
		</div>
		<div id="search_period" class="cleft" style="<%=SEARCHCSS%>">
			<a href="javascript:fnFaList();" class="a_submit design3"><%=LNG_TEXT_FAVORITE_MEMBER%></a>
			<%If Not IS_LIMIT_LEVEL Then%>
			<a href="javascript:fnUnderList();" class="a_submit design3"><%=LNG_TEXT_UNDER_MEMBER_SEARCH%></a>
			<%End If%>
			<select name="cLvl" class="select" id="cLvl">
				<option value=""   <%=isSelect(cLvl,"")%>><%=LNG_TEXT_LEVEL%></option>
				<%For i = 1 To MAX_LVL_OUT%>
					<option value="<%=i%>"  <%=isSelect(cLvl,i)%>><%=i%></option>
				<%Next%>
			</select>
			<br />

			<input type="button" id="viewM" class="input_submit design4" value="<%=LNG_TEXT_REDUCTION%>" />
			<input type='text' id="nowView" name='nowView' value="<%=cZoom%>%" class='tcenter readonly input_text' size='3' readonly="readonly">
			<input type="button" id="viewP" class="input_submit design1" value="<%=LNG_TEXT_ENLARGEMENT%>" />
			<br />

			<%
				'넘버링 설정
				'① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩
				N_CT = "①"
				N_SI = "②"		'SAVE_MENU_USING 값에 따라 하단 정보 넘버링 수동 정렬~
				N_PV = "②"
				'N_CV = "④"
				N_DPV = "③"
				'N_DCV = "⑥"
				N_GD = "④"
				'N_CP = "⑧"
				N_SM = "⑤"
			%>
			<input type="checkbox" name="cCenter" id="cCenter" value="1" <%=isChecked(cCenter,"1")%>><label for="cCenter"><%=N_CT%><%=LNG_TEXT_CENTER%></label>
			<%If SAVE_MENU_USING Then%>
			<input type="checkbox" name="cSaveInfo" id="cSaveInfo" value="1" <%=isChecked(cSaveInfo,"1")%>><label for="cSaveInfo"><%=N_SI%><%=LNG_TEXT_TREE_SPON_INFO%></label>
			<%End If%>
			<%If PV_VIEW_TF = "T" Then%>
			<input type="checkbox" name="cPeriodPV" id="cPeriodPV" value="1" <%=isChecked(cPeriodPV,"1")%>><label for="cPeriodPV"><%=N_PV%><%=LNG_TEXT_PeriodPV%></label>
			<%End If%>
			<%If BV_VIEW_TF = "T" Then%>
			<input type="checkbox" name="cPeriodCV" id="cPeriodCV" value="1" <%=isChecked(cPeriodCV,"1")%>><label for="cPeriodCV"><%=N_CV%><%=LNG_TEXT_PeriodCV%></label>
			<%End If%>
			<%If PV_VIEW_TF = "T" Then%>
			<input type="checkbox" name="cPeriodDownPV" id="cPeriodDownPV" value="1" <%=isChecked(cPeriodDownPV,"1")%>><label for="cPeriodDownPV"><%=N_DPV%><%=LNG_TEXT_PeriodDownPV%></label>
			<%End If%>
			<%If BV_VIEW_TF = "T" Then%>
			<input type="checkbox" name="cPeriodDownCV" id="cPeriodDownCV" value="1" <%=isChecked(cPeriodDownCV,"1")%>><label for="cPeriodDownCV"><%=N_DCV%><%=LNG_TEXT_PeriodDownCV%></label>
			<%End If%>
			<input type="checkbox" name="cGrade" id="cGrade" value="1" <%=isChecked(cGrade,"1")%>><label for="cGrade"><%=N_GD%><%=LNG_TEXT_POSITION%></label>
			<!-- <input type="checkbox" name="cCPoint" id="cCPoint" value="1" <%=isChecked(cCPoint,"1")%>><label for="cCPoint"><%=N_CP%><%=LNG_TEXT_GRADE%></label> -->
			<input type="checkbox" name="cSellMemTF" id="cSellMemTF" value="1" <%=isChecked(cSellMemTF,"1")%>><label for="cSellMemTF" style="margin-left:14px;"><%=N_SM%><%=LNG_BUSINESS_CONSUMER%>/<%=LNG_MEMBER_IDPW_TEXT06%></label>

			<form name="sfrm" action="T_tree_vt_V11.asp" method="post">
				<input type="hidden" name="sid1" value="<%=SDK_MEMBER_ID1%>" />
				<input type="hidden" name="sid2" value="<%=SDK_MEMBER_ID2%>" />
				<input type="hidden" name="cName" value="1"><!-- <%=LNG_TEXT_NAME%> -->
				<input type="hidden" name="cID" value="1"><!-- <%=LNG_TEXT_ID%> -->
				<input type="hidden" name="cRegdate" value="1"><!-- <%=LNG_TEXT_REGTIME%> -->

				<input type="hidden" name="cCenter"  value="<%=cCenter%>"	>
				<input type="hidden" name="cGrade"  value="<%=cGrade%>"	>
				<input type="hidden" name="cCPoint"  value="<%=cCPoint%>"	>
				<input type="hidden" name="cSaveInfo" value="<%=cSaveInfo%>"	>
				<input type="hidden" name="cPeriodPV" value="<%=cPeriodPV%>" >
				<input type="hidden" name="cPeriodCV" value="<%=cPeriodCV%>" >
				<input type="hidden" name="cPeriodDownPV" value="<%=cPeriodDownPV%>" >
				<input type="hidden" name="cPeriodDownCV" value="<%=cPeriodDownCV%>" >

				<input type="hidden" name="cLvl" value="<%=cLvl%>" >
				<input type="hidden" name="cZoom" id="cZoom" value="<%=cZoom%>" >

				<strong><%=LNG_TEXT_START_DATE%> </strong><input type='text' name='toStartDate' value="<%=toStartDate%>" class='readonly input_text' size='8' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				~
				<strong><%=LNG_TEXT_END_DATE%> </strong><input type='text' name='toEndDate' value="<%=toEndDate%>" class=' input_text readonly' size='8' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				<input type="submit" class="input_submit design1" value="<%=LNG_TEXT_SEARCH%>" />
			</form>
		</div>

			<!-- <label><input type="checkbox" name="cGrade" value="1" class="input_chk vmiddle" <%=isChecked(cGrade,"1")%>><%=LNG_TEXT_POSITION%></label> -->

			<!-- <label><input type="checkbox" name="cShopURL" value="1" class="input_chk vmiddle" <%=isChecked(cShopURL,"1")%>><%=LNG_TEXT_TREE_SHOP_URL%></label> -->
			<!-- <label><input type="checkbox" name="cPeriodUnderPV" value="1" class="input_chk vmiddle" <%=isChecked(cPeriodUnderPV,"1")%>><%=LNG_TEXT_TREE_LOWER_PV%></label> -->

	</div>
	<!--<div id="zoom" style="margin-right:10px;">
		<a href="#" onClick="zoomIn();" onKeyPress="zoomIn();"><img src="zoomin.png" alt="<%=LNG_TEXT_ENLARGEMENT%>" usemap="#index_cs" ></a>
		<a href="#" onClick="zoomOut();" onKeyPress="zoomOut();"><img src="zoomout.png" alt="<%=LNG_TEXT_REDUCTION%>" usemap="#index_cs" ></a>
	</div>
	<div style="float:right; margin-top:4px;margin-right:20px;font-weight:bold;"><a href="https://www.google.com/chrome?hl=ko" target="_blank" />구글 크롬</a>을 이용하시면 빠른 속도로 보실 수 있습니다</div> -->
</div>

<%
	Response.Buffer = True
	Response.Write("<div id=""treeArea"" style='padding-top:60px;'>")
	Response.Write("	<div id='waiting' style='visibility:hidden;'>")
	Response.Write("		<div class='wrap'>")
	Response.Write("			<img src='159.gif' width='60' height='60'>")
	Response.Write("			<div class='alert'>Data Loading<br />"&LNG_TEXT_TAKE_TIME_TO_LOAD&"</div>")
	Response.Write("		</div>")
	Response.Write("	</div>")
	Response.Write("</div>")

	Response.Write("<script type=""text/javascript""> ")
	Response.Write("waiting.style.visibility='visible' ")
	Response.Write("</script>")
	Response.Flush() '여기까지의 내용을 일단 Flush
%>
<ul id="org" style="display:none">
<%
	If IsArray(arrList) Then
		For i = 0 To listLen
			arrList_Mbid			= arrList(0,i)
			arrList_Mbid2			= arrList(1,i)
			arrList_M_Name			= arrList(2,i)
			arrList_WebID			= arrList(3,i)
			arrList_Na_Code			= arrList(4,i)
			arrList_Saveid			= arrList(5,i)
			arrList_Saveid2			= arrList(6,i)
			arrList_SaveName		= arrList(7,i)
			arrList_Nominid			= arrList(8,i)
			arrList_Nominid2		= arrList(9,i)
			arrList_NominName		= arrList(10,i)
			arrList_lvl				= arrList(11,i)
			arrList_Cur				= arrList(12,i)
			arrList_NominCur		= arrList(13,i)			'NominCur
			arrList_RegDate			= arrList(14,i)
			arrList_Leave			= arrList(15,i)
			arrList_BussCode		= arrList(16,i)
			arrList_BussName		= arrList(17,i)
			arrList_PeriodPV		= arrList(18,i)
			arrList_PeriodCV		= arrList(19,i)
			arrList_PeriodDownPV	= arrList(20,i)
			arrList_PeriodDownCV	= arrList(21,i)
			arrList_CurGrade    	= arrList(22,i)
			arrList_Grade_Name		= arrList(23,i)
			arrList_CurPoint		= arrList(24,i)
			arrList_CurP_Name		= arrList(25,i)
			arrList_LastOrder		= arrList(26,i)
			arrList_ConnectTF		= 0
			arrList_Url_Add			= ""

			'브라우저 표현범위 제한
			If i >= 1000 Then		'mob 추천
				PRINT "<script>"
				PRINT "	alert('브라우저 표현 범위를 넘어갑니다. \n\n최대대수 ["&arrList_lvl-1&"대] 이하로 선택해주세요.')"
				'PRINT "	document.sfrm.cLvl.value = '"&arrList_lvl-1&"'"
				PRINT "	document.sfrm.cLvl.value = '1' "
				PRINT "	document.sfrm.submit();"
				PRINT "</script>"
				Exit For
			End If

			TrID = arrList_Mbid & arrList_Mbid2
			PaID = arrList_Nominid & arrList_Nominid2	'추천인아이디

			WEBID_TF = "F"
			If WEBID_TF = "T" Then
				viewBoxID = arrList_WebID														'웹아이디 기준
			Else
				viewBoxID = arrList_Mbid&"-"&Fn_MBID2(arrList_mbid2)		'회원번호 기준
			End If

			If arrList_Leave = 1 Then
				'leaveCheck = "정상회원"
				liClass = ""
				leaveTxt = ""
				If arrList_ConnectTF < 1 Then
					nodeBgC = "notConnect"
				Else
					nodeBgC = ""
				End If
			Else
				'leaveCheck = "<span class=""tweight"">탈퇴</span>"
				liClass = "bgs"
				leaveTxt = "["&LNG_TEXT_TREE_RESIGNED_MEMBER&"] "
				'leaveTxt = ""
				If arrList_ConnectTF < 1 Then
					nodeBgC = "notConnect2"
				Else
					nodeBgC = ""
				End If
			End If

			ThisName = Replace(Replace(Replace(Replace(arrList_M_Name,vbcrlf, ""),Chr(13)&Chr(10),""),Chr(13),""),Chr(10),"")

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If arrList_WEBID <> "" Then arrList_WEBID	= objEncrypter.Decrypt(arrList_WEBID)
				On Error GoTo 0
			Set objEncrypter = Nothing

			If cCenter	 = "1" Then cCenter_display = "" Else cCenter_display = "display:none;" End If
			If cSaveInfo = "1" Then cSaveInfo_display = "" Else cSaveInfo_display = "display:none;" End If

			If cPeriodPV = "1" Then cPeriodPV_display = "" Else cPeriodPV_display = "display:none;" End If
			If cPeriodCV = "1" Then cPeriodCV_display = "" Else cPeriodCV_display = "display:none;" End If
			If cPeriodDownPV = "1" Then cPeriodDownPV_display = "" Else cPeriodDownPV_display = "display:none;" End If
			If cPeriodDownCV = "1" Then cPeriodDownCV_display = "" Else cPeriodDownCV_display = "display:none;" End If
			If cGrade	 = "1" Then cGrade_display = "" Else cGrade_display = "display:none;" End If
			If cCPoint	 = "1" Then ccCPoint_display = "" Else ccCPoint_display = "display:none;" End If
			If cSellMemTF	 = "1" Then cSellMemTF_display = "" Else cSellMemTF_display = "display:none;" End If

			'If cShopURL = "1" Then cShopURL_display = "" Else cShopURL_display = "display:none;" End If

			IF arrList_Grade_Name = "" Then arrList_Grade_Name = LNG_STRFUNCDATA_TEXT05 	'	직급 빈값이면 "회원" 표기

			'소비자/판매원
			SQLMI = "SELECT [Sell_Mem_TF] FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [MBID] = ? AND [MBID2] = ?"
			arrParamsWI = Array(_
				Db.makeParam("@MBID1",adVarChar,adParamInput,20,arrList_Mbid), _
				Db.makeParam("@MBID2",adVarChar,adParamInput,20,arrList_Mbid2) _
			)
			Set HJRSMI = Db.execRs(SQLMI,DB_TEXT,arrParamsWI,DB3)
			If Not HJRSMI.BOF And Not HJRSMI.EOF Then
				RS_Sell_Mem_TF = HJRSMI("Sell_Mem_TF")
				Select Case RS_Sell_Mem_TF
					Case "0"
						RS_Sell_Mem_TF = LNG_MEMBER_IDPW_TEXT06		'"판매원"
					Case "1"
						RS_Sell_Mem_TF = LNG_BUSINESS_CONSUMER		'"소비자"
				End Select
			Else
				RS_Sell_Mem_TF = ""
			End If
			Call closeRs(HJRSMI)

			MODAL_DATA = "" & _
				"<input type=""hidden"" name=""mi_mbid1"" value="""&arrList_Mbid&""" />" & _
				"<input type=""hidden"" name=""mi_mbid2"" value="""&arrList_Mbid2&""" />" & _
				"<input type=""hidden"" name=""mi_mname"" value="""&ThisName&"("&arrList_Cur&")"" />" & _
				"<input type=""hidden"" name=""mi_regTime"" value="""&date8to13(arrList_RegDate)&""" />" & _
				"<input type=""hidden"" name=""mi_center"" value="""&arrList_BussName&""" />" &  _
				"<input type=""hidden"" name=""mi_vname"" value="""&arrList_SaveName&""" />" &  _
				"<input type=""hidden"" name=""mi_vid"" value="""&arrList_SaveID&"-"&Fn_MBID2(arrList_SaveID2)&""" />" &  _
				"<input type=""hidden"" name=""mi_meap"" value="""&num2curINT(arrList_PeriodPV)&""" />" &  _
				"<input type=""hidden"" name=""mi_meac"" value="""&num2cur(arrList_PeriodCV)&""" />" &  _
				"<input type=""hidden"" name=""mi_url"" value="""&arrList_Url_Add&""" />" &  _
				"<input type=""hidden"" name=""mi_Grade_Name"" value="""&arrList_Grade_Name&""" />" &  _
				"<input type=""hidden"" name=""mi_webID"" value="""&arrList_WEBID&""" /></a>"
			MODAL_DATA2 = MODAL_DATA & "<input type=""button"" name=""memInfo"" class=""input_submit design3"" value="""&LNG_TEXT_MEMBER_OTHER_INFOS&""" />"
			MODAL_DATA = MODAL_DATA & "</p>"
			MODAL_DATA2 = MODAL_DATA2 & "</p>"


			viewP_cCenter		= "<p class="""&liClass&" cCenter"" style="""&cCenter_display&""">"&N_CT&" :  "&arrList_BussName&"</p>"
			viewP_cSaveInfo_1	= "<p class="""&liClass&" cSaveInfo"" style="""&cSaveInfo_display&""">"&N_SI&" : "&arrList_SaveName&"</p>"
			viewP_cSaveInfo_2	= "<p class="""&liClass&" cSaveInfo"" style="""&cSaveInfo_display&""">"&N_SI&" : "&arrList_SaveID&"-"&Fn_MBID2(arrList_SaveID2)&"</p>"
			viewP_cPeriodPV		= "<p class="""&liClass&" cPeriodPV"" style="""&cPeriodPV_display&""">"&N_PV&" : "&num2cur(arrList_PeriodPV)&"</p>"
			viewP_cPeriodCV		= "<p class="""&liClass&" cPeriodCV"" style="""&cPeriodCV_display&""">"&N_CV&" : "&num2cur(arrList_PeriodCV)&"</p>"
			viewP_cPeriodDownPV	= "<p class="""&liClass&" cPeriodDownPV"" style="""&cPeriodDownPV_display&""">"&N_DPV&" : "&num2cur(arrList_PeriodDownPV)&"</p>"
			viewP_cPeriodDownCV	= "<p class="""&liClass&" cPeriodDownCV"" style="""&cPeriodDownCV_display&""">"&N_DCV&" : "&num2cur(arrList_PeriodDownCV)&"</p>"
			viewP_cGrade		= "<p class="""&liClass&" cGrade"" style="""&cGrade_display&""">"&N_GD&" : "&arrList_Grade_Name&"</p>"
			viewP_cCPoint		= "<p class="""&liClass&" cCPoint"" style="""&ccCPoint_display&""">"&N_CP&" : "&arrList_CurP_Name&"</p>"
			viewP_cSellMemTF		= "<p class="""&liClass&" cSellMemTF"" style="""&cSellMemTF_display&""">"&N_SM&" : "&RS_Sell_Mem_TF&"</p>"		'소비자/판매원
			viewP_cShopURL		= "<p class="""&liClass&" cShopURL"" style="""&cShopURL_display&""">"&printURL&"</p>"

			If i = 0 Then
				If cZoom <> "100" And cZoom <> "70" Then
					PRINT "<li class=""nodess fnodeTop tweight "&nodeBgC&" "&liClass&""" id=""topNodeTop"">"
					PRINT "<p class="""&liClass&"""><a class=""cp memInfoBtn"">"&ThisName&"("&arrList_Cur&")" & _
					MODAL_DATA
					PRINT "<ul id=""T"&TrID&"""></ul></li>"
				Else
					PRINT "<li class=""nodess fnodeTop tweight "&nodeBgC&" "&liClass&""" id=""topNodeTop"">"
					PRINT "<p class="""&liClass&" tweight fa_porel"">"
					If faTF Then
						If FN_IN_ARRAY(arrList_Mbid&arrList_Mbid2,S_DKRSD_strFavorite) = True Then
							PRINT "<a href=""javascript:tree_favorite('"&arrList_Mbid & arrList_Mbid2&"','DEL');"" class=""fa_poabs ofv cp fa"&arrList_Mbid & arrList_Mbid2&"""></a>"
						Else
							PRINT "<a href=""javascript:tree_favorite('"&arrList_Mbid & arrList_Mbid2&"','ADD');"" class=""fa_poabs nfv cp fa"&arrList_Mbid & arrList_Mbid2&"""></a>"
						End If
					Else
						PRINT "<a href=""javascript:tree_favorite('"&arrList_Mbid & arrList_Mbid2&"','ADD');"" class=""fa_poabs nfv cp fa"&arrList_Mbid & arrList_Mbid2&"""></a></p>"
					End If

					PRINT "<p class="""&liClass&"""><a href=""javascript:sFrmSubmit('"&arrList_Nominid&"','"&arrList_Nominid2&"');"">"&LNG_TEXT_TREE_TOP&"</a></p>"
					PRINT "<p class="""&liClass&""">"&leaveTxt&"<a href=""javascript:sFrmSubmit('"&arrList_Mbid&"','"&arrList_Mbid2&"');"">"&viewBoxID&"</a></p>"
					PRINT "<p class="""&liClass&" blue2 oName"">"&LNG_TEXT_NAME&" : "&ThisName&"("&arrList_Cur&")"&"</p>"
					'PRINT "<p class="""&liClass&""">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList_RegDate)&"</p>"

					PRINT viewP_cCenter & viewP_cSaveInfo_1 & viewP_cSaveInfo_2 & viewP_cPeriodPV & viewP_cPeriodCV & viewP_cPeriodDownPV & viewP_cPeriodDownCV & viewP_cGrade & viewP_cCPoint
					PRINT viewP_cSellMemTF

					PRINT "<p class="""&liClass&""" style=""text-align:center;"">" & MODAL_DATA2

					PRINT "<ul id=""T"&TrID&"""></ul></li>"
				End If
			Else
				If cZoom <> "100" And cZoom <> "70" Then
					innerHTML = "<li class=""nodess fnodeSub "&nodeBgC&" "&liClass&""">"
					innerHTML = innerHTML & "<p class="""&liClass&"""><a class=""cp memInfoBtn"">"&ThisName&"("&arrList_Cur&")" & MODAL_DATA
					innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
					trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
				Else
					innerHTML = "<li class=""nodess fnodeSub "&nodeBgC&" "&liClass&""">"
					innerHTML = innerHTML & "<p class="""&liClass&" tweight fa_porel"">"
					If faTF Then
						If FN_IN_ARRAY(arrList_Mbid&arrList_Mbid2,S_DKRSD_strFavorite) = True Then
							innerHTML = innerHTML & "<a href=""javascript:tree_favorite(\'"&arrList_Mbid&arrList_Mbid2&"\',\'DEL\');"" class=""fa_poabs ofv cp fa"&arrList_Mbid&arrList_Mbid2&"""></a>"
						Else
							innerHTML = innerHTML & "<a href=""javascript:tree_favorite(\'"&arrList_Mbid&arrList_Mbid2&"\',\'ADD\');"" class=""fa_poabs nfv cp fa"&arrList_Mbid&arrList_Mbid2&"""></a>"
						End If
					Else
						innerHTML = innerHTML & "<a href=""javascript:tree_favorite(\'"&arrList_Mbid&arrList_Mbid2&"\',\'ADD\');"" class=""fa_poabs nfv cp fa"&arrList_Mbid&arrList_Mbid2&"""></a>"
					End If
					innerHTML = innerHTML & leaveTxt&"<a href=""javascript:sFrmSubmit(\'"&arrList_Mbid&"\',\'"&arrList_Mbid2&"\');"">"&viewBoxID&"</a></p>"
					innerHTML = innerHTML & "<p class="""&liClass&" blue2 tweight oName"">"&LNG_TEXT_NAME&" : "&ThisName&"("&arrList_Cur&")"&"</p>"
					'innerHTML = innerHTML & "<p class="""&liClass&""">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList_RegDate)&"</p>"

					innerHTML = innerHTML &  viewP_cCenter & viewP_cSaveInfo_1 & viewP_cSaveInfo_2 & viewP_cPeriodPV & viewP_cPeriodCV & viewP_cPeriodDownPV & viewP_cPeriodDownCV & viewP_cGrade & viewP_cCPoint
					innerHTML = innerHTML &  viewP_cSellMemTF

					innerHTML = innerHTML & "<p class="""&liClass&""" style=""text-align:center;"">"
					innerHTML = innerHTML & MODAL_DATA2
					innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
					trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
				End If
			End If
		Next
	End If
%>
</ul>
<div id="chart" class="orgChart"></div>
<script type="text/javascript" language="JScript.Encode" >
	//waiting.style.visibility="hidden"		//하단이동
	<%=trees%>

	$(document).ready(function() {
		$('#list-html').text($('#org').html());

		$("#org").bind("DOMSubtreeModified", function() {
			$('#list-html').text('');
			$('#list-html').text($('#org').html());
		});
		switch ($("#cZoom").val()) {
			case "100" :
				$(".jOrgChart").css({"transform":"scale(1)","transform-origin":"top left"});
				//alert("DD");
				break;
			case "70" :
				$(".jOrgChart").css({"transform":"scale(0.7)","transform-origin":"top left"});
				break;
			case "50" :
				$("#chart .node").css({"height":"160px"});
				$("#chart p").css({"display":"block","width":"100%","height":"100%"});
				$("#chart p a").css({"font-size":"24px","display":"block","padding":"68px 0px"});
				$(".jOrgChart").css({"transform":"scale(0.5)","transform-origin":"top left"});
				break;
			case "30" :
				$("#chart .node").css({"height":"160px"});
				$("#chart p").css({"display":"block","width":"100%","height":"100%"});
				$("#chart p a").css({"font-size":"36px","display":"block","padding":"68px 0px"});
				$(".jOrgChart").css({"transform":"scale(0.3)","transform-origin":"top left"});
				break;
			case "10" :
				$("#chart .node").css({"height":"160px"});
				$("#chart p").css({"display":"block","width":"100%","height":"100%"});
				$("#chart p a").css({"font-size":"36px","display":"block","padding":"68px 0px"});
				$(".jOrgChart").css({"transform":"scale(0.1)","transform-origin":"top left"});
				break;
			default :
				$(".jOrgChart").css({"transform":"scale(1)","transform-origin":"top left"});
				break;
		};
		//$("#chart").css({"width":"100%","overflow":"scroll"});
		//$("body").css({"width":$(".jOrgChart").width()+"px"});


		var ftableWidth = $("div.orgChart table:first-child").width();
		var moveWidth = (ftableWidth/2)-($(window).width()/2);
		var ofs = $("#topNodeTop").position().left;

		setTimeout(function() {
			//console.log("ofs" + ofs);
			//console.log("ftableWidth" + ftableWidth);
			//console.log("moveWidth" + (moveWidth / 100) * ($("#cZoom").val()));
			//$("#chart").css({"width":$(window).width()+"px"});
			//	$("html, body").css({"width":$(".jOrgChart > table").width()+"px"}).scrollLeft(2000).delay(300);
			$(".orgChart").animate({scrollLeft : (moveWidth / 100) * ($("#cZoom").val()), scrollTop : 0},50);
			//$("html, body").scrollTop(100);
		},50);

	});

</script>

<!-- Modal 1 S -->
	<div class="modal fade" id="ModalScrollable1" tabindex="-1" role="dialog" aria-labelledby="ModalScrollableTitle1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title tweight" id="ModalScrollableTitle1"><%=LNG_TEXT_FAVORITE_MEMBER_LIST%></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body">
					<table <%=tableatt%> class="width100" id="TableGrid1">
						<!-- <col width="" /> -->
						<col width="" />
						<col width="" />
						<col width="" />
						<thead>
							<tr>
								<th><%=LNG_TEXT_MEMID%></th>
								<!-- <th><%=LNG_TEXT_WEBID%></th> -->
								<th><%=LNG_TEXT_NAME%></th>
								<th><%=LNG_TEXT_FUNCTIONS%></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="3" class="notData"><p><img src="159.gif" alt="" /></p><p style="margin-top:30px;"><%=LNG_TEXT_DATA_LOADING%></p></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
<!-- Modal 1 E -->

<!-- Modal 2 S -->
	<div class="modal fade" id="ModalScrollable2" tabindex="-1" role="dialog" aria-labelledby="ModalScrollableTitle2" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title tweight" id="ModalScrollableTitle2"><%=LNG_TEXT_UNDER_MEMBER_SEARCH%></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-sbody">
					<%=LNG_TEXT_NAME%> <!-- <%=LNG_TEXT_ID%> --> : <input type="text" class="input_text" name="sNameSearch" id="sNameSearch" />
					<input type="button" class="input_submit design1" id="sNameSearchBtn" value="<%=LNG_TEXT_SEARCH%>"  />
				</div>
				<div class="modal-body">
					<table <%=tableatt%> class="width100" id="TableGrid2">
						<!-- <col width="" /> -->
						<col width="" />
						<col width="" />
						<col width="" />
						<thead>
							<tr>
								<th><%=LNG_TEXT_MEMID%></th>
								<!-- <th><%=LNG_TEXT_WEBID%></th> -->
								<th><%=LNG_TEXT_NAME%></th>
								<th><%=LNG_TEXT_FUNCTIONS%></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="3" class="notData"><%=LNG_TEXT_INPUT_SEARCH_WORD%></td>
							</tr>
							<!-- <tr>
								<td colspan="4" class="notData"><p><img src="159.gif" alt="" /></p><p style="margin-top:30px;"><%=LNG_TEXT_DATA_LOADING%></p></td>
							</tr> -->
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
<!-- Modal 2 E -->

<!-- Modal 3 S -->
	<div class="modal fade" id="ModalScrollable3" tabindex="-1" role="dialog" aria-labelledby="ModalScrollableTitle3" aria-hidden="true">
		<input type="hidden" name="hidden_mbid1"	id="hidden_mbid1" value="" />
		<input type="hidden" name="hidden_mbid2"	id="hidden_mbid2" value="" />
		<input type="hidden" name="hidden_mname"	id="hidden_mname" value="" />
		<input type="hidden" name="hidden_regTime"	id="hidden_regTime" value="" />
		<input type="hidden" name="hidden_center"	id="hidden_center" value="" />
		<input type="hidden" name="hidden_vname"	id="hidden_vname" value="" />
		<input type="hidden" name="hidden_vid"		id="hidden_vid" value="" />
		<input type="hidden" name="hidden_meap"		id="hidden_meap" value="" />
		<input type="hidden" name="hidden_meac"		id="hidden_meac" value="" />
		<input type="hidden" name="hidden_url"		id="hidden_url" value="" />
		<input type="hidden" name="hidden_webID"	id="hidden_webID" value="" />
		<input type="hidden" name="hidden_Grade_Name"	id="hidden_Grade_Name" value="" />

		<div class="modal-dialog modal-dialog-scrollable" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title tweight" id="ModalScrollableTitle3"></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body">
					<div class="memInfo">
						<h6 style="border-bottom:1px dashed #dee2e6; padding-bottom:7px;"><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
						<div style="text-align:center;">
							<table <%=tableatt%> class="width100">
								<tr>
									<th><%=LNG_TEXT_MEMID%></th>
									<td class="view_mbid1"></td>

									<th><%=LNG_TEXT_WEBID%></th>
									<td colspan="3" class="view_webID"></td>
								</tr><tr>
									<th><%=LNG_TEXT_NAME%></th>
									<td class="view_mname"></td>

									<th><%=LNG_TEXT_REGTIME%></th>
									<td class="view_regTime"></td>
								</tr>
								<tr>
									<!-- <th><%=LNG_TEXT_POSITION%></th>
									<td class="view_Grade_Name"></td> -->
									<%If PV_VIEW_TF = "T" Then%>
									<th><%=LNG_TEXT_TREE_MY_PV%></th>
									<td colspan="3" class="view_meap"></td>
									<%End If%>
									<!-- <th><%=LNG_TEXT_PeriodCV%></th>
									<td colspan="1" class="view_meac"></td> -->
								</tr>
								<!-- <tr>
									<th><%=LNG_TEXT_TREE_SPON_NAME%></th>
									<td class="view_vname"></td>

									<th><%=LNG_TEXT_TREE_SPON_MEMID%></th>
									<td class="view_vid"></td>
								</tr> -->
							</table>
						</div>
					</div>

					<%If SAVE_MENU_USING Then%>
					<div class="underPV1">
						<h6 style="border-bottom:1px dashed #dee2e6; padding-bottom:7px;"><%=LNG_TEXT_TOTAL_SALES_OF_UNDER_MEMBER%> - <%=LNG_TEXT_SPON%></h6>
						<script type="text/javascript">
							function chgDate(sdate,nDate) {
								var SDATE = $("#SDATE1");
								var EDATE = $("#EDATE1");

								var nowDate = nDate;

								if (sdate != '')
								{
									EDATE.val(nowDate);
									SDATE.val(sdate);

								} else {
									EDATE.val('');
									SDATE.val('');
								}
							}
						</script>
						<%ThisM_1stDate = Left(Date(),8)&"01"'이번달 1일%>
						<div class="memInfo" style="border-bottom: none;">
							<div style="text-align:center;">
								<table <%=tableatt%> class="width100">
									<col width="100" />
									<col width="*" />
									<tr>
										<th class="text_breakword"><%=LNG_TEXT_DATE_SEARCH%></th>
										<td style="padding:6px; 6px;">
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button></span>
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button></span>
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button></span>
											<!-- <span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button></span> -->
											<!-- <span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button></span>
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button></span> -->
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button></span>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div style="text-align:center;">
							<!-- <%=LNG_TEXT_START_DATE%> --> <input type='text' name='SDATE1' id="SDATE1" value="<%=Date()%>" class='readonly input_text' style="width:90px;" onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
							~
							<!-- <%=LNG_TEXT_END_DATE%> --> <input type='text' name='EDATE1' id="EDATE1" value="<%=Date()%>" class='input_text readonly' style="width:90px;" onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
							<input type="button" class="input_submit design1" value="<%=LNG_TEXT_SEARCH%>" onclick="fnMemberInfo1();" />
						</div>
						<div class="width100" id="PURCHASE1" style="margin-top: 10px;">


						</div>
					</div>
					<!-- <div class="underPV2">
						<h6 style="border-bottom:1px dashed #dee2e6; padding-bottom:7px;">하선 매출 내역 - 후원 (이월)</h6>
						<div style="text-align:center;">
							날짜검색 <input type='text' name='SDATE2' id="SDATE2" value="<%=Date()%>" class='readonly input_text' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
							<input type="submit" class="input_submit design1" value="검색" onclick="fnMemberInfo2();" />
						</div>
						<div class="width100" id="PURCHASE2" style="height:196px; border:1px solid #cdcdcd; padding:20px 0px; margin-top:7px;">

						</div>
					</div> -->
					<%End If%>
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
<!-- Modal 3 E -->
<script src="bootstrap.bundle.min.js"></script>
<script>
	waiting.style.visibility="hidden"
</script>
</body>
</html>
<%Response.Flush()%>
