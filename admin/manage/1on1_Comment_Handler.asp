<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE8-2"

	sc_isReply	= Request("sc_isReply")			: If sc_isReply	= "" Then sc_isReply	= ""
	sc_cate1	= Request("sc_cate1")			: If sc_cate1	= "" Then sc_cate1		= ""
	sc_cate2	= Request("sc_cate2")			: If sc_cate2	= "" Then sc_cate2		= ""
	sc_Name		= Request("sc_Name")			: If sc_Name	= "" Then sc_Name		= ""
	sc_ReplyID	= Request("sc_ReplyID")			: If sc_ReplyID	= "" Then sc_ReplyID	= ""
	intIDX		= Request("idx")				: If intIDX = "" Then Call ALERTS("정상적인 접근이 아닙니다","BACK","")

	PAGE = Request("page")						: If PAGE="" Then PAGE = 1 End If

	SC_QUERY = "PAGE="&page
	SC_QUERY = SC_QUERY & "&sc_cate1="&sc_cate1
	SC_QUERY = SC_QUERY & "&sc_cate2="&sc_cate2
	SC_QUERY = SC_QUERY & "&sc_Name="&server.urlencode(sc_Name)
	SC_QUERY = SC_QUERY & "&sc_ReplyID="&server.urlencode(sc_ReplyID)
	SC_QUERY = SC_QUERY & "&sc_isReply="&sc_isReply





	MODE			= pRequestTF("mode",True)
	intIDX			= pRequestTF("idx",False)

		Select Case MODE
			Case "ADD"
				strMemo			= pRequestTF("strMemo",False)
				arrParams = Array(_
					Db.makeParam("@FK_IDX",adInteger,adParamInput,4,intIDX), _

					Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
					Db.makeParam("@strMemo",adVarWChar,adParamInput,2000,strMemo), _
					Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _

					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("[DKSP_COUNSEL_1ON1_MEMO_INSERT_ADMIN]",DB_PROC,arrParams,Nothing)
				OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			Case "DEL"
					delIDX	= pRequestTF("delIDX",False)

					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,4,delIDX), _
						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
					)
					Call Db.exec("[DKSP_COUNSEL_1ON1_MEMO_DELETE_ADMIN]",DB_PROC,arrParams,Nothing)
					OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


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
			SC_QUERY = SC_QUERY & "&idx="&intIDX

			Call ALERTS(DBFINISH,"GO","1on1_view.asp?"&SC_QUERY)
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<!--#include virtual = "/admin/_inc/copyright.asp"-->
