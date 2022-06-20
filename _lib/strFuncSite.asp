<%

' *****************************************************************************
' Function Name		: CallPointComment
' Discription		: 현재 상태 변경
' *****************************************************************************
	Function Fn_MapType(ByVal value)
		Dim types : types = value
		Dim State
		Select Case types
			Case "I" : State = spans("이미지사용","","9pt","normal")
			Case "A" : State = spans("다음 API사용","","9pt","normal")
		End Select
		Fn_MapType = State
	End Function


' *****************************************************************************
' Function Name		: CallPointComment
' Discription		: 현재 상태 변경
' *****************************************************************************
	Function CallMemGroup(ByVal value)
		Dim types : types = value
		Dim State
		Select Case types
			Case "ADMIN"		: State = LNG_STRFUNCSITE_TEXT01	'"관리자"
			Case "OPERATOR"		: State = LNG_STRFUNCSITE_TEXT02	'"오퍼레이터"
			Case "SADMIN"		: State = LNG_STRFUNCSITE_TEXT03	'"지점관리자"
			Case "MEMBER"		: State = LNG_STRFUNCSITE_TEXT04	'"회원"
			Case "COMPANY"		: State = LNG_STRFUNCSITE_TEXT05	'"CS 연동회원"
		End Select
		CallMemGroup = State
	End Function
' *****************************************************************************
' Function Name		: CallPointComment
' Discription		: 현재 상태 변경
' *****************************************************************************
	Function CallPointComment(ByVal value)
		Dim types : types = value
		Dim State
		Select Case types
			Case "ORDER1" : State = spans(LNG_STRFUNCSITE_TEXT06,"#0000ff","9pt","normal")
			Case "ORDER2" : State = spans(LNG_STRFUNCSITE_TEXT07,"#ff0000","9pt","normal")
			Case "ADMIN1" : State = spans(LNG_STRFUNCSITE_TEXT08,"#0000ff","9pt","normal")
			Case "ADMIN2" : State = spans(LNG_STRFUNCSITE_TEXT09,"#ff0000","9pt","normal")
		End Select
		CallPointComment = State
	End Function

' *****************************************************************************
' Function Name		: CallState
' Discription		: 현재 상태 변경
' *****************************************************************************
	Function CallState(ByVal value)
		Dim types : types = value
		Dim State
		Select Case types
			Case "100" : State = LNG_STRFUNCSITE_TEXT10	'"입금확인중"
			Case "101" : State = LNG_STRFUNCSITE_TEXT11	'"배송준비중"
			Case "102" : State = LNG_STRFUNCSITE_TEXT12	'"배송완료"
			Case "103" : State = LNG_STRFUNCSITE_TEXT13	'"수취확인"

			Case "201" : State = LNG_STRFUNCSITE_TEXT14	'"관리자취소"
			Case "301" : State = LNG_STRFUNCSITE_TEXT15	'"취소요청"
			Case "302" : State = LNG_STRFUNCSITE_TEXT16	'"취소완료"
		End Select
		CallState = State
	End Function

' *****************************************************************************
' Function Name		: CallPointComment
' Discription		: 현재 상태 변경
' *****************************************************************************
	Function CallMemSex(ByVal value)
		Dim types : types = value
		Dim State
		Select Case types
			Case "M" : State = LNG_STRFUNCSITE_TEXT17	'"남성"
			Case "F" : State = LNG_STRFUNCSITE_TEXT18	'"여성"
		End Select
		CallMemSex = State
	End Function
