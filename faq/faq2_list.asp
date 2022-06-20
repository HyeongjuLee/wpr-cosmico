<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 6 'gRequestTF("view",True)
	mNum = 4
	sView = 5

	Dim PAGESIZE		:	PAGESIZE = Request.Form("PAGESIZE")
	Dim PAGE			:	PAGE = Request.Form("PAGE")
	Dim SEARCHTERM		:	SEARCHTERM = Request.Form("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR = Request.Form("SEARCHSTR")
	Dim intCate			:	intCate = Request.QueryString("cate")
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1
	If intCate = "" Then intCate = ""


	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If

	arrParams = Array(_
		Db.makeParam("@intCate",adInteger,adParamInput,10,intCate),_
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_FAQ2_LIST",DB_PROC,arrParams,listLen,Nothing)
	All_Count = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If



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
	});


//-->
</script>
<link rel="stylesheet" href="faq.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<p><%=viewImg(IMG_FAQ&"/customer_06_05_tit.jpg",780,45,"")%></p>
<div class="tab2">
	<ul>
<%
	arrList2 = Db.execRsList("DKP_FAQ2_CATEGORY_LIST",DB_PROC,Nothing,listLen2,Nothing)
		If IsArray(arrList2) Then
			If intCate = "" Then
				classOn = "class=""on"""
			Else
				classOn = ""
			End If

%>
<li <%=classOn%>><a href="faq2_list.asp">전체</a></li>
<%
			For j = 0 To listLen2
				arrList_intIDX			= arrList2(0,j)
				arrList_isDel			= arrList2(1,j)
				arrList_isView			= arrList2(2,j)
				arrList_intSort			= arrList2(3,j)
				arrList_strTitle		= arrList2(4,j)

				Select Case arrList_isView
					Case "T" : Icon_viewTF = "[보임]"
					Case "F" : Icon_viewTF = "[숨김]"
					Case Else : Icon_viewTF = "[오류]"
				End Select
				If intCate <> "" Then
					If CInt(intCate) = CInt(arrList_intIDX) Then
						classOn = "class=""on"""
					Else
						classOn = ""
					End If
				Else
					classOn = ""
				End If
	%>
	<li <%=classOn%>><a href="faq2_list.asp?cate=<%=arrList_intIDX%>"><%=arrList_strTitle%></a></li>
	<%
			Next
		Else
	%>
	<li class="on"><a href="faq2_list.asp">카테고리가 존재하지 않습니다.</a></li>
	<%
		End If
	%>

	</ul>
</div>
<!--//ui object -->


<div class="faq">
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
				arrList_intIDX			= arrList(1,i)
				arrList_strSubject		= arrList(2,i)
				arrList_strContent		= arrList(3,i)
	%>
		<h3><%=arrList_strSubject%></h3>
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
<div class="pageArea2"><%Call pageList(PAGE,PAGECOUNT)%></div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
</form>
<!--#include virtual = "/_include/copyright.asp"-->