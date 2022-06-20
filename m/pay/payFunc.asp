<%
'깨방정
		Sub pageList_payM(ByVal page, ByVal total_page,ByVal dataType, ByVal EDATE,ByVal divID,ByVal ajaxPage )
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
			'If pre_part <> 0 Then strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')""><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')"" ><</a></span>"

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
						strPageList = strPageList & "<span class='currentPage defalut'>" &page_num& "</span>"
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='currentPage defalut'>" &page_num& "</span>"
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='defalut'><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" >" &page_num& "</a></span>"
					Else
						strPageList = strPageList & "<span><a class='defalut' href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"">" &page_num& "</a></span>"
					End If
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"" >></a></span>"
			'If next_part <> 0 Then strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"">>></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList



		End Sub



		Sub pageList_pay(ByVal page, ByVal total_page,ByVal dataType, ByVal EDATE,ByVal divID,ByVal ajaxPage )
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
			'If pre_part <> 0 Then strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')""><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')"">◀</a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For

				If page_num = ccur(page) Then
					If page_num < 10 Then
						strPageList = strPageList & "<span class='currentPage' style='width:13px;'>" &page_num& "</span>"
					Else
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"" style='width:13px;'>" &page_num& "</a></span>"
					Else
						strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"');"">" &page_num& "</a></span>"
					End If
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"">▶</a></span>"
			'If next_part <> 0 Then strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&next_part&"','"&ajaxPage&"')"">>></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList



		End Sub




%>