<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache

		MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
		MaxDataSize1 = 10 * 1024 * 1024 ' 실제 Data1의 업로드 시킬 파일 사이즈
		MaxDataSize2 = 10 * 1024 * 1024 ' 실제 Data2의 업로드 시킬 파일 사이즈
		MaxDataSize3 = 10 * 1024 * 1024 ' 실제 Data3의 업로드 시킬 파일 사이즈
		MaxMovieSize = 100 * 1024 * 1024 ' 실제 Movie의 업로드 시킬 파일 사이즈
		MaxPicSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

		Set Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.MaxBytesToAbort = MaxFileAbort
		Upload.CodePage = 65001
		Upload.Start REAL_PATH("Temps")



	intIDX				= upfORM("intIDX",True)
	cate1				= upfORM("cate1",False)
	cate2				= upfORM("cate2",False)
	cate3				= upfORM("cate3",False)
	GoodsType			= upfORM("GoodsType",False)
	GoodsName			= upfORM("GoodsName",False)
	GoodsComment		= upfORM("GoodsComment",False)


	GoodsStockType		= upfORM("GoodsStockType",False)
	GoodsStockNum		= upfORM("GoodsStockNum",False)

	GoodsMade			= upfORM("GoodsMade",False)
	GoodsProduct		= upfORM("GoodsProduct",False)
	GoodsBrand			= upfORM("GoodsBrand",False)
	GoodsModels			= upfORM("GoodsModels",False)
	GoodsDate			= upfORM("GoodsDate",False)
	GoodsSearch			= upfORM("GoodsSearch",False)
	GoodsViewTF			= upfORM("GoodsViewTF",False)

	flagBest			= upfORM("flagBest",False)
	flagNew				= upfORM("flagNew",False)
	flagVote			= upfORM("flagVote",False)
	GoodsContent		= upfORM("GoodsContent",False)

	' 배송비 타입 추가 2014-02-22

	GoodsDeliPolicyType	= upfORM("GoodsDeliPolicyType",True)
	GoodsDeliPolicy		= upfORM("GoodsDeliPolicy",False)


	GoodsMaterial		= upfORM("GoodsMaterial",False)
	GoodsCarton			= upfORM("GoodsCarton",False)
	GoodsSize			= upfORM("GoodsSize",False)
	GoodsColor			= upfORM("GoodsColor",False)
	flagMain			= upfORM("flagMain",False)

	isCSGoods			= upfORM("isCSGoods",False)
	CSGoodsCode			= upfORM("CSGoodsCode",False)

	chgMode				= upfORM("chgMode",False)
	strReturnCause		= upfORM("strReturnCause",False)
	If chgMode = "return" Then
		If strReturnCause = "" Then Call ALERTS("상품 반려시에는 반려사유를 적으셔야합니다.","BACK","")
	End If




		isViewMemberNot		= upfORM("isViewMemberNot",False)
		isViewMemberAuth	= upfORM("isViewMemberAuth",False)
		isViewMemberDeal	= upfORM("isViewMemberDeal",False)
		isViewMemberVIP		= upfORM("isViewMemberVIP",False)
		intPriceNot			= upfORM("intPriceNot",False)
		intPriceAuth		= upfORM("intPriceAuth",False)
		intPriceDeal		= upfORM("intPriceDeal",False)
		intPriceVIP			= upfORM("intPriceVIP",False)
		intMinNot			= upfORM("intMinNot",False)
		intMinAuth			= upfORM("intMinAuth",False)
		intMinDeal			= upfORM("intMinDeal",False)
		intMinVIP			= upfORM("intMinVIP",False)
		intPointNot			= upfORM("intPointNot",False)
		intPointAuth		= upfORM("intPointAuth",False)
		intPointDeal		= upfORM("intPointDeal",False)
		intPointVIP			= upfORM("intPointVIP",False)


		If isViewMemberNot	= "" Then isViewMemberNot = "F"
		If isViewMemberAuth	= "" Then isViewMemberAuth = "F"
		If isViewMemberDeal	= "" Then isViewMemberDeal = "F"
		If isViewMemberVIP	= "" Then isViewMemberVIP = "F"
		If intPriceNot		= "" Then intPriceNot = 0
		If intPriceAuth		= "" Then intPriceAuth = 0
		If intPriceDeal		= "" Then intPriceDeal = 0
		If intPriceVIP		= "" Then intPriceVIP = 0
		If intMinNot		= "" Then intMinNot = 0
		If intMinAuth		= "" Then intMinAuth = 0
		If intMinDeal		= "" Then intMinDeal = 0
		If intMinVIP		= "" Then intMinVIP = 0
		If intPointNot		= "" Then intPointNot = 0
		If intPointAuth		= "" Then intPointAuth = 0
		If intPointDeal		= "" Then intPointDeal = 0
		If intPointVIP		= "" Then intPointVIP = 0



		isViewMemberAuth	= isViewMemberNot
		isViewMemberDeal	= isViewMemberNot
		isViewMemberVIP		= isViewMemberNot

		intPriceAuth		= intPriceNot
		intPriceDeal		= intPriceNot
		intPriceVIP			= intPriceNot

		intMinAuth			= intMinNot
		intMinDeal			= intMinNot
		intMinVIP			= intMinNot

		intPointAuth		= intPointNot
		intPointDeal		= intPointNot
		intPointVIP			= intPointNot






	If flagMain = "" Then flagMain = "F"
	If isCSGoods = "" Or IsNull(isCSGoods) = True Then isCSGoods = "F"
	if isCSGoods = "F" Then CSGoodsCode = ""
	If CSGoodsCode = "" Then isCSGoods = "F"


	GoodsBanner = upfORM("GoodsBanner",False)
	If GoodsBanner = "notBanner" Then GoodsBanner = ""

	GoodsNote = upfORM("GoodsNote",False)
	GoodsNoteColor = upfORM("GoodsNoteColor",False)
	If GoodsNoteColor = "" Then GoodsNoteColor = "#777777"
	GoodsNoteColor = Right(GoodsNoteColor,6)


