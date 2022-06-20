<!--#include virtual = "/_lib/strFunc.asp"-->
<%
		Session.CodePage = 949
		Response.CharSet = "euc-kr"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

%>
<!--#include virtual = "/_include/document.asp"-->
		<table <%=tableatt%> class="userCWidth">
			<colgroup>
				<col width="72" />
				<col width="102" />
				<col width="257" />
				<col width="90" />
				<col width="112" />
				<col width="117" />
			</colgroup>
			<thead>
				<tr>
					<th><%=viewImg(IMG_SHOP&"/detailQnATh01.gif",72,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailQnATh02.gif",102,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailQnATh03.gif",257,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailQnATh04.gif",90,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailQnATh05.gif",112,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailQnATh06.gif",117,27,"")%></th>
				</tr>
			</thead>
			<tbody>
				<%

					GoodsIDX	= gRequestTF("goodsIDX",False)
					PAGESIZE	= Request("PAGESIZE")
					PAGE		= Request("PAGE")
					If PAGESIZE = "" Then PAGESIZE = 10
					If PAGE = "" Then PAGE = 1


					If DK_MEMBER_LEVEL > 0 Then
						qna_btn = aImg("javascript:popQna('"&GoodsIDX&"');",IMG_SHOP&"/qna_btn.gif",65,21,"")
					Else
						qna_btn = aImg("javascript:popLogin('"&ThisPageURL&"');",IMG_SHOP&"/qna_btn.gif",65,21,"")
					End If
					arrParams = Array(_
						Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
						Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
						Db.makeParam("@goodsIDX",adInteger,adParamInput,0,GoodsIDX),_
						Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0)_
					)
					arrList = Db.execRsList("DKP_GOODS_QNA_LIST",DB_PROC,arrParams,listLen,Nothing)
					All_Count = arrParams(UBound(arrParams))(4)
'					PRINT ALL_COUNT
					PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
					IF CCur(PAGE) = 1 Then
						CNT = All_Count
					Else
						CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
					End If
					If IsArray(arrList) Then
						For i = 0 To listLen
						ThisNum = ALL_Count - CInt(arrList(0,i)) + 1
						If arrList(10,i) = "T" Then
							BuyTF = "구매"
						Else
							BuyTF = spans("비구매","#bfbfbf","","")
						End If
						ThisIDLen = Len(arrList(3,i))

						ThisWriterID = Left(Left(arrList(3,i),3)&"********************",ThisIDLen)
						thisDateValue = DateValue(arrList(8,i)) & " "&Hour(arrList(8,i))&":"&Minute(arrList(8,i))

						If arrList(7,i) <> "" And Not IsNull(arrList(7,i)) Then
							iconReplyTF = viewImg(IMG_SHOP&"/qna_replyT.gif",52,17,"")
						Else
							iconReplyTF = viewImg(IMG_SHOP&"/qna_replyF.gif",52,17,"")
						End If


				%>

				<tr>
					<td><%=ThisNum%></td>
					<td><%=arrList(4,i)%></td>
					<td class="subject"><%=iconReplyTF%> <a href="javascript:toggle_content('qnas<%=arrList(1,i)%>')"><%=arrList(5,i)%></a></td>
					<td><%=BuyTF%></td>
					<td><%=ThisWriterID%></td>
					<td><%=thisDateValue%></td>
				</tr><tr id="qnas<%=arrList(1,i)%>" style="display:none;">
					<td colspan="6" class="qna_reply">
						<table <%=tableatt%> class="userFullWidth">
							<colgroup>
								<col width="110" />
								<col width="*" />
							</colgroup>
							<tr>
								<td><%=viewImg(IMG_SHOP&"/qna_icon_q.gif",24,23,"")%></td>
								<td class="subject"><%=arrList(6,i)%></td>
							</tr>
							<%If arrList(7,i) <> "" And Not IsNull(arrList(7,i)) Then%>
							<tr>
								<td><%=viewImg(IMG_SHOP&"/qna_icon_a.gif",24,22,"")%></td>
								<td class="subject2"><%=arrList(7,i)%></td>
							</tr>
							<%End If%>
						</table>
					</td>
				</tr>
				<%
						Next
					Else
				%>
				<tr>
					<td colspan="6" style="height:80px; text-align:center;"><%=LNG_CHGQNAPAGE_TEXT01%></td>
				</tr>
				<%
					End If
				%>
			</tbody>
		</table>
		<div class="pagingArea"><% Call pageList1(PAGE,PAGECOUNT)%><div class="fright"><%=qna_btn%></div></div>
