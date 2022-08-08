<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "GUIDE"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 4
	sNum = view
	sVar = sNum

%>
<!--#include virtual = "/_include/document.asp"-->
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
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
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
					<div class="ready">
						<div><img src="/images/content/maintenance-line.svg" alt=""></div>
						<p><%=LNG_READY_02_01%></p>
					</div>
				</div>
				<div class="con">
					<div class="ready">
						<div><img src="/images/content/maintenance-line.svg" alt=""></div>
						<p><%=LNG_READY_02_01%></p>
					</div>
				</div>
				<div class="con">
					이 안에 내용 작성
				</div>
			</div>
		</div>
	<%Case "2"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "3"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->