' *****************************************************************************
' Function Name		: makeBan
' Discription		: 카테고리 출력
' *****************************************************************************

	Function PrintCate(ByVal InCate1, ByVal InCate2)

		arrParams = Array(_
			Db.makeParam("@CheckCate1",adVarChar,adParamInput,3,InCate1), _
			Db.makeParam("@CheckCate2",adVarChar,adParamInput,6,InCate2) _
		)
		'	Db.makeParam("@strGoodsCategory",adVarChar,adParamInput,9,InCate3) _

		Set DKRS_FUNC1 = Db.execRs("DKP_PRINT_CATEGORY",DB_PROC,arrParams,Nothing)
			If Not DKRS_FUNC1.BOF Or Not DKRS_FUNC1.EOF Then
				PrintCate = ""
				PrintCate = PrintCate & DKRS_FUNC1(0) & " &gt; "
				PrintCate = PrintCate & DKRS_FUNC1(1)
'				PrintCate = PrintCate & DKRS_FUNC1(2) & " &gt; "

			End If
		Call closeRs(DKRS_FUNC1)
	End Function


	Function PrintCate1(ByVal InCate1)

		arrParams = Array(_
			Db.makeParam("@CheckCate1",adVarChar,adParamInput,3,InCate1), _
			Db.makeParam("@CheckCate2",adVarChar,adParamInput,6,"") _
		)
		'	Db.makeParam("@strGoodsCategory",adVarChar,adParamInput,9,InCate3) _

		Set DKRS_FUNC1 = Db.execRs("DKP_PRINT_CATEGORY",DB_PROC,arrParams,Nothing)
			If Not DKRS_FUNC1.BOF Or Not DKRS_FUNC1.EOF Then
				'PrintCate = ""
				PrintCate1 = DKRS_FUNC1(0)
				'PrintCate = PrintCate & DKRS_FUNC1(1)
'				PrintCate = PrintCate & DKRS_FUNC1(2) & " &gt; "

			End If
		Call closeRs(DKRS_FUNC1)
	End Function


	Function PrintCate2(ByVal InCate1, ByVal InCate2)

		arrParams = Array(_
			Db.makeParam("@CheckCate1",adVarChar,adParamInput,3,InCate1), _
			Db.makeParam("@CheckCate2",adVarChar,adParamInput,6,InCate2) _
		)
		'	Db.makeParam("@strGoodsCategory",adVarChar,adParamInput,9,InCate3) _

		Set DKRS_FUNC1 = Db.execRs("DKP_PRINT_CATEGORY2",DB_PROC,arrParams,Nothing)
			If Not DKRS_FUNC1.BOF Or Not DKRS_FUNC1.EOF Then
				PrintCate2 = ""
				PrintCate2 = PrintCate2 & DKRS_FUNC1(0) & " &gt; "
				PrintCate2 = PrintCate2 & DKRS_FUNC1(1)
