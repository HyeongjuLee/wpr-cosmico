<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"
	W1200 = "T"
	view = 1

	strBoardName = gRequestTF("bname",True)

	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	Set DKRS = Db.execRs("DKSP_FORUM_CONFIG_VIEW_ADMIN",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then

		DKRS_strCateCode		= DKRS("strCateCode")
		DKRS_strBoardTitle		= DKRS("strBoardTitle")
		DKRS_strBoardType		= DKRS("strBoardType")
		DKRS_strBoardSkin		= DKRS("strBoardSkin")
		DKRS_isUse				= DKRS("isUse")
		DKRS_isLeft				= DKRS("isLeft")
		DKRS_strLeftMode		= DKRS("strLeftMode")
		DKRS_isCategoryUse		= DKRS("isCategoryUse")
		DKRS_isCommentUse		= DKRS("isCommentUse")
		DKRS_isForum			= DKRS("isForum")
		DKRS_blockWord			= DKRS("blockWord")
		DKRS_blockWordChg		= DKRS("blockWordChg")
		DKRS_defaultWord		= DKRS("defaultWord")
		DKRS_isSearch			= DKRS("isSearch")
		DKRS_intListView		= DKRS("intListView")
		DKRS_isSMS				= DKRS("isSMS")
		DKRS_defaultSMS			= DKRS("defaultSMS")
		DKRS_newIconDate		= DKRS("newIconDate")
		DKRS_isImg				= DKRS("isImg")
		DKRS_strImg				= DKRS("strImg")
		DKRS_isSubImg			= DKRS("isSubImg")
		DKRS_SubImg				= DKRS("SubImg")
		DKRS_mainVar			= DKRS("mainVar")
		DKRS_SubVar				= DKRS("SubVar")
		DKRS_sViewVar			= DKRS("sViewVar")			'sview
		DKRS_isVote				= DKRS("isVote")			'sview
		DKRS_intWriteLimit		= DKRS("intWriteLimit")
		DKRS_intReplyLimit		= DKRS("intReplyLimit")
		DKRS_isReplyLimitDate	= DKRS("isReplyLimitDate")
		DKRS_isGroupUse			= DKRS("isGroupUse")
		DKRS_isTopNotice		= DKRS("isTopNotice")
		DKRS_intTopNotice		= DKRS("intTopNotice")
		DKRS_isViewNameType		= DKRS("isViewNameType")
		DKRS_isViewNameChg		= DKRS("isViewNameChg")
		DKRS_intViewNameCnt		= DKRS("intViewNameCnt")
		DKRS_isTopBestView  	= DKRS("isTopBestView")
		DKRS_intTopBestView 	= DKRS("intTopBestView")
		DKRS_intTopBestLimit	= DKRS("intTopBestLimit")
		DKRS_isTopNavi			= DKRS("isTopNavi")
		DKRS_isTopMargin		= DKRS("isTopMargin")
		DKRS_intTopMargin		= DKRS("intTopMargin")

	Else
		Call ALERTS("????????? ????????? ????????? ?????????????????????. ???????????? ??? ?????? ??????????????????.","back","")

	End If

%>
<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="admin_forum" class="insert">
	<!--#include file = "forum_tabs.asp"-->
	<form name="cfrm" action="forumHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return chkConfigFrm(this)">
		<input type="hidden" name="mode" value="CONFIG" />
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<input type="hidden" name="isLeft" value="<%=DKRS_isLeft%>" />
		<input type="hidden" name="strLeftMode" value="<%=strLeftMode%>" />
		<input type="hidden" name="strBoardSkin" value="<%=strBoardSkin%>" />
		<input type="hidden" name="o_strImg" value="<%=DKRS_strImg%>" />
		<input type="hidden" name="o_SubImg" value="<%=DKRS_SubImg%>" />
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="550" />
				<col width="*" />
			</colgroup>
			<tr>
				<th colspan="3">????????? ????????????</th>
			</tr><tr>
				<th>??????</th>
				<th>??????</th>
				<th>??????</th>
			</tr><tr>
				<th>??????????????????</th>
				<td><%=strBoardName%></td>
				<td class="borLeft"></td>
			</tr><tr>
				<th>???????????????</th>
				<td><div class="checks">
					<input type="radio" name="isUse" id="isUse_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isUse)%> /><label for="isUse_T" class="radioT">?????????</label>
					<input type="radio" name="isUse" id="isUse_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isUse)%> /><label for="isUse_F" class="radioF">????????????</label>

				</div></td>
				<td class="borLeft">???????????? ?????????(??????) ?????????.</td>
			</tr><tr>
				<th>???????????????</th>
				<td>
					<select name="strBoardType" class="input_select">
						<option value="board" <%=isSelect(DKRS_strBoardType,"board")%>>???????????????</option>
						<option value="board_vote" <%=isSelect(DKRS_strBoardType,"board_vote")%>>???????????????_????????????</option>
						<option value="limitReply" <%=isSelect(DKRS_strBoardType,"limitReply")%>>???????????????_??????????????????</option>

						<option value="gallery" <%=isSelect(DKRS_strBoardType,"gallery")%>>???????????????</option>
						<option value="gallery2" <%=isSelect(DKRS_strBoardType,"gallery2")%>>???????????????(blog?????????)</option>
						<option value="movie" <%=isSelect(DKRS_strBoardType,"movie")%>>???????????????</option>
						<option value="movie2" <%=isSelect(DKRS_strBoardType,"movie2")%>>???????????????(blog?????????)</option>
						<option value="video_pop" <%=isSelect(DKRS_strBoardType,"video_pop")%>>???????????????(??????)</option>
						<option value="liner" <%=isSelect(DKRS_strBoardType,"liner")%>>??? ??? ????????? ??????</option>
						<option value="review" <%=isSelect(DKRS_strBoardType,"review")%>>???????????????</option>
						<option value="kin" <%=isSelect(DKRS_strBoardType,"kin")%>>???????????????</option>
						<option value="sns" <%=isSelect(DKRS_strBoardType,"sns")%>>sns??????</option>

					</select>
				</td>
				<td class="borLeft">?????????????????? ???????????????.</td>
			</tr><tr>
				<th>???????????????</th>
				<td><input type="text" name="strBoardTitle" class="input_text" style="width:220px;" value="<%=DKRS_strBoardTitle%>" /></td>
				<td class="borLeft">?????????????????? ???????????????.</td>
			</tr><tr>
				<th>?????????????????????</th>
				<td><input type="text" name="strCateCode" class="input_text" style="width:220px;" value="<%=DKRS_strCateCode%>" /></td>
				<td class="borLeft">?????????????????? ???????????????.</td>
			</tr><tr>
				<th>????????? ?????? ??????</th>
				<td>?????? : <input type="text" name="mainVar" class="input_text" style="width:45px;" value="<%=DKRS_mainVar%>" />&nbsp;&nbsp; ?????? (view???) : <input type="text" name="SubVar" class="input_text" style="width:45px;" value="<%=DKRS_SubVar%>" />&nbsp;&nbsp; ??????2 (sview???) : <input type="text" name="sViewVar" class="input_text" style="width:45px;" value="<%=DKRS_sViewVar%>" /></td>
				<td class="borLeft">????????????????????? (?????? = view???, ??????2 = sview???(?????????:0) ).</td>
			</tr>

			<tr>
				<th colspan="3">????????? ?????? ??????</th>
			</tr><tr>
				<th>?????? ?????? ??????</th>
				<td>
					<input type="radio" name="isTopNavi" id="isTopNavi_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopNavi)%> /><label for="isTopNavi_T" class="radioT">?????? ?????? ??????</label>
					<input type="radio" name="isTopNavi" id="isTopNavi_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopNavi)%> /><label for="isTopNavi_F" class="radioF">?????? ?????? ?????????</label>
				</td>
				<td class="borLeft">???????????? ????????? ??????(???????????????/GNB???)??? ???????????????.</td>
			</tr><tr>
				<th>?????? ?????? ??????</th>
				<td>
					<input type="radio" name="isTopMargin" id="isTopMargin_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopMargin)%> /><label for="isTopMargin_T" class="radioT">?????? ?????? ??????</label>
					<input type="radio" name="isTopMargin" id="isTopMargin_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopMargin)%> /><label for="isTopMargin_F" class="radioF">?????? ?????? ?????????</label>
					/ <input type="text" name="intTopMargin" class="input_text" style="width:60px;" value="<%=DKRS_intTopMargin%>" <%=onlyKeys%> />px
				</td>
				<td class="borLeft">???????????? ????????? ????????? ?????? ???????????????.</td>
			</tr><tr>
				<th>????????????????????????</th>
				<td>
					<select name="isSubImg" class="input_select">
						<option value="T" <%=isSelect(DKRS_isSubImg,"T")%>>??????</option>
						<option value="F" <%=isSelect(DKRS_isSubImg,"F")%>>?????????</option>
					</select>
					<input type="file" name="SubImg" class="input_file" style="width:220px;" value="" /></td>
				<td class="borLeft">???????????? ?????? ???????????? ???????????????.</td>
			</tr><tr>
				<th>????????????????????????</th>
				<td>
					<select name="isImg" class="input_select">
						<option value="T" <%=isSelect(DKRS_isImg,"T")%>>??????</option>
						<option value="F" <%=isSelect(DKRS_isImg,"F")%>>?????????</option>
					</select>
					<input type="file" name="strImg" class="input_file" style="width:220px;" value="" /></td>
				<td class="borLeft">???????????? ?????? ???????????? ???????????????.</td>
			</tr><tr>
				<th>????????? ?????? ??????</th>
				<td><input type="text" name="intListView" class="input_text" style="width:60px;" value="<%=DKRS_intListView%>" <%=onlyKeys%> /> ??? ??? ??????</td>
				<td class="borLeft">???????????? ????????? ????????? ?????? ???????????????.</td>
			</tr><tr>
				<th>New ????????? ????????????</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<input type="text" name="newIconDate" class="input_text" style="width:80px;" value="<%=DKRS_newIconDate%>" />??? ??? ??????????????? ??????<br />
				</td>
				<td class="borLeft">0?????? ???????????? ?????? ????????? ???????????? new ???????????? ???????????????.</td>
			</tr>

			<tr>
				<th colspan="3">????????? ?????? ?????? ??????</th>
			</tr>
			<tr>
				<th>???????????? ??????</th>
				<td>
					<input type="radio" name="isSearch" id="isSearch_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isSearch)%> /><label for="isSearch_T" class="radioT">??????????????? ???????????????.</label>
					<input type="radio" name="isSearch" id="isSearch_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isSearch)%> /><label for="isSearch_F" class="radioF">??????????????? ???????????? ????????????.</label>
				</td>
				<td class="borLeft">???????????? ?????? ????????? ???????????????.</td>
			</tr><tr>
				<th>?????????????????????<br />(???????????? ??????)</th>
				<td>
					<input type="radio" name="isCommentUse" id="isCommentUse_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isCommentUse)%> /><label for="isCommentUse_T" class="radioT">?????????(??????)??? ???????????????.</label>
					<input type="radio" name="isCommentUse" id="isCommentUse_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isCommentUse)%> /><label for="isCommentUse_F" class="radioF">?????????(??????)??? ???????????? ????????????.</label>
				</td>
				<td class="borLeft">???????????? ?????????(??????) ????????? ???????????????.</td>
			</tr><tr>
				<th>???????????? ??????</th>
				<td>
					<input type="radio" name="isVote" id="isVote_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isVote)%> /><label for="isVote_T" class="radioT">????????????(?????????)??? ??????</label>
					<input type="radio" name="isVote" id="isVote_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isVote)%> /><label for="isVote_F" class="radioF">????????????(?????????)??? ?????????</label>
				</td>
				<td class="borLeft">???????????? ????????????(?????????) ????????? ???????????????.</td>
			</tr>
			<tr>
				<th>?????? ?????? ??????</th>
				<td>
					<input type="radio" name="isTopNotice" id="isTopNotice_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopNotice)%> /><label for="isTopNotice_T" class="radioT">????????? ??????</label>
					<input type="radio" name="isTopNotice" id="isTopNotice_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopNotice)%> /><label for="isTopNotice_F" class="radioF">????????? ?????????</label>
					/ <input type="text" name="intTopNotice" class="input_text" style="width:60px;" value="<%=DKRS_intTopNotice%>" <%=onlyKeys%> /> ???

				</td>
				<td class="borLeft">???????????? ?????? ?????? ?????? ????????? ???????????????.</td>
			</tr><tr>
				<th>?????? ????????? ??????</th>
				<td>
					<input type="radio" name="isTopBestView" id="isTopBestView_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isTopBestView)%> /><label for="isTopBestView_T" class="radioT">?????? ????????? ??????</label>
					<input type="radio" name="isTopBestView" id="isTopBestView_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isTopBestView)%> /><label for="isTopBestView_F" class="radioF">?????? ????????? ?????????</label>
					/ <input type="text" name="intTopBestView" class="input_text" style="width:60px;" value="<%=DKRS_intTopBestView%>" <%=onlyKeys%> /> ???
					/ <input type="text" name="intTopBestLimit" class="input_text" style="width:60px;" value="<%=DKRS_intTopBestLimit%>" <%=onlyKeys%> /> ?????????
				</td>
				<td class="borLeft">????????? ????????? ????????? ????????? ???????????????.</td>
			</tr>

			<tr>
				<th>????????? ????????? ??????</th>
				<td>
					<input type="radio" name="isViewNameType" id="isViewNameType_N" class="input_check"  value="N" <%=isChecked("N",DKRS_isViewNameType)%> /><label for="isViewNameType_N" class="radioT">?????? ??????</label>
					<input type="radio" name="isViewNameType" id="isViewNameType_I" class="input_check2" value="I" <%=isChecked("I",DKRS_isViewNameType)%> /><label for="isViewNameType_I" class="radioF">????????? ??????</label>

				</td>
				<td class="borLeft">???????????? ?????? ?????? ?????? ????????? ???????????????.</td>
			</tr><tr>
				<th>????????? ????????? ?????????</th>
				<td>
					<input type="radio" name="isViewNameChg" id="isViewNameChg_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isViewNameChg)%> /><label for="isViewNameChg_T" class="radioT">?????????</label>
					<input type="radio" name="isViewNameChg" id="isViewNameChg_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isViewNameChg)%> /><label for="isViewNameChg_F" class="radioF">????????? ??????</label>
					/ <input type="text" name="intViewNameCnt" class="input_text" style="width:60px;" value="<%=DKRS_intViewNameCnt%>" <%=onlyKeys%> /> ?????? ??????

				</td>
				<td class="borLeft">???????????? ?????? ?????? ?????? ????????? ???????????????.</td>
			</tr>

			<tr>
				<th>???????????????</th>
				<td>
					<input type="radio" name="isGroupUse" id="isGroupUse_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isGroupUse)%> /><label for="isGroupUse_T" class="radioT">??????????????? ??????</label>
					<input type="radio" name="isGroupUse" id="isGroupUse_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isGroupUse)%> /><label for="isGroupUse_F" class="radioF">?????????</label>
				</td>
				<td class="borLeft">???????????? ????????? ???????????? ????????? ????????????.</td>
			</tr>

			<tr>
				<th colspan="3">????????? ?????? ?????? ??????</th>
			</tr>
			<tr>
				<th>?????? ????????? ?????? ??????</th>
				<td><input type="text" name="intWriteLimit" class="input_text" style="width:60px;" value="<%=DKRS_intWriteLimit%>" <%=onlyKeys%> /> ??? / (0 : ?????????)</td>
				<td class="borLeft">????????? ???????????? ????????? ??? ?????? ????????? ???????????????. </td>
			</tr><tr>
				<th>???????????? ?????? ?????? ??????</th>
				<td><input type="text" name="intReplyLimit" class="input_text" style="width:60px;" value="<%=DKRS_intReplyLimit%>" <%=onlyKeys%> /> ??? / (0 : ?????????)</td>
				<td class="borLeft">???????????? ????????? ??? ??? ?????? ????????? ???????????????. </td>
			</tr><tr>
				<th>?????? ?????? ??????</th>
				<td>
					<input type="radio" name="isReplyLimitDate" id="isReplyLimitDate_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isReplyLimitDate)%> /><label for="isReplyLimitDate_T" class="radioT">??????</label>
					<input type="radio" name="isReplyLimitDate" id="isReplyLimitDate_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isReplyLimitDate)%> /><label for="isReplyLimitDate_F" class="radioF">?????????</label>
				</td>
				<td class="borLeft">???????????? ????????? ??? ??? ?????? ????????? ???????????????. </td>
			</tr>


			<tr>
				<th>????????????</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<textarea name="blockWord" class="input_area" style="width:95%; height:200px;"><%=DKRS_blockWord%></textarea><br />
				</td>
				<td class="borLeft">??????(,) ??? ??????????????????. (ex:??????,?????????,?????? ???)</td>
			</tr><tr>
				<th>???????????? ??????</th>
				<td>??????????????? <input type="text" name="blockWordChg" class="input_text" style="width:80px;" value="<%=DKRS_blockWordChg%>" /> ??? ???????????????.</td>
				<td class="borLeft"></td>
			</tr><tr>
				<th>????????????</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<textarea name="defaultWord" class="input_area" style="width:95%; height:200px;"><%=DKRS_defaultWord%></textarea><br />
				</td>
				<td class="borLeft">????????? ?????? ??? ???????????? ???????????? ????????????.</td>
			</tr><tr>
				<th>SMS ????????????</th>
				<td>
					<input type="radio" name="isSMS" id="isSMS_T" class="input_check"  value="T" <%=isChecked("T",DKRS_isSMS)%> /><label for="isSMS_T">SMS????????? ???????????????.</label>
					<input type="radio" name="isSMS" id="isSMS_F" class="input_check2" value="F" <%=isChecked("F",DKRS_isSMS)%> /><label for="isSMS_F">SMS????????? ???????????? ????????????.</label>
				</td>
				<td class="borLeft">?????? ???????????? SMS ??????????????? ???????????????.</td>
			</tr><tr>
				<th>SMS ????????????</th>
				<td style="padding-top:7px;padding-bottom:7px;">
					<textarea name="defaultSMS" class="input_area" style="width:95%; height:100px;"><%=DKRS_defaultSMS%></textarea><br />
				</td>
				<td class="borLeft"><p>SMS ??????????????? ???????????????.</p>(<span class="GoodsComment_cnt">0</span> / 80byte)</td>
			</tr>
		</table>
	</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChkConfig();""")%></div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
