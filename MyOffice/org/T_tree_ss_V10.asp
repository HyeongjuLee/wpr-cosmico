<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Response.Redirect "T_tree_ss_V11.asp"
	Response.End
	v = "12"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><%=DKCONF_SITE_TITLE%> <%=LNG_MYOFFICE_CHART_01%> by Webpro.kr</title>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">


<script src="jquery-1.10.2.min.js"></script>

<script type="text/javascript" src="Oc.js"></script>
<script type="text/javascript" src="calendar.js"></script>

<link rel="stylesheet" href="T_tree_ss_V10.css?v=<%=v%>">
<link rel="stylesheet" href="bootstrap.css">
<!-- <script type="text/javascript" src="T_tree_ss_V10.js?v=<%=v%>"></script> -->
<!--#include file = "T_tree_ss_V10.js.asp"--><%'JS%>
<%
	Call ONLY_CS_MEMBER_CLOSE()
	'DK_MEMBER_ID1 = "AL"
	'DK_MEMBER_ID2 = "10266298"

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
	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK",DB_PROC,arrParams,DB3))
	If arrChkData < 1 Then
		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
	End If

	cName			= Request("cName")
	cID				= Request("cID")
	cRegdate		= Request("cRegdate")

	cGrade			= Request("cGrade")
	cCenter			= Request("cCenter")
	cNomInfo		= Request("cNomInfo")
	cPeriodPV		= Request("cPeriodPV")
	cPeriodCV		= Request("cPeriodCV")
	cPeriodUnderPV	= Request("cPeriodUnderPV")
	cShopURL		= Request("cShopURL")

	cLvl			= Request("cLvl")
	cZoom			= Request("cZoom")

	If cName		= ""	Then cName 		= 0
	If cID			= ""	Then cID		= 0
	If cRegdate		= ""	Then cRegdate	= 0

	If cGrade		= ""	Then cGrade		= 0
	If cCenter		= ""	Then cCenter	= 0	'Else SEARCH_CHECK = SEARCH_CHECK + 1 End If
	If cNomInfo		= ""	Then cNomInfo	= 0 'Else SEARCH_CHECK = SEARCH_CHECK + 1 End If
	If cPeriodPV	= ""	Then cPeriodPV  = 0 'Else SEARCH_CHECK = SEARCH_CHECK + 1 End If
	If cPeriodCV	= ""	Then cPeriodCV  = 0
	If cPeriodUnderPV	= ""	Then cPeriodUnderPV  = 0
	If cShopURL	= ""	Then cShopURL  = 1
	If cLvl = "" Then cLvl = 5
	If cZoom = "" Then cZoom = 100

	'본인 / 직후원 총하선PV
'	arrParams = Array(_
'		Db.makeParam("@SMBID1",adVarChar,adParamInput,20,SDK_MEMBER_ID1), _
'		Db.makeParam("@SMBID2",adInteger,adParamInput,0,SDK_MEMBER_ID2) ,_
'		Db.makeParam("@SDATE",adVarChar,adParamInput,20,toStartDate) ,_
'		Db.makeParam("@EDATE",adVarChar,adParamInput,20,toEndDate) _
'	)
'	Set HJRS = Db.execRs("HJP_SPON_PERIOD_PV_LR",DB_PROC,arrParams,DB3)
'	If Not HJRS.BOF And Not HJRS.EOF Then
'		 MY_PERIOD_PV		=	HJRS(0)
'		 L_PERIOD_PV		=	HJRS(1)
'		 R_PERIOD_PV		=	HJRS(2)
'	END If


	faTF = False
	SQL_FA = "SELECT [strFavorite] FROM [DKT_TREE_FAVORITE_SPON] WITH(NOLOCK) WHERE MBID = ? AND MBID2 = ?"
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

