<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "GUIDE"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 5
	sNum = view
	sVar = sNum

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript">
	$(function(){
		$('.guide .tab_wrap li').each(function(i){
			var i = 0;
			var $index = $(this).index();
			$(this).eq(i).addClass('tab'+$index);
			

			$('.guide .con_wrap .con').each(function(i){
				var i = 0;
				var $index = $(this).index();
				
				$(this).eq(i).addClass('tab'+$index);
			});

			var $class = $(this).attr('class');
			
			$('li.'+$class).click(function(e){
				$('.guide .tab_wrap li, .guide .con_wrap .con').removeClass('active');

				var $target = $(e.target).attr('class');
				console.log($target);
				$('.'+$target).addClass('active');
			});
		});
		$('.tab0').addClass('active');
	});
</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<%Select Case view%>
<%Case "1"%>
	<div class="guide guide01">
		<div class="tab_wrap">
			<ul>
				<li>안티에이징</li>
				<li>계절별</li>
				<li>여드름</li>
			</ul>
		</div>
		<div class="con_wrap">
			<div class="con">
				<img src="/m/images/content/guide01_1.jpg" alt="" width="100%" />
			</div>
			<div class="con">
				<img src="/m/images/content/guide01_2.jpg" alt="" width="100%" />
			</div>
			<div class="con">
				<img src="/m/images/content/guide01_3.jpg" alt="" width="100%" />
			</div>
		</div>
	</div>
<%Case "2"%>
	<img src="/m/images/content/guide02_2.jpg" alt="" width="100%" />

	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>

<!--#include virtual = "/m/_include/copyright.asp"-->