<!--#include virtual = "/_lib/strFunc.asp"-->
<%

		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

		arrBname = gRequestTF("bname",True)

		bname_01_sts = "off"
		bname_02_sts = "off"
		bname_03_sts = "off"
		bname_04_sts = "off"

		Select Case arrBname
			Case "notice"
				bname_01_sts = "on"
			Case "schedule"
				bname_02_sts = "on"
			Case "faq"
				bname_03_sts = "on"
			Case "pds"
				bname_04_sts = "on"
		End Select



		'드림어드벤쳐투어 2016-01-06
		Select Case arrBname
			Case "notice","pds"
				INDEX_BBS_PROCEDURE = "DKP_INDEX_BBS_TOP_CONTENT"
				INDEX_BBS_MORE_LINK = "/cboard/board_list.asp?bname="&arrBname
			Case "schedule"
				INDEX_BBS_PROCEDURE = "DKP_INDEX_SCHEDULE_TOP_CONTENT"
				INDEX_BBS_MORE_LINK = "/schedule/schedule.asp"
			Case "faq"
				INDEX_BBS_PROCEDURE = "DKSP_INDEX_FAQ_TOP_CONTENT"
				INDEX_BBS_MORE_LINK = "/faq/faq_list.asp"
		End Select
%>
			<div class="cleft"><img src="<%=IMG_INDEX%>/index_left_tit_customer.png" alt="" /></div>
			<div class="fleft">
				<ul>
					<li><%=aImgOpt("javascript:chgIndexBBS('notice');","S",IMG_INDEX&"/index_left_customer_01_"&bname_01_sts&".png",43,29,"","")%></li>
					<li><%=aImgOpt("javascript:chgIndexBBS('schedule');","S",IMG_INDEX&"/index_left_customer_02_"&bname_02_sts&".png",42,29,"","")%></li>
					<li><%=aImgOpt("javascript:chgIndexBBS('faq');","S",IMG_INDEX&"/index_left_customer_03_"&bname_03_sts&".png",23,29,"","")%></li>
					<li><%=aImgOpt("javascript:chgIndexBBS('pds');","S",IMG_INDEX&"/index_left_customer_04_"&bname_04_sts&".png",62,29,"","")%></li>
					<li><a href="<%=INDEX_BBS_MORE_LINK%>"><img src="<%=IMG_INDEX%>/index_left_more.png" alt="" /></a></li>
				</ul>
			</div>
			<div class="cleft width100">
				<table <%=tableatt%> class="width100">
					<col width="16" />
					<col width="*" />
					<col width="80" />
					<%

						arrParams = Array(_
							Db.makeParam("@TOPCNT",adInteger,adParamInput,0,6),_
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,arrBname),_
							Db.makeParam("@strNation",adVarChar,adParamInput,10,Lang)_
						)
						arrList = Db.execRsList(INDEX_BBS_PROCEDURE,DB_PROC,arrParams,listLen,Nothing)
						If IsArray(arrList) Then
							For i = 0 To listLen

							Select Case arrBname
								Case "notice","pds"
									INDEX_BBS_LINK = "/cboard/board_view.asp?bname="&arrBname&"&amp;num="&arrList(0,i)
								Case "schedule"
									INDEX_BBS_LINK = "/schedule/schedule.asp?syear="&Left(arrList(3,i),4)&"&smonth="&Mid(arrList(3,i),6,2)
								Case "faq"
									INDEX_BBS_LINK = "/faq/faq_list.asp?cate="&arrList(4,i)
							End Select

					%>
					<tr>
						<td><img src="<%=IMG_INDEX%>/index_left_notice_arrow.png" alt="" /></td>
						<td><a href="<%=INDEX_BBS_LINK%>"><%=cutString2(arrList(2,i),36)%></a></td>
						<td class="tright">[<%=Replace(Left(arrList(3,i),10),"-",".")%>]</td>
					</tr>
					<%
							Next
						Else
					%>
					<tr>
						<td colspan="3" style="height:125px;" class="tcenter"><%=LNG_TEXT_NO_REGISTERED_POST%></td>
					</tr>
					<%
						End If
					%>
				</table>
			</div>

