<%

	li_class_snum1 = "off"
	li_class_snum2 = "off"
	li_class_snum3 = "off"
	li_class_snum4 = "off"
	li_class_snum5 = "off"


	Select Case sview
		Case 1 : li_class_snum1 = "on"
		Case 2 : li_class_snum2 = "on"
		Case 3 : li_class_snum3 = "on"
		Case 4 : li_class_snum4 = "on"
		Case 5 : li_class_snum5 = "on"
	End Select
%>
<script type="text/javascript">
	//#sub_navi 고정
	$( document ).ready( function() {
		var jbOffset = $( '#content' ).offset();
		var	scrolled = false;

		$( window ).scroll( function() {
			if ($( document ).scrollTop() > 120 && !scrolled) {
				$( '#sub_navi .sub_nav' ).addClass( 'jbFixed' );
				$( '#sub_navi .sub_nav' ).animate({top: '0', opacity: '0'},0);
				$( '#sub_navi .sub_nav' ).animate({top: '0', opacity: '1'},0);
				scrolled = true;
			}
			if ($( document ).scrollTop() < 120 && scrolled) {
				$( '#sub_navi .sub_nav' ).removeClass( 'jbFixed' );
				$( '#sub_navi .sub_nav' ).animate({opacity: '0'},0);
				$( '#sub_navi .sub_nav' ).animate({top: '0px', opacity: '1'},0);
				scrolled = false;
			}
		});
	});
</script>

<%
'▣▣▣ sub menu 위치이동 / highlight ▣▣▣
Select Case PAGE_SETTING
	Case "COMPANY","BRAND","BUSINESS","CUSTOMER" 		'해당페이지만 적용!!!
%>
	<script type="text/javascript">

		$(document).ready(function() {
			var sub_li	  = "#sub_navi .sub_nav ul li"
			var sub_li_sm = sub_li+".sm"+<%=view%>;			//li.sm클래스
			//console.log($(sub_li_sm).position().left);
			<%If view = 1 Then%>
				$("#sub_navi .sub_nav ul").scrollLeft(0);	//첫번 째 메뉴
			<%Else%>
				$("#sub_navi .sub_nav ul").scrollLeft($(sub_li_sm).position().left -100);
			<%End If%>

			$(sub_li).addClass("");			//초기화
			$(sub_li_sm).addClass("on");	//현페이지 highlight
		});

	</script>
<%
End Select
%>

<%
Select Case PAGE_SETTING
	Case "COMPANY","BUSINESS","BRAND","CUSTOMER"
%>

<div id="sub_navi">
	<%
		Select Case PAGE_SETTING
	%>

	<% Case "COMPANY" %>
		<div class="sub_nav">
			<ul>
				<li class="sm1"><a href="/m/page/company.asp?view=1"><%=LNG_COMPANY_01%></a><i></i></li>
				<li class="sm2"><a href="/m/page/company.asp?view=2"><%=LNG_COMPANY_02%></a><i></i></li>
				<li class="sm3"><a href="/m/page/company.asp?view=3"><%=LNG_COMPANY_03%></a><i></i></li>
				<li class="sm4"><a href="/m/page/company.asp?view=4"><%=LNG_COMPANY_04%></a><i></i></li>
				<li class="sm5"><a href="/m/page/location.asp"><%=LNG_COMPANY_05%></a><i></i></li>
			</ul>
		</div>
	<% Case "BUSINESS" %>
		<div class="sub_nav">
			<ul>
				<li class="sm1"><a href="/m/page/business.asp?view=1"><%=LNG_BUSINESS_01%></a><i></i></li>
				<li class="sm2"><a href="/m/page/business.asp?view=2"><%=LNG_BUSINESS_02%></a><i></i></li>
				<li class="sm3"><a href="/m/page/business.asp?view=3"><%=LNG_BUSINESS_03%></a><i></i></li>
				<li class="sm4"><a href="/m/page/pyramid_law.asp?sview=1"><%=LNG_BUSINESS_04%></a><i></i></li>
			</ul>
			<%
				Select Case view
					Case "1","2","3"
					Case "4"
						PRINT "	<div class=""sub_nav2"">"
						PRINT "		<ul>"
						PRINT "			<li class="""&li_class_snum1&"""><a href=""/m/page/pyramid_law.asp?sview=1"">"&LNG_BUSINESS_04_01&"</a></li>"
						PRINT "			<li class="""&li_class_snum2&"""><a href=""/m/page/pyramid_law.asp?sview=2"">"&LNG_BUSINESS_04_02&"</a></li>"
						PRINT "			<li class="""&li_class_snum3&"""><a href=""/m/page/pyramid_law.asp?sview=3"">"&LNG_BUSINESS_04_03&"</a></li>"
						PRINT "		</ul>"
						PRINT "	</div>"
					Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
				End Select
			%>
		</div>
	<% Case "BRAND" %>
		<div class="sub_nav">
			<ul>
				<li class="sm1"><a href="/m/page/brand.asp?view=1"><%=LNG_BRAND_01%></a><i></i></li>
			</ul>
		</div>

	<% Case "CUSTOMER" %>
		<div class="sub_nav">
			<ul>
				<li class="sm1"><a href="/m/cboard/board_list.asp?bname=notice"><%=LNG_CUSTOMER_01%></a><i></i></li>
				<!-- <li class="sm2"><a href="/m/cboard/board_list.asp?bname=qna"><%=LNG_CUSTOMER_02%></a><i></i></li> -->
				<li class="sm3"><a href="/m/cboard/board_list.asp?bname=pds"><%=LNG_CUSTOMER_03%></a><i></i></li>
				<li class="sm4"><a href="/m/cboard/board_list.asp?bname=notice2"><%=LNG_CUSTOMER_04%></a><i></i></li>
				<%If webproIP="T" then%>
				<%End If%>
			</ul>
		</div>

	<%
		End Select
	%>
</div>

<%
End Select
%>