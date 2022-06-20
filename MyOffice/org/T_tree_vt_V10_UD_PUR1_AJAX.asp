<!--#include virtual="/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%



'		DK_MEMBER_ID1 = "00"
'		DK_MEMBER_ID2 = 1010749

	SDATE = pRequestTF_AJAX2("SDATE",False)
	EDATE = pRequestTF_AJAX2("EDATE",False)
	PUR_DK_MEMBER_ID1 = pRequestTF_AJAX2("mbid1",True)
	PUR_DK_MEMBER_ID2 = pRequestTF_AJAX2("mbid2",True)
	PUR_DK_MEMBER_NAME = pRequestTF_AJAX2("mname",True)

	If SDATE = "" Then SDATE = ""
	If EDATE = "" Then EDATE = ""

	ThisM_1stDate = Left(Date(),8)&"01"

	arrParamsM = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,PUR_DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,PUR_DK_MEMBER_ID2), _
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE) _
	)
	Set HJRS_M = Db.execRs("HJP_SAVE_PURCHASE_TOTAL_DOWN_PV",DB_PROC,arrParamsM,DB3)		'변경 20210623~
	If Not HJRS_M.BOF And Not HJRS_M.EOF Then
		SUMPV_M = HJRS_M(0)
		SUMCV_M = HJRS_M(1)
	Else
		SUMPV_M = 0
		SUMCV_M = 0
	End If
	Call closeRS(HJRS_M)

	'본인 직후원 정보
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,PUR_DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,PUR_DK_MEMBER_ID2) _
	)
	Set HJRS = Db.execRs("HJP_UNDER_INFO",DB_PROC,arrParams,DB3)
	If Not HJRS.BOF And Not HJRS.EOF Then
		L_SAVENAME	=	HJRS(0)
		L_SAVEID1	=	HJRS(1)
		L_SAVEID2	=	HJRS(2)
		R_SAVENAME	=	HJRS(3)
		R_SAVEID1	=	HJRS(4)
		R_SAVEID2	=	HJRS(5)
		L_SAVEWEBID	=	HJRS(6)
		R_SAVEWEBID	=	HJRS(7)

		'본인 직후원(좌)
			arrParamsM = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,L_SAVEID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,L_SAVEID2), _
				Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
				Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE) _
			)
			Set HJRS_M = Db.execRs("HJP_SAVE_PURCHASE_TOTAL_DOWN_PV",DB_PROC,arrParamsM,DB3)
			If Not HJRS_M.BOF And Not HJRS_M.EOF Then
				SUMPV_L = HJRS_M(0)
				SUMCV_L = HJRS_M(1)
			Else
				SUMPV_L = 0
				SUMCV_L = 0
			End If
			Call closeRS(HJRS_M)

			'본인 직후원(우)
			arrParamsM = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,R_SAVEID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,R_SAVEID2), _
				Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE), _
				Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE) _
			)
			Set HJRS_M = Db.execRs("HJP_SAVE_PURCHASE_TOTAL_DOWN_PV",DB_PROC,arrParamsM,DB3)
			If Not HJRS_M.BOF And Not HJRS_M.EOF Then
				SUMPV_R = HJRS_M(0)
				SUMCV_R = HJRS_M(1)
			Else
				SUMPV_R = 0
				SUMCV_R = 0
			End If
			Call closeRS(HJRS_M)

	Else
		L_SAVENAME	=	""
		L_SAVEID1	=	""
		L_SAVEID2	=	0
		R_SAVENAME	=	""
		R_SAVEID1	=	""
		R_SAVEID2	=	0
	END If
	Call closeRS(HJRS)

	'후원인 WebID
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,PUR_DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,PUR_DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("HJP_MEMBER_WEBID",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		PUR_DK_MEMBER_WebID	= DKRS("WebID")
	Else
		PUR_DK_MEMBER_WebID =""
	End If
	Call closeRS(DKRS)

	WEBID_TF = "F"
	If WEBID_TF = "T" Then
		viewBoxID		= PUR_DK_MEMBER_WebID
		viewL_SaveID	= L_SAVEWEBID
		viewR_SaveID	= R_SAVEWEBID
	Else
		viewBoxID		= pur_dk_member_id1&"-"&Fn_MBID2(pur_dk_member_id2)
		viewL_SaveID	= L_SAVEID1&"-"&Fn_MBID2(L_SAVEID2)
		viewR_SaveID	= R_SAVEID1&"-"&Fn_MBID2(R_SAVEID2)
	End If





%>
<div class="width100" style="">
	<div class="fleft spon_area" style="border:1px solid #cdcdcd; padding:20px 0px;">
		<div class="tcenter" >

			<div class="area_inners">
				<!-- 본인 -->
				<div class="spon_info" style="">
					<div class="clear left_info">
						<div class="addr fon_n "><%=viewBoxID%></div>
						<div class="addr fon_g "><%=PUR_DK_MEMBER_NAME%></div>
						<div class="addr fon_c"><span class="fon3" style="margin-left:5px;"><%=LNG_TEXT_ALL_OVER%> </span><span class="fon1 red2"><%=num2curINT(SUMPV_M)%></span><span class="fon3"> <%=CS_PV%></span></div>
						<!-- <div class="addr fon_c"><span class="fon3" style="margin-left:5px;"><%=LNG_TEXT_ALL_OVER%> </span><span class="fon1 red2"><%=num2curINT(SUMCV_M)%></span><span class="fon3"> <%=CS_PV2%></span></div> -->
					</div>
				</div>

				<%If L_SAVEID1 <> "" Or  R_SAVEID1 <> "" Then%>
				<div style="margin:0px auto;margin-top:20px; width:80%;">
					<%If L_SAVEID1 <> "" And L_SAVEID2 > 0 Then%>
					<div class="spon_info2 fleft">
						<div class="clear left_info">
							<div class="addr fon_n"><%=viewL_SaveID%></div>
							<div class="addr fon_g"><%=L_SAVENAME%></div>
							<div class="addr fon_g"><span class="fon2 blue2"><%=num2curINT(SUMPV_L)%></span><span class="fon4"> <%=CS_PV%></span></div>
							<!-- <div class="addr fon_g"><span class="fon2 blue2"><%=num2curINT(SUMCV_L)%></span><span class="fon4"> <%=CS_PV2%></span></div> -->
						</div>
					</div>
					<%Else%>
					<div id="spon_info" class="fleft" style="background:#fff;"></div>
					<%End If%>


					<%If R_SAVEID1 <> "" And R_SAVEID2 > 0 Then%>
					<div class="spon_info2 fright">
						<div class="clear left_info">
							<div class="addr fon_n"><%=viewR_SaveID%></div>
							<div class="addr fon_g"><%=R_SAVENAME%></div>
							<div class="addr fon_g"><span class="fon2 blue2"><%=num2curINT(SUMPV_R)%></span><span class="fon4"> <%=CS_PV%></span></div>
							<!-- <div class="addr fon_g"><span class="fon2 blue2"><%=num2curINT(SUMCV_R)%></span><span class="fon4"> <%=CS_PV2%></span></div> -->
						</div>
					</div>
					<%Else%>
					<div id="spon_info" class="fright" style="background:#fff;"></div>
					<%End If%>
				</div>
				<%End If%>

			</div>

		</div>
	</div>
</div>