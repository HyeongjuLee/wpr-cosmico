<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	PAGE_SETTING2 = "SUBPAGE"

	view = 4 'gRequestTF("view",True)
	mNum = 2
	sView = gRequestTF("sView",True)

	Select Case sView
		Case "1"
			intCate = 1
		Case "2"
			intCate = 2
		Case "3"
			intCate = 3
		Case "4"
			intCate = 4
	End Select

	SQL = "SELECT * FROM [DK_PYRAMID_LAW] WHERE [intCate] = ? ORDER BY [intSort] ASC"
	arrParams = Array(_
		Db.makeParam("@intCate",adInteger,adParamInput,4,intCate) _
	)
	arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript">
<!--
	$(function(){
		click();
	});

	var click = function(){
		$('.pyramid li h6').click(function(index){
			$(this).parent('li').toggleClass('active');
			$(this).parent('li').siblings().removeClass('active');
		});
	};
//-->
</script>
<link rel="stylesheet" href="/m/css/pyramid.css?v0" />
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<script>
	$('.nav-left-sub').ready(function(){
		var sub = $('.nav-left-sub ol li');
		var depth2 = sub.eq(<%=intCate%> - 1);

		depth2.addClass('depth2');

		<%If NAVI_P_NUM = 1 Then%>
			$('.nav-left-sub > ul').scrollLeft(0);
		<%Else%>
			$('.nav-left-sub > ul').scrollLeft(depth2.position().left - 100);
		<%End If%>
		
	});
</script>
<div class="nav-left-sub">
	<ol>
		<li><a href="/m/page/pyramid_law.asp?sview=1"><span><%=LNG_PYRAMID_01%></span></a>
		<li><a href="/m/page/pyramid_law.asp?sview=2"><span><%=LNG_PYRAMID_02%></span></a>
		<li><a href="/m/page/pyramid_law.asp?sview=3"><span><%=LNG_PYRAMID_03%></span></a>
	</ol>
</div>
<div class="pyramid">
	<ul>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
				arrList_strAticle		= arrList(3,i)
				arrList_strSubject		= arrList(4,i)
				arrList_strContent		= arrList(5,i)
	%>
		<li>
			<h6>
				<p><span class="article"><%=arrList_strAticle%></span>
					<span class="subject"><%=arrList_strSubject%></span></p>
				<i class="icon-angle-circled-down"></i>
			</h6>
			<div class="contents"><%=backword(arrList_strContent)%></div>
		</li>

	<%Next%>
	</ul>
	<%Else%>
	<p class="notFAQ">등록된 관련규정이 없습니다</p>
	<%
		End If
	%>

</div>
<div class="pageArea2"><%Call pageList(PAGE,PAGECOUNT)%></div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
</form>
<!--#include virtual = "/m/_include/copyright.asp"-->