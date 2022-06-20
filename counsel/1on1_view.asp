<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include file = "1on1_config.asp"-->
<%

'	PAGE_MODE_ON = "SHOP"
'	PAGE_MODE = FN_PAGE_MODE_SELECTOR(PAGE_MODE_ON)




	intIDX	= gRequestTF("idx",True)
	PAGE	= gRequestTF("PAGE",False)

	If PAGE="" Then PAGE = 1 End If



	arrParams = Array( _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG) _
	)
	Set DKRS = Db.execRs("DKSP_COUNSEL_1ON1_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX			= DKRS("intIDX")
		DKRS_isDel			= DKRS("isDel")
		DKRS_strUserID			= DKRS("strUserID")
		DKRS_strName			= DKRS("strName")
		DKRS_strEmail			= DKRS("strEmail")
		DKRS_strMobile			= DKRS("strMobile")
		DKRS_strSubject			= DKRS("strSubject")
		DKRS_strContent			= DKRS("strContent")
		DKRS_regDate			= DKRS("regDate")
		DKRS_regIP				= DKRS("regIP")
		DKRS_isSmsSend			= DKRS("isSmsSend")
		DKRS_isMailSend			= DKRS("isMailSend")
		DKRS_isReply			= DKRS("isReply")
		DKRS_repDate			= DKRS("repDate")
		DKRS_strReply			= DKRS("strReply")
		DKRS_strReplyData1		= DKRS("strReplyData1")
		DKRS_strReplyID			= DKRS("strReplyID")

		DKRS_strNation			= DKRS("strNation")
		DKRS_strData1			= DKRS("strData1")
		DKRS_strData2			= DKRS("strData2")
		DKRS_strData3			= DKRS("strData3")

		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			'If DKRS_strName		<> "" Then DKRS_strName		= objEncrypter.Decrypt(DKRS_strName)
			If DKRS_strEmail	<> "" Then DKRS_strEmail	= objEncrypter.Decrypt(DKRS_strEmail)
			If DKRS_strMobile	<> "" Then DKRS_strMobile	= objEncrypter.Decrypt(DKRS_strMobile)

		Set objEncrypter = Nothing
		If DKRS_isDel = "T" Then Call ALERTS(LNG_1ON1_DELETED_DATA,"GO","1on1_list.asp?PAGE="&PAGE)


	Else
		Call ALERTS(LNG_TEXT_NO_DATA,"GO","1on1_list.asp?PAGE="&PAGE)
	End If
	Call closeRS(DKRS)
%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="1on1.css" />
<!-- <script type="text/javascript" src="member_info.js"></script> -->
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$("tr.link").click(function() {
			var linkHref = $(this).attr("attrLink");
			//console.log(linkHref);
			$(location).attr("href",linkHref);
		});
	});

// -->
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="counseling" class="cs_view">
	<table <%=tableatt%> class="width100 view">
		<col width="60" />
		<col width="*" />

		<tr class="subject">
			<td class="tcenter">Q</td>
			<td><%=BACKWORD(DKRS_strSubject)%></td>
		</tr><tr>
			<td colspan="2" class="counselContent"><%=DKRS_strContent%></td>
		</tr>
		<%
			If DKRS_strData1 <> "" Then
				strDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/counselData1")&"\"&DKRS_strData1) / 1024)
		%>
		<tr>
			<td colspan="2"><span style="color:#949494;;"><%=LNG_TEXT_FILE1%> : </span><span style="color:#333;"><a href="javascript:fTrans('<%=FN_HR_ENC(DKRS_strData1)%>','<%=FN_HR_ENC("counsel1")%>');"><%=BACKWORD(DKRS_strData1)%></a></span> <span style="font-size:0.8em; color:#f32000">(<%=num2cur(strDataSize1)%>KB)</span></td>
		</tr>
		<%End If%>
		<tr class="last">
			<!-- <td colspan="2" class="tright"><%=DKRS_strName%>님이 <%=DKRS_regDate%> 에 작성하신 문의입니다.</td> -->
			<td colspan="2" class="tright">[<%=LNG_1ON1_INQUIRY_TIME%>]  <%=DKRS_regDate%></td>
		</tr>
	</table>

	<%If DKRS_isReply = "F" Then%>
		<p class="replyInfo"><span style="color:#ee0000"><%=LNG_1ON1_WAITING_FOR_REPLY%></span></p>
	<%Else%>
		<!-- <p class="replyInfo"><span class="color:#0000cc"><%=DKRS_repDate%> 에 최종답변이 등록되었습니다.</span></p> -->
		<p class="replyInfo"><span class="color:#0000cc"><%=LNG_1ON1_FINAL_ANSWER_REGISTRATION%> - <%=DKRS_repDate%></span></p>
		<div class="reply">
			<%=DKRS_strReply%>
		</div>
		<%
			If DKRS_strReplyData1 <> "" Then
				strReplyDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/counselReply")&"\"&DKRS_strReplyData1) / 1024)
		%>
		<div class="replyData">
			<div class="DataS"><%=LNG_TEXT_FILE1%></div>
			<div class="DataD">
				<span style="color:#333;" class="tweight"><%=BACKWORD(DKRS_strReplyData1)%></span> <span style="color:#f32000">(<%=num2cur(strReplyDataSize1)%>KB)</span>
				| <a href="javascript:fTrans('<%=FN_HR_ENC(DKRS_strReplyData1)%>','<%=FN_HR_ENC("counselR")%>');">[<%=LNG_1ON1_DOWNLOAD%>]</a>
				<!-- | <a href="<%=VIR_PATH("data/reply")%>/<%=DKRS_strReplyData1%>" target="_blank">[<%=LNG_1ON1_RIGHT_VIEW%>]</a> -->
			</div>
		</div>
		<%End If%>
	<%End If%>

	<div class="btnArea">
		<a href="1on1_list.asp?page=<%=PAGE%>" class="a_submit design2"><%=LNG_BOARD_BTN_LIST%></a>
	</div>

</div>
<!--#include virtual = "/_include/copyright.asp"-->


