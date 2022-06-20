<!--#include virtual="/_lib/strFunc.asp" -->
<%
'▣ 나이스 본인인증 관련 S
   Dim clsCPClient
    Dim sSiteCode, sSitePassword, sCipherTime
    Dim sRequestNumber             '요청 번호
    Dim sErrorCode                 '인증 결과코드
    Dim sAuthType                  '인증 수단
    Dim sResult

    sEncodeData = Fn_checkXss(Request("EncodeData"), "encodeData")

    sSiteCode      	= ""			'NICE로부터 부여받은 사이트 코드
	sSitePassword   = ""			'NICE로부터 부여받은 사이트 패스워드

	SET clsCPClient  = SERVER.CREATEOBJECT("CPClient.Kisinfo")

	iRtn = clsCPClient.fnDecode(sSiteCode, sSitePassword, sEncodeData)

    IF iRtn = 0 THEN
		sPlain           = clsCPClient.bstrPlainData
		sCipherTime      = clsCPClient.bstrCipherDateTime

		RESPONSE.WRITE "인증결과_복호화_성공_원문[" & sPlain & "]<br>"

		iReturn = clsCPClient.fnGetAuthInfo("REQ_SEQ")
		sRequestNumber= clsCPClient.bstrAuthInfo

		iReturn = clsCPClient.fnGetAuthInfo("ERR_CODE")
		sErrorCode= clsCPClient.bstrAuthInfo

		iReturn = clsCPClient.fnGetAuthInfo("AUTH_TYPE")
		sAuthType= clsCPClient.bstrAuthInfo

		sRequestNO = sRequestNumber

	IF session("REQ_SEQ") <> sRequestNO THEN
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



%>

<% if session("MO_CHECK") <> "" Then %>
<!--#include virtual="/m/_include/document.asp" -->
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
	function goJoin() {
		//opener.agreeFrm.sRequestNO.value = j_sRequestNO;
		<% if session("MO_CHECK") <> "" Then %>
			$(opener.location).attr("href","/m/common/joinStep01.asp");
			self.close();
		<% Else %>
			$(opener.location).attr("href","/common/joinStep01.asp");
			self.close();
		<% End If %>
	}
//-->
</script>
<div class="joinAuthTitle width100">
본인인증 및 회원가입여부 확인 결과
</div>
<div class="Result width100">
		<table <%=tableatt%> class="width100">
			<col width="120" />
			<col width="*" />
			<tr>
				<th>본인인증</th>
				<td>실패</td>
			</tr><tr>
				<th>회원중복여부</th>
				<td>-</td>
			</tr><tr>
				<th>가입아이디</th>
				<td>-</td>
			</tr>
		</table>
		<p style="margin-top:20px;">본인인증에 실패했습니다.</p>
		<p style="margin-top:30px;"><a href="javascript:goJoin();" class="a_submit design6">재인증하기</a></p>

</div>

</body>
</html>