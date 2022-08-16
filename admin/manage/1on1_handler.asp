<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache

	MaxFileAbort = 15 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)


	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage = 65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")

	MaxDataSize1 = 5 * 1024 * 1024 ' 실제 Data1의 업로드 시킬 파일 사이즈
	MaxDataSize2 = 5 * 1024 * 1024 ' 실제 Data2의 업로드 시킬 파일 사이즈
	MaxDataSize3 = 5 * 1024 * 1024 ' 실제 Data3의 업로드 시킬 파일 사이즈



	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE8-2"

	'strNationCode = upfORM("nc",True)
	strNationCode = UCase(viewAdminLangCode)

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	'INFO_MODE = "MANAGE3-1-"&DKRS_FA_intSort&""
	'INFO_TEXT = DKRS_FA_strNationName

	sc_isReply	= upfORM("sc_isReply",false)		: If sc_isReply	= "" Then sc_isReply	= ""
	sc_cate1	= upfORM("sc_cate1",false)			: If sc_cate1	= "" Then sc_cate1		= ""
	sc_cate2	= upfORM("sc_cate2",false)			: If sc_cate2	= "" Then sc_cate2		= ""
	sc_Name		= upfORM("sc_Name",false)			: If sc_Name	= "" Then sc_Name		= ""
	sc_ReplyID	= upfORM("sc_ReplyID",false)		: If sc_ReplyID	= "" Then sc_ReplyID	= ""
	sc_WebID	= upfORM("sc_WebID",false)			: If sc_WebID	= "" Then sc_WebID	= ""
	intIDX		= upfORM("idx",True)				: If intIDX = "" Then Call ALERTS("정상적인 접근이 아닙니다","BACK","")

	PAGE = upfORM("page",False)						: If PAGE="" Then PAGE = 1 End If

	SC_QUERY = "nc="&LCase(strNationCode)
	SC_QUERY = SC_QUERY & "&PAGE="&page
	SC_QUERY = SC_QUERY & "&sc_cate1="&sc_cate1
	SC_QUERY = SC_QUERY & "&sc_cate2="&sc_cate2
	SC_QUERY = SC_QUERY & "&sc_Name="&server.urlencode(sc_Name)
	SC_QUERY = SC_QUERY & "&sc_ReplyID="&server.urlencode(sc_ReplyID)
	SC_QUERY = SC_QUERY & "&sc_WebID="&server.urlencode(sc_WebID)
	SC_QUERY = SC_QUERY & "&sc_isReply="&sc_isReply



	MODE			= upForm("mode",True)
	intIDX			= upForm("idx",False)


		Select Case MODE
			Case "DELETE"
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("DKSP_COUNSEL_1ON1_DELETE_ADMIN",DB_PROC,arrParams,Nothing)
				OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
			Case "UPDATE"
				strReply			= upfORM("strReply",False)
				isReply				= upfORM("isReply",False)
				isSmsSend			= upfORM("isSmsSend",False)
				o_strReplyData1		= upfORM("o_strReplyData1",False)
				strReplyID			= DK_MEMBER_ID

				strReplyData1 = FN_FILEUPLOAD("strReplyData1","F",MaxDataSize1,REAL_PATH2("/uploadData/counselReply"),o_strReplyData1)

				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX),_
					Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(strNationCode)) _
				)
				Set DKRS = Db.execRs("DKSP_COUNSEL_1ON1_VIEW_ADMIN",DB_PROC,arrParams,Nothing)
				If Not DKRS.BOF And Not DKRS.EOF Then
					DKRS_isReply			= DKRS("isReply")
				Else
					Call ALERTS("데이터가 존재하지 않습니다","GO","1on1_list.asp?"&SC_QUERY)
				End If
				Call closeRS(DKRS)

				If DKRS_isReply = "T" Then
					Call ALERTS("이미 답변처리가 된 데이터입니다","BACK","")
				Else
					If isReply = "T" Then
						repDate = Now()


						If DK_MEMBER_ID = "webpro" And webproIP="T" and 1=2 Then
						'COSMICO SMS 1:1문의 관리자 답변 문자메세지 전송
							strMobile = upfORM("strMobile",False)
							strWebID = upfORM("strWebID",False)

							strMobile = "01082860240"

							strCate = "1on1"
							MMS_BODY = "안녕하세요 코즈미코 코리아 입니다. 1:1 문의 하신 내역의 답변이 등록되었습니다."
							MMS_SUBJECT = "안녕하세요 코즈미코 코리아 입니다"
							MSG_MMS_USE = "F"  'MMS도 사용시
							Call FN_SMS_MOBILE_INFO_SEND(strMobile, strWebID, MMS_BODY, MMS_SUBJECT, strCate, MSG_MMS_USE)
						End If

					Else
						repDate = Now()
						isReply = isReply
					End If

					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
						Db.makeParam("@isReply",adChar,adParamInput,1,isReply), _
						Db.makeParam("@strReplyID",adVarChar,adParamInput,20,strReplyID), _

						Db.makeParam("@strReply",adVarWChar,adParamInput,MAX_LENGTH,strReply), _
						Db.makeParam("@strReplyData1",adVarWChar,adParamInput,100,strReplyData1), _
						Db.makeParam("@repDate",adDBTimeStamp,adParamInput,16,repDate), _

						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
					)
					Call Db.exec("DKSP_COUNSEL_1ON1_UPDATE_ADMIN",DB_PROC,arrParams,Nothing)
					OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

				End If




			Case Else
				Call ALERTS("모드가 올바르지 않습니다","BACK","")
		End Select



	Select Case OUTPUT_VALUE
		Case "FINISH"	:
			'1:1문의 업데이트 성공시 처리
			'If MODE = "UPDATE" And isReply = "T" Then
			'	arrParams = Array(_
			'		Db.makeParam("@WebID",adVarChar,adParamInput,20,DKRS_strUserID) _
			'	)
			'	Set DKRS_INFO = Db.execRs("DKP_MEMBER_INFO_WEBID",DB_PROC,arrParams,DB3)
			'	token = DKRS_INFO("fcm_token")
			'
			'	If Len(token) > 0 Then
			'		message = "회원님의 1:1문의에 답변이 등록되었습니다.\r\n확인 하시겠습니까?"
			'		url = houUrl&"/m/mypage/1on1_view.asp?page=1&idx="&DKRS_intIDX
			'		Call FnPushMessage(token, message, url, "1on1", DK_MEMBER_ID)
			'	End If
			'End If
			Call ALERTS(DBFINISH,"GO","1on1_list.asp?"&SC_QUERY)
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<!--#include virtual = "/admin/_inc/copyright.asp"-->
