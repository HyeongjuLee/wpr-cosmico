<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'### 산하회원정보 : AJAX처리 ###
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER1-7"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()


	'하선기준회원 검색
	UnderID1 	= pRequestTF("UnderID1",False)
	UnderID2 	= pRequestTF("UnderID2",False)
	UnderName 	= pRequestTF("UnderName",False)
	SearchCate 		= pRequestTF("SearchCate",False)

	If UnderID1 = "" Then UnderID1 = DK_MEMBER_ID1
	If UnderID2 = "" Then UnderID2 = DK_MEMBER_ID2
	If UnderName = "" Then UnderName = DK_MEMBER_NAME
	If SearchCate = "" Then SearchCate = "03"


%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css?v0" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript">

	function closeAlert(){
		$("#layerAlert").hide();
	}

	//AJAX
	$(document).ready(function() {
		fnSearch('s');
	});
	function fnSearch(value) {
		let SDATE
		let EDATE
		let UnderID1
		let UnderID2
		let UnderName
		let M_Name
		let SearchCate
		let v_CurGrade
		let v_LEVEL

		if (value == 's') {
			UnderID1 	= $("#UnderID1").val();
			UnderID2 	= $("#UnderID2").val();
			UnderName 	= $("#UnderName").val();
			M_Name 		= $("#M_Name").val();
			SearchCate 	= $("#SearchCate").val();
			SDATE 		= $("#SDATE").val();
			EDATE 		= $("#EDATE").val();
			v_LEVEL 	= $("#v_LEVEL").val();
			v_CurGrade 	= $("#v_CurGrade").val();

		} else {
			UnderID1 	= '';
			UnderID2 	= '';
			UnderName 	= '';
			M_Name 		= '';
			SearchCate 	= '';
			SDATE 		= '';
			EDATE 		= '';
			v_LEVEL 	= '';
			v_CurGrade 	= '';

			$("#UnderID1").val('<%=DK_MEMBER_ID1%>');
			$("#UnderID2").val('<%=DK_MEMBER_ID2%>');
			$("#UnderName").val('<%=DK_MEMBER_NAME%>');
			$("#M_Name").val('');
			$("#SearchCate").val('03');
			$("#SDATE").val('');
			$("#EDATE").val('');
			$("#v_LEVEL").val('');
			$("#v_CurGrade").val('');
		}

		var sh = $(".search_form").height();		//검색창 높이
		var ch = $("#left").height();				//left menu높이
		let fw = $(".contents").width();		//fixed talbe 폭

		$("#loadingsTop").css({"height": sh+"px"});

		$(".loadings, .loadingslmenuInner").css({"height":ch+"px"});

		$("#AjaxContent01 .lineCnt").text("<%=LNG_TEXT_PAY_LINE1%>");
		$("#AjaxContent02 .lineCnt").text("<%=LNG_TEXT_PAY_LINE2%>");

		//1라인
		$.ajax({
			type: "POST"
			,url: "member_UnderSpon_Ajax.asp"
			,data : {
				"UnderID1"		: UnderID1,
				"UnderID2"		: UnderID2,
				"UnderName" 	: UnderName,
				"M_Name" 		: M_Name,
				"SearchCate" 	: SearchCate,
				"SDATE"		: SDATE,
				"EDATE"		: EDATE,
				"viewID"		: "AjaxContent01",
				"v_LEVEL" 		: v_LEVEL,
				"v_CurGrade" 	: v_CurGrade,
				"LINE_CNT" 	: 1				//라인분기
			}
			,beforeSend : function() {
				$("#AjaxContent01 tbody").hide();
			}
			,success: function(data) {
				setTimeout(function() {
					$("#AjaxContent01").html(data);
					$("#AjaxContent01 tbody").show();
					$(".loadings").css({"width": fw+"px"});
				},0);
			}
			,error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
			,complete: function() {

			}
		});

		//2라인
		$.ajax({
			type: "POST"
			,url: "member_UnderSpon_Ajax.asp"
			,data : {
				"UnderID1"		: UnderID1,
				"UnderID2"		: UnderID2,
				"UnderName" 	: UnderName,
				"M_Name" 		: M_Name,
				"SearchCate" 	: SearchCate,
				"SDATE"		: SDATE,
				"EDATE"		: EDATE,
				"viewID"		: "AjaxContent02",
				"v_LEVEL" 		: v_LEVEL,
				"v_CurGrade" 	: v_CurGrade,
				"LINE_CNT" 	: 2			//라인분기
			}
			,beforeSend : function() {
				$("#AjaxContent02 tbody").hide();
			}
			,success: function(data) {
				setTimeout(function() {
					$("#AjaxContent02").html(data);
					$("#AjaxContent02 tbody").show();
					$(".loadings").css({"width": fw+"px"});		//fixed talbe loading
				},0);
			}
			,error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
			,complete: function() {

			}

		});

	}