%>
</head>
<body>
<div class="SearchLayer2">
	<div id="search_wrap">
		<div class="cleft">
			<a href="T_tree_ss_V10.asp" class="a_submit design4"><%=LNG_TEXT_INITIALIZATION%></a>
			<a href="javascript:fnCheckSearch();" class="a_submit design8" id="etcBtn"><!-- 기타검색조건열기 --><%=LNG_TEXT_DATE_SEARCH%></a>

			<a href="javascript:fnFaList();" class="a_submit design3"><%=LNG_TEXT_FAVORITE_MEMBER%></a>
			<a href="javascript:fnUnderList();" class="a_submit design3"><%=LNG_TEXT_UNDER_MEMBER_SEARCH%></a>
			<select name="cLvl" class="select" id="cLvl">
				<option value=""   <%=isSelect(cLvl,"")%>><%=LNG_TEXT_TREE_SELECT_LEVEL%></option>
				<%For i = 5 To 30%>
					<option value="<%=i%>"  <%=isSelect(cLvl,i)%>><%=i%></option>
				<%Next%>
				<option value="50">50</option>
			</select>
			<input type="button" id="viewM" class="input_submit design4" value="<%=LNG_TEXT_REDUCTION%>" />
			<input type='text' id="nowView" name='nowView' value="<%=cZoom%>%" class='tcenter readonly input_text' size='3' readonly="readonly">
			<input type="button" id="viewP" class="input_submit design1" value="<%=LNG_TEXT_ENLARGEMENT%>" />

			<!-- <input type="checkbox" name="cCenter" id="cCenter" value="1" <%=isChecked(cCenter,"1")%>><label for="cCenter" style="margin-left:14px;"><%=LNG_TEXT_CENTER%></label> -->
			<!-- <input type="checkbox" name="cNomInfo" id="cNomInfo" value="1" <%=isChecked(cNomInfo,"1")%>><label for="cNomInfo" style="margin-left:7px;"><%=LNG_TEXT_TREE_NOMIN_INFO%></label> -->
			<input type="checkbox" name="cPeriodPV" id="cPeriodPV" value="1" <%=isChecked(cPeriodPV,"1")%>><label for="cPeriodPV" style="margin-left:7px;"><%=LNG_TEXT_TREE_MY_PRICE%></label>
			<!-- <input type="checkbox" name="cGrade" id="cGrade" value="1" <%=isChecked(cGrade,"1")%>><label for="cGrade" style="margin-left:7px;"><%=LNG_TEXT_POSITION%></label> -->
		</div>
		<div id="search_period" class="cleft" style="<%=SEARCHCSS%>">
			<form name="sfrm" action="T_tree_ss_v10.asp" method="post">
				<input type="hidden" name="sid1" value="<%=SDK_MEMBER_ID1%>" />
				<input type="hidden" name="sid2" value="<%=SDK_MEMBER_ID2%>" />
				<input type="hidden" name="cName" value="1"><!-- <%=LNG_TEXT_NAME%> -->
				<input type="hidden" name="cID" value="1"><!-- <%=LNG_TEXT_ID%> -->
				<input type="hidden" name="cRegdate" value="1"><!-- <%=LNG_TEXT_REGTIME%> -->

				<input type="hidden" name="cCenter"  value="<%=cCenter%>"	>
				<input type="hidden" name="cGrade"  value="<%=cGrade%>"	>
				<input type="hidden" name="cNomInfo" value="<%=cNomInfo%>"	>
				<input type="hidden" name="cPeriodPV" value="<%=cPeriodPV%>" >
				<input type="hidden" name="cLvl" value="<%=cLvl%>" >
				<input type="hidden" name="cZoom" id="cZoom" value="<%=cZoom%>" >

				<strong><%=LNG_TEXT_START_DATE%> </strong><input type='text' name='toStartDate' value="<%=toStartDate%>" class='readonly input_text' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				~
				<strong><%=LNG_TEXT_END_DATE%> </strong><input type='text' name='toEndDate' value="<%=toEndDate%>" class=' input_text readonly' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				<input type="submit" class="input_submit design1" value="<%=LNG_TEXT_SEARCH%>" />
			</form>
		</div>

			<!-- <label><input type="checkbox" name="cGrade" value="1" class="input_chk vmiddle" <%=isChecked(cGrade,"1")%>><%=LNG_TEXT_POSITION%></label> -->

			<!-- <label><input type="checkbox" name="cShopURL" value="1" class="input_chk vmiddle" <%=isChecked(cShopURL,"1")%>><%=LNG_TEXT_TREE_SHOP_URL%></label> -->
			<!-- <label><input type="checkbox" name="cPeriodUnderPV" value="1" class="input_chk vmiddle" <%=isChecked(cPeriodUnderPV,"1")%>><%=LNG_TEXT_TREE_LOWER_PV%></label> -->

	</div>
	<!--<div id="zoom" style="margin-right:10px;">
		<a href="#" onClick="zoomIn();" onKeyPress="zoomIn();"><img src="zoomin.png" alt="<%=LNG_TEXT_ENLARGEMENT%>" usemap="#index_cs" ></a>
		<a href="#" onClick="zoomOut();" onKeyPress="zoomOut();"><img src=zoomout.png" alt="<%=LNG_TEXT_REDUCTION%>" usemap="#index_cs" ></a>
	</div>
	<div style="float:right; margin-top:4px;margin-right:20px;font-weight:bold;"><a href="https://www.google.com/chrome?hl=ko" target="_blank" />구글 크롬</a>을 이용하시면 빠른 속도로 보실 수 있습니다</div> -->
