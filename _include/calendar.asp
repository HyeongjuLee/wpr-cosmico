
<link rel="stylesheet" href="/datepicker/jquery-ui.css">
<script src="/datepicker/jquery-ui.js"></script>
<script type="text/javascript">
	$(function() {
		$( "#DDATE, #mDDATE" ).datepicker({
			dateFormat			: "yy-mm-dd",				//데이터 포맷으로 (yy년 mm월 dd일, yyyy-mm-dd, mm/dd/yy, yy-mm-dd)
			changeMonth			: false,
			changeYear			: false,
			yearRange			: "c-5:c+5",
			showAnim			: "slideDown",				//달력의 표시 형태 show,slideDown,fadeIn,blind,bounce,clip,drop
			minDate				: "<%=nowDate%>",
			maxDate				: "<%=DateAdd("d",1,nowDate)%>",
			<%IF Ucase(Lang) ="KR" THEN%>
			showMonthAfterYear	: true,						//True(Year Month), False(Month Year)
			yearSuffix			: "년",						//OOOO년
			monthNames			: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			monthNamesShort		: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			dayNames			: ['일', '월', '화', '수', '목', '금', '토'],		//PopUp
			dayNamesMin			: ['일', '월', '화', '수', '목', '금', '토'],		//요일
			<%END IF%>
		});
		$('.ui-datepicker').css('font-size', '15px');								//font대비 달력크기조정(기본 13px)
		$('.ui-datepicker').css({ "margin-left" : "0px", "margin-top": "0px"});		//달력(calendar) 위치
	});
</script>