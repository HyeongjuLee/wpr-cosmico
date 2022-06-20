<%

	'function underPurchase_ajax_view(MBID1,MBID2,SDATE,EDATE,viewID,ajax_page,ajax_url){

			'하선구매 ajax_Paging
		Sub pageList_underPurchaseMob5(ByVal page, ByVal total_page,ByVal MBID1,ByVal MBID2, ByVal SDATE, ByVal EDATE,ByVal divID,ByVal ajaxPage )
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
			If pre_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')"" ><</a></span>"

			For i=1 To 5
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 5) + i
				End If

				If total_page < page_num Then Exit For

				If page_num = ccur(page) Then
					If page_num < 10 Then
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"					'2자리숫자 넓이
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"	'3자리숫자 넓이
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"

					Else
						strPageList = strPageList & "<span><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"">" &page_num& "</a></span>"
					End If
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"" >></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList

		End Sub
%>
<%
		'하선구매 ajax_Paging
		'SELLCODE, sLvl 추가

		Sub pageList_underPurchaseMob5N(ByVal page, ByVal total_page, ByVal MBID1, ByVal MBID2, ByVal SDATE, ByVal EDATE, ByVal SELLCODE, ByVal sLvl, ByVal divID, ByVal ajaxPage )
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
			If pre_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')"" ><</a></span>"

			For i=1 To 5
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 5) + i
				End If

				If total_page < page_num Then Exit For

				If page_num = ccur(page) Then
					If page_num < 10 Then
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"					'2자리숫자 넓이
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"	'3자리숫자 넓이
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"

					Else
						strPageList = strPageList & "<span><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"">" &page_num& "</a></span>"
					End If
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href=""javascript:underPurchase_ajax_view_N('"&MBID1&"','"&MBID2&"','"&SDATE&"','"&EDATE&"','"&SELLCODE&"','"&sLvl&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"" >></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList

		End Sub
%>