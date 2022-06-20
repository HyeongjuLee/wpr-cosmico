<!--#include virtual="/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 6

	Call Only_Member(DK_MEMBER_LEVEL)



%>

<!--#include virtual="/_include/document.asp"-->
<link rel="stylesheet" href="/css/mypage.css" />
</head>
<body>
<!--#include virtual="/_include/header.asp"-->
<p><%=viewImg(IMG_MYPAGE&"/tit_mypage_review.jpg",780,65,"")%></p>
<div id="mypage">
	<div id="detailReview">
		<table <%=tableatt%> class="userCWidth2">
			<colgroup>
				<col width="83" />
				<col width="512" />
				<col width="98" />
				<col width="87" />
			</colgroup>
			<thead>
				<tr>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh01.gif",83,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh02.gif",512,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh03.gif",98,27,"")%></th>
					<th><%=viewImg(IMG_SHOP&"/detailReviewTh04.gif",87,27,"")%></th>
				</tr>
			</thead>
			<tbody>
				<%

					PAGESIZE2 = 10
					PAGE2 = 1


					arrParams = Array(_
						Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE2),_
						Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE2),_
						Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
						Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0)_
					)
					arrList = Db.execRsList("DKP_MYPAGE_REVIEW_LIST",DB_PROC,arrParams,listLen,Nothing)
					All_Count2 = arrParams(UBound(arrParams))(4)

					PAGECOUNT2 = int((ccur(All_Count2) - 1 ) / CInt(PAGESIZE2) ) + 1
					IF CCur(PAGE2) = 1 Then
						CNT2 = All_Count2
					Else
						CNT2 = All_Count2 - ((CCur(PAGE2)-1)*CInt(PAGESIZE2)) '
					End If

					If IsArray(arrList) Then
						For i = 0 To listLen
						ThisNum = ALL_Count - CInt(arrList(0,i)) + 1

						ThisIDLen = Len(arrList(3,i))

						ThisWriterID = Left(Left(arrList(3,i),3)&"********************",ThisIDLen)
						thisDateValue = DateValue(arrList(8,i)) & " "&Hour(arrList(8,i))&":"&Minute(arrList(8,i))

						voteIcon = viewImg(IMG_SHOP&"/review_icon0"&arrList(4,i)&".gif",55,16,"")

				%>

				<tr>
					<td rowspan="2" class="underline"><%=voteIcon%></td>
					<td class="subject"><a href="javascript:open_reviews('<%=arrList(1,i)%>')"><%=arrList(5,i)%></a></td>
					<td><%=ThisWriterID%></td>
					<td rowspan="2" class="underline"><%=thisDateValue%></td>
				</tr><tr>
					<td colspan="2" class="review_td2 underline"><p><%=cutString(stripHTMLtag(arrList(6,i)),300)%></p></td>
				</tr>
				<%
						Next
					Else
				%>
				<tr>
					<td colspan="4" style="height:80px; text-align:center;">해당 상품에 등록된 리뷰 가 없습니다.</td>
				</tr>
				<%
					End If
				%>
			</tbody>
		</table>
		<div class="pagingArea"><% Call pageList2(PAGE2,PAGECOUNT2)%></div>
	</div>
</div>
<!--#include virtual="/_include/copyright.asp"-->
