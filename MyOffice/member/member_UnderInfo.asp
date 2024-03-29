<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'### 추천/후원인 정보 통합 ###
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER1-6"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	sc = gRequestTF("sc",False)
	NOM_MODE = False
	SAVE_MODE = False
	Select Case sc
		Case "v"	'추천인 vd/va
			If Not NOM_MENU_USING Then Call WRONG_ACCESS()
			INFO_MODE	 = "MEMBER1-2"
			SearchCate = "vd"
			NOM_MODE = True
		Case "s"	'후원인	sd/sa
			If Not SAVE_MENU_USING Then Call WRONG_ACCESS()
			INFO_MODE	 = "MEMBER1-1"
			SearchCate = "sd"
			SAVE_MODE = True
		Case Else
			Call WRONG_ACCESS()
	End Select

	'하선기준회원 검색
	UnderID1 	= pRequestTF("UnderID1",False)
	UnderID2 	= pRequestTF("UnderID2",False)
	UnderName 	= pRequestTF("UnderName",False)
	'SearchCate 		= pRequestTF("SearchCate",False)

	If UnderID1 = "" Then UnderID1 = DK_MEMBER_ID1
	If UnderID2 = "" Then UnderID2 = DK_MEMBER_ID2
	If UnderName = "" Then UnderName = DK_MEMBER_NAME
	If SearchCate = "" Then
		'If NOM_MENU_USING Then SearchCate = "vd"
		'If SAVE_MENU_USING Then SearchCate = "sd"
	End If

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/style_cs.css" />
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
			SearchCate 	= String('<%=SearchCate%>');
			SDATE 		= '';
			EDATE 		= '';
			v_LEVEL 	= '';
			v_CurGrade 	= '';

			$("#UnderID1").val('<%=DK_MEMBER_ID1%>');
			$("#UnderID2").val('<%=DK_MEMBER_ID2%>');
			$("#UnderName").val('<%=DK_MEMBER_NAME%>');
			$("#M_Name").val('');
			$("#SearchCate").val(String('<%=SearchCate%>'));
				$('#SearchCate option').eq(0).prop('selected', true);
			$("#SDATE").val('');
			$("#EDATE").val('');
			$("#v_LEVEL").val('');
			$("#v_CurGrade").val('');
		}

		levelVisible(SearchCate);

		let ch = $("#LeftMenu_M").height();

		$.ajax({
			type: "POST"
			,url: "member_UnderInfo_Ajax.asp"
			,data : {
				"UnderID1"		: UnderID1,
				"UnderID2"		: UnderID2,
				"UnderName" 	: UnderName,
				"M_Name" 		: M_Name,
				"SearchCate" 	: SearchCate,
				"SDATE"		: SDATE,
				"EDATE"		: EDATE,
				"v_LEVEL" 		: v_LEVEL,
				"v_CurGrade" 	: v_CurGrade
			}
			,beforeSend : function() {
				$("#loadings").show();
				$("#loadings").css({"height":ch+"px"});
			}
			,success: function(data) {
				$("#AjaxContent").html(data);
				$("#loadings").hide();
			}
			,error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
			,complete: function() {
				$("#loadings").hide();
			}

		});
	}

	function levelVisible(val){
		if (val == 'sd' || val == 'vd') {
			$("#v_LEVEL").css({"visibility":"hidden"});
		}else{
			$("#v_LEVEL").css({"visibility":"visible"});
		}
	}

</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="loadings" class="loadings userCWidth">
	<div class="loadingsInner"><img src="<%=IMG%>/159.gif" width="60" alt="" /></div>