'print oIDX



	Category = Cate1
	If Cate2 <> "" Then Category = Cate2
	If Cate3 <> "" Then Category = Cate3


	If flagBest = "" Or IsNull(flagBest) Then flagBest = "F"
	If flagNew = "" Or IsNull(flagNew) Then flagNew = "F"
	If flagVote = "" Or IsNull(flagVote) Then flagVote = "F"

	'base64 문자형 이미지 체크
	If checkDataImages(GoodsContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")
	If checkDataImages(GoodsDeliPolicy) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다2","back","")


	imgIndex = ""
	imgIndexOver = ""
	Imgs2 = ""
	Imgs3 = ""
	Imgs4 = ""
	Imgs5 = ""
	ImgList = ""
	ImgRelation = ""
	ImgThum = ""


	isImgType = upfORM("isImgType",True)


	Select Case isImgType
		Case "S"
			Ori_Img1Ori			 = upfORM("Ori_Img1Ori",True)
			Ori_Img2Ori			 = upfORM("Ori_Img2Ori",False)
			Ori_Img3Ori			 = upfORM("Ori_Img3Ori",False)
			Ori_Img4Ori			 = upfORM("Ori_Img4Ori",False)
			Ori_Img5Ori			 = upfORM("Ori_Img5Ori",False)
			Ori_ImgList			 = upfORM("Ori_ImgList",True)
			Ori_ImgThum			 = upfORM("Ori_ImgThum",True)
			Ori_ImgRelation		 = upfORM("Ori_ImgRelation",True)
			Ori_ImgBanner		 = upfORM("Ori_ImgBanner",False)
			Ori_imgMobMain		 = upfORM("Ori_imgMobMain",False)





			'기본 이미지 시작
			If Upload.Form("Img2Ori") <> "" Then Imgs2 = uploadImg("Img2Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img2"),upImgWidths_Default,upImgHeight_Default) Else Imgs2 = Ori_Img2Ori End If
			If Upload.Form("Img3Ori") <> "" Then Imgs3 = uploadImg("Img3Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img3"),upImgWidths_Default,upImgHeight_Default) Else Imgs3 = Ori_Img3Ori End If
			If Upload.Form("Img4Ori") <> "" Then Imgs4 = uploadImg("Img4Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img4"),upImgWidths_Default,upImgHeight_Default) Else Imgs4 = Ori_Img4Ori End If
			If Upload.Form("Img5Ori") <> "" Then Imgs5 = uploadImg("Img5Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img5"),upImgWidths_Default,upImgHeight_Default) Else Imgs5 = Ori_Img5Ori End If
			If Upload.Form("imgMobMain") <> "" Then imgMobMain = uploadImg("imgMobMain",REAL_PATH("goods\Original"),REAL_PATH("goods\MobMain"),640,340) Else imgMobMain = Ori_imgMobMain End If


			If Upload.Form("Img1Ori") <> "" Then
				Imgs1 = uploadImg("Img1Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img1"),upImgWidths_Default,upImgHeight_Default)
				ImgThum = ThumImg(Imgs1,REAL_PATH("goods\img1"),REAL_PATH("goods\thum"),upImgWidths_Thum,upImgHeight_Thum)
				If Upload.Form("ImgList") <> "" Then
					ImgList = uploadImg("ImgList",REAL_PATH("goods\Original"),REAL_PATH("goods\list"),upImgWidths_List,upImgHeight_List)
				Else
					ImgList = ThumImg(Imgs1,REAL_PATH("goods\img1"),REAL_PATH("goods\list"),upImgWidths_List,upImgHeight_List)
				End If
				If Upload.Form("ImgRelation") <> "" Then
					ImgRelation = uploadImg("ImgRelation",REAL_PATH("goods\Original"),REAL_PATH("goods\relation"),upImgWidths_relation,upImgHeight_relation)
				Else
					ImgRelation = ThumImg(Imgs1,REAL_PATH("goods\img1"),REAL_PATH("goods\relation"),upImgWidths_relation,upImgHeight_relation)
				End If
			Else
				Imgs1 = Ori_Img1Ori
				ImgThum = Ori_ImgThum
				ImgList = Ori_ImgList
				ImgRelation = Ori_ImgRelation
			End If

			ImgBanner = ""

		Case "V"
			Imgs1		= upfORM("Img1Ori_V",True)
			Imgs2		= upfORM("Img2Ori_V",False)
			Imgs3		= upfORM("Img3Ori_V",False)
			Imgs4		= upfORM("Img4Ori_V",False)
			Imgs5		= upfORM("Img5Ori_V",False)

			ImgList		= upfORM("ImgList_V",False)
			If ImgList = "" Then ImgList = Imgs1

			ImgThum		= upfORM("ImgThum_V",False)
			print imgThum
			If ImgThum = "" Then ImgThum = Imgs1

			ImgRelation	= ""
			ImgBanner	= ""

	End Select

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKPA_GOODS_VIEW",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_CategoryS				= DKRS("Category")
		DKRS_DelTF					= DKRS("DelTF")
		DKRS_GoodsType				= DKRS("GoodsType")
		DKRS_GoodsName				= DKRS("GoodsName")
		DKRS_GoodsComment			= DKRS("GoodsComment")
		DKRS_GoodsSearch			= DKRS("GoodsSearch")
		DKRS_GoodsPrice				= DKRS("GoodsPrice")
		DKRS_GoodsCustomer			= DKRS("GoodsCustomer")
		DKRS_GoodsCost				= DKRS("GoodsCost")
		DKRS_GoodsStockType			= DKRS("GoodsStockType")
		DKRS_GoodsStockNum			= DKRS("GoodsStockNum")
		DKRS_GoodsPoint				= DKRS("GoodsPoint")
		DKRS_GoodsMade				= DKRS("GoodsMade")
		DKRS_GoodsProduct			= DKRS("GoodsProduct")
		DKRS_GoodsBrand				= DKRS("GoodsBrand")
		DKRS_GoodsModels			= DKRS("GoodsModels")
		DKRS_GoodsDate				= DKRS("GoodsDate")
		DKRS_GoodsViewTF			= DKRS("GoodsViewTF")
		DKRS_flagBest				= DKRS("flagBest")
		DKRS_flagNew				= DKRS("flagNew")
		DKRS_FlagVote				= DKRS("FlagVote")
		DKRS_GoodsContent			= DKRS("GoodsContent")
		DKRS_GoodsDeliveryType		= DKRS("GoodsDeliveryType")
		DKRS_GoodsDeliveryFee		= DKRS("GoodsDeliveryFee")
		DKRS_GoodsDeliveryLimit		= DKRS("GoodsDeliveryLimit")
		DKRS_GoodsDeliPolicyType	= DKRS("GoodsDeliPolicyType")
		DKRS_GoodsDeliPolicy		= DKRS("GoodsDeliPolicy")

		DKRS_RegID					= DKRS("RegID")
		DKRS_RegDate				= DKRS("RegDate")
		DKRS_RegHost				= DKRS("RegHost")

		DKRS_OptionVal				= DKRS("OptionVal")
		DKRS_GoodsBanner			= DKRS("GoodsBanner")
		DKRS_GoodsNote				= DKRS("GoodsNote")
		DKRS_GoodsNoteColor			= DKRS("GoodsNoteColor")

		DKRS_Img1Ori				= DKRS("Img1Ori")
		DKRS_Img2Ori				= DKRS("Img2Ori")
		DKRS_Img3Ori				= DKRS("Img3Ori")
		DKRS_Img4Ori				= DKRS("Img4Ori")
		DKRS_Img5Ori				= DKRS("Img5Ori")
		DKRS_ImgList				= DKRS("ImgList")
		DKRS_ImgThum				= DKRS("ImgThum")
		DKRS_ImgRelation			= DKRS("ImgRelation")
		DKRS_ImgBanner				= DKRS("ImgBanner")

		DKRS_GoodsMaterial			= DKRS("GoodsMaterial")
		DKRS_GoodsCarton			= DKRS("GoodsCarton")
		DKRS_flagMain				= DKRS("flagMain")
		DKRS_GoodsSize				= DKRS("GoodsSize")
		DKRS_GoodsColor				= DKRS("GoodsColor")

		DKRS_isCSGoods				= DKRS("isCSGoods")
		DKRS_CSGoodsCode			= DKRS("CSGoodsCode")

	Else
		Call ALERTS("존재하지 않는 상품입니다.","BACK","")

	End If

	Function Fnc_Modify_Compare(ByVal FK_IDX, ByVal COMPARE1, ByVal COMPARE2,  ByVal COMPARETYPE,ByRef RESULT_CNT)
		If COMPARE1 <> COMPARE2 Then
			arrParams = Array(_
				Db.makeParam("@FK_IDX",adInteger,adParamInput,0,FK_IDX), _
				Db.makeParam("@strFieldName",adVarChar,adParamInput,50,COMPARETYPE), _
				Db.makeParam("@strFieldORG",adVarWChar,adParamInput,MAX_LENGTH,COMPARE1), _
				Db.makeParam("@strFieldCHG",adVarWChar,adParamInput,MAX_LENGTH,COMPARE2), _
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@HostIP",adVarChar,adParamInput,20,getUserIP), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_GOODS_CHG_LOG_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			If OUTPUT_VALUE = "FINISH" Then
				RESULT_CNT = RESULT_CNT
				PRINT COMPARETYPE
			Else
				RESULT_CNT = RESULT_CNT + 1
			End If
		End If
	End Function




'	Call Fnc_Modify_Compare(intIDX,DKRS_CategoryS				,Category				,"Category",RESULT_CNT)
'
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsType				,GoodsType				,"GoodsType",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsName				,GoodsName				,"GoodsName",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsComment			,GoodsComment			,"GoodsComment",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsSearch				,GoodsSearch			,"GoodsSearch",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,INT(DKRS_GoodsPrice)			,INT(GoodsPrice)		,"GoodsPrice",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,INT(DKRS_GoodsCustomer)		,INT(GoodsCustomer)		,"GoodsCustomer",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,INT(DKRS_GoodsCost)			,INT(GoodsCost)			,"GoodsCost",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsStockType			,GoodsStockType			,"GoodsStockType",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,INT(DKRS_GoodsStockNum)		,INT(GoodsStockNum)		,"GoodsStockNum",RESULT_CNT)
'
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsMade				,GoodsMade				,"GoodsMade",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsProduct			,GoodsProduct			,"GoodsProduct",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsBrand				,GoodsBrand				,"GoodsBrand",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsModels				,GoodsModels			,"GoodsModels",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,Left(DKRS_GoodsDate,10)		,Left(GoodsDate,10)		,"GoodsDate",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsViewTF				,GoodsViewTF			,"GoodsViewTF",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_flagBest				,flagBest				,"flagBest",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_flagNew					,flagNew				,"flagNew",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_FlagVote				,FlagVote				,"FlagVote",RESULT_CNT)
'
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsContent			,GoodsContent			,"GoodsContent",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsDeliveryType		,GoodsDeliveryType		,"GoodsDeliveryType",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,INT(DKRS_GoodsDeliveryFee)	,INT(GoodsDeliveryFee)		,"GoodsDeliveryFee",RESULT_CNT)
'	'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsDeliveryLimit		,GoodsDeliveryLimit		,"GoodsDeliveryLimit",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsDeliPolicyType		,GoodsDeliPolicyType	,"GoodsDeliPolicyType",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsDeliPolicy			,GoodsDeliPolicy		,"GoodsDeliPolicy",RESULT_CNT)
'
'	Call Fnc_Modify_Compare(intIDX,DKRS_OptionVal				,OptionVal				,"OptionVal",RESULT_CNT)
'	'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsBanner				,GoodsBanner			,"GoodsBanner",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsNote				,GoodsNote				,"GoodsNote",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsNoteColor			,GoodsNoteColor			,"GoodsNoteColor",RESULT_CNT)
'
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_Img1Ori)		,Imgs1					,"Imgs1",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_Img2Ori)		,Imgs2					,"Imgs2",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_Img3Ori)		,Imgs3					,"Imgs3",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_Img4Ori)		,Imgs4					,"Imgs4",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_Img5Ori)		,Imgs5					,"Imgs5",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_ImgList)		,ImgList				,"ImgList",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_ImgThum)		,ImgThum				,"ImgThum",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_ImgRelation)	,ImgRelation			,"ImgRelation",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,backword(DKRS_ImgBanner)		,ImgBanner				,"ImgBanner",RESULT_CNT)
'
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsMaterial			,GoodsMaterial			,"GoodsMaterial",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsCarton				,GoodsCarton			,"GoodsCarton",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_flagMain				,flagMain				,"flagMain",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsSize				,GoodsSize				,"GoodsSize",RESULT_CNT)
'	Call Fnc_Modify_Compare(intIDX,DKRS_GoodsColor				,GoodsColor				,"GoodsColor",RESULT_CNT)

	Select Case chgMode
		Case "return"
			isAccept = "R"
			arrParams = Array(_
				Db.makeParam("@FK_IDX",adInteger,adParamInput,0,intIDX), _

				Db.makeParam("@strReturnCause",adVarWChar,adParamInput,4000,strReturnCause),_

				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP) _

			)
			Call Db.exec("DKPA_VENDOR_GOODS_RETURN",DB_PROC,arrParams,Nothing)
		Case "accept"
			isAccept = "T"
		Case Else
			isAccept = "P"
	End Select






	Call Db.beginTrans(Nothing)
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _

		Db.makeParam("@Category",adVarChar,adParamInput,20,Category),_

		Db.makeParam("@GoodsType",adChar,adParamInput,1,GoodsType),_
		Db.makeParam("@GoodsName",adVarWChar,adParamInput,100,GoodsName),_
		Db.makeParam("@GoodsComment",adVarWChar,adParamInput,200,GoodsComment),_
		Db.makeParam("@GoodsSearch",adVarWChar,adParamInput,200,GoodsSearch),_

		Db.makeParam("@GoodsStockType",adChar,adParamInput,1,GoodsStockType),_
		Db.makeParam("@GoodsStockNum",adInteger,adParamInput,0,GoodsStockNum),_

		Db.makeParam("@GoodsMade",adVarWChar,adParamInput,60,GoodsMade),_
		Db.makeParam("@GoodsProduct",adVarWChar,adParamInput,50,GoodsProduct),_
		Db.makeParam("@GoodsBrand",adVarWChar,adParamInput,60,GoodsBrand),_
		Db.makeParam("@GoodsModels",adVarWChar,adParamInput,100,GoodsModels),_
		Db.makeParam("@GoodsDate",adDBTimeStamp,adParamInput,16,GoodsDate),_

		Db.makeParam("@GoodsViewTF",adChar,adParamInput,1,GoodsViewTF),_
		Db.makeParam("@flagBest",adChar,adParamInput,1,flagBest),_
		Db.makeParam("@flagNew",adChar,adParamInput,1,flagNew),_
		Db.makeParam("@FlagVote",adChar,adParamInput,1,flagVote),_
		Db.makeParam("@GoodsContent",adVarWChar,adParamInput,MAX_LENGTH,GoodsContent),_


		Db.makeParam("@GoodsDeliPolicyType",adChar,adParamInput,1,GoodsDeliPolicyType),_
		Db.makeParam("@GoodsDeliPolicy",adVarWChar,adParamInput,MAX_LENGTH,GoodsDeliPolicy),_

		Db.makeParam("@GoodsBanner",adInteger,adParamInput,0,GoodsBanner),_
		Db.makeParam("@GoodsNote",adVarWChar,adParamInput,400,GoodsNote),_
		Db.makeParam("@GoodsNoteColor",adChar,adParamInput,6,GoodsNoteColor),_


		Db.makeParam("@Imgs1",adVarWChar,adParamInput,512,Imgs1),_
		Db.makeParam("@Imgs2",adVarWChar,adParamInput,512,Imgs2),_
		Db.makeParam("@Imgs3",adVarWChar,adParamInput,512,Imgs3),_
		Db.makeParam("@Imgs4",adVarWChar,adParamInput,512,Imgs4),_
		Db.makeParam("@Imgs5",adVarWChar,adParamInput,512,Imgs5),_

		Db.makeParam("@ImgList",adVarWChar,adParamInput,512,ImgList),_
		Db.makeParam("@ImgRelation",adVarWChar,adParamInput,512,ImgRelation),_
		Db.makeParam("@ImgThum",adVarWChar,adParamInput,512,ImgThum),_
		Db.makeParam("@ImgBanner",adVarWChar,adParamInput,512,ImgBanner),_

		Db.makeParam("@isCSGoods",adChar,adParamInput,1,isCSGoods),_
		Db.makeParam("@CSGoodsCode",adVarChar,adParamInput,20,CSGoodsCode),_

		Db.makeParam("@GoodsMaterial",adVarWChar,adParamInput,200,GoodsMaterial),_
		Db.makeParam("@GoodsCarton",adVarWChar,adParamInput,200,GoodsCarton),_
		Db.makeParam("@GoodsSize",adVarWChar,adParamInput,100,GoodsSize),_
		Db.makeParam("@GoodsColor",adVarWChar,adParamInput,100,GoodsColor),_
		Db.makeParam("@flagMain",adVarChar,adParamInput,1,flagMain),_


		Db.makeParam("@isViewMemberNot",adChar,adParamInput,1,isViewMemberNot),_
		Db.makeParam("@isViewMemberAuth",adChar,adParamInput,1,isViewMemberAuth),_
		Db.makeParam("@isViewMemberDeal",adChar,adParamInput,1,isViewMemberDeal),_
		Db.makeParam("@isViewMemberVIP",adChar,adParamInput,1,isViewMemberVIP),_

		Db.makeParam("@intPriceNot",adInteger,adParamInput,4,intPriceNot),_
		Db.makeParam("@intPriceAuth",adInteger,adParamInput,4,intPriceAuth),_
		Db.makeParam("@intPriceDeal",adInteger,adParamInput,4,intPriceDeal),_
		Db.makeParam("@intPriceVIP",adInteger,adParamInput,4,intPriceVIP),_
		Db.makeParam("@intMinNot",adInteger,adParamInput,4,intMinNot),_
		Db.makeParam("@intMinAuth",adInteger,adParamInput,4,intMinAuth),_
		Db.makeParam("@intMinDeal",adInteger,adParamInput,4,intMinDeal),_
		Db.makeParam("@intMinVIP",adInteger,adParamInput,4,intMinVIP),_
		Db.makeParam("@intPointNot",adInteger,adParamInput,4,intPointNot),_
		Db.makeParam("@intPointAuth",adInteger,adParamInput,4,intPointAuth),_
		Db.makeParam("@intPointDeal",adInteger,adParamInput,4,intPointDeal),_
		Db.makeParam("@intPointVIP",adInteger,adParamInput,4,intPointVIP),_

		Db.makeParam("@isAccept",adChar,adParamInput,1,isAccept),_
		Db.makeParam("@isImgType",adChar,adParamInput,1,isImgType),_

		Db.makeParam("@imgMobMain",adVarWChar,adParamInput,512,imgMobMain),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_VENDOR_GOODS_MODIFY",DB_PROC,arrParams,Nothing)

	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)



	Call Db.finishTrans(Nothing)




	If Err.Number = 0 Then
		'PRINT "SUCCESS"
		Call ALERTS("정상적으로 저장되었습니다.","go","Vendor_Goods_List_P.asp")
	Else
		'PRINT "ERROR"
		Call ALERTS("저장중 오류가 발생하였습니다..","back","")
	End If



%>
</head>
<body>
</body>
</html>
