<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->
<%
	
	PAGE_SETTING = "COMMON"

	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"
	IS_LANGUAGESELECT = "F"

	view = 4
	sview = 2

	R_NationCode = "KR"


	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	If DK_MEMBER_VOTER_ID <> "" Then
		If Not FNC_CHECK_VOTER(DK_MEMBER_VOTER_ID) Then
			Call FN_MEMBER_LOGOUT("존재하지 않는 추천인(회원)입니다.")
			Call ALERTS("","silentgo","/index.asp")
		End If

		SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WHERE [webID] = ? "
		arrParamsVI = Array(_
			Db.makeParam("@WebID",adVarWChar,adParamInput,100,DK_MEMBER_VOTER_ID) _
		)
		Set DKRSVI = Db.execRs(SQLVI,DB_TEXT,arrParamsVI,DB3)
		If Not DKRSVI.BOF And Not DKRSVI.EOF Then
			DKRSVI_MBID1		= DKRSVI("MBID")
			DKRSVI_MBID2		= DKRSVI("MBID2")
			DKRSVI_MNAME		= DKRSVI("M_NAME")
			DKRSVI_CHECK		= "T"
			DKRSVI_WEBID		= DKRSVI("WebID")
		Else
			DKRSVI_MBID1		= ""
			DKRSVI_MBID2		= ""
			DKRSVI_MNAME		= ""
			DKRSVI_CHECK		= "F"
			DKRSVI_WEBID		= ""
		End If
	End If


	Select Case Left(strSSH2,1)
		Case "1"
			birthYY = "19"
			isSex = "M"
		Case "2"
			birthYY = "19"
			isSex = "F"
		Case "3"
			birthYY = "20"
			isSex = "M"
		Case "4"
			birthYY = "20"
			isSex = "F"
	End Select

	birthYYYY = birthYY
	birthMM = birthMM
	birthDD = birthDD

