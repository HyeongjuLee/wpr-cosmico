<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = "CUSTOMER"

	view = 3

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

'	arrParams = Array(_
'		Db.makeParam("@intCate",adInteger,adParamInput,10,intCate),_
'		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_
'		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR),_
'		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
'		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
'		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
'	)
'	arrList = Db.execRsList("DKSP_FAQ_LIST",DB_PROC,arrParams,listLen,Nothing)
'	All_Count = arrParams(UBound(arrParams))(4)

	arrParams = Array(_
		Db.makeParam("@intCate",adInteger,adParamInput,10,intCate),_
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG),_
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
<style type="text/css">

	.input_text {height:15px;}
	.bor1 {border:1px solid #ccc;}

	.padding_left7 {padding-left:7px;}

	th, td {border:1px solid #ccc; padding:4px 0px;}
	th {background-color:#eee;}


	.insert td {padding-left:7px;}

	.list th {padding:8px 0px;}
	.list td {}

	.regist th {padding:8px 0px;}
	.regist td {padding-left:7px;}


	.faq {width:100%;border-bottom:solid 1px #c4c4c4;color:#333; margin-top:7px;}
	.faq h3 {background:#e9e7e7; margin:0; padding:10px 15px; font:bold 110%/100% Arial, Helvetica, sans-serif; border:solid 1px #c4c4c4; border-bottom:none; cursor:pointer; }
	.faq p {background:#f7f7f7; margin:0;  line-height:160%;}
	.faq div {background:#f7f7f7; margin:0; padding:10px 15px 20px; border-left:solid 1px #c4c4c4; border-right:solid 1px #c4c4c4; }
	.hide {position:absolute; left:-1000%; top:0; width:1px; height:1px; font-size:0; line-height:0; overflow:hidden; }
	.notFAQ {background:#e9e7e7; margin:0; padding:50px 0px; font:bold 110%/100% Arial, Helvetica, sans-serif; border:solid 1px #c4c4c4; border-bottom:none; cursor:pointer; text-align:center;}

	/* UI Object */
	.tab2{position:relative;margin-top:20px;background:url(/images/faq/tab_menu.gif) repeat-x 0 100%;font-family:'돋움',dotum;font-size:12px}
	.tab2 ul,.tab2 ul li{margin:0;padding:0}
	.tab2 ul li{list-style:none}
	.tab2 ul li,.tab2 ul li a{background:url(/images/faq/bg_tab2_off.gif) no-repeat}
	.tab2 ul li{float:left;margin-right:-1px;line-height:26px}
	.tab2 ul li a{display:inline-block;padding:2px 16px 1px;_padding:3px 16px 0;background-position: 100% 0;font-weight:bold;color:#666;text-decoration:none !important}
	.tab2 ul li a:hover{color:#000}
	.tab2 ul li.on,.tab2 ul li.on a{background-image:url(/images/faq/bg_tab2_on.gif)}
	.tab2 ul li.on a{color:#3376b8}
	/* //UI Object */

	.select {width:100%; font-size:13px; padding:5px 0px;}
</style>
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

		$("select[name=faq_select]").change(function(e) {
			//alert($(this).val());
			document.location.href='faq.asp?cate='+$(this).val();
		});

	});


//-->
</script>

</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
</div>
<div id="faq" style="width: 92%; margin: 0 auto;">
	<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_CUSTOMER_03%></div>
	<div class="tab2">

		<select name="faq_select" class="select">
			<option value=""><%=LNG_FAQ_LIST_TEXT01%></option>

			<%

				arrParams2 = Array(_
					Db.makeParam("@strNation",adVarChar,adParamInput,10,Lang) _
				)
				arrList2 = Db.execRsList("DKSP_FAQ_CATEGORY_LIST",DB_PROC,arrParams2,listLen2,Nothing)
					If IsArray(arrList2) Then
						For j = 0 To listLen2
							arrList_intIDX			= arrList2(0,j)
							arrList_isDel			= arrList2(1,j)
							arrList_isView			= arrList2(2,j)
							arrList_intSort			= arrList2(3,j)
							arrList_strTitle		= arrList2(4,j)

				%>
				<option value="<%=arrList_intIDX%>" <%=isSelect(arrList_intIDX,intCate)%>><%=arrList_strTitle%></option>
				<%
						Next
					Else
				End If
			%>
		</select>
	</div>


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
		<p class="notFAQ"><%=LNG_FAQ_LIST_TEXT06%></p>
		<%
			End If
		%>

	</div>
	<div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div>
	<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	</form>


</div>
<!--#include virtual = "/m/_include/copyright.asp"-->