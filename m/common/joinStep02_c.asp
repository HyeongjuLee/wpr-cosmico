<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"



	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"



	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/m/common/joinStep01.asp") Then Call alerts("잘못된 접근입니다.","go","/m/common/joinStep01.asp")
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
	End Select



	'국가정보
	R_NationCode = gRequestTF("cnd",True)
	arrParams = Array(_
		Db.makeParam("@nationCode",adVarChar,adParamInput,20,R_NationCode) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_CHK_NATION",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_nationNameEn	= DKRS("nationNameEn")
		DKRS_nationCode		= DKRS("nationCode")
		DKRS_className		= DKRS("className")
	Else
		Call ALERTS("We are sorry. The country code is not valid.","back","")
	End If

	arrParams1 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy01"),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,R_NationCode) _
	)
	policyContent1 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams1,Nothing)
	policyContent1 = Replace(policyContent1,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = "사이트 이용약관이 등록되지 않았습니다."

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02"),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,R_NationCode) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	policyContent2 = Replace(policyContent2,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = "개인정보취급방침이 등록되지 않았습니다."

	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03"),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,R_NationCode) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)
	policyContent3 = Replace(policyContent3,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = "사업자회원 가입약관이 등록되지 않았습니다."



%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<style type="text/css">
	#join_c .stit {font-size: 18px;}
	#join_c div.list {overflow: hidden; padding: 0 0px;}
	#join_c div.list ul {margin: 25px auto; font-size: 0;}
	#join_c div.list li {margin:5px 0; display: inline-block; width:100%; font-size: 0;}
	#join_c div.list h3 {height:50px; line-height:50px; color:#fff; background:#333; font-weight:500; font-size:15px; cursor:pointer; box-shadow:0 10px 10px rgba(0,0,0,0.1), 0 1px 10px rgba(0,0,0,0.3);display:inline-block; border:0px solid #fff; box-sizing:border-box; width:100%; padding:0 15px; position: relative;}
	#join_c div.list h3 p {color: #fff; font-weight: 500; font-size: 15px; line-height: 50px; float: left;}
	#join_c div.list h3 span {position: absolute; width: 20px; height: 20px; border-radius: 20px; border: 1px solid #fff; top: 50%; margin-top: -10px; right: 15px;}
	#join_c div.list h3 span i {position: absolute; background-color: #fff; width: 6px; height: 1px; top: 50%;}
	#join_c div.list h3 span i.i01 {transform: rotate(40deg); left: 5px;}
	#join_c div.list h3 span i.i02 {transform: rotate(-40deg); right: 5px;}
	#join_c div.list h3 span.on {width: 30px;}

	#join_c div.list li.on .i01 {transform: rotate(-40deg); left: 5px;}
	#join_c div.list li.on .i02 {transform: rotate(40deg); right: 5px;}

	#join_c div.list .agArea {background: #fff; padding: 15px; margin-bottom: 10px; overflow-y: scroll; height: 300px; font-size: 13px; margin-top: -1px; border-top: 10px solid #fff; border-bottom: 10px solid #fff;text-align:left;}

	#join_c .join_btn {width: 100%; margin: 15px 0;}
	#join_c .join_btn input {border: none; background: #2c8cca; color: #fff; padding: 12px; width: 100%;border-radius: 3px;}
	#join_c .join_btn .inner {width: 95%; overflow: hidden;}
	#join_c .join_btn .inner div {width: 49%;}
	#join_c .join_btn .fleft input {background: #777;}
	#join_c .join_btn .fright input {background: #ad0d0d;}

	select {height:28px;}
</style>

<script type="text/javascript" src="/m/js/ajax.js"></script>
<script type="text/javascript" src="joinStep.js"></script>
<script type="text/javascript" src="joinStep02_c.js"></script>
<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<link rel="stylesheet" href="/m/css/membership.css?v2" />
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$('.list li').click(function(){
			$(this).toggleClass('on');
		});
	});
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join_c" class="memberWrap">
	<div class="tit"><!-- 회원가입 --><%=LNG_TEXT_JOIN%><i></i></div>
	<div class="stit">약관동의</div>

	<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>



	<div class="list">
		<form name="agreeFrm" method="post" action="joinStep03_c.asp<%=ptshop%>" onsubmit="">
			<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
			<input type="hidden" name="name" value="" readonly="readonly" />
			<!-- <input type="hidden" name="ssh1" value="" readonly="readonly" />
			<input type="hidden" name="ssh2" value="" readonly="readonly" /> -->
			<input type="hidden" name="M_Name_Last" value="" readonly="readonly" />
			<input type="hidden" name="M_Name_First" value="" readonly="readonly" />
			<input type="hidden" name="birthYY" value="" readonly="readonly" />
			<input type="hidden" name="birthMM" value="" readonly="readonly" />
			<input type="hidden" name="birthDD" value="" readonly="readonly" />
			<ul>
				<li>
					<h3 onclick="toggle_ee('ag01');"><p>사이트이용약관</p>
						<span><i class="i01"></i><i class="i02"></i></span>
					</h3>
					<div id="ag01" class="agArea" style="display:none;"><%=policyContent1%></div>
				</li>
				<li>
					<h3 onclick="toggle_ee('ag03');"><p>사업자회원 약관</p>
						<span><i class="i01"></i><i class="i02"></i></span>
					</h3>
					<div id="ag03" class="agArea" style="display:none;"><%=policyContent3%></div>
				</li>
				<li>
					<h3 onclick="toggle_ee('ag02');"><p>개인정보 수집 및 이용에 대한 안내</p>
						<span><i class="i01"></i><i class="i02"></i></span>
					</h3>
					<div id="ag02" class="agArea" style="display:none;"><%=policyContent2%></div>
				</li>
			</ul>
			<div class="porel" style="height:40px; margin-top:20px; border-bottom:1px solid #eee;padding-bottom:10px;">
				<%
					'red / green / blue / aero / grey / orange / yellow / pink / purple
					RColor01 = "red"
					RColor02 = "grey"
				%>
				<div class="fleft" style="width:calc(50% - 10px);">
					<div class="skin-<%=RColor01%>"><input type="radio" name="agreement" value="T"/><label>약관동의</label></div>
				</div>
				<div class="fright" style="width:calc(50% - 10px);">
					<div class="skin-<%=RColor02%>"><input type="radio" name="agreement" value="F" /><label>약관 미동의</label></div>
				</div>
			</div>
		</form>
		<div class="in_content" style="width: 100%;"><div class="alert3">
		<%=DKCONF_SITE_TITLE%>는 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.
		</div>
		</div>
		<div class="join_area02" style="width :98%;" >
			<form name="nfrm" method="post" action="joinCheck_nc.asp" onSubmit="return nameChk2(this)"  />
				<div class="join">
					<table <%=tableatt%> class="width100 infoForm">
						<col width="105" />
						<col width="*" />
						<!-- <tr>
							<th>이름</th>
							<td><input type="text" class="input_text" name="name" style="width:90%;"  /></td>
						</tr> -->
						<input type="hidden" name="name" id="nfrm_name" value="" />
						<tr>
							<th rowspan="2">예금주<br />(성 /이름)</th>
							<td>
								<input type="text" class="input_text fleft" name="M_Name_Last" style="width:40%;" placeholder="성" />
							</td>
						</tr><tr>
							<td>
								<input type="text" class="input_text fleft" name="M_Name_First" style="width:90%;" placeholder="이름" />
							</td>
						</tr>
						<tr>
							<th>생년월일</th>
							<td style="line-height:36px;" align="left" >
								<select name = "birthYY" class="vmiddle" style="width:60px;">
									<option value=""></option>
									<%For i = MIN_YEAR To MAX_YEAR%>
										<option value="<%=i%>" ><%=i%></option>
									<%Next%>
								</select> 년
								<select name = "birthMM" class="vmiddle" style="width:45px;">
									<option value=""></option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" ><%=jsmm%></option>
									<%Next%>
								</select> 월
								<select name = "birthDD" class="vmiddle" style="width:45px;">
									<option value=""></option>
									<%For k = 1 To 31%>
										<%ksdd = Right("0"&k,2)%>
										<option value="<%=ksdd%>" ><%=ksdd%></option>
									<%Next%>
								</select> 일

							</td>
						</tr>
					</table>
					<div class="join_btn">
						<input type="submit" value="가입확인" onclick="" />
					</div>
				</div>
			</form>
		</div>

		<div class="join_btn">
			<div class="inner">
				<div class="fleft"><input type="button" onclick="javascript:history.go(-1);" value="동의하지 않습니다"/></div>
				<div class="fright"><input type="submit" onclick="javascript:return checkAgree();" value="가입동의"/></div>
			</div>
		</div>

		<script>
			$(document).ready(function(){
				$('.skin-<%=RColor01%> input').each(function(){
					var self = $(this),
					label = self.next(),
					label_text = label.text();

					label.remove();
					self.iCheck({
						checkboxClass: 'icheckbox_line-<%=RColor01%>',
						radioClass: 'iradio_line-<%=RColor01%>',
						insert: '<div class="icheck_line-icon"></div>' + label_text
					});
				});

				$('.skin-<%=RColor02%> input').each(function(){
					var self = $(this),
					label = self.next(),
					label_text = label.text();

					label.remove();
					self.iCheck({
						checkboxClass: 'icheckbox_line-<%=RColor02%>',
						radioClass: 'iradio_line-<%=RColor02%>',
						insert: '<div class="icheck_line-icon"></div>' + label_text
					});
				});
			});
		</script>
	</div>
<!--#include virtual = "/m/_include/copyright.asp"-->