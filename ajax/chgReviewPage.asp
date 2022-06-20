<!--#include virtual = "/_lib/strFunc.asp"-->
<%
		Session.CodePage = 949
		Response.CharSet = "euc-kr"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

%>
<!--#include virtual = "/_include/document.asp"-->
		<table <%=tableatt%> class="userFullWidth2">
			<colgroup>
				<col width="79" />
				<col width="352" />
				<col width="90" />
				<col width="112" />
				<col width="117" />
			</colgroup>
			<thead>
				<tr>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh05.gif",79,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh01.gif",352,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh02.gif",90,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh03.gif",112,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh04.gif",117,27,"")%></th>
			</thead>
			<tbody>
				<%

					goodsIDX		= gRequestTF("goodsIDX",False)
					PAGE2			= Request("PAGE2")
					PAGESIZE2 = 1
					If PAGE2 = "" Then PAGE2 = 1


					arrParams = Array(_
						Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE2),_
						Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE2),_
						Db.makeParam("@goodsIDX",adInteger,adParamInput,0,goodsIDX),_
						Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0)_
					)
					arrList = Db.execRsList("DKP_GOODS_REVIEW_LIST",DB_PROC,arrParams,listLen,Nothing)
					All_Count2 = arrParams(UBound(arrParams))(4)

					PAGECOUNT2 = Int((CCur(All_Count2) - 1 ) / CInt(PAGESIZE2) ) + 1
					IF CCur(PAGE2) = 1 Then
						CNT2 = All_Count2
					Else
						CNT2 = All_Count2 - ((CCur(PAGE2)-1)*CInt(PAGESIZE2)) '
					End If

					If IsArray(arrList) Then
						For i = 0 To listLen
						ThisNum = ALL_Count2 - CInt(arrList(0,i)) + 1

						ThisIDLen = Len(arrList(3,i))

						ThisWriterID = Left(Left(arrList(3,i),3)&"********************",ThisIDLen)
						thisDateValue = DateValue(arrList(8,i)) & " "&Hour(arrList(8,i))&":"&Minute(arrList(8,i))

						voteIcon = viewImg(IMG_SHOP&"/review_icon0"&arrList(4,i)&".gif",55,16,"")

				%>

				<tr>
					<td rowspan="2" class="underline"><%=voteIcon%></td>
					<td class="subject"><a href="javascript:open_reviews('<%=arrList(1,i)%>')"><%=arrList(5,i)%></a></td>
					<td><%=arrList(7,i)%></td>
					<td><%=ThisWriterID%></td>
					<td rowspan="2" class="underline"><%=thisDateValue%></td>
				</tr><tr>
					<td colspan="3" class="review_td2 underline"><p><%=cutString(stripHTMLtag(arrList(6,i)),300)%></p></td>
				</tr>
				<%
						Next
					End If
				%>
			</tbody>
		</table>
		<div class="pagingArea"><% Call pageList2(PAGE2,PAGECOUNT2)%></div>