%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="join.css?v2" />
<script type="text/javascript">
<!--

	$(document).ready(function(){
		$(".policy").on("click", function(){
			var urlVal = $(this).attr("id");
			var selNa = "<%=DK_MEMBER_LNG_CODE%>";				//선택 언어로 변환 2020-02-27
			openPopup("/common/pop_policy.asp?policyCode="+urlVal+"&nationCode="+selNa, "popPolicy", 800, 600, "left=200, top=200");
		});

		//공백제거
		$('form').on("propertychange change keyup paste input","input", function() {
			$(this).val(function(index, value) {
				return value.replace(/ /gi, '');
			});
		});
	});


	function join_idcheck() {
		var ids = document.cfrm.strID;
		if (ids.value == '')
		{
			alert("<%=LNG_JS_ID%>");
			ids.focus();
			return false;
		}

		if (!checkID(ids.value.trim(), 6, 20) || !checkEngNum(ids.value) ){
			alert("<%=LNG_JS_ID_FORM_CHECK_NEW%>");
			ids.focus();
			return false;
		}
		createRequest();
		var url = 'ajax_idcheck_join.asp?ids='+ids.value;
		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("idCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}

	//SSN check
	function join_SSNcheck() {
		var ids = document.cfrm.strSSH;
		if (ids.value == '')
		{
			alert("Please enter SSN");
			ids.focus();
			return false;
		}
		if (ids.value.stripspace().length < 9) {
			alert("Please enter SSN Number correctly!");
			ids.focus();
			return false;
		}
		createRequest();
		var url = 'ajax_SSNcheck.asp?ids='+ids.value;
		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("SSNCheck").innerHTML = newContent;
			}
		  }
		}
		request.send(null);
	}

	function openzip() {
		openPopup("/common/pop_Zipcode.asp", "Zipcodes", 100, 100, "left=200, top=200");
	}
	function openzip_jp() {
		openPopup("/common/pop_ZipCode_JP.asp", "Zipcodes", 100, 100, "left=200, top=200");		//일본주소
	}
	function vote_idcheck() {
		openPopup("/common/pop_voter.asp", "vote_idcheck", 300, 300, "left=200, top=200");
	}
	function spon_idcheck() {
		openPopup("/common/pop_sponsorN2_LINE.asp", "vote_idcheck", 300, 300, "left=200, top=200");
	}

	function fnEmailCheck(){
		var strEmail = $("input[name=strEmail]").val();

		if (strEmail == "" || $.trim(strEmail) == ""){
			alert("<%=LNG_JS_EMAIL%>");
			return false;
		}
		
		$.ajax({
			method : "post",
			url : "ajax_emailCheck.asp",
			data : {"email" : strEmail},
			success: function(xhrData) {
				jsonData = $.parseJSON(xhrData);
				if (jsonData.result == 'success') {
					$("input[name=emailCheck]").val("T");
					$("input[name=duplicateMail]").val(jsonData.data);
					$("input[name=strEmail]").addClass("readonly");
					$("input[name=strEmail]").attr("readonly", "readonly");
					$("#btnEmailChk").removeAttr("onclick");
					$("#txtEmailAble").css("display", "");
					return false;
				} else {
					alert(jsonData.resultMsg);
					return false;
				}
			},
			error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%>");
			}
		});
	}

	function checkName(value, min, max) {
		var RegExp = /^[a-zA-Z0-9_]*$/i;
		var returnVal = RegExp.test(value) ? true : false;
		if (typeof(min) != "undefined" && value.length < min) returnVal = false;
		if (typeof(max) != "undefined" && value.length > max) returnVal = false;
		return returnVal;
	}

	function chkSubmit() {
		var f = document.cfrm;
		var objItem;
	
		if (f.M_Name_Last.value == "")
		{
			alert("<%=LNG_JS_FAMILY_NAME%>");
			f.M_Name_Last.focus();
			return false;
		}

		if (f.M_Name_First.value == "")
		{
			alert("<%=LNG_JS_GIVEN_NAME%>");
			f.M_Name_First.focus();
			return false;
		}

		if (f.strID.value == "")
		{
			alert("<%=LNG_JS_ID%>");
			f.strID.focus();
			return false;
		} else {
			if (!checkID(f.strID.value, 6, 20) || !checkEngNum(f.strID.value)){
				alert("<%=LNG_JS_ID_FORM_CHECK_NEW%>");
				f.strID.focus();
				return false;
			}
			if (f.idcheck.value == 'F'){
				alert("<%=LNG_JS_ID_DOUBLE_CHECK%>");
				f.strID.focus();
				return false;
			}
			if (f.strID.value != f.chkID.value){
				alert("<%=LNG_JS_ID_DOUBLE_CHECK2%>");
				$("#idCheck").text("<%=LNG_JS_DUPLICATION_CHECK%>").css({"color":"red","font-weight":"bold"});
				f.strID.focus();
				return false;
			}
		}
		if (chkEmpty(f.strPass)) {
			alert("<%=LNG_JS_PASSWORD%>");
			f.strPass.focus();
			return false;
		}

		if (!checkPass(f.strPass.value, 6, 20)){
			alert("<%=LNG_JS_PASSWORD_FORM_CHECK%>");
			f.strPass.focus();
			return false;
		}
		if (f.idcheck.value == f.strPass.value){
			alert("<%=LNG_JS_PASSWORD_FORM_CHECK2%>");
			f.strPass.focus();
			return false;
		}
		if (chkEmpty(f.strPass2)) {
			alert("<%=LNG_JS_PASSWORD_CONFIRM%>");
			f.strPass2.focus();
			return false;
		}
		if (f.strPass.value != f.strPass2.value){
			alert("<%=LNG_JS_PASSWORD_CHECK%>");
			f.strPass2.focus();
			return false;
		}
		if (chkEmpty(f.outPin)){
			alert("<%=LNG_JS_MONEY_OUTPUT_PIN%>");
			f.outPin.focus();
			return false;
		} else {
			if (parseInt(f.outPin.value.length) < <%=CONST_OUTPIN_MINIMUM_CHAR%>){
				alert("<%=LNG_JS_MONEY_OUTPUT_PIN_FORM_CHECK%>");
				f.outPin.focus();
				return false;
			}
			if (chkEmpty(f.outPinOK)) {
				alert("<%=LNG_JS_MONEY_OUTPUT_PIN_CONFIRM%>");
				f.outPinOK.focus();
				return false;
			}
			if (f.outPin.value != f.outPinOK.value){
				alert("<%=LNG_JS_MONEY_OUTPUT_PIN_CHECK%>");
				f.outPinOK.focus();
				return false;
			}
		}

		if (chkEmpty(f.infoPin)){
			alert("<%=LNG_JS_INFO_CHANGE_PIN%>");
			f.infoPin.focus();
			return false;
		} else {
			if (parseInt(f.infoPin.value.length) < <%=CONST_INFOPIN_MINIMUM_CHAR%>){
				alert("<%=LNG_JS_INFO_CHANGE_PIN_FORM_CHECK%>");
				f.infoPin.focus();
				return false;
			}
			if (chkEmpty(f.infoPinOK)) {
				alert("<%=LNG_JS_INFO_CHANGE_PIN_CONFIRM%>");
				f.infoPinOK.focus();
				return false;
			}
			if (f.infoPin.value != f.infoPinOK.value){
				alert("<%=LNG_JS_INFO_CHANGE_PIN_CHECK%>");
				f.infoPinOK.focus();
				return false;
			}
		}
		if (chkEmpty(f.voter) || chkEmpty(f.NominID1) || chkEmpty(f.NominID2) || f.NominChk.value == 'F') {
			alert("<%=LNG_JS_VOTER%>");
			f.voter.focus();
			return false;
		}
		if (chkEmpty(f.sponsor) || chkEmpty(f.SponID1) || chkEmpty(f.SponID2) || f.SponIDChk.value == 'F') {
			alert("<%=LNG_JS_SPONSOR%>");
			f.sponsor.focus();
			return false;
		}
		
		//이메일 필수
		if (chkEmpty(f.strEmail)) {
			alert("<%=LNG_JS_EMAIL%>");
			f.strEmail.focus();
			return false;
		} else {
			if (!checkEmail(f.strEmail.value)) {
				alert("<%=LNG_JS_EMAIL_CONFIRM%>");
				f.strEmail.focus();
				return false;
			}
		}

		if (confirm("<%=LNG_JOINSTEP03_U_JS28%>")) {
			f.target = "_self";
			return;
		} else {
			return false;
		}
	}

	function RefreshImage(valImageId) {
		var objImage = document.getElementById(valImageId)
		if (objImage == undefined) {
			return;
		}
		var now = new Date();
		objImage.src = objImage.src.split('?')[0] + '?x=' + now.toUTCString();
	}

