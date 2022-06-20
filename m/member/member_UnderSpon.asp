<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_MEMBER"
	Call FNC_ONLY_CS_MEMBER()

	ISSCROLL = "T"

	'하선기준회원 검색
	UnderID1 	= pRequestTF("UnderID1",False)
	UnderID2 	= pRequestTF("UnderID2",False)
	UnderName 	= pRequestTF("UnderName",False)
	SearchCate 		= pRequestTF("SearchCate",False)

	If UnderID1 = "" Then UnderID1 = DK_MEMBER_ID1
	If UnderID2 = "" Then UnderID2 = DK_MEMBER_ID2
	If UnderName = "" Then UnderName = DK_MEMBER_NAME
	If SearchCate = "" Then SearchCate = "03"


	ThisM_1stDate = Left(Date(),8)&"01" 					'이번달 1일


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<style>
	/* 산하회정정보  S    기존 /m/css/style.css 코드 복구  */
		#members {padding-top: 0px;}
		#members tr:nth-Child(even) {background-color:#f4f4f4;}
		#members tr:nth-Child(odd) {background-color:#fff;}
		#members th, #members td {padding:8px 10px; text-align: center;}
		#members th {background:#032f4f; color:#fff; border:1px solid #043a62; font-size:13px; font-weight:300; white-space: nowrap;}
		#members td {border:1px solid #e0e0e0;}
		#members .contents {width:470px; overflow:hidden;}
		#members .table1 {width:470px;}

		.fixedTableWrap {position:relative; width:100%; height:100%;}
		#fixedTable {position:relative; display:block; font-size:13px;color:#333;}
		#fixedTable .fixedTable_Default {-webkit-overflow-scrolling:touch; overflow-x:scroll; height: 100%;}
		#fixedTable .fixedTable_overCell {background-color:#fff; box-shadow:2px 0 5px -2px #cdcdcd; left:0; position:absolute; top:0; z-index:21;}

		#fixedTable th , #fixedTable td {white-space: nowrap; }
		#fixedTable th.first {width:40px;min-width:40px;}
		#fixedTable th.second {width:100px;min-width:100px;}
		#fixedTable th.third {width:90px;min-width:90px;}
</style>
<script type="text/javascript" src="/m/js/calendar.js"></script>
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
				$("#loadings1").show();
				$("#AjaxContent01 tbody").hide();
			}
			,success: function(data) {
				$("#AjaxContent01").html(data);
				$("#AjaxContent01 tbody").show();
			}
			,error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
			,complete: function() {
				$("#loadings1").hide();
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
				$("#loadings2").show();
				$("#AjaxContent02 tbody").hide();
			}
			,success: function(data) {
				$("#AjaxContent02").html(data);
				$("#AjaxContent02 tbody").show();
			}
			,error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
			,complete: function() {
				$("#loadings2").hide();
			}

		});
	}

</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_MEMBER_06%></div>
<div id="div_date">
	<form name="dateFrm" action="" method="post">
		<table <%=tableatt%> class="width100">
			<col width="" />
			<col width="*" />
			<tr>
				<th rowspan="2"><%=LNG_TEXT_REGTIME%></th>
				<td>
					<span class="button medium"><button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button></span>
					<span class="button medium"><button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button></span>
				</td>
			</tr><tr>
				<td>
					<input type="text" id="SDATE" name="SDATE" class="input_text readonly" style="width:100px;" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> ~
					<input type="text" id="EDATE" name="EDATE" class="input_text readonly" style="width:100px;" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this,
					'YYYY-MM-DD');" />
				</td>
			</tr><tr>
				<th><%=LNG_STANDARD_MEMBER%></th>
				<td>
					<input type="hidden" id="UnderID1" name="UnderID1" value="<%=UnderID1%>" readonly="readonly" />
					<input type="hidden" id="UnderID2" name="UnderID2" value="<%=UnderID2%>" readonly="readonly" />
					<div class="fleft"><input type="text" id="UnderName" name="UnderName" class="input_text tcenter tweight readonly" style="width: 160px;" value="<%=UnderName%>" readonly="readonly" /></div>
					<%'#modal dialog%>
					<div class="fleft" style="padding-left: 5px;">
						<a name="modal" id="popvoter" href="/m/member/pop_underMember.asp?u=s" title="<%=LNG_TEXT_UNDER_MEMBER_SEARCH%>">
							<input type="button" class="txtBtn small3 radius3" value="<%=LNG_TEXT_SEARCH%>"  />
						</a>
					</div>
				</td>
			</tr><tr>
				<th><%=LNG_SEARCH_MEMBER_NAME%></th>
				<td>
					<div class="fleft"><input type="text" id="M_Name" name="M_Name" class="input_text tcenter tweight" style="width: 160px;" value="<%=M_Name%>" /></div>
				</td>
			</tr><tr style="display:none;">
				<th><%=LNG_SEARCH_CATEGORY%></th>
				<td>
					<div class="fleft">
						<select id="SearchCate" name="SearchCate" >
							<option value="" <%=isSelect(SearchCate,"")%>>== <%=LNG_SELECT_SEARCH_CATEGORY%> ==</option>
							<option value="01" <%=isSelect(SearchCate,"01")%>><%=LNG_DIRECT_UNDER_SPON%></option>
							<option value="02" <%=isSelect(SearchCate,"02")%>><%=LNG_DIRECT_UNDER_VOTER%></option>
							<option value="03" <%=isSelect(SearchCate,"03")%>><%=LNG_ALL_UNDER_SPON%></option>
							<option value="04" <%=isSelect(SearchCate,"04")%>><%=LNG_ALL_UNDER_VOTER%></option>
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
					<div class="fleft" style="margin-left:5px;">
						<select id="v_LEVEL" name="v_LEVEL" class="vmiddle">
							<option value=""  ><%=LNG_TEXT_ALL%></option>
							<%For i = 1 To 50%>
								<option value="<%=i%>"  <%=isSelect(v_LEVEL,i)%>><%=i%></option>
							<%Next%>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<th><%=LNG_TEXT_SEARCH%></th>
				<td>
					<div class="fleft">
						<input type="button" id="searchBtn" class="txtBtn search radius3" onclick="fnSearch('s')" value="<%=LNG_TEXT_SEARCH%>"/>
						<input type="button" class="txtBtn small3 radius3" onclick="fnSearch('r')" value="<%=LNG_TEXT_INITIALIZATION%>"/>
					</div>
				</td>
			</tr>
		</table>
	</form>
</div>

<div id="members">
	<div id="AjaxContent01" >
        <div id="loadings1" style="width:100%; height:100%;position:absolute;display:none;"><div id="loading_bg"><img id="loading-image" src="<%=IMG%>/159.gif" width="50"  alt="" /></div></div>
        <p class="titles"><%=LNG_TEXT_LIST%></p>
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
			<tr>
				<td colspan="7" class="notData" style="height:50px;"></td>
			</tr>
		</table>
	</div>
	<div id="AjaxContent02" >
		<div id="loadings2" style="width:100%; height:100%;position:absolute;display:none;"><div id="loading_bg"><img id="loading-image" src="<%=IMG%>/159.gif" width="50"  alt="" /></div></div>
		<p class="titles"><%=LNG_TEXT_LIST%></p>
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
			<tr>
				<td colspan="7" class="notData" style="height:50px;"></td>
			</tr>
		</table>
	</div>
</div>

<%'▣ 회원검색 modal▣%>

<!--#include virtual="/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/copyright.asp"-->