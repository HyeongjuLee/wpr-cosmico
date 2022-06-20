<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%

	Call Only_Member(DK_MEMBER_LEVEL)


	intIDX			= pRequestTF("intIDX",True)
	strGrade		= pRequestTF("strGrade",True)
	strSubject		= pRequestTF("strSubject",True)
	content1		= pRequestTF("content1",True)


'	Call ResRW(intIDX			,"intIDX")
'	Call ResRW(strGrade			,"strGrade")
'	Call ResRW(strSubject		,"strSubject")
'	Call ResRW(content1			,"content1")

	'base64 문자형 이미지 체크
	If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
'	Set DKRS = Db.execRs("DKP_REVIEW_WRITE_INFO",DB_PROC,arrParams,Nothing)
	Set DKRS = Db.execRs("DKP2_REVIEW_WRITE_INFO",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_gIDX				= DKRS("gIDX")
		DKRS_ReViewTF			= DKRS("ReViewTF")
		DKRS_strOption			= DKRS("strOption")
		DKRS_strUserID			= DKRS("strUserID")
		DKRS_status				= DKRS("status")
		DKRS_GoodsName			= DKRS("GoodsName")
		DKRS_goodsPrice			= DKRS("goodsPrice")
		DKRS_imgThum			= backword(DKRS("imgThum"))
		DKRS_Category			= DKRS("Category")
		DKRS_OrderNum			= DKRS("OrderNum")
	Else
		Call ALERTS("주문정보가 올바르지 않습니다.","CLOSE","")
	End If
	Call closeRS(DKRS)

	If DKRS_status <> "103" Then Call ALERTS("수취확인된 주문에 대해서만 리뷰작성이 가능합니다.","CLOSE","")
	If DKRS_ReViewTF = "T" Then Call ALERTS("이미 리뷰를 작성한 상품입니다.","CLOSE","")
	If DKRS_strUserID <> DK_MEMBER_ID Then Call ALERTS("주문자와 리뷰작성자가 틀립니다.","CLOSE","")


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
		Db.makeParam("@goodsIDX",adInteger,adParamInput,0,DKRS_gIDX), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
		Db.makeParam("@strGrade",adInteger,adParamInput,0,strGrade), _
		Db.makeParam("@strSubject",adVarChar,adParamInput,200,strSubject), _
		Db.makeParam("@strContent",adVarChar,adParamInput,MAX_LENGTH,content1), _
		Db.makeParam("@orderNum",adVarChar,adParamInput,20,DKRS_OrderNum), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
'	Call Db.exec("DKP_REVIEW_WRITE_INSERT",DB_PROC,arrParams,Nothing)
	Call Db.exec("DKP2_REVIEW_WRITE_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"back","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"o_reloada","")
		Case Else		: Call ALERTS(DBUNDEFINED,"back","")
	End Select



%>
</head>
<body>


</body>
</html>