// -->
</script>
<link rel="stylesheet" href="/css/common.css">
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="joinStep" class="common joinStep3">
	<form name="cfrm" method="post" action="joinFinish_fg.asp" onsubmit="return chkSubmit(this);">
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="gather" value="<%=gather%>" />
		<input type="hidden" name="company" value="<%=company%>" />
		<input type="hidden" name="sellMemTF" value="<%=sellMemType%>" />
		
		<input type="hidden" name="SponID1" value="" readonly="readonly" />
		<input type="hidden" name="SponID2" value="" readonly="readonly" />
		<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
		<input type="hidden" name="sponLine" value="" readonly="readonly" />
		<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />
		
		<input type="hidden" name="dataNum" value="<%=RChar%>" readonly="readonly" />
		<input type="hidden" name="joinType" value="COMPANY" readonly="readonly" />

		<input type="hidden" name="For_Kind_TF" value="<%=For_Kind_TF%>" readonly="readonly" />

		<input type="hidden" name="NominID1" value="<%=DKRSVI_MBID1%>" readonly="readonly" />
		<input type="hidden" name="NominID2" value="<%=DKRSVI_MBID2%>" readonly="readonly" />
		<input type="hidden" name="NominWebID" value="<%=DKRSVI_WEBID%>" readonly="readonly" />
		<input type="hidden" name="NominChk" value="<%=DKRSVI_CHECK%>" readonly="readonly" />

		<div class="wrap">
			<article>
				<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
				<div class="name">
					<h5><%=LNG_TEXT_NAME%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="M_Name_Last" class="input_text" maxlength="20" size="14" placeholder="<%=LNG_TEXT_FAMILY_NAME%>" />
						<input type="text" name="M_Name_First" class="input_text" maxlength="20" size="14" placeholder="<%=LNG_TEXT_GIVEN_NAME%>" />
						<p class="summary"><%=LNG_TEXT_INPUT_TYPE%></p>
					</div>
				</div>
				<div class="id">
					<h5><%=LNG_TEXT_ID%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="strID" class="input_text" maxlength="20" <%=toNoKorText%> placeholder="" autocomplete="off" />
						<input type="button" class="button" onclick="join_idcheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<p class="summary" id="idCheck"><%=LNG_JOINSTEP03_U_TEXT04_NEW%>
							<input type="hidden" name="idcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkID" value="" readonly="readonly" />
						</p>
					</div>
				</div>
				<div class="password dwrap">
					<div>
						<h5><%=LNG_TEXT_PASSWORD%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" class="input_text" name="strPass" maxlength="20" size="24" onkeyup="noSpace('strPass');" placeholder="" />
							<p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p>
						</div>
					</div>
					<div>
						<h5><%=LNG_TEXT_PASSWORD_CONFIRM%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" class="input_text" name="strPass2" maxlength="20" size="24" onkeyup="noSpace('strPass');" placeholder="" />
						</div>
					</div>
				</div>
				<!-- <div class="pin dwrap">
					<div>
						<h5><%=LNG_MONEY_OUTPUT_PIN%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="outPin" class="input_text" maxlength="20" size="24" placeholder="" />
							<p class="summary"><%=LNG_MONEY_OUTPUT_PIN_TYPE%></p>
						</div>
					</div>
					<div>
						<h5><%=LNG_MONEY_OUTPUT_PIN_CONFIRM%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="outPinOK" class="input_text" maxlength="20" size="24" placeholder="" />
						</div>
					</div>
				</div>
				<div class="pin dwrap">
					<div>
						<h5><%=LNG_INFO_CHANGE_PIN%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="infoPin" class="input_text" maxlength="20" size="24" placeholder="" />
							<p class="summary"><%=LNG_INFO_CHANGE_PIN_TYPE%></p>
						</div>
					</div>
					<div>
						<h5><%=LNG_INFO_CHANGE_PIN_CONFIRM%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="infoPinOK" class="input_text" maxlength="20" size="24" placeholder="" />
						</div>
					</div>
				</div> -->
				<div class="email">
					<h5><%=LNG_TEXT_EMAIL%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="strEmail" class="input_text" value=""/>
						<p class="summary"><%=LNG_JOINSTEP03_U_TEXT29%></p>
					</div>
				</div>
				<div class="voter">
					<h5><%=CS_NOMIN%> / <%=CS_SPON%>&nbsp;<%=starText%></h5>
					<div class="con">
						<div class="inputs">
							<input type="text" name="voter" class="input_text" readonly="readonly" placeholder="<%=LNG_JOIN_SEARCH_PLACEHOLDER%>" value="<%=DKRSVI_MNAME%>" />
							<input type="text" name="sponsor" class="input_text" readonly="readonly" placeholder="<%=LNG_JOIN_SEARCH_PLACEHOLDER%>" value="" />
						</div>
						<a name="modal" class="button" id="popVoter" href="/common/pop_voterN2.asp" title="<%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
					</div>
				</div>
				<div class="select center">
					<h5><%=LNG_TEXT_CENTER%></h5>
					<div class="con">
						<select name="businessCode" class="input_select" id="businessCode">
							<option value="">::: <%=LNG_TEXT_CENTER_SELECT%> :::</option>
							<%
								R_NationCode = "KR"

								SQL = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = '"&R_NationCode&"' AND [U_TF] = 0 ORDER BY [ncode] ASC"
								arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
								If IsArray(arrList) Then
									For i = 0 To listLen
										PRINT TABS(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
									Next
								Else
									PRINT TABS(5)& "	<option value="""">"&LNG_JOINSTEP03_U_TEXT10&"</option>"
								End If
							%>
						</select>
					</div>
				</div>
				<div class="mobile">
					<h5><%=LNG_TEXT_MOBILE%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strMobile" maxlength="15" <%=onLyKeys%> value="" />
					</div>
				</div>
				<!-- <div class="gopWallet">
					<h5>GOP <%=LNG_WALLET_ADDRESS%></h5>
					<div class="con">
						<input type="text" class="input_text" name="walletAddress" maxlength="50" value="" />
					</div>
				</div>
				<div class="ethWallet">
					<h5>ETH <%=LNG_WALLET_ADDRESS%></h5>
					<div class="con">
						<input type="text" class="input_text" name="walletAddressETH" maxlength="50" value="" />
					</div>
				</div> -->
			</article>
			<% If False Then %>
			<article class="agreement">
				<section class="policy">
					<label id="policy01"><%=LNG_POLICY_01%></label>
					<label id="policy02"><%=LNG_POLICY_02%></label>
					<label id="policy03"><%=LNG_POLICY_03%></label>
				</section>
				<section class="all">
					<label>
						<input type="checkbox" id="agreement" name="agreement" value="" />
						<span><%=LNG_JOINSTEP02_U_TEXT07%></span>
					</label>
				</section>
			</article>
			<% End If %>
			<div class="btnZone">
				<a href="/index.asp" type="button" class="cancel"><%=LNG_TEXT_JOIN_CANCEL%></a>
				<input type="submit" class="promise" value="<%=LNG_TEXT_JOIN%>" />
			</div>
		</div>
	</form>

</div>
<%'▣ 추천인 / 후원인 선택 modal 2020-02-26 ▣%>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style>
	.ui-dialog .ui-dialog-title {
		margin: 0.5em 0;
		font-size: 14px;
	}
	.ui-widget-header {
		border: 1px solid #dddddd;
		background: #2565D0;
		color: #ffffff;
		font-weight: bold;
	}
	.ui-dialog .ui-dialog-titlebar-close {
		right: 0.7em;
		top: 42%;
		width: 26px;
		height: 26px;
	}
</style>
<div id="modal_view" style="display:none;"><iframe src="/hiddens.asp"  id="modalIFrame" width="100%" height="99%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="yes" ></iframe></div>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript">

	$(document).ready(function() {

		$("a[name=modal]").click(function() {

			var $this = $(this);
			var url = $this.attr('href');
			var cw = 800
			var ch = 600
			var chTop = ($(window).height()-ch) /2;

			var dialogOpts = {
				title: ($this.attr('title')) ? $this.attr('title') : "",		//anchor's title

				autoOpen: true,
				bgiframe: true,
				width: cw,
				height: ch,
				modal: true,
				resizable: false,
				autoResize: true,
				draggable: false,
				data : {'nominID1':"11"},
				buttons: {
					"Close": function() {
						$("#modalIFrame").attr('src',"");
						$(this).dialog("close");
					}
				}
			};

			setTimeout(function() {
				$("#modal_view").dialog(dialogOpts);
				$(".ui-dialog").css({"position":"fixed", "top":chTop+"px", "z-index":"999999"});		//PC
			},300);
			$("#modalIFrame").attr('src',url);

			return false;

		});

		$(window).resize(function() {
			var rw = $(window).width();
			var rh = $(window).height();
			var rwLeft = (rw-550) /2 ;
			var rhTop = (rh-600) /2 ;
			$('.ui-dialog').css({"top":rhTop+"px", "left":rwLeft+"px"});
		});

	});

</script>

<!--#include virtual="/_include/copyright.asp" -->