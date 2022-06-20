<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%


	intIDX = Request.Form("intIDX")

	Call ResRW(intIDX,"intIDX")


	Call Db.BeginTrans(Nothing)
	SQL = "SELECT [isDelivery],[DeliveryDate],[strUserID],[totalPoint],[totalVotePoint],[totalPrice] FROM [DK_ORDER] WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRSS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)


	'배송정보 유무 확인
	If Not DKRSS.BOF And Not DKRSS.EOF Then
			arrDelivery = DKRSS(0)
			arrDeliveryDate = Left(DKRSS(1),10)
			arrUserID = DKRSS(2)
			arrPoint = DKRSS(3)
			arrVotePoint = DKRSS(4)
			arrPrice = DKRSS(5)
			todays = Left(Now,10)

			checkday = DateDiff("d",todays,arrDeliveryDate)

'			If Not checkday < -14 Then Call alerts("배송완료일로부터 14일이 지나지 않았습니다.\n14일 이전에는 주문자만 수취확인을 할 수 있습니다.","go","/hiddens.asp")
	Else
		Call alerts("배송정보를 확인할 수 없습니다.\n데이터가 수정됐을수 있습니다. 새로고침 후 다시 시도해주세요.","go","/hiddens.asp")
	End If
	Call closeRS(DKRSS)


	SQL = "UPDATE [DK_ORDER] SET [state] = '103', [isFinish] = 'T', [FinishDate] = getdate() , [FinishID] = ?  WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@FinishID",adVarChar,adParamInput,30,DKADMIN_ID), _
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

	If Not arrUserID = "GUEST" Or Not IsNull(arrUserID) Then
		SQL =  "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] + ?, [intPrice]= [intPrice] + ?, [intPriceCnt] = [intPriceCnt] + 1 WHERE [strUserID] = ?"
		arrParams = Array(_
			Db.makeParam("@point",adInteger,adParamInput,0,arrPoint), _
			Db.makeParam("@totalPrice",adVarChar,adParamInput,20,arrPrice), _
			Db.makeParam("@userID",adVarChar,adParamInput,20,arrUserID) _

		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

		SQL = "INSERT INTO [DK_MEMBER_POINT_LOG] ([strUserID],[intValue],[valueComment]) VALUES (?,?,?)"
		arrParams = Array(_
			Db.makeParam("@userID",adVarChar,adParamInput,20,arrUserID), _
			Db.makeParam("@point",adInteger,adParamInput,0,arrPoint), _
			Db.makeParam("@valueComment",adVarChar,adParamInput,50,"ORDER1") _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)


		' 추천인 포인트 적립
'		SQL = "SELECT [strVoter] FROM [DK_MEMBER] WHERE [strUserID] = ? "
'		arrParams = Array(_
'			Db.makeParam("@strUserID",adVarChar,adParamInput,20,arrUserID) _
'		)
'		Set DKRSS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
'		'비회원 유무 확인
'			If Not DKRSS.BOF And Not DKRSS.EOF Then
'				arrVoterID = DKRSS(0)
'			Else
'				arrVoterID = ""
'			End If
'		Call closeRS(DKRSS)
'
'		If arrVoterID <> "" Then
'			SQL =  "UPDATE [DK_MEMBER] SET [intPoint] = [intPoint] + ? WHERE [strUserID] = ?"
'			arrParams = Array(_
'				Db.makeParam("@point",adInteger,adParamInput,0,arrVotePoint), _
'				Db.makeParam("@userID",adVarChar,adParamInput,20,arrVoterID) _
'			)
'			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
'			SQL = "INSERT INTO [DK_MEMBER_POINT_LOG] ([strUserID],[valueP],[valueComment]) VALUES (?,?,?)"
'			arrParams = Array(_
'				Db.makeParam("@userID",adVarChar,adParamInput,20,arrVoterID), _
'				Db.makeParam("@point",adInteger,adParamInput,0,arrPoint), _
'				Db.makeParam("@valueComment",adVarChar,adParamInput,50,"ORDER3") _
'			)
'			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
'		End If

	End If






	Call Db.finishTrans(Nothing)

	If Err.Number > 0 Then Call alerts("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","go","/hiddens.asp")


%>
<script type='text/javascript'>
<!--
	parent.location.reload();
//-->
</script>
</body>
</html>