</div>

<%

	Response.Buffer = True
	Response.Write("<div style='padding-top:55px;'>")
	Response.Write("<table id='waiting' height='100%' width='100%'" )
	Response.Write("style='position:absolute; visibility:hidden'> ")
	Response.Write("<tr><td align=""center"" style='font-size:9pt; background:#FFFFFF;'>")
	Response.Write("<img src=""159.gif"" width=""128"" height=""128"" alt="""" /><br>")
	Response.Write("<center><span style=""color:black"">Data Loading<br />"&LNG_TEXT_TAKE_TIME_TO_LOAD&"</span></center>")
	Response.Write("</td></tr></table></div> ")

	Response.Write("<script type=""text/javascript""> ")
	Response.Write("waiting.style.visibility='visible' ")
	Response.Write("</script>")
	Response.Flush() '여기까지의 내용을 일단 Flush

%>
<ul id="org" style="display:none">
<%

'	DK_MEMBER_ID1 = "00"
'	DK_MEMBER_ID2 = 10001

	If cLvl = "" Then cLvl = 5		'default 대수
	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,cLvl),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,20,toStartDate) ,_
		Db.makeParam("@EDATE",adVarChar,adParamInput,20,toEndDate) _
	)
	arrList = Db.execRsList("DKSP_TREE_SPONSOR_DETAIL_NEW",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("DKP_TREE_SPONSOR_DETAIL",DB_PROC,arrParams,listLen,DB3)

	If IsArray(arrList) Then
		For i = 0 To listLen
			arrList_Mbid			= arrList(0,i)
			arrList_Mbid2			= arrList(1,i)
			arrList_M_Name			= arrList(2,i)
			arrList_Saveid			= arrList(3,i)
			arrList_Saveid2			= arrList(4,i)
			arrList_lvl				= arrList(5,i)
			arrList_Cur				= arrList(6,i)
			arrList_CpNumber		= arrList(7,i)
			arrList_RegDate			= arrList(8,i)
			arrList_Nom				= arrList(9,i)
			arrList_Nom2			= arrList(10,i)
			arrList_Leave			= arrList(11,i)
			arrList_BussCode		= arrList(12,i)
			arrList_SaveCur			= arrList(13,i)
			arrList_BGrade			= arrList(14,i)
			arrList_BGrade2			= arrList(15,i)
			arrList_Grade_Name		= arrList(16,i)
			arrList_NomName			= arrList(17,i)
			arrList_BussName		= arrList(18,i)
			arrList_WebID			= arrList(19,i)
			arrList_TotalSumPV		= arrList(20,i)
			arrList_LastOrder		= arrList(21,i)
			arrList_Na_Code			= arrList(22,i)
			arrList_ConnectTF		= arrList(23,i)
			'arrList_Url_Add			= arrList(23,i)
			'arrList_CustomerPV		= arrList(25,i)


			TrID = arrList_Mbid & arrList_Mbid2
			PaID = arrList_Saveid & arrList_Saveid2	'후원인아이디

			viewBoxID = arrList_Mbid & "-" &arrList_Mbid2
			'viewBoxID = arrList_WebID

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
				'leaveCheck = "<span class=""tweight"">"&LNG_TEXT_TREE_RESIGNED_MEMBER&"</span>"
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
			'ThisName = arrList_WebID

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If arrList_WebID <> "" Then arrList_WebID	= objEncrypter.Decrypt(arrList_WebID)
				On Error GoTo 0
			Set objEncrypter = Nothing

			If cCenter	 = "1" Then cCenter_display = "" Else cCenter_display = "display:none;" End If
			If cNomInfo = "1" Then cNomInfo_display = "" Else cNomInfo_display = "display:none;" End If
			If cPeriodPV = "1" Then cPeriodPV_display = "" Else cPeriodPV_display = "display:none;" End If
			If cGrade	 = "1" Then cGrade_display = "" Else cGrade_display = "display:none;" End If
			'If cPeriodUnderPV = "1" Then cPeriodUnderPV_display = "" Else cPeriodUnderPV_display = "display:none;" End If
			'If cShopURL = "1" Then cShopURL_display = "" Else cShopURL_display = "display:none;" End If

			'If arrList_Url_Add <> "" Then
			'	printURL = "<a href="""&HTTPS&"://"&arrList_Url_Add&"."&MAIN_DOMAIN&""" target=""_blank"">"&LNG_TEXT_TREE_SHOP_URL2&"</a>"
			'Else
			'	printURL = "쇼핑몰없음"
			'End If

			viewP01	= "<p class="""&liClass&" view01"" style="""&cCenter_display&""">"&LNG_TEXT_CENTER&" :  "&arrList_BussName&"</p>"
			viewP02_1	= "<p class="""&liClass&" view02"" style="""&cNomInfo_display&""">"&LNG_TEXT_TREE_NOMIN_NAME&" : "&arrList_NomName&"</p>"
			viewP02_2	= "<p class="""&liClass&" view02"" style="""&cNomInfo_display&""">"&LNG_TEXT_TREE_NOMIN_MEMID&" : "&arrList_Nom&"-"&Fn_MBID2(arrList_Nom2)&"</p>"
			viewP03	= "<p class="""&liClass&" view03"" style="""&cPeriodPV_display&""">"&LNG_TEXT_TREE_MY_PRICE&" : "&num2cur(arrList_TotalSumPV)&"</p>"
			viewP04	= "<p class="""&liClass&" view04"" style="""&cGrade_display&""">"&LNG_TEXT_POSITION&" : "&arrList_Grade_Name&"</p>"
			'viewP05	= "<p class="""&liClass&" view05"" style="""&cShopURL_display&""">"&printURL&"</p>"
			'viewP06	= "<p class="""&liClass&" view06"" style="""&cPeriodUnderPV_display&""">"&LNG_TEXT_TREE_LOWER_PV&" : "&num2cur(MY_PERIOD_PV - arrList_TotalSumPV)&"</p>"

			'viewP07	= "<p class="""&liClass&" view07"" style="""&cReqTF2_display&""">"&MY_cReqTF2&"</p>"
			'viewP08	= "<p class="""&liClass&" view08"" style="""&cDirCustomerPV_display&""">"&LNG_TEXT_TREE_Dir_Customer&" : "&num2cur(arrList_CustomerPV)&"</p>"
			'viewP09	= "<p class="""&liClass&" view09"" style="""&cAllCustomerPV_display&""">"&LNG_TEXT_TREE_All_Customer&" : "&num2cur(allCustomverPV-arrList_CustomerPV)&"</p>"
			'viewP10	= "<p class="""&liClass&" view10"" style="""&cOverAllPV_display&""">"&LNG_TEXT_TREE_OverAll&" : "&num2cur(MY_PERIOD_PV - arrList_TotalSumPV + allCustomverPV-arrList_CustomerPV)&"</p>"




			MODAL_DATA = "" & _
				"<input type=""hidden"" name=""mi_mbid1"" value="""&arrList_Mbid&""" />" & _
				"<input type=""hidden"" name=""mi_mbid2"" value="""&arrList_Mbid2&""" />" & _
				"<input type=""hidden"" name=""mi_mname"" value="""&ThisName&"("&arrList_Cur&")"" />" & _
				"<input type=""hidden"" name=""mi_regTime"" value="""&date8to13(arrList_RegDate)&""" />" & _
				"<input type=""hidden"" name=""mi_center"" value="""&arrList_BussName&""" />" &  _
				"<input type=""hidden"" name=""mi_vname"" value="""&arrList_NomName&""" />" &  _
				"<input type=""hidden"" name=""mi_vid"" value="""&arrList_Nom&"-"&Fn_MBID2(arrList_Nom2)&""" />" &  _
				"<input type=""hidden"" name=""mi_meap"" value="""&num2cur(arrList_TotalSumPV)&""" />" &  _
				"<input type=""hidden"" name=""mi_url"" value="""&arrList_Url_Add&""" />" &  _
				"<input type=""hidden"" name=""mi_Grade_Name"" value="""&arrList_Grade_Name&""" />" &  _
				"<input type=""hidden"" name=""mi_webID"" value="""&arrList_WEBID&""" /></a>"
			MODAL_DATA2 = MODAL_DATA & "<input type=""button"" name=""memInfo"" class=""input_submit design3"" value="""&LNG_TEXT_MEMBER_OTHER_INFOS&""" />"
			MODAL_DATA = MODAL_DATA & "</p>"
			MODAL_DATA2 = MODAL_DATA2 & "</p>"



			If i = 0 Then
				If cZoom <> "100" And cZoom <> "70" Then
					PRINT "<li class=""nodess fnodeTop tweight "&nodeBgC&" "&liClass&""" id=""topNodeTop"">"
					PRINT "<p class="""&liClass&"""><a class=""cp memInfoBtn"">"&ThisName&"("&arrList_Cur&")" & MODAL_DATA
					PRINT "<ul id=""T"&TrID&"""></ul></li>"
				Else
					PRINT "<li class=""nodess fnodeTop tweight "&nodeBgC&" "&liClass&""" id=""topNodeTop"">"
					'PRINT "<p class="""&liClass&"""><img src=""/images/nation2/"&arrList_Na_Code&".png"" alt=""""/></p>"
					PRINT "<p class="""&liClass&" tweight fa_porel"">"
					If faTF Then
						If FN_IN_ARRAY(arrList_Mbid&arrList_Mbid2,S_DKRSD_strFavorite) = True Then
							PRINT "<a href=""javascript:tree_favorite('"&arrList_Mbid&arrList_Mbid2&"','DEL');"" class=""fa_poabs ofv cp fa"&arrList_Mbid&arrList_Mbid2&"""></a>"
						Else
							PRINT "<a href=""javascript:tree_favorite('"&arrList_Mbid&arrList_Mbid2&"','ADD');"" class=""fa_poabs nfv cp fa"&arrList_Mbid&arrList_Mbid2&"""></a>"
						End If
					Else
						PRINT "<a href=""javascript:tree_favorite('"&arrList_Mbid&arrList_Mbid2&"','ADD');"" class=""fa_poabs nfv cp fa"&arrList_Mbid&arrList_Mbid2&"""></a></p>"
					End If

					PRINT "<p class="""&liClass&"""><a href=""javascript:sFrmSubmit('"&arrList_Saveid&"','"&arrList_Saveid2&"');"">"&LNG_TEXT_TREE_TOP&"</a></p>"
					PRINT "<p class="""&liClass&""">"&leaveTxt&"<a href=""javascript:sFrmSubmit('"&arrList_Mbid&"','"&arrList_Mbid2&"');"">"&viewBoxID&"</a></p>"
					PRINT "<p class="""&liClass&" blue2 oName"">"&ThisName&"("&arrList_Cur&")"&"</p>"
					'PRINT "<p class="""&liClass&""">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList_RegDate)&"</p>"
					'PRINT "<p class="""&liClass&""">"&LNG_TEXT_NATION&" : "&arrList_Na_Code&"</p>"

					PRINT viewP01 & viewP02_1 & viewP02_2 & viewP03 & viewP04
					'& viewP05 & viewP07 & viewP06 & viewP08 & viewP09 & viewP10



					PRINT "<p class="""&liClass&""" style=""text-align:center;"">" & MODAL_DATA2
					PRINT "<ul id=""T"&TrID&"""></ul></li>"
				End If
			Else
				If cZoom <> "100" And cZoom <> "70" Then
					innerHTML = "<li class=""nodess fnodeSub "&nodeBgC&" "&liClass&""">"
					innerHTML = innerHTML & "<p class="""&liClass&"""><a class=""cp memInfoBtn"">"&ThisName&"("&arrList_Cur&")"& MODAL_DATA

					innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
					trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
				Else
					innerHTML = "<li class=""nodess fnodeSub "&nodeBgC&" "&liClass&""">"
					'innerHTML = innerHTML & "<p class="""&liClass&"""><img src=""/images/nation2/"&arrList_Na_Code&".png"" alt=""""/></p>"
					innerHTML = innerHTML & "<p class="""&liClass&" tweight fa_porel"">"
					If faTF Then
						If FN_IN_ARRAY(arrList_Mbid & arrList_Mbid2,S_DKRSD_strFavorite) = True Then
							innerHTML = innerHTML & "<a href=""javascript:tree_favorite(\'"&arrList_Mbid & arrList_Mbid2&"\',\'DEL\');"" class=""fa_poabs ofv cp fa"&arrList_Mbid & arrList_Mbid2&"""></a>"
						Else
							innerHTML = innerHTML & "<a href=""javascript:tree_favorite(\'"&arrList_Mbid & arrList_Mbid2&"\',\'ADD\');"" class=""fa_poabs nfv cp fa"&arrList_Mbid & arrList_Mbid2&"""></a>"
						End If
					Else
						innerHTML = innerHTML & "<a href=""javascript:tree_favorite(\'"&arrList_Mbid & arrList_Mbid2&"\',\'ADD\');"" class=""fa_poabs nfv cp fa"&arrList_Mbid & arrList_Mbid2&"""></a>"
					End If
					innerHTML = innerHTML & leaveTxt&"<a href=""javascript:sFrmSubmit(\'"&arrList_Mbid&"\',\'"&arrList_Mbid2&"\');"">"&viewBoxID&"</a></p>"
					innerHTML = innerHTML & "<p class="""&liClass&" blue2 tweight oName"">"&ThisName&"("&arrList_Cur&")"&"</p>"
					'innerHTML = innerHTML & "<p class="""&liClass&""">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList_RegDate)&"</p>"
					'innerHTML = innerHTML & "<p class="""&liClass&""">"&LNG_TEXT_NATION&" : "&arrList_Na_Code&"</p>"

					innerHTML = innerHTML &  viewP01 & viewP02_1 & viewP02_2 & viewP03 & viewP04
					'& viewP05 & viewP07 & viewP06 & viewP08 & viewP09 & viewP10

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
	waiting.style.visibility="hidden"
	<%=trees%>

	$(document).ready(function() {
		$('#list-html').text($('#org').html());

		$("#org").bind("DOMSubtreeModified", function() {
			$('#list-html').text('');
			$('#list-html').text($('#org').html());
		});
		switch ($("#cZoom").val()) {
			case "100" :
				$("#chart").css({"transform":"scale(1)"});
				//alert("DD");
				break;
			case "70" :
				$("#chart").css({"transform":"scale(0.7)"});
				break;
			case "50" :
				$("#chart .node").css({"height":"160px"});
				$("#chart p").css({"display":"block","width":"100%","height":"100%"});
				$("#chart p a").css({"font-size":"24px","display":"block","padding":"68px 0px"});
				$("#chart").css({"transform":"scale(0.5)"});
				break;
			case "30" :
				$("#chart .node").css({"height":"160px"});
				$("#chart p").css({"display":"block","width":"100%","height":"100%"});
				$("#chart p a").css({"font-size":"36px","display":"block","padding":"68px 0px"});
				$("#chart").css({"transform":"scale(0.3)"});
				break;
			case "10" :
				$("#chart .node").css({"height":"160px"});
				$("#chart p").css({"display":"block","width":"100%","height":"100%"});
				$("#chart p a").css({"font-size":"36px","display":"block","padding":"68px 0px"});
				$("#chart").css({"transform":"scale(0.1)"});
				break;
			default :
				$("#chart").css({"transform":"scale(1)"});
				break;
		};
		$("body").css({"width":$(".jOrgChart").width()+"px"});


		/*
		.done(function() {
			//$("html, body").css({"width":$(".jOrgChart > table").width()+"px"}).scrollLeft(2000);
			console.log('aaa');
		});
		*/

//		$("html,body").scrollLeft(moveWidth);
//		console.log(ftableWidth);
//		console.log(moveWidth);
		/*
		var ofs = $("#topNodeTop").offset().left;
		$("html,body").scrollLeft(ofs);
		console.log("ofs : " + ofs);
		*/
	//	$("#chart .jOrgChart>table").css({"zoom":"0.2"});
	//	$("#chart .node-cell div").css({"display":"none"});
	//	$("#chart p").not(".oName").text("");
	//	$("#chart a").not(".oName").text("");
	//	$("#chart p.oName").css({"transform":"scale(3)"});
	//	$("#chart .node-cell div").text("");
	//	$("#chart .node-cell div").css({"height":"160px","width":"160px"});
	//	var hheight = $(".jOrgChart").height() / 100 * 20;
	//	var wwwidth = $(".jOrgChart").width() / 100 * 20;
	//	console.log("hh: " + hheight);
	//	console.log("ww: " + wwwidth);

		//console.log($("#cZoom").val());


	//	$("#chart p").text("");
	//	$("#chart a").text("");


		var ftableWidth = $("div.orgChart table:first-child").width();
		var moveWidth = (ftableWidth/2)-($(window).width()/2);
		var ofs = $("#topNodeTop").position().left;

		setTimeout(function() {
			//console.log("ddd");
			//console.log("ofs" + ofs);
			//	$("html, body").css({"width":$(".jOrgChart > table").width()+"px"}).scrollLeft(2000).delay(300);
			$("html").scrollLeft((moveWidth/100)*($("#cZoom").val()));
			//$("html, body").scrollTop(100);
		},1000);

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
						<col width="" />
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
					<%=LNG_TEXT_NAME%> : <input type="text" class="input_text" name="sNameSearch" id="sNameSearch" />
					<input type="button" class="input_submit design1" id="sNameSearchBtn" value="<%=LNG_TEXT_SEARCH%>"  />
				</div>
				<div class="modal-body">
					<table <%=tableatt%> class="width100" id="TableGrid2">
						<col width="" />
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

									<th><%=LNG_TEXT_TREE_MY_PV%></th>
									<td colspan="3" class="view_meap"></td>
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
					<!-- <div class="underPV2">
						<h6 style="border-bottom:1px dashed #dee2e6; padding-bottom:7px;"><%=LNG_TEXT_TOTAL_SALES_OF_UNDER_MEMBER%> (이월)</h6>
						<div style="text-align:center;">
							날짜검색 <input type='text' name='SDATE2' id="SDATE2" value="<%=Date()%>" class='readonly input_text' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
							<input type="submit" class="input_submit design1" value="<%=LNG_TEXT_SEARCH%>" onclick="fnMemberInfo2();" />
						</div>
						<div class="width100" id="PURCHASE2" style="height:196px; border:1px solid #cdcdcd; padding:20px 0px; margin-top:7px;">

						</div>
					</div> -->

					<div class="underPV1">
						<h6 style="border-bottom:1px dashed #dee2e6; padding-bottom:7px;"><%=LNG_TEXT_TOTAL_SALES_OF_UNDER_MEMBER%></h6>
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
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button></span>
											<!-- <span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button></span>
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button></span> -->
											<span class="button medium icon"><span class="calendar"></span><button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button></span>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div style="text-align:center;">
							<!-- <%=LNG_TEXT_START_DATE%> --> <input type='text' name='SDATE1' id="SDATE1" value="<%=Date()%>" class='readonly input_text' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
							~
							<!-- <%=LNG_TEXT_END_DATE%> --> <input type='text' name='EDATE1' id="EDATE1" value="<%=Date()%>" class='input_text readonly' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
							<input type="button" class="input_submit design1" value="<%=LNG_TEXT_SEARCH%>" onclick="fnMemberInfo1();" />
						</div>
						<div class="width100" id="PURCHASE1" style="margin-top: 10px;">


						</div>

				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
<!-- Modal 3 E -->
<script src="bootstrap.bundle.min.js"></script>

</body>
</html>
<%Response.Flush()%>
