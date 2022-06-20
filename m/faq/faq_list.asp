<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	PAGE_SETTING2 = "SUBPAGE"
	ISSUBTOP = "T"

	Dim PAGESIZE		:	PAGESIZE = Request.Form("PAGESIZE")
	Dim PAGE			:	PAGE = Request.Form("PAGE")
	Dim SEARCHTERM		:	SEARCHTERM = Request.Form("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR = Request.Form("SEARCHSTR")
	Dim intCate			:	intCate = Request.QueryString("cate")
	Dim sc_Group		:	sc_Group = Request.QueryString("sc_Group")

	If PAGESIZE = "" Then PAGESIZE = 15
	If PAGE = "" Then PAGE = 1
	If intCate = "" Then intCate = ""
	If sc_Group = "" Then sc_Group = "BASIC"

	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If
	'▣ 설정확인 S
		arrParams_C = Array(_
			Db.makeParam("@strNationCode",adVarchar,adParamInput,10,LANG), _
			Db.makeParam("@strGroup",adVarchar,adParamInput,20,sc_Group) _
		)
		Set DKRS_C = Db.execRs("DKSP_FAQ_CONFIG_VIEW",DB_PROC,arrParams_C,Nothing)
		If Not DKRS_C.BOF And Not DKRS_C.EOF Then
			DKRS_C_intIDX			= DKRS_C("intIDX")
			DKRS_C_strNationCode	= DKRS_C("strNationCode")
			DKRS_C_strGroup			= DKRS_C("strGroup")
			DKRS_C_strCateCode		= DKRS_C("strCateCode")
			DKRS_C_isUse			= DKRS_C("isUse")
			DKRS_C_mainVar			= DKRS_C("mainVar")
			DKRS_C_SubVar			= DKRS_C("SubVar")
			DKRS_C_sViewVar			= DKRS_C("sViewVar")
			DKRS_C_intViewLevel		= DKRS_C("intViewLevel")
		Else
			Call ALERTS("존재하지 않는 FAQ 입니다","BACK","")
		End If
		Set DKRS_C = Nothing

		mNum = DKRS_C_mainVar
		sNum = DKRS_C_SubVar
		sVar = DKRS_C_sViewVar
		view = mNum
		If DK_MEMBER_LEVEL < DKRS_C_intViewLevel Then
			Call ALERTS("접근할 수 없는 메뉴입니다","BACK","")
		End If

	'▣ 설정확인 E

	sNum = 2
	view = sNum


	arrParams = Array(_
		Db.makeParam("@intCate",adInteger,adParamInput,10,intCate),_
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG),_
		Db.makeParam("@strType",adVarChar,adParamInput,10,sc_Group),_
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKSP_FAQ_LIST",DB_PROC,arrParams,listLen,Nothing)
	All_Count = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<!-- <link rel="stylesheet" href="faq.css?v2.0" /> -->
<link rel="stylesheet" href="/m/css/style.css?v0" />
<script type="text/javascript">

	// $(document).ready(function(){
	// 	$(".list div").addClass("hide");
	// 	$(".list h3").click(function(){
	// 		if ($(this).next("div").hasClass("hide"))
	// 		{
	// 			$(this).next("div").removeClass("hide")
	// 			.siblings("div").addClass("hide");
	// 		} else {
	// 			$(this).next("div").addClass("hide")
	// 			.siblings("div").addClass("hide");
	// 		}

	// 		//$(this).next("div").removeClass()
	// 		//.siblings("div").addClass("hide");
	// 	});
	// });

	var faqList = function(){
		var add = $('.icon-add');
		var remove = $('.icon-remove');
		$('#faq .list li').each(function(index, item){
			remove.hide(0);
			$(item).on('click', function(){
				$(this).toggleClass('active');
				$(this).find('.faqContent').toggleClass('hide');
				$(this).find(add).toggle(0);
				$(this).find(remove).toggle(0);
				//debugger;
				$('li').not(this).removeClass('active');
				$('li').not(this).find('.faqContent').addClass('hide');
				$('.faqContent').each(function(){
					if ($(this).hasClass('hide') == true) {
						$(this).siblings('h3').find(add).show(0);
						$(this).siblings('h3').find(remove).hide(0);
					}else{
						$(this).siblings('h3').find(remove).show(0);
						$(this).siblings('h3').find(add).hide(0);
					}
				});
			});
		});

	};

	$(function(){
		faqList();
	});

	function pagegotoMove(PG,recordcnt)
	{
		document.frm.PAGE.value=PG;
		document.frm.submit();
	}

</script>

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<div id="faq">
	<ul class="menu">
		<%If intCate = "" Then%>
			<li class="on"><a href="faq_list.asp?sc_group=<%=sc_Group%>"><%=LNG_FAQ_LIST_TEXT01%></a></li>
		<%Else%>
			<li><a href="faq_list.asp?sc_group=<%=sc_Group%>"><%=LNG_FAQ_LIST_TEXT01%></a></li>
		<%End If%>

		<%
			arrParams2 = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,10,LANG), _
				Db.makeParam("@strGroup",adVarChar,adParamInput,20,sc_group) _
			)
			arrList2 = Db.execRsList("DKSP_FAQ_CATEGORY_LIST",DB_PROC,arrParams2,listLen2,Nothing)
			If IsArray(arrList2) Then
				If intCate = "" Then
					classOn = "class=""on"""
				Else
					classOn = ""
				End If

				For j = 0 To listLen2
					arrList2_intIDX			= arrList2(0,j)
					arrList2_strNationCode	= arrList2(1,j)
					arrList2_strGroup		= arrList2(2,j)
					arrList2_isDel			= arrList2(3,j)
					arrList2_isView			= arrList2(4,j)
					arrList2_intSort		= arrList2(5,j)
					arrList2_strTitle		= arrList2(6,j)

					If intCate <> "" Then
						If CInt(intCate) = CInt(arrList2_intIDX) Then
							classOn = "class=""on"""
						Else
							classOn = ""
						End If
					Else
						classOn = ""
					End If

					PRINT "<li "&classOn&"><a href=""faq_list.asp?sc_group="&sc_Group&"&cate="&arrList2_intIDX&""">"&arrList2_strTitle&"</a></li>"
				Next
			End If
		%>
	</ul>

	<div class="list">
		<ul>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX			= arrList(1,i)
					arrList_strSubject		= arrList(2,i)
					arrList_strContent		= arrList(3,i)
		%>
		<li>
			<h3><%=arrList_strSubject%><i class="icon-add"></i><i class="icon-remove"></i></h3>
			<div class="faqContent hide"><%=backword_Tag(arrList_strContent)%></div>
		</li>
		<%
				Next
			Else
		%>
		</ul>
		<p class="notFAQ"><%=LNG_FAQ_LIST_TEXT06%></p>
		<%
			End If
		%>

	</div>
	<div class="tcenter"><%Call pagingMobNewMOVE(PAGE,PAGECOUNT)%></div>

	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	</form>
</div>




<!--#include virtual = "/m/_include/copyright.asp"-->