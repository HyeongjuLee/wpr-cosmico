<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "JOIN"
	view = 3
	sview = 1
	ISSUBTOP = "T"

	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<style>
	:root {touch-action: pan-x pan-y;	height: 100%;	}
</style>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />

<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<!-- <script type="text/javascript" src="joinStep03_c.js"></script> -->
<script type="text/javascript">
</script>
<!-- <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script> -->
</head>
<body onunload="" style="bo rder: 2px solid red; min-height:100px; height:100%;">
<!--#include virtual = "/m/_include/header.asp"-->

<div id="join03" class="joinstep fleft" >
	<form name="cfrm" method="post" action="joinFinish_g.asp" onsubmit="return chkSubmit(this);">

		<%If 1=1 then%>
		<div class="wrap">
			<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
			<table <%=tableatt%> class="width100">
				<col width="80" />
				<col width="*" />
				<tr class="id">
					<th><%=LNG_TEXT_ID%>&nbsp;<%=starText%></th>
					<td>
						<input type="text" name="strID" class="" onkeyup="this.value=this.value.replace(/[^a-zA-Z0-9]/g,'');" value="" />
						<input type="button" name="" onclick="join_idcheck();" class="" value="<%=LNG_TEXT_DOUBLE_CHECK%>" />
						<p id="idCheck" class="summary"><%=LNG_JOINSTEP03_U_TEXT04%>
							<input type="hidden" name="idcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkID" value="" readonly="readonly" />
						</p>
					</td>
				</tr>
				<tr class="voter">
					<th><%=CS_NOMIN%>&nbsp;<%=starText_NOMIN%></th>
					<td>
						<%'#modal dialog%>
						<input type="text" name="voter" class="" value="<%=DKRSVI_MNAME%>" readonly="readonly" style="background-color:#efefef;" />
						<a name="modal" id="popVoter" href="/m/common/pop_voter.asp" title="<%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%>">
							<input type="button" value="<%=LNG_TEXT_SEARCH%>"/>
						</a><!-- <div style="width: 25%;"><input type="button" class="input_btn width95a" value="<%=LNG_STRFUNCDATA_TEXT06%>" onclick="vote_company();" /></div> -->
					</td>
				</tr>
			</table>
		</div>
		<%End if%>
		<div class="wrap">
			<h6><%=LNG_TEXT_MEMBER_ADDITIONAL_INFO%></h6>
			<table <%=tableatt%> class="width100">
				<col width="80" />
				<col width="*" />
				<tr class="address">
					<th><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText_ADDRESS1%></th>
					<td>
						<input type="text" name="strZip" id="strZipDaum" class="readonly" readonly="readonly" style="background-color:#efefef;" maxlength="7" />
						<a name="modal" href="/m/common/pop_postcode.asp" title="우편번호 찾기"><input type="button" value="<%=LNG_TEXT_ZIPCODE%>"/></a>
						<input type="text" name="strADDR1" id="strADDR1Daum" class="" style="background-color:#efefef;" maxlength="500" readonly="readonly" />
					</td>
				</tr>
				<tr class="address2">
					<th><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></th>
					<td><input type="text" name="strADDR2" id="strADDR2Daum" maxlength="500" class="" /></td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div id ="ggg" class="fleft" style="width: 100%; height:700px; border: 2px solid blue;	display: none;">

</div>

<!-- <div id="test" class="" style=""></div> -->
<%'▣ 추천/후원인 선택 modal▣%>
<!--#include virtual="/m/_include/modal_config.asp" -->

<!--#include virtual = "/m/_include/copyright.asp"-->