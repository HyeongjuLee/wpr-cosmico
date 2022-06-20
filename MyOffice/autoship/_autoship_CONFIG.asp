<%
	'If webproIP<> "T" Then Call WRONG_ACCESS()

	If Ucase(DK_MEMBER_NATIONCODE) <> "KR" Then CALL WRONG_ACCESS()

	'▣오토쉽 월 결제일 설정
	AUTOSHIP_PAYABLE_DAYS = "5, 10, 15, 20, 25"			'javascript, asp 공통 (1 ~ 31)
	AUTOSHIP_PAYABLE_DAYS_TEXT = "("&AUTOSHIP_PAYABLE_DAYS&"일 중 신청 가능)"
	AUTOSHIP_PAYABLE_DAYS_ALERT = "오토십 시작일은 "&AUTOSHIP_PAYABLE_DAYS&"일 중에서 신청 가능합니다."


	' *****************************************************************************
	'	Function name	: FN_AUTOSHIP_PAYABLE_DAYS
	'	Description		: 오토쉽 월 결제일 체크
	' *****************************************************************************
		Function FN_AUTOSHIP_PAYABLE_DAYS (ByVal value)
			FN_AUTOSHIP_PAYABLE_DAYS = False

			abledDays_Array = Split(Replace(AUTOSHIP_PAYABLE_DAYS," ",""), ",")

			For aInedx = 0 to Ubound(abledDays_Array)
				If CStr(abledDays_Array(aInedx)) = CStr(value) Then
					FN_AUTOSHIP_PAYABLE_DAYS = True
					Exit For
				End If
			Next
		End Function

%>
<%
	'*** 오토쉽 특이사항 설정 ***

	'◆오토쉽 횟수 체크(테이블 기본키 설정 확인!!)
	If AUTOSHIP_CNT_PAGE = "T" Then			'등록 페이지만 체크
		SQL_AC = "SELECT COUNT(*) FROM [dbo].[tbl_Memberinfo_A] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ? "
		arrParams = Array(_
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2)_
		)
		AUTOSHIP_CNT = Db.execRsData(SQL_AC,DB_TEXT,arrParams,DB3)
		IF CDbl(AUTOSHIP_CNT) > 0 Then
			If AJAX_TF = "T" Then
				PRINT "{""result"":""error"",""message"":""오토쉽은 1번만 신청 할 수 있습니다.""}"
				Response.End
			Else
				Call ALERTS("오토쉽은 1번만 신청 할 수 있습니다.","BACK","")
			End If
		End If
	End If


	'본인매출 누적 100만BV미만 오토쉽 신청 불가처리('엠제트 2021-06-25)
	'▣승인된 회원매출(01) PV
	'arrParams = Array(_
	'	Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
	'	Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	')
	'TOTALPV01_APPROVED = Db.execRsData("HJP_TOTALPV01_APPROVED",DB_PROC,arrParams,DB3)
	'If TOTALPV01_APPROVED < Cdbl(1000000) Then
	'	If AJAX_TF = "T" Then
	'		PRINT "{""result"":""error"",""message"":""본인매출 누적 100만BV미만은 오토쉽 신청을 할 수 없습니다""}"
	'		Response.End
	'	Else
	'		Call ALERTS("본인매출 누적 100만BV미만은 오토쉽 신청을 할 수 없습니다","BACK","")
	'	End If
	'End If

%>




