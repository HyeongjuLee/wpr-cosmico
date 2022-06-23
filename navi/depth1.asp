
<!--#include virtual = "/navi/company.asp"-->
<!--#include virtual = "/navi/brand.asp"-->
<!--#include virtual = "/navi/product.asp"-->
<!--#include virtual = "/navi/business.asp"-->
<!--#include virtual = "/navi/guide.asp"-->
<!--#include virtual = "/navi/shop.asp"-->
<!--#include virtual = "/navi/community.asp"-->
<!--#include virtual = "/navi/customer.asp"-->
<!--#include virtual = "/navi/sns.asp"-->
<!--#include virtual = "/navi/mypage.asp"-->
<!--#include virtual = "/navi/policy.asp"-->
<%Select Case NAVI_P_NUM%>
<%Case "8"%>
<!--include virtual = "/navi/gallery.asp"-->
<%End Select%>

<script type="text/javascript">
	$(document).each(function(){
		var navMain = $('.nav-left').find('li.main');

		navMain.find('.nav-sub').remove();
	});
</script>

<%Select Case NAVI_P_NUM%>
<%Case "0"%>
<script type="text/javascript">
	$(document).each(function(){
		var sub_title = $('.nav-left').find('li.none:contains(<%=sub_title_d2%>)');

		$('.nav-left').find('li.none').not(sub_title).remove();
	});
</script>
<%Case Else%>
<script type="text/javascript">
	$(document).each(function(){
		$('.nav-left').find('li.none').remove();
	});
</script>
<%End Select%>