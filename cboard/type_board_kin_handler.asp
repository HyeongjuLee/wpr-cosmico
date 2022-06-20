<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	idx			 = pRequestTF("bidx",True)
	replyIdx	 = pRequestTF("replyIdx",True)



	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,idx) _
	)
	Set DKRS = Db.execRs("DKP_NBOARD_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		strUserID			= DKRS("strUserID")
		strBoardName		= DKRS("strBoardName")
		intList				= DKRS("intList")
	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_DATA,"back","")
	End If

	If UCase(DK_MEMBER_ID) = UCase(strUserID) Or DK_MEMBER_TYPE="ADMIN" Then

		arrParams3 = Array(_
			Db.makeParam("@intList",adInteger,adParamInput,0,intList) _
		)
		ReplyCnt_T = CDbl(Db.execRsData("DKSP_NBOARD_KIN_LIST_DATA_T_COUNT",DB_PROC,arrParams3,Nothing))

		If ReplyCnt_T > 0 Then '리플중 답변을 선택한 게시물이라면
			Call ALERTS(LNG_TEXT_KIN_OVER_SELECT,"back","")
		End If

		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,replyIdx),_
			Db.makeParam("@boIDX",adInteger,adParamInput,4,idx),_
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
		)
		Call Db.exec("[DKSP_NBOARD_KIN_SELECT]",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		Select Case OUTPUT_VALUE
			Case "ERROR" : Call ALERTS("데이터 저장 중 오류가 발생하였습니다","back","")
			Case "FINISH" : Call ALERTS("답변이 선택되었습니다","go","board_view_kin.asp?bname="&strBoardName&"&num="&idx)
		End Select


	Else
		Call ALERTS("작성자와 답변 선택자가 다릅니다.","BACK","")
	End If






%>
