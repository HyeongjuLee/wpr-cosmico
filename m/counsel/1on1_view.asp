<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/counsel/1on1_config.asp"-->
<%

	PAGE_SETTING = "CUSTOMER"
	PAGE_SETTING2 = "SUBPAGE"
	ISSUBTOP = "T"

	mNum = 5
	sNum = 3
	sVar = sView
	view = sNum

	If PAGE_SETTING = "MYOFFICE" Then
		Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
		Call ONLY_CS_MEMBER()
	End If

	IS_LANGUAGESELECT = "F"


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
		DKRS_strUserID		= DKRS("strUserID")
		DKRS_strName		= DKRS("strName")
		DKRS_strEmail		= DKRS("strEmail")
		DKRS_strMobile		= DKRS("strMobile")
		DKRS_strSubject		= DKRS("strSubject")
		DKRS_strContent		= DKRS("strContent")
		DKRS_regDate		= DKRS("regDate")
		DKRS_regIP			= DKRS("regIP")
		DKRS_isSmsSend		= DKRS("isSmsSend")
		DKRS_isMailSend		= DKRS("isMailSend")
		DKRS_isReply		= DKRS("isReply")
		DKRS_repDate		= DKRS("repDate")
		DKRS_strReply		= DKRS("strReply")
		DKRS_strReplyData1	= DKRS("strReplyData1")
		DKRS_strReplyID		= DKRS("strReplyID")

		DKRS_strNation		= DKRS("strNation")
		DKRS_strData1		= DKRS("strData1")
		DKRS_strData2		= DKRS("strData2")
		DKRS_strData3		= DKRS("strData3")

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
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/1on1.css?" />

</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="counseling" class="cs_view">
	<div class="question">
		<h6>
			<p><%=LNG_TEXT_WRITE_DATE%><i></i><%=DKRS_regDate%></p>
			<span><%=BACKWORD(DKRS_strSubject)%></span>
		</h6>
		<div class="content"><%=DKRS_strContent%></div>
		<%
			If DKRS_strData1 <> "" Then
				strDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/counselData1")&"\"&DKRS_strData1) / 1024)
		%>
		<div class="file">
			<a href="javascript:fTrans('<%=FN_HR_ENC(DKRS_strData1)%>','<%=FN_HR_ENC("counsel1")%>');">
				<h6><%=LNG_TEXT_FILE1%><i></i></h6>
				<p><%=BACKWORD(DKRS_strData1)%></p>
				<span>(<%=num2cur(strDataSize1)%>KB)</span>
			</a>
		</div>
		<%End If%>
	</div>

	<%If DKRS_isReply = "F" Then%>
		<p class="replyInfo"><span style="color:#ee0000"><%=LNG_1ON1_WAITING_FOR_REPLY%></span></p>
	<%Else%>
		<!-- <p class="replyInfo2"><span class="color:#0000cc"><%=DKRS_repDate%> 에 답변이 최종등록되었습니다.</span></p> -->
		<div class="replyInfo2">
			<!-- <h6><p><%=LNG_1ON1_FINAL_ANSWER_REGISTRATION%><i></i><%=DKRS_repDate%></p></h6> -->
			<h6><p><%=LNG_1ON1_ANSWER%><i></i><%=DKRS_repDate%></p></h6>
			<div class="content">
				<%=DKRS_strReply%>
			</div>
			<%
				If DKRS_strReplyData1 <> "" Then
					strReplyDataSize1 = num2cur(ChkFileSize(REAL_PATH2("uploadData/counselR")&"\"&DKRS_strReplyData1) / 1024)
			%>
			<div class="file">
				<a href="javascript:fTrans('<%=FN_HR_ENC(DKRS_strReplyData1)%>','<%=FN_HR_ENC("counselR")%>');">
					<h6><%=LNG_TEXT_FILE1%><i></i></h6>
					<p><%=BACKWORD(DKRS_strReplyData1)%></p>
					<span>(<%=num2cur(strReplyDataSize1)%>KB)</span>
				</a>
			</div>
		<%End If%>
		</div>
	<%End If%>

		<div class="btnZone">
			<a href="1on1_list.asp?page=<%=PAGE%>" class="button"><%=LNG_BOARD_BTN_LIST%></a>
		</div>
	</div>


</div>

<!--#include virtual = "/m/_include/copyright.asp"-->