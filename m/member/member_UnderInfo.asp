<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'### 추천/후원인 정보 통합 ###
	PAGE_SETTING = "MYOFFICE"
	'INFO_MODE	 = "MEMBER1-6"

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
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="member.css?v2.1" />
<script type="text/javascript" src="/m/js/calendar.js?v1"></script>
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
				$("#filter").hide();
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
<body  onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="member" class="member_vote">
	<div id="loadings" style="width:100%; height:100%;position:absolute;display:none;">
		<div id="loading_bg">
			<img id="loading-image" src="<%=IMG%>/159.gif" width="50"  alt="" />
		</div>
	</div>

	<form name="dateFrm" action="" method="post">
		<div class="search_form vertical">
			<article>
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
					<button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
				</div>
				<!-- <input type="submit" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/> -->
			</article>
			<article class="table" id="filter" style="display: none;">
				<%'기준회원%>
				<div class="standard">
					<h6><%=LNG_STANDARD_MEMBER%></h6>
					<input type="hidden" id="UnderID1" name="UnderID1" value="<%=UnderID1%>" readonly="readonly" />
					<input type="hidden" id="UnderID2" name="UnderID2" value="<%=UnderID2%>" readonly="readonly" />
					<input type="text" id="UnderName" name="UnderName" class="tweight tcenter input_text" value="<%=UnderName%>" readonly="readonly" />
					<%'#modal dialog%>
					<a name="modal" id="underMember" class="button" href="/m/member/pop_underMember.asp?u=<%=sc%>" title="<%=LNG_TEXT_UNDER_MEMBER_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
				</div>
				<%'검색회원명%>
				<div class="searchMem">
					<h6><%=LNG_SEARCH_MEMBER_NAME%></h6>
					<input type="text" id="M_Name" name="M_Name" class="tweight input_text" value="<%=M_Name%>" />
				</div>
				<%'조회구분%>
				<div class="searchCate">
					<h6><%=LNG_SEARCH_CATEGORY%></h6>
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
				<!-- <h6><%=LNG_TEXT_LEVEL%></h6>
				<div class="level">
					<select id="v_LEVEL" name="v_LEVEL" class="vmiddle input_select">
						<option value=""  ><%=LNG_TEXT_ALL%></option>
						<%For i = 1 To 50%>
							<option value="<%=i%>"  <%=isSelect(v_LEVEL,i)%>><%=i%></option>
						<%Next%>
					</select>
				</div> -->
				<%'검색%>
			</article>
			<article class="table">
				<div class="search">
					<input type="button" class="search_btn" onclick="fnSearch('s')" value="<%=LNG_TEXT_SEARCH%>"/>
					<!-- <input type="button" class="search_reset" onclick="fnSearch('r')" value="<%=LNG_TEXT_INITIALIZATION%>"/> -->
					<!-- <input type="button" class="search_filter" onclick="toggle_filter('filter');"  value="필터"/> -->
					<div class="icon-ccw-1 search_reset" onclick="location.replace(location.href);"/></div>
					<div class="icon-cog search_filter" onclick="toggle_filter('filter');"/></div>
				</div>
			</article>
		</div>
			<!-- <tbody id="filter" style="display: none;" >
				<tr>
					<th><%=LNG_STANDARD_MEMBER%></th>
					<td>
						<input type="hidden" id="UnderID1" name="UnderID1" value="<%=UnderID1%>" readonly="readonly" />
						<input type="hidden" id="UnderID2" name="UnderID2" value="<%=UnderID2%>" readonly="readonly" />
						<div class="fleft"><input type="text" id="UnderName" name="UnderName" class="input_text tcenter tweight readonly" style="width: 160px;" value="<%=UnderName%>" readonly="readonly" /></div>
						<%'#modal dialog	'u=v(voter), u=a(all) %>
						<div class="fleft" style="padding-left: 5px;"><a name="modal" id="underMember" href="/m/member/pop_underMember.asp?u=<%=sc%>" title="<%=LNG_TEXT_UNDER_MEMBER_SEARCH%>"><input type="button" class="txtBtn small3 radius3" value="<%=LNG_TEXT_SEARCH%>"  /></a></div>
					</td>
				</tr><tr>
					<th><%=LNG_SEARCH_MEMBER_NAME%></th>
					<td>
						<div class="fleft"><input type="text" id="M_Name" name="M_Name" class="input_text tcenter tweight" style="width: 160px;" value="<%=M_Name%>" /></div>
					</td>
				</tr><tr>
					<th><%=LNG_SEARCH_CATEGORY%></th>
					<td>
						<div class="fleft">
							<select id="SearchCate" name="SearchCate" onchange="levelVisible(this.value);">
								<!-- <option value="" <%=isSelect(SearchCate,"")%>>== <%=LNG_SELECT_SEARCH_CATEGORY%> ==</option> -->
								<!-- <%If NOM_MODE Then%>
									<%If NOM_MENU_USING Then%><option value="vd" <%=isSelect(SearchCate,"vd")%>><%=LNG_DIRECT_UNDER_VOTER%></option><%End If%>
									<%If NOM_MENU_USING Then%><option value="va" <%=isSelect(SearchCate,"va")%>><%=LNG_ALL_UNDER_VOTER%></option><%End If%>
								<%End if%>
								<%If SAVE_MODE Then%>
									<%If SAVE_MENU_USING Then%><option value="sd" <%=isSelect(SearchCate,"sd")%>><%=LNG_DIRECT_UNDER_SPON%></option><%End If%>
									<%If SAVE_MENU_USING Then%><option value="sa" <%=isSelect(SearchCate,"sa")%>><%=LNG_ALL_UNDER_SPON%></option><%End If%>
								<%End if%>
							</select>
						</div>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_POSITION%> / <%=LNG_TEXT_LEVEL%></th>
					<td>
						<div class="fleft">
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
						<div class="fleft level">
							<select id="v_LEVEL" name="v_LEVEL" class="vmiddle">
								<option value=""  ><%=LNG_TEXT_ALL%></option>
								<%For i = 1 To 50%>
									<option value="<%=i%>"  <%=isSelect(v_LEVEL,i)%>><%=i%></option>
								<%Next%>
							</select>
						</div>
					</td>
				</tr>
			</tbody>
			<tr>
				<th><%=LNG_TEXT_SEARCH%></th>
				<td>
					<div class="fleft">
						<input type="button" id="searchBtn" class="txtBtn search radius3" onclick="fnSearch('s')" value="<%=LNG_TEXT_SEARCH%>"/>
						<input type="button" class="txtBtn small3 radius3" onclick="fnSearch('r')" value="<%=LNG_TEXT_INITIALIZATION%>"/>
						&nbsp;&nbsp;<input type="button" id="searchBtn" class="txtBtn s_modify radius3" onclick="toggle_filter('filter');"  value="필터"/>

					</div>
				</td>
			</tr>
		</table> -->
	</form>

	<div id="AjaxContent" >
		<p class="titles"><%=LNG_TEXT_LIST%></p>
		<table <%=tableatt%> class="width100 table2">
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
			<tr>
				<td colspan="8" class="notData" style="height:50px;"></td>
			</tr>
		</table>
	</div>
</div>

<%'▣ 회원검색 modal▣%>
<!--#include virtual="/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/copyright.asp"-->