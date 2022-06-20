<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	mode = Request("mode")
	If mode = "TODAYGOODS" Then
		page    = Request("page")
		T_Goods = Request.Cookies("TodayGcode")
		T_Count = Request.Cookies("TodayGcode").count
		If T_Goods = "" OR T_Count = "" Then T_Count = 0
		If T_Count > 11 Then T_Count = 11

		If T_Count / 3 <= 1 Then
			T_Count_page = 1
		Else
			T_Count_page = CInt(T_Count / 3)
		End If

		fromCount = (page*3) - 2
		toCount = page * 3

		nextPage = page+1
		If nextPage > T_Count_page Then nextPage = T_Count_page
		prePage = page - 1
		If prePage < 1 Then prePage = 1
	'한글
    %>
	<div class="goodsArea">
    <%

       For g_cnt = fromCount  To toCount
          TodayGcode = Request.Cookies("TodayGcode")("G" & g_cnt)
          TodayImg = Request.Cookies("TodayImg")("G" & g_cnt)
          'TodayUrl = Request.Cookies("TodayUrl")("G" & g_cnt)
          If TodayUrl = "" Then TodayUrl = "#"
		  If TodayGcode <> "" Then
			tGInt = 0
			If InStr(TodayImg,"http://") > 0 Then tGInt = tGInt + 1
			If InStr(TodayImg,"https://") > 0 Then tGInt = tGInt + 1
			If tGInt > 0 Then
				TodayImg = TodayImg
			Else
				TodayImg = VIR_PATH("goods/thum")&"/"&TodayImg
			End If
          %>
			<a href="/shop/detailView.asp?gidx=<%=TodayGcode%>" class="imgLinks"><img src="<%=TodayImg%>" width="70" /></a>

		  <%
		  End If
       Next
    %>
	</div>
    <div style="text-align:center;"><a href="Javascript:fnGetTodayGoods(<%=prePage%>);"><span style="float:left;padding:6px;padding-top:0;">◀</span></a><%=page%> / <%=T_Count_page%><a href="Javascript:fnGetTodayGoods(<%=nextPage%>);"><span style="float:right;padding:6px;padding-top:0;">▶</span></a></div>
    <%
End If
%>