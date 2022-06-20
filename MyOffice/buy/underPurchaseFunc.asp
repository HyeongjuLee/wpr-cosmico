<%
'깨방정

	'function underPurchase_ajax_view(MBID1,MBID2,SDATE,EDATE,viewID,ajax_page,ajax_url){

		'하선구매 ajax_Paging

		Sub pageList_underPurchase(ByVal page, ByVal total_page,ByVal MBID1,ByVal MBID2, ByVal SDATE, ByVal EDATE,ByVal divID,ByVal ajaxPage )
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
			If pre_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&first_page&"','"&ajaxPage&"')""><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')""><</a></span>"

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
					strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"')"">" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"">></a></span>"
			If next_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&total_page&"','"&ajaxPage&"')"">>></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList


		End Sub


%>
<%
		'하선구매 ajax_Paging
		'SELLCODE, sLvl 추가

		Sub pageList_underPurchase_N(ByVal page, ByVal total_page, ByVal MBID1, ByVal MBID2, ByVal SDATE, ByVal EDATE, ByVal SELLCODE, ByVal sLvl, ByVal divID, ByVal ajaxPage )
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
			If pre_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&first_page&"','"&ajaxPage&"')""><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')""><</a></span>"

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
					strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&page_num&"','"&ajaxPage&"')"">" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"">></a></span>"
			If next_part <> 0 Then strPageList = strPageList & "<span class=''><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&total_page&"','"&ajaxPage&"')"">>></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList


		End Sub
%>