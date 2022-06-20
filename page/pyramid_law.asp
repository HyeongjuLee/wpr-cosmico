<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 44 'gRequestTF("view",True)
	mNum = 2
	sNum = view
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

<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
	$(document).ready(function(){
		$(".faq div").addClass("hide");
		$(".faq h3").click(function(){
			if ($(this).next("div").hasClass("hide"))
			{
				$(this).next("div").removeClass("hide dsnone")
				.siblings("div").addClass("hide");
			} else {
				$(this).next("div").addClass("hide")
				.siblings("div").addClass("hide");
			}

	//		$(this).next("div").removeClass()
	//		.siblings("div").addClass("hide");
		});
	});


//-->
</script>
<link rel="stylesheet" href="pyramid.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
<%Case "KR"%> <!--한국 외 국가 감추기-->

<div class="stit">
	<p><%=title_txt%><span></span></p>
</div>

<div class="pyramid_tit">
	<ul>
	<%Select Case sView%>
		<%Case "1"%>
		<li class="on"><a href="/page/pyramid_law.asp?sview=1"><p><%=LNG_PYRAMID_01%><i></i></p></a></li>
		<li><a href="/page/pyramid_law.asp?sview=2"><p><%=LNG_PYRAMID_02%><i></i></p></a></li>
		<li><a href="/page/pyramid_law.asp?sview=3"><p><%=LNG_PYRAMID_03%><i></i></p></a></li>
		<%Case "2"%>
		<li><a href="/page/pyramid_law.asp?sview=1"><p><%=LNG_PYRAMID_01%><i></i></p></a></li>
		<li class="on"><a href="/page/pyramid_law.asp?sview=2"><p><%=LNG_PYRAMID_02%><i></i></p></a></li>
		<li><a href="/page/pyramid_law.asp?sview=3"><p><%=LNG_PYRAMID_03%><i></i></p></a></li>
		<%Case "3"%>
		<li><a href="/page/pyramid_law.asp?sview=1"><p><%=LNG_PYRAMID_01%><i></i></p></a></li>
		<li><a href="/page/pyramid_law.asp?sview=2"><p><%=LNG_PYRAMID_02%><i></i></p></a></li>
		<li class="on"><a href="/page/pyramid_law.asp?sview=3"><p><%=LNG_PYRAMID_03%><i></i></p></a></li>
	<%End Select%>
	</ul>
</div>

<div class="faq">
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
				arrList_strAticle		= arrList(3,i)
				arrList_strSubject		= arrList(4,i)
				arrList_strContent		= arrList(5,i)




	%>
		<h3><span class="article"><%=arrList_strAticle%></span><span class="subject"><%=arrList_strSubject%></span></h3>
		<div class="dsnone"><%=backword(arrList_strContent)%></div>
	<%
			Next
		Else
	%>
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
<%Case Else%><!--한국 외 국가 준비중 페이지-->
<div class="ready">
	<div class="tit">
		<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
	</div>
	<div class="stit"><%=LNG_READY_02_01%></div>
</div>
<%End Select%>
<!--#include virtual = "/_include/copyright.asp"-->