</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="members" class="memberInfo">
	<form name="dateFrm" action="" method="post">
		<div class="search_form">
			<!--가입일-->
			<div class="legtime">
				<h6><%=LNG_TEXT_REGTIME%></h6>
				<div class="inputs">
					<div class="fleft">
						<input type="text" id="SDATE" name="SDATE" class="tcenter tweight" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
						<span>~</span>
						<input type="text" id="EDATE" name="EDATE" class="tcenter tweight" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					</div>
					<div class="fright">
						<button type="button" class="today" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button>
						<button type="button" class="twoM" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button>
						<button type="button" class="twoM" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button>
						<button type="button" class="threeM" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button>
						<button type="button" class="threeM" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button>
						<button type="button" class="threeM" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button>
						<button type="button" class="all" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
						<!-- <button type="button" onclick="chgDate('<%=DateAdd("m",-1,nowDate)%>','<%=nowDate%>');">1개월</button>
						<button type="button" onclick="chgDate('<%=DateAdd("d",-7,nowDate)%>','<%=nowDate%>');">1주일</button> -->
					</div>
				</div>
			</div>
			<div class="area-bottom">
				<%'기준회원%>
				<div class="standard">
					<h6><%=LNG_STANDARD_MEMBER%></h6>
					<div class="inputs">
						<input type="hidden" id="UnderID1" name="UnderID1" value="<%=UnderID1%>" readonly="readonly" />
						<input type="hidden" id="UnderID2" name="UnderID2" value="<%=UnderID2%>" readonly="readonly" />
						<input type="text" id="UnderName" name="UnderName" class="tweight readonly tcenter" value="<%=UnderName%>" readonly="readonly" />
						<%'#modal dialog%>
						<a name="modal" id="underMember" href="/myoffice/member/pop_underMember.asp?u=s" title="<%=LNG_TEXT_UNDER_MEMBER_SEARCH%>"><input type="button" value="<%=LNG_TEXT_SEARCH%>" /></a>
					</div>
				</div>
				<%'검색회원명%>
				<div class="searchMem">
					<h6><%=LNG_SEARCH_MEMBER_NAME%></h6>
					<div class="inputs">
						<input type="text" id="M_Name" name="M_Name" class="tweight" value="<%=M_Name%>" />
					</div>
				</div>
				<%'조회구분%>
				<div class="searchCate" style="opacity:0;">
					<h6><%=LNG_SEARCH_CATEGORY%></h6>
					<div class="inputs">
						<select id="SearchCate" name="SearchCate" disabled="disabled" >
							<option value="" <%=isSelect(SearchCate,"")%>>== <%=LNG_SELECT_SEARCH_CATEGORY%> ==</option>
							<option value="03" <%=isSelect(SearchCate,"03")%>><%=LNG_ALL_UNDER_SPON%></option>
							<option value="04" <%=isSelect(SearchCate,"04")%>><%=LNG_ALL_UNDER_VOTER%></option>
							<option value="01" <%=isSelect(SearchCate,"01")%>><%=LNG_DIRECT_UNDER_SPON%></option>
							<option value="02" <%=isSelect(SearchCate,"02")%>><%=LNG_DIRECT_UNDER_VOTER%></option>
						</select>
					</div>
				</div>
				<%'직급%>
				<div class="rank">
					<h6><%=LNG_TEXT_POSITION%></h6>
					<div class="inputs">
						<%
							SQLGC = "SELECT [Grade_Code],[Grade_Name] FROM [tbl_class] WITH(NOLOCK) ORDER BY CONVERT(INTEGER,[Grade_Code]) "
							PRINT TABS(4)&" <select id=""v_CurGrade"" name=""v_CurGrade"" >"
							PRINT TABS(4)&" <option value="""">"&LNG_TEXT_ALL&"</option>"
							arrListGC = Db.execRsList(SQLGC,DB_TEXT,Nothing,listLenGC,DB3)
							If IsArray(arrListGC) Then
								For i = 0 To listLenGC
									PRINT TABS(4)&"	<option value="""&arrListGC(0,i)&""" """&isSelect(v_CurGrade,arrListGC(0,i))&""" >"&arrListGC(1,i)&"</option>"
								Next
							Else
								PRINT TABS(4)&"	<option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_06&"</option>"
							End If
							PRINT TABS(4)&"	</select>"
						%>
					</div>
				</div>
				<%'대수%>
				<div class="level" >
					<h6><%=LNG_TEXT_LEVEL%></h6>
					<div class="inputs">
						<select id="v_LEVEL" name="v_LEVEL" class="vmiddle">
							<option value=""  ><%=LNG_TEXT_ALL%></option>
							<%For i = 1 To 50%>
								<option value="<%=i%>"  <%=isSelect(v_LEVEL,i)%>><%=i%></option>
							<%Next%>
						</select>
					</div>
				</div>
				<%'검색%>
				<div class="search fright">
					<div class="inputs">
						<input type="button" class="btn-Search" onclick="fnSearch('s')" value="<%=LNG_TEXT_SEARCH%>"/>
						<input type="button" class="btn-Reset" onclick="fnSearch('r')" value="<%=LNG_TEXT_INITIALIZATION%>"/>
					</div>
				</div>
			</div>
		</div>
	</form>

	<div id="AjaxContent01" class="fleft contents porel">
		<div id="loadings1" class="loadings"><div class="loadingsInner"><img src="<%=IMG%>/159.gif" width="60" alt="" /></div></div>
		<p class="titles lineCnt"><%=LNG_TEXT_PAY_LINE1%></p>
		<table <%=tableatt%> class="width100">
			<tr>
				<th><%=LNG_TEXT_LEVEL%></th>
				<th><%=LNG_TEXT_MEMID%></th>
				<th><%=LNG_LEFT_MEM_INFO_NAME%></th>
				<th><%=LNG_TEXT_REGTIME%></th>
				<th><%=LNG_TEXT_POSITION%></th>
				<th><%=CS_SPON%></th>
				<th><%=CS_NOMIN%></th>
			</tr>
		</table>
	</div>
	<div id="AjaxContent02" class="fright contents porel">
		<div id="loadings2" class="loadings"><div class="loadingsInner"><img src="<%=IMG%>/159.gif" width="60" alt="" /></div></div>
		<p class="titles lineCnt"><%=LNG_TEXT_PAY_LINE2%></p>
		<table <%=tableatt%> class="width100">
			<tr>
				<th><%=LNG_TEXT_LEVEL%></th>
				<th><%=LNG_TEXT_MEMID%></th>
				<th><%=LNG_LEFT_MEM_INFO_NAME%></th>
				<th><%=LNG_TEXT_REGTIME%></th>
				<th><%=LNG_TEXT_POSITION%></th>
				<th><%=CS_SPON%></th>
				<th><%=CS_NOMIN%></th>
			</tr>
		</table>
	</div>
</div>

<%'▣ 회원검색 modal▣%>
<%
	MODAL_CONTENT_WIDTH = 600
%>
<!--#include virtual="/_include/modal_config.asp" -->
<!--#include virtual = "/_include/copyright.asp"-->
