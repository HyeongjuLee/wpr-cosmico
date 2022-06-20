<!--#include virtual="/_lib/strFunc.asp" -->
<%
'▣ 나이스 본인인증 관련 S
	'인증 후 결과값이 null로 나오는 부분은 관리담당자에게 문의 바랍니다.
    Dim clsCPClient
    Dim sSiteCode, sSitePassword, sCipherTime
    Dim sRequestNumber				'요청 번호
    Dim sResponseNumber				'인증 고유번호
    Dim sAuthType					'인증 수단
    Dim sName                   	'성명
    Dim sDupInfo					'중복가입 확인값 (DI_64 byte)
    Dim sConnInfo					'연계정보 확인값 (CI_88 byte)
    Dim sBirthDate					'생일
    Dim sGender		                '성별
    Dim sNationalInfo				'내/외국인 정보 (사용자 매뉴얼 참조)
	Dim sMobileNo					'휴대폰번호
	Dim sMobileCo					'통신사
    Dim sResult


	sType = request("stype")
	dType = request("dvc")


	Select Case LCase(sType)
		Case "c"
			sType = "CONVERT"	'소비자판매원 전환
		Case "m"
			sType = "MODIFY"	'마이페이지 휴대폰수정
		Case Else
			sType = "EXIT"		'회원탈퇴
	End Select



    sEncodeData = Fn_checkXss(Request("EncodeData"), "encodeData")

	sSiteCode     	= NICE_MOBILE_AUTH_ID			'NICE로부터 부여받은 사이트 코드
	sSitePassword   = NICE_MOBILE_AUTH_PWD			'NICE로부터 부여받은 사이트 패스워드

	SET clsCPClient  = SERVER.CREATEOBJECT("CPClient.Kisinfo")

    iRtn = clsCPClient.fnDecode(sSiteCode, sSitePassword, sEncodeData)


    IF iRtn = 0 THEN
	    sPlain           = clsCPClient.bstrPlainData
	    sCipherTime      = clsCPClient.bstrCipherDateTime


        iReturn = clsCPClient.fnGetAuthInfo("REQ_SEQ")
        sRequestNumber= clsCPClient.bstrAuthInfo

		iReturn = clsCPClient.fnGetAuthInfo("RES_SEQ")
        sResponseNumber= clsCPClient.bstrAuthInfo

		iReturn = clsCPClient.fnGetAuthInfo("AUTH_TYPE")
        sAuthType= clsCPClient.bstrAuthInfo

        'iReturn = clsCPClient.fnGetAuthInfo("NAME")
        'sName= clsCPClient.bstrAuthInfo

		'charset utf8 사용시 주석 해제 후 사용
        iReturn = clsCPClient.fnGetAuthInfo("UTF8_NAME")
        sName= clsCPClient.bstrAuthInfo

		iReturn = clsCPClient.fnGetAuthInfo("BIRTHDATE")
        sBirthDate= clsCPClient.bstrAuthInfo

        iReturn = clsCPClient.fnGetAuthInfo("GENDER")
        sGender= clsCPClient.bstrAuthInfo

        iReturn = clsCPClient.fnGetAuthInfo("NATIONALINFO")
        sNationalInfo= clsCPClient.bstrAuthInfo

        iReturn = clsCPClient.fnGetAuthInfo("DI")
        sDupInfo= clsCPClient.bstrAuthInfo

        iReturn = clsCPClient.fnGetAuthInfo("CI")
        sConnInfo= clsCPClient.bstrAuthInfo

        iReturn = clsCPClient.fnGetAuthInfo("MOBILE_NO")
        sMobileNo= clsCPClient.bstrAuthInfo

        iReturn = clsCPClient.fnGetAuthInfo("MOBILE_CO")
        sMobileCo= clsCPClient.bstrAuthInfo
        ' checkplus_success 페이지에서 결과값 null 일 경우, 관련 문의는 관리담당자에게 하시기 바랍니다

		sRequestNO = sRequestNumber

		sName =	UrlDecode_GBToUtf8(sName)

        IF session("REQ_SEQ") <> sRequestNO Then
			Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","o_reloada","")
    	    RESPONSE.WRITE "세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다.<br>"
        END IF

		ELSE
	    RESPONSE.WRITE "요청정보_암호화_오류:" & iRtn & "<br>"
	    ' -1 : 암호화 시스템 에러입니다.
	    ' -4 : 입력 데이터 오류입니다.
	    ' -5 : 복호화 해쉬 오류입니다.
	    ' -6 : 복호화 데이터 오류입니다.
	    ' -9 : 입력 데이터 오류입니다.
		'-12 : 사이트 패스워드 오류입니다.
    END IF
	Set clsCPClient = Nothing

	Function Fn_checkXss (CheckString, CheckGubun)
		CheckString = trim(CheckString)
		CheckString = replace(CheckString,"<","&lt;")
		CheckString = replace(CheckString,">","&gt;")
		CheckString = replace(CheckString,"""","")
		CheckString = replace(CheckString,"'","")
		CheckString = replace(CheckString,"(","")
		CheckString = replace(CheckString,")","")
		CheckString = replace(CheckString,"#","")
		CheckString = replace(CheckString,"%","")
		CheckString = replace(CheckString,";","")
		CheckString = replace(CheckString,":","")
		CheckString = replace(CheckString,"-","")
		CheckString = replace(CheckString,"`","")
		CheckString = replace(CheckString,"--","")
		CheckString = replace(CheckString,"\","")
		IF CheckGubun <> "encodeData" THEN
			CheckString = replace(CheckString,"+","")
			CheckString = replace(CheckString,"=","")
			CheckString = replace(CheckString,"/","")
		END IF
		Fn_checkXss = CheckString
	End Function



'▣ 나이스 본인인증 관련 E

	SQL = "SELECT [hptel],[M_name] FROM [tbl_memberInfo] (nolock) WHERE [mbid] = ? AND [mbid2] = ?"
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,2,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_hptel		= DKRS("hptel")
		DKRS_M_name		= DKRS("M_name")
	End If


	'프리먼스 요청 2020-07-16 (홍길동A = 홍길동 비교 ㅡㅜ)
	sName_Len = 0
	If DKRS_M_name <> "" Then
		sName_Len = Len(sName)
		DKRS_M_name =  Left(DKRS_M_name,sName_Len)
	End If


	ORI_sMobileNo = sMobileNo
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If sMobileNo	<> "" Then sMobileNo	= objEncrypter.Encrypt(sMobileNo)
	Set objEncrypter = Nothing

	'*** 인증정보 INSERT S ***
	arrParams = Array(_
		Db.makeParam("@sType",adVarChar,adParamInput,20,sType), _
		Db.makeParam("@sCipherTime",adVarChar,adParamInput,20,sCipherTime), _
		Db.makeParam("@sRequestNumber",adVarChar,adParamInput,30,sRequestNumber), _
		Db.makeParam("@sResponseNumber",adVarChar,adParamInput,24,sResponseNumber), _
		Db.makeParam("@sAuthType",adVarChar,adParamInput,1,sAuthType), _
		Db.makeParam("@sName",adVarWChar,adParamInput,20,sName), _
		Db.makeParam("@sGender",adVarChar,adParamInput,1,sGender), _
		Db.makeParam("@sBirthDate",adVarChar,adParamInput,20,sBirthDate), _
		Db.makeParam("@sNationalInfo",adVarChar,adParamInput,5,sNationalInfo), _
		Db.makeParam("@sDupInfo",adVarChar,adParamInput,64,sDupInfo), _
		Db.makeParam("@sConnInfo",adVarChar,adParamInput,88,sConnInfo), _
		Db.makeParam("@sMobileNo",adVarChar,adParamInput,150,sMobileNo), _
		Db.makeParam("@sMobileCo",adVarChar,adParamInput,20,sMobileCo), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKSP_MEMBER_MOBILE_AUTH_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrPArams(UBound(arrPArams))(4)

	'*** 인증정보 INSERT E ***


	ALREADY_REGIST_TF = ""
	'▣ CS 핸드폰 중복체크
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [hptel] = ? AND NOT ([mbid] = ? AND [mbid2] = ?) "
	arrParams = Array(_
		Db.makeParam("@hptel",adVarChar,adParamInput,100,sMobileNo), _
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	DbCheckMember_2 = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))
	If DbCheckMember_2 > 0 Then
		ALREADY_REGIST_TF = "T"
		'Call alerts("이미 등록된 핸드폰 번호입니다.\n본인이 회원가입을 하지 않았다면 본사로 문의해주세요.!","go","joinStep01.asp")
	End If

	Select Case UCASE(sType)
		Case "CONVERT"
			ALREADY_REGIST_TF = ALREADY_REGIST_TF

		Case "MODIFY"
			ALREADY_REGIST_TF = ALREADY_REGIST_TF

			SESSION("sResponseNumber") = sResponseNumber		'수정시 세션생성

		Case Else
			ALREADY_REGIST_TF = ""

	End Select


%>
<%' if session("MO_CHECK") <> "" Then 'session 꼬임??%>
<% If LCase(dType) = "m" Then	%>
	<!--#include virtual="/m/_include/document.asp" -->
	<script type="text/javascript" src="/m/jquerymobile/jquery-1.9.1.min.js"></script>
<% Else %>
	<!--#include virtual="/_include/document.asp" -->
<% End If %>
</head>
<body>
<style>
	* {-moz-box-sizing: border-box;box-sizing: border-box;}
	.joinAuthTitle {font-size:16px; line-height:50px; background-color:#555555; color:#fff; padding-left:15px;}
	.Result {}
	.Result p {text-align:center; padding:10px 0px; font-size:14px; line-height:32px;}
	.Result p {text-align:center; padding:10px 0px;}


	.Result th,
	.Result td {border-bottom:1px solid #ccc; font-size:14px;text-align:left; padding-left:7px;}
	.Result th {background-color:#eee; height:38px; font-size:13px; font-weight:normal}
	.Result th.tcenter {font-weight:bold;}
	.Result td {}


	.a_submit  {display: inline-block; padding: 0px 20px; vertical-align: middle; cursor: pointer; line-height:40px; height:42px; font-size:15px; max-width: 180px; }
	.design1 {color:#fff !important; background-color:#777;border:1px solid #333;}
	.design2 {color:#666 !important; background-color:#f9f9f9;border:1px solid #cccccc;}
	.design6 {background-color: #333333; border:1px solid #ffffff; border-radius: 3px; color:#fff !important;padding: 0px 40px;}

</style>

<script type="text/javascript">

	function exitNext() {

		//console.log(window.opener.document.URL);

		$(opener.document).find("#authVal").val("<%=sResponseNumber%>");
		$(opener.document).find("#mobileAuth_TF").val("T");

		<%
			Select Case UCASE(sType)
				Case "CONVERT"
		%>

		<%		Case "MODIFY"%>
					$(opener.document).find("#strMobile").val("<%=ORI_sMobileNo%>");
					$(opener.document).find("#authStatus").text("");

		<%		Case Else %>

		<%
			End Select
		%>
		/*
		$(opener.document).find(".design3").removeAttr("onclick");
		$(opener.document).find(".design3").addClass("opacity");
		$(opener.document).find(".medium2").removeAttr("onclick");
		$(opener.document).find(".medium2").addClass("opacity");
		*/
		//$(opener.document).find("#success").css("display", "block");
		window.open('about:blank','_self').close();
	}

	function exitClose() {
		$(opener.document).find("#mobileAuth_TF").val("F");
		self.close();
	}

	resizePopupWindow(parseInt("<%=400%>", 10), parseInt("<%=280%>", 10));

</script>
<div class="joinAuthTitle width100">
휴대폰인증 확인 결과
</div>
<div class="Result width100">

<%
	Select Case UCASE(sType)
		Case "CONVERT"
%>
			<% If DKRS_hptel = sMobileNo And DKRS_M_name = sName And ALREADY_REGIST_TF <> "T" Then %>
				<table <%=tableatt%> class="width100">
					<col width="120" />
					<col width="*" />
					<tr>
						<th>휴대폰인증</th>
						<td>성공</td>
					</tr>
				</table>
				<p style="margin-top:10px;">
					휴대폰인증에 성공했습니다. <br />
					확인버튼 클릭후 진행해 주세요.
				</p>
				<p style="margin-top:10px;">
					<a href="javascript:exitNext();" class="a_submit design6">확인</a>
				</p>
			<% Else %>

				<table <%=tableatt%> class="width100">
					<col width="120" />
					<col width="*" />
					<tr>
						<th>휴대폰인증</th>
						<td>실패</td>
					</tr>
				</table>
				<p style="margin-top:10px;">
					<%If ALREADY_REGIST_TF = "T" Then%>
						이미 등록된 핸드폰 번호입니다 <br />
						본인이 회원가입을 하지 않았다면 본사로 문의해주세요.
					<%Else%>
						휴대폰인증에 실패했습니다. <br />
						등록된 휴대폰번호와 인증휴대폰번호가 다릅니다. <br />
						(또는 명의자명과 회원명이 다릅니다)
					<%End If%>
				</p>
				<p style="margin-top:10px;">
					<a href="javascript:exitClose();" class="a_submit design6">닫기</a>
				</p>

			<% End If %>

<%		Case "MODIFY"%>
			<% If DKRS_M_name = sName And ALREADY_REGIST_TF <> "T" Then %>
				<table <%=tableatt%> class="width100">
					<col width="120" />
					<col width="*" />
					<tr>
						<th>휴대폰인증</th>
						<td>성공</td>
					</tr>
				</table>
				<p style="margin-top:10px;">
					휴대폰인증에 성공했습니다. <br />
					확인버튼 클릭후 진행해 주세요.
				</p>
				<p style="margin-top:10px;">
					<a href="javascript:exitNext();" class="a_submit design6">확인</a>
				</p>
			<% Else %>

				<table <%=tableatt%> class="width100">
					<col width="120" />
					<col width="*" />
					<tr>
						<th>휴대폰인증</th>
						<td>실패</td>
					</tr>
				</table>
				<p style="margin-top:10px;">
					<%If ALREADY_REGIST_TF = "T" Then%>
						이미 등록된 핸드폰 번호입니다 <br />
						본인이 회원가입을 하지 않았다면 본사로 문의해주세요.
					<%Else%>
						휴대폰인증에 실패했습니다. <br />
						(또는 명의자명과 회원명이 다릅니다)
					<%End If%>
				</p>
				<p style="margin-top:10px;">
					<a href="javascript:exitClose();" class="a_submit design6">닫기</a>
				</p>

			<% End If %>

<%		Case Else %>

<%
	End Select
%>
</div>

</body>
</html>