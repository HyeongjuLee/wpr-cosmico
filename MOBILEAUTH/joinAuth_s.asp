<!--#include virtual="/_lib/strFunc.asp" -->
<%
'▣ 나이스 본인인증 관련 S
	'인증 후 결과값이 null로 나오는 부분은 관리담당자에게 문의 바랍니다.

	'기본적으로 당사에서 제공되는 리턴값은 이름, 생년월일, 성별, 내외국인, DI값이 제공되고 있습니다
	'휴대폰번호 리턴 X

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


	dType = request("dvc")



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

				IF session("REQ_SEQ") <> sRequestNO Then
					Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","o_reloada","")
					RESPONSE.WRITE "세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다.<br>"
				END IF

				'sMobileNo 휴대폰번호, sMobileCo 통신사정보 응답값 요청 확인!
				if session("MO_CHECK") <> "" Then
					MO_CHECK_PATH = "/m"
				Else
					MO_CHECK_PATH = ""
				End If

				IF sMobileNo = "" Then
					Call ALERTS("응답값이 없습니다. sMoNo (회원사 문의)","o_reload_go", MO_CHECK_PATH&"/common/joinStep01.asp")
					RESPONSE.WRITE "응답값이 없습니다. sMoNo.<br>"
				End If

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

	SESSION("sResponseNumber") = sResponseNumber

'▣ 나이스 본인인증 관련 E


	sName =	UrlDecode_GBToUtf8(sName)

	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		On Error Resume Next
			If sMobileNo		<> "" Then sMobileNo		= objEncrypter.Encrypt(sMobileNo)
		On Error GoTo 0
	Set objEncrypter = Nothing

'▣ 미성년 체크 S

	adultCheck = "F"

	Dim today : today = Date
 	Dim limitDate : limitDate = Dateadd("yyyy", -19, today)

	limitDate = replace(limitDate, "-", "")

	If (CDBL(sBirthDate) <= CDBL(limitDate)) then
		adultCheck = "T"
	Else
		adultCheck = "F"
	End If

'▣ 미성년 체크 E


	'로그기록생성
	On Error Resume Next
	Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
	Dim LogPath : LogPath = Server.MapPath ("/MOBILEAUTH/loggs/loggs_") & Replace(Date(),"-","") & ".log"
	Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

		Sfile.WriteLine "Date : " & now()
		Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
		Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
		Sfile.WriteLine "Referer : " & Request.ServerVariables("HTTP_REFERER")
		Sfile.WriteLine "URL : " & Request.ServerVariables("URL")
		Sfile.WriteLine "QUERY_STRING : " & Request.ServerVariables("QUERY_STRING")

		Sfile.WriteLine "sName	 : " & sName
		Sfile.WriteLine "sRequestNumber  : " & sRequestNumber
		Sfile.WriteLine "sResponseNumber : " & sResponseNumber
		Sfile.WriteLine chr(13)

	Sfile.Close
	Set Fso= Nothing
	Set objError= Nothing
	On Error GoTo 0

	'print session("MO_CHECK")
	'Response.End