</div>
<div id="member" class="member_vote">
	<form name="dateFrm" action="" method="post">
		<div class="search_form">
			<article class="date">
				<h6><%=LNG_TEXT_DATE_SEARCH%></h6>
				<div class="inputs">
					<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					<span>~</span>
					<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
				</div>
				<div class="buttons">
					<button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button>
					<button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button>
					<button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button>
					<button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
				</div>
				<!-- <input type="submit" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/> -->
			</article>
			<article class="members">
				<%'기준회원%>
				<h6><%=LNG_STANDARD_MEMBER%></h6>
				<div class="standard">
					<div class="input">
						<input type="hidden" id="UnderID1" name="UnderID1" value="<%=UnderID1%>" readonly="readonly" />
						<input type="hidden" id="UnderID2" name="UnderID2" value="<%=UnderID2%>" readonly="readonly" />
						<input type="text" id="UnderName" name="UnderName" class="tweight tcenter input_text" value="<%=UnderName%>" readonly="readonly" />
						<%'#modal dialog%>
						<%If NOT IS_LIMIT_LEVEL Then%>
						<a name="modal" id="underMember" class="button" href="/myoffice/member/pop_underMember.asp?u=<%=sc%>" title="<%=LNG_TEXT_UNDER_MEMBER_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
						<%End If%>
					</div>
				</div>
				<%'검색회원명%>
				<h6><%=LNG_SEARCH_MEMBER_NAME%></h6>
				<div class="searchMem">
					<input type="text" id="M_Name" name="M_Name" class="tweight input_text" value="<%=M_Name%>" />
				</div>
				<%'조회구분%>
				<h6><%=LNG_SEARCH_CATEGORY%></h6>
				<div class="searchCate">
					<div class="selects">
						<select id="SearchCate" name="SearchCate" onchange="levelVisible(this.value);" class="input_select">
							<!-- <option value="" <%=isSelect(SearchCate,"")%>>== <%=LNG_SELECT_SEARCH_CATEGORY%> ==</option> -->
							<%If NOM_MODE Then%>
								<%If NOM_MENU_USING Then%><option value="vd" <%=isSelect(SearchCate,"vd")%>><%=LNG_DIRECT_UNDER_VOTER%></option><%End If%>
								<%If NOM_MENU_USING Then%><option value="va" <%=isSelect(SearchCate,"va")%>><%=LNG_ALL_UNDER_VOTER%></option><%End If%>
							<%End if%>
							<%If SAVE_MODE Then%>
								<%If SAVE_MENU_USING Then%><option value="sd" <%=isSelect(SearchCate,"sd")%>><%=LNG_DIRECT_UNDER_SPON%></option><%End If%>
								<%If SAVE_MENU_USING Then%><option value="sa" <%=isSelect(SearchCate,"sa")%>><%=LNG_ALL_UNDER_SPON%></option><%End If%>
							<%End if%>
						</select>
					</div>
				</div>
			</article>
			<article class="searchs">
				<%'직급%>
				<h6><%=LNG_TEXT_POSITION%></h6>
				<div class="rank">
					<div class="selects">
						<%
							SQLGC = "SELECT [Grade_Code],[Grade_Name] FROM [tbl_class] WITH(NOLOCK) ORDER BY CONVERT(INTEGER,[Grade_Code]) "
							PRINT TABS(4)&" <select id=""v_CurGrade"" name=""v_CurGrade"" class=""input_select"" >"
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
				<%
					v_LEVEL = 50
					'대수제한
					If IS_LIMIT_LEVEL Then
						v_LEVEL = CS_LIMIT_LEVEL
					End IF
				%>
				<h6><%=LNG_TEXT_LEVEL%></h6>
				<div class="level">
					<select id="v_LEVEL" name="v_LEVEL" class="vmiddle input_select">
						<option value=""  ><%=LNG_TEXT_ALL%></option>
						<%For i = 1 To v_LEVEL%>
							<option value="<%=i%>"  <%=isSelect(v_LEVEL,i)%>><%=i%></option>
						<%Next%>
					</select>
				</div>
				<%'검색%>
				<input type="button" class="search_btn" onclick="fnSearch('s')" value="<%=LNG_TEXT_SEARCH%>"/>
				<input type="button" class="search_reset" onclick="fnSearch('r')" value="<%=LNG_TEXT_INITIALIZATION%>"/>
				<!-- <div class="search">
				</div> -->
			</article>
		</div>
	</form>

	<div id="AjaxContent" >
		<p class="titles"><%=LNG_TEXT_LIST%></p>
		<table <%=tableatt%> class="board width100">
			<col width="50" />
			<col width="160" />
			<col width="150" />
			<col width="50" />
			<col width="110" />
			<col width="110" />
			<col width="160" />
			<col width="160" />
			<thead>
				<tr>
					<th><%=LNG_TEXT_NUMBER%></th>
					<th><%=LNG_TEXT_MEMID%></th>
					<th><%=LNG_LEFT_MEM_INFO_NAME%></th>
					<th><%=LNG_TEXT_LEVEL%></th>
					<th><%=LNG_TEXT_REGTIME%></th>
					<th><%=LNG_TEXT_POSITION%></th>
					<th><%=CS_SPON%></th>
					<th><%=CS_NOMIN%></th>
				</tr>
			</thead>
			<tr>
				<td colspan="8" class="notData" style="background:#FFF;"></td>
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
