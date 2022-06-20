<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 3 'gRequestTF("view",True)
	mNum = 2
	sView = gRequestTF("sView",True)
'	Select Case sView
'		Case "2"
'		Case "2"
'		Case "2"
	'sView = 4



	SQL = "SELECT * FROM [DK_PYRAMID_LAW] WHERE [intCate] = ? ORDER BY [intSort] ASC"
	arrParams = Array(_
		Db.makeParam("@intCate",adInteger,adParamInput,4,sView) _
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
				$(this).next("div").removeClass("hide")
				.siblings("div").addClass("hide");
			} else {
				$(this).next("div").addClass("hide")
				.siblings("div").addClass("hide");
			}

	//		$(this).next("div").removeClass()
	//		.siblings("div").addClass("hide");
		});

		var spanMaxWidth;
		var ThisWidth;
		spanMaxWidth = 0;
		//alert(spanCount);

		$("span.aticle").each(function(index, domEle) {
			ThisWidth = $(domEle).width();
			if (ThisWidth > spanMaxWidth)
			{
				spanMaxWidth = ThisWidth;
				//alert(spanMaxWidth);
			}
		});
		$("span.aticle").css("width",spanMaxWidth);
/*
		for (i=1;i <= spanCount ;i++ )
		{
			$("span.aticle").[i];
			//alert($("span.aticle").width());
			var ThisWidth = $("span.aticle").width();
			if (ThisWidth > spanMaxWidth)
			{
				spanMaxWidth = ThisWidth;

			}
		}
*/
		//alert(spanMaxWidth);
	});


//-->
</script>
<link rel="stylesheet" href="faq2.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<p><%=viewImg(IMG_content&"/business_03_02_tit.jpg",780,45,"")%></p>

<div class="faq" style="margin-top:50px;">
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
				arrList_intIDX			= arrList(1,i)
				arrList_strArticle		= arrList(3,i)
				arrList_strSubject		= arrList(4,i)
				arrList_strContent		= arrList(5,i)
	%>
		<h3><span class="aticle"><%=arrList_strArticle%></span> <%=arrList_strSubject%></h3>
		<div><%=backword(arrList_strContent)%></div>
	<%
			Next
		Else
	%>
	<p class="notFAQ">등록된 자주 묻는 질문이 없습니다</p>
	<%
		End If
	%>

</div>

<!--#include virtual = "/_include/copyright.asp"-->