'				PrintCate = PrintCate & DKRS_FUNC1(2) & " &gt; "

			End If
		Call closeRs(DKRS_FUNC1)
	End Function


	'다국어
	Function PrintCate_E1(ByVal InCate1, ByVal InCate2, ByVal InCate3, ByVal InDepth, ByVal nationCode)

		arrParams = Array(_
			Db.makeParam("@CheckCate1",adVarChar,adParamInput,3,InCate1), _
			Db.makeParam("@CheckCate2",adVarChar,adParamInput,6,InCate2), _
			Db.makeParam("@CheckCate3",adVarChar,adParamInput,9,InCate3), _
			Db.makeParam("@PAGE_SETTING",adVarChar,adParamInput,20,PAGE_SETTING), _
			Db.makeParam("@nationCode",adVarChar,adParamInput,6,nationCode) _
		)
		'	Db.makeParam("@strGoodsCategory",adVarChar,adParamInput,9,InCate3) _

		Set DKRS_FUNC1 = Db.execRs("DKSP_PRINT_SHOP_CATEGORY_E",DB_PROC,arrParams,Nothing)
		If Not DKRS_FUNC1.BOF Or Not DKRS_FUNC1.EOF Then
			Select Case InDepth
				Case "1" : PrintCate_E1 = DKRS_FUNC1(0)
				Case "2" : PrintCate_E1 = DKRS_FUNC1(1)
				Case "3" : PrintCate_E1 = DKRS_FUNC1(2)
				Case Else :
					If DKRS_FUNC1(1) <> "" Then	CATE2 = " &gt; "&DKRS_FUNC1(1)
					If DKRS_FUNC1(2) <> "" Then	CATE3 = " &gt; "&DKRS_FUNC1(2)
					PrintCate_E1 = DKRS_FUNC1(0) & CATE2 & CATE3
					'PrintCate_E1 = DKRS_FUNC1(0) &" &gt; "&DKRS_FUNC1(1) &" &gt; "&DKRS_FUNC1(2)
			End Select
		End If


		Call closeRs(DKRS_FUNC1)
	End Function






	'/header_shop.asp 선언
	Function FN_NationCurrency(ByVal nation, ByRef Chg_CurrencyName, ByRef Chg_CurrencyISO)
		arrParams_F1 = Array(_
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,nation) _
		)
		Set DKRS_F1 = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_F1,Nothing)
		If Not DKRS_F1.BOF And Not DKRS_F1.EOF Then
			Chg_CurrencyName	= DKRS_F1("strCurrency")
			Chg_CurrencyISO		= DKRS_F1("strCurrencyISO")
		Else
			Chg_CurrencyName = "원"
			Chg_CurrencyISO = "KRW"
		End If
	End Function


	Function FNC_CS_POINT_INPUT(ByVal fnc_mbid,ByVal fnc_mbid2,ByVal fnc_M_Name,ByVal fnc_PlusValue,ByVal fnc_PlusKind,ByVal fnc_MinusValue,ByVal fnc_MinusKind,ByVal fnc_User_id,ByVal fnc_ETC1,ByVal fnc_PayDate)
		'900	웹 게시판 작성 적립
		'901	웹 게시판 삭제 차감
		'902	웹 게시판 답글 작성 적립
		'903	웹 게시판 답글 삭제 차감
		'904	웹 게시판 댓글 작성 적립
		'905	웹 게시판 댓글 삭제 차감
		'910	웹 게시판 추천 적립
		'911	웹 게시판 추천 작성자 적립
		'990	웹 출석 적립
		'991	웹 출석 특별 적립
		arrParams = Array(_
			Db.makeParam("@mbid",adVarChar,adParamInput,20,fnc_mbid), _
			Db.makeParam("@mbid2",adInteger,adParamInput,4,fnc_mbid2), _
			Db.makeParam("@M_Name",adVarWChar,adParamInput,50,fnc_M_Name), _
			Db.makeParam("@PlusValue",adCurrency,adParamInput,6,fnc_PlusValue), _
			Db.makeParam("@PlusKind",adVarChar,adParamInput,3,fnc_PlusKind), _
			Db.makeParam("@MinusValue",adCurrency,adParamInput,6,fnc_MinusValue), _
			Db.makeParam("@MinusKind",adVarChar,adParamInput,3,fnc_MinusKind), _
			Db.makeParam("@User_id",adVarChar,adParamInput,30,fnc_User_id), _
			Db.makeParam("@ETC1",adVarWChar,adParamInput,300,fnc_ETC1), _
			Db.makeParam("@PayDate",adVarChar,adParamInput,30,fnc_PayDate) _
		)
		Call Db.exec("[DKSP_CS_POINT_INPUT]",DB_PROC,arrParams,DB3)
		'	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		'	CREATE PROCEDURE [DKSP_CS_POINT_INPUT]
		'	(
		'		 @MBID1			VARCHAR(20)
		'		,@MBID2			INT
		'		,@M_NAME		NVARCHAR(50)
		'		,@PlusValue		MONEY
		'		,@PlusKind		VARCHAR(3)
		'		,@MinusValue	MONEY
		'		,@MinusKind		VARCHAR(3)
		'		,@User_id		VARCHAR(30)
		'		,@ETC1			NVARCHAR(300)
		'		,@PayDate		VARCHAR(30)
		'	)
		'	AS
		'	SET NOCOUNT ON
		'	BEGIN
		'
		'
		'		INSERT INTO [tbl_Member_Mileage] (
		'			[T_Time],[mbid],[mbid2],[M_Name],[PlusValue],[PlusKind],[MinusValue],[MinusKind],[PayDate],[User_id],[ETC1]
		'		) VALUES (
		'			 CONVERT(VARCHAR,GETDATE(),121), @MBID1,@MBID2,@M_NAME,@PlusValue,@PlusKind
		'			,@MinusValue,@MinusKind,@PayDate,@User_id,@ETC1
		'		)
		'
		'
		'
		'	END
		'	SET NOCOUNT OFF
	End Function


	Function FNC_CS_POINT_INPUT_WEB(ByVal fnc_webID, ByVal fnc_PlusValue,ByVal fnc_PlusKind,ByVal fnc_MinusValue,ByVal fnc_MinusKind,ByVal fnc_User_id,ByVal fnc_ETC1,ByVal fnc_PayDate)
		'900	웹 게시판 작성 적립
		'901	웹 게시판 삭제 차감
		'902	웹 게시판 답글 작성 적립
		'903	웹 게시판 답글 삭제 차감
		'904	웹 게시판 댓글 작성 적립
		'905	웹 게시판 댓글 삭제 차감
		'910	웹 게시판 추천 적립
		'911	웹 게시판 추천 작성자 적립
		'990	웹 출석 적립
		'991	웹 출석 특별 적립
		arrParams = Array(_
			Db.makeParam("@M_Name",adVarWChar,adParamInput,100,fnc_webID), _
			Db.makeParam("@PlusValue",adCurrency,adParamInput,6,fnc_PlusValue), _
			Db.makeParam("@PlusKind",adVarChar,adParamInput,3,fnc_PlusKind), _
			Db.makeParam("@MinusValue",adCurrency,adParamInput,6,fnc_MinusValue), _
			Db.makeParam("@MinusKind",adVarChar,adParamInput,3,fnc_MinusKind), _
			Db.makeParam("@User_id",adVarChar,adParamInput,30,fnc_User_id), _
			Db.makeParam("@ETC1",adVarWChar,adParamInput,300,fnc_ETC1), _
			Db.makeParam("@PayDate",adVarChar,adParamInput,30,fnc_PayDate) _
		)
		Call Db.exec("DKSP_CS_POINT_INPUT_WEBID",DB_PROC,arrParams,DB3)
		'	CREATE PROCEDURE [DKSP_CS_POINT_INPUT_WEBID]
		'	(
		'		 @webID			NVARCHAR(100)
		'		,@PlusValue		MONEY
		'		,@PlusKind		VARCHAR(3)
		'		,@MinusValue	MONEY
		'		,@MinusKind		VARCHAR(3)
		'		,@User_id		VARCHAR(30)
		'		,@ETC1			NVARCHAR(300)
		'		,@PayDate		VARCHAR(30)
		'	)
		'	AS
		'	SET NOCOUNT ON
		'	BEGIN
		'		DECLARE @MBID1	VARCHAR(20)
		'		DECLARE @MBID2	INT
		'		DECLARE @M_NAME	NVARCHAR(100)
		'
		'		SELECT @MBID1 = MBID, @MBID2 = mbid2, @M_NAME = M_Name
		'		FROM tbl_Memberinfo WHERE WebID = @webID
		'
		'		IF @MBID1 <> '' BEGIN
		'
		'			INSERT INTO [tbl_Member_Mileage] (
		'				[T_Time],[mbid],[mbid2],[M_Name],[PlusValue],[PlusKind],[MinusValue],[MinusKind],[PayDate],[User_id],[ETC1]
		'			) VALUES (
		'				 CONVERT(VARCHAR,GETDATE(),121), @MBID1,@MBID2,@M_NAME,@PlusValue,@PlusKind
		'				,@MinusValue,@MinusKind,@PayDate,@User_id,@ETC1
		'			)
		'		END
		'
		'
		'	END
		'	SET NOCOUNT OFF




	End Function
%>
