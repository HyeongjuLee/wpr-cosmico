
<style type="text/css">
	.sticky-wrap {
		width: 100%;
		max-height: 350px;
		height: auto;
		margin: auto;
		overflow: auto;
	}
	.sticky-wrap thead th {
		position: -webkit-sticky;
		position: sticky;
		top: -1px;
		border-top: none !important;
		border-bottom: none !important;
		box-shadow: inset 0 1px 0 #ddd, inset 0 -1px 0 #ddd;
		border-bottom: 2px solid #000000;
		white-space: nowrap;
	}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		//sticky head top bottom border control
		$.fn.hasScrollBar = function() {return this.get(0).scrollHeight > this.height();}
		if ($('.sticky-wrap').hasScrollBar()) {
			$('.sticky-wrap').scrollTop(1);			//sticky-wrap thead th
			$('.sticky-wrap').scroll(function() {
				if ($(this).scrollTop() < 1) {
					$('.sticky-wrap').scrollTop(1);
				}
			});
		}else{
			$('table thead th').css({"box-shadow":"none"});
		}
	});
</script>

<%
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

			If next_part > total_page Then next_part = 0
			strPageList = ""
			If pre_part <> 0 Then strPageList = strPageList & "<span class=""arrow left margin""><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&pre_part&"','"&ajaxPage&"')""><i class=""icon-angle-left""></i></a></span>"

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
					strPageList = strPageList & "<span><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&page_num&"','"&ajaxPage&"')"">" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class=""arrow right margin""><a href=""javascript:pay_ajax_view('"&dataType&"','"&EDATE&"','"&divID&"','"&next_part&"','"&ajaxPage&"')""><i class=""icon-angle-right""></i></a></span>"


			If total_page <> 0 Then 	Response.Write strPageList

		End Sub
%>