'▣ 회원중복확인 S
	joinTrue = "F"
	isSameNameBirth = "F"

	'SQL = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [mobileAuth] = ?"
	SQL = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [hptel] = ? AND [hptel] <> '' "
	arrParams = Array(_
		Db.makeParam("@mobileAuth",adVarChar,adParamInput,88,sMobileNo) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		joinTrue = "T"
		DKRS_MBID		= DKRS("MBID")
		DKRS_MBID2		= DKRS("MBID2")
		DKRS_M_NAME		= DKRS("M_NAME")
		DKRS_WebID		= DKRS("WebID")
	Else

		'▣ 공인인증서 가입 + CS 이름 + 생년월일 중복체크
		If UCase(sAuthType) = "X" Then

			If Len(sBirthDate) = 8  Then
				strBirthYY = Left(sBirthDate,4)
				strBirthMM = Mid(sBirthDate,5,2)
				strBirthDD = Right(sBirthDate,2)

				SQL2 = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "
				arrParams2 = Array(_
					Db.makeParam("@M_Name",adVarWchar,adParamInput,100,sName), _
					Db.makeParam("@BirthDay",adVarchar,adParamInput,4,strBirthYY), _
					Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,strBirthMM), _
					Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,strBirthDD) _
				)
				Set DKRS2 = Db.execRs(SQL2,DB_TEXT,arrParams2,DB3)
				If Not DKRS2.BOF And Not DKRS2.EOF Then
					joinTrue = "T"
					DKRS2_MBID		= DKRS2("MBID")
					DKRS2_MBID2		= DKRS2("MBID2")
					DKRS2_M_NAME	= DKRS2("M_NAME")
					DKRS2_WebID		= DKRS2("WebID")

					joinTrue = "T"
					isSameNameBirth = "T"
				End If
			End If

		Else

			SQL = "SELECT COUNT(*) FROM [DKT_MEMBER_MOBILE_AUTH] (nolock) WHERE [sRequestNumber] = ? AND [sType] = 'JOIN' "
			arrParams = Array(_
				Db.makeParam("@sRequestNumber",adVarChar,adParamInput,30,sRequestNumber) _
			)
			ThisCount = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

			If ThisCount = 0 Then

				arrParams = Array(_
					Db.makeParam("@sType",adVarChar,adParamInput,20,"JOIN"), _
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
				'PRINT OUTPUT_VALUE
			End If
			joinTrue = "F"

		End If

	End If
	Call closeRs(DKRS)


'▣ 회원중복확인 E
'DKRS_WebID = "test"


%>
<%' If LCase(dType) = "m" Then	%>
<% if session("MO_CHECK") <> "" Then %>
	<!--#include virtual="/m/_include/document.asp" -->
	<script type="text/javascript" src="/m/jquerymobile/jquery-1.9.1.min.js"></script>
<% else %>
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
<!--
	function joinNext() {
		//opener.agreeFrm.sRequestNO.value = j_sRequestNO;
		<% If session("returnUrl") <> "" then %>
		location.href = "<%=session("returnUrl")%>" +  "?sRequestNO=<%=sRequestNO%>&sResponseNumber=<%=sResponseNumber%>&sCheckKey=cordova";
		self.close();
		<% Else %>
		opener.agreeFrm.submit();
		self.close();
		<% End If %>
	}

	function goIDPWD(){
	<% if session("MO_CHECK") <> "" Then %>
		opener.location.href = "/m/common/member_search_id.asp";
		self.close();
	<% Else %>
		opener.location.href = "/common/member_idpw.asp";
		self.close();
	<% End If %>
	}

	function goLogin(){
	<% if session("MO_CHECK") <> "" Then %>
		opener.location.href = "/m/common/member_login.asp";
		self.close();
	<% Else %>
		opener.location.href = "/common/member_login.asp";
		self.close();
	<% End If %>
	}

	function goIndex(){
		<% if session("MO_CHECK") <> "" Then %>
			opener.location.href = "/m/index.asp";
			self.close();
		<% Else %>
			opener.location.href = "/index.asp";
			self.close();
		<% End If %>
	}
//-->
</script>
<div class="joinAuthTitle width100">
본인인증 및 회원가입여부 확인 결과
</div>
<div class="Result width100">
	<%If joinTrue = "T" Then%>
		<table <%=tableatt%> class="width100">
			<col width="120" />
			<col width="*" />
			<%If isSameNameBirth = "T" Then %>
				<tr>
					<th>본인인증</th>
					<td>성공</td>
				</tr><tr>
					<th>회원중복여부</th>
					<td>이미 가입된 회원</td>
				</tr><tr>
					<th>가입아이디</th>
					<td><%=Mid(DKRS2_WebID,1,Len(DKRS2_WebID)-3)%>***</td>
				</tr><tr>
					<td colspan="2" class="red2">동일한 이름과 생년월일로 등록된 회원이 존재합니다.<br />본인이 회원가입을 하지 않았다면 본사로 문의해주세요.</td>
				</tr>
			<%Else%>
				<tr>
					<th>본인인증</th>
					<td>성공</td>
				</tr><!-- <tr>
					<th>회원중복여부</th>
					<td>이미 가입된 회원</td>
				</tr> -->
					<th>가입아이디</th>
					<td><%=Mid(DKRS_WebID,1,Len(DKRS_WebID)-3)%>***</td>
				</tr>
			<%End If%>
		</table>
		<p style="margin-top:20px;">이미 회원으로 가입된 회원입니다.</p>
		<p style="margin-top:30px;"><a href="javascript:goIDPWD();" class="a_submit design1">ID/패스워드 찾기</a><a href="javascript:goLogin();" class="a_submit design2" style="margin-left:4px;">로그인창으로</a></p>
	<%Else%>
		<% If adultCheck = "T" Then %>
		<script>
			$(document).ready(function(){
				joinNext();
			});
		</script>
		<table <%=tableatt%> class="width100">
			<col width="120" />
			<col width="*" />
			<tr>
				<th>본인인증</th>
				<td>성공</td>
			</tr><tr>
				<th>회원중복여부</th>
				<td>미가입회원</td>
			</tr>
		</table>
		<p style="margin-top:20px;"><strong><%=(sName)%></strong>님 환영합니다.<br />회원가입을 할 수 있습니다</p>
		<p style="margin-top:30px;"><a href="javascript: joinNext();" class="a_submit design6" style="padding: 0px 10px;">회원가입 계속하기</a></p>
		<% Else %>
		<table <%=tableatt%> class="width100">
			<col width="120" />
			<col width="*" />
			<tr>
				<th>본인인증</th>
				<td>성공</td>
			</tr><tr>
				<th>미성년자체크</th>
				<td>미성년 회원은 가입할 수 없습니다.</td>
			</tr>
		</table>
		<p style="margin-top:30px;"><a href="javascript:goIndex();" class="a_submit design2" style="margin-left:4px;">닫기</a></p>
		<% End If %>
	<%End If%>
</div>

</body>
</html>