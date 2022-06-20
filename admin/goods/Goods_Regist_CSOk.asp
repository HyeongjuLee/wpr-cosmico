<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache

		MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)

		MaxDataSize  = 2
		MaxDataSize1 = MaxDataSize * 1024 * 1024 ' 실제 Data1의 업로드 시킬 파일 사이즈
		MaxDataSize2 = MaxDataSize * 1024 * 1024 ' 실제 Data2의 업로드 시킬 파일 사이즈
		MaxDataSize3 = MaxDataSize * 1024 * 1024 ' 실제 Data3의 업로드 시킬 파일 사이즈
		MaxMovieSize = 100 * 1024 * 1024 ' 실제 Movie의 업로드 시킬 파일 사이즈
		MaxPicSize1 = MaxDataSize * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

		Set Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.MaxBytesToAbort = MaxFileAbort
		Upload.CodePage = 65001
		Upload.Start REAL_PATH("Temps")



		cate1				= upfORM("cate1",False)
		cate2				= upfORM("cate2",False)
		cate3				= upfORM("cate3",False)
		GoodsType			= upfORM("GoodsType",False)
		GoodsName			= upfORM("GoodsName",False)
		GoodsComment		= upfORM("GoodsComment",False)
        GoodsMall           = upfORM("GoodsMall", False)


'		GoodsPrice			= upfORM("GoodsPrice",False)
		GoodsCustomer		= upfORM("GoodsCustomer",False)
		GoodsCost			= upfORM("GoodsCost",False)
		GoodsStockType		= upfORM("GoodsStockType",False)
		GoodsStockNum		= upfORM("GoodsStockNum",False)
		GoodsPoint			= upfORM("GoodsPoint",False)
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
		'flagEvent			= upfORM("flagEvent",False)			'기획전

		GoodsContent		= upfORM("GoodsContent",False)

		' 배송비 타입 추가 2014-02-22
		GoodsDeliveryType	= upfORM("GoodsDeliveryType",True)
		GoodsDeliveryFee	= upfORM("GoodsDeliveryFee",False)
		GoodsDeliPolicyType	= upfORM("GoodsDeliPolicyType",True)
		GoodsDeliPolicy		= upfORM("GoodsDeliPolicy",False)

		OptionVal			= upfORM("OptionVal",True)
		optiontitle			= upfORM("optiontitle",False)
		optionValues		= upfORM("optionValues",False)



		isCSGoods			= upfORM("isCSGoods",False)
		CSGoodsCode			= upfORM("CSGoodsCode",False)

		flagMain			= upfORM("flagMain",False)

		GoodsMaterial		= upfORM("GoodsMaterial",False)
		GoodsCarton			= upfORM("GoodsCarton",False)
		GoodsSize			= upfORM("GoodsSize",False)
		GoodsColor			= upfORM("GoodsColor",False)

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

		strNationCode		= upfORM("strNationCode",True) '국가코드 추가

		strShopID			= upfORM("strShopID",True)

		intCSPrice6			= upfORM("intCSPrice6",False)	'VIP 가 (엘라이프)
		intCSPrice7			= upfORM("intCSPrice7",False)	'GOLD가 (엘라이프)

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

		If intCSPrice6 = "" Or isNull(intCSPrice6) Then intCSPrice6 = 0
		If intCSPrice7 = "" Or isNull(intCSPrice7) Then intCSPrice7 = 0

		GoodsPrice		= 0
		'GoodsCustomer	= 0
		'GoodsCost		= 0






		If flagMain = "" Then flagMain = "F"

		If isCSGoods = "" Or IsNull(isCSGoods) = True Then isCSGoods = "F"
		If isCSGoods = "F" Then CSGoodsCode = ""
		If CSGoodsCode = "" Then isCSGoods = "F"

		GoodsBanner = upfORM("GoodsBanner",False)
		If GoodsBanner = "notBanner" Then GoodsBanner = ""

		GoodsNote = upfORM("GoodsNote",False)
		GoodsNoteColor = upfORM("GoodsNoteColor",False)
		If GoodsNoteColor = "" Then GoodsNoteColor = "#777777"
		GoodsNoteColor = Right(GoodsNoteColor,6)

		Category = Cate1
		If Cate2 <> "" Then Category = Cate2
		If Cate3 <> "" Then Category = Cate3


		If flagBest = "" Or IsNull(flagBest) Then flagBest = "F"
		If flagNew = "" Or IsNull(flagNew) Then flagNew = "F"
		If flagVote = "" Or IsNull(flagVote) Then flagVote = "F"
		'If flagEvent = "" Or IsNull(flagEvent) Then flagEvent = "F"

		imgIndex = ""
		imgIndexOver = ""
		Imgs2 = ""
		Imgs3 = ""
		Imgs4 = ""
		Imgs5 = ""
		ImgList = ""
		ImgRelation = ""
		ImgThum = ""

		'이미지 시작

		'base64 문자형 이미지 체크
		If checkDataImages(GoodsContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")
		If checkDataImages(GoodsDeliPolicy) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다2","back","")


		If Upload.Form("Img1Ori") = "" Then
			Call alerts("필수값입니다.","back","")
		Else
			If Upload.Form("Img1Ori").FileSize < MaxDataSize1 Then
				Imgs1 = uploadImg("Img1Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img1"),upImgWidths_Default,upImgHeight_Default)
			Else
				Call ALERTS("이미지 크기는 "&MaxDataSize&"MB를 넘을 수 없습니다.","BACK","")
			End If
		End If

		If Upload.Form("Img2Ori") <> "" Then Imgs2 = uploadImg("Img2Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img2"),upImgWidths_Default,upImgHeight_Default)
		If Upload.Form("Img3Ori") <> "" Then Imgs3 = uploadImg("Img3Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img3"),upImgWidths_Default,upImgHeight_Default)
		If Upload.Form("Img4Ori") <> "" Then Imgs4 = uploadImg("Img4Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img4"),upImgWidths_Default,upImgHeight_Default)
		If Upload.Form("Img5Ori") <> "" Then Imgs5 = uploadImg("Img5Ori",REAL_PATH("goods\Original"),REAL_PATH("goods\img5"),upImgWidths_Default,upImgHeight_Default)
		If Upload.Form("imgMobMain") <> "" Then
			imgMobMain = uploadImg("imgMobMain",REAL_PATH("goods\Original"),REAL_PATH("goods\mobMain"),640,340)
		Else
			imgMobMain = ""
		End If

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

		ImgThum = ThumImg(Imgs1,REAL_PATH("goods\img1"),REAL_PATH("goods\thum"),upImgWidths_Thum,upImgHeight_Thum)
		'ImgIndex = ThumImg(Imgs1,REAL_PATH("goods\img1"),REAL_PATH("goods\index"),110,110)

		ImgBanner = ""




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

	'기본 이미지 종료

'print Imgs1 & "<br />"
'print Imgs2 & "<br />"
'print Imgs3 & "<br />"
'print Imgs4 & "<br />"
'print Imgs5 & "<br />"
'print ImgList & "<br />"
'print ImgRelation & "<br />"
'print ImgThum & "<br />"
'Call ResRW(Category			,"@Category adVarChar")
'Call ResRW(GoodsType		,"@GoodsType adChar			")
'Call ResRW(GoodsName		,"@GoodsName adVarChar		")
'Call ResRW(GoodsComment		,"@GoodsComment adVarChar		")
'Call ResRW(GoodsSearch		,"@GoodsSearch adVarChar		")
'Call ResRW(GoodsPrice		,"@GoodsPrice adInteger		")
'Call ResRW(GoodsCustomer	,"@GoodsCustomer adInteger	")
'Call ResRW(GoodsCost		,"@GoodsCost adInteger		")
'Call ResRW(GoodsStockType	,"@GoodsStockType adChar		")
'Call ResRW(GoodsStockNum	,"@GoodsStockNum adInteger	")
'Call ResRW(GoodsPoint		,"@GoodsPoint adInteger		")
'Call ResRW(GoodsMade		,"@GoodsMade adVarChar		")
'Call ResRW(GoodsProduct		,"@GoodsProduct adVarChar		")
'Call ResRW(GoodsBrand		,"@GoodsBrand adVarChar		")
'Call ResRW(GoodsModels		,"@GoodsModels adVarChar		")
'Call ResRW(GoodsDate		,"@GoodsDate adDBTimeStamp	")
'Call ResRW(GoodsViewTF		,"@GoodsViewTF adChar			")
'Call ResRW(flagBest			,"@flagBest adChar			")
'Call ResRW(flagNew			,"@flagNew adChar				")
'Call ResRW(flagVote			,"@FlagVote adChar			")
	'Call ResRW(GoodsContent		,"@GoodsContent adVarChar		")
'Call ResRW(DK_MEMBER_ID		,"@RegID adVarChar			")
'Call ResRW(getUserIP		,"@RegHost adVarChar			")
'Call ResRW(OptionVal		,"@OptionVal adChar			")
'Call ResRW(GoodsBanner		,"@GoodsBanner adInteger		")
'Call ResRW(GoodsNote		,"@GoodsNote adVarChar		")
'Call ResRW(GoodsNoteColor	,"@GoodsNoteColor adChar		")
'Call ResRW(Imgs1			,"@Imgs1 adVarChar			")
'Call ResRW(Imgs2			,"@Imgs2 adVarChar			")
'Call ResRW(Imgs3			,"@Imgs3 adVarChar			")
'Call ResRW(Imgs4			,"@Imgs4 adVarChar			")
'Call ResRW(Imgs5			,"@Imgs5 adVarChar			")
'Call ResRW(ImgList			,"@ImgList adVarChar			")
'Call ResRW(ImgRelation		,"@ImgRelation adVarChar		")
'Call ResRW(ImgThum			,"@ImgThum adVarChar			")
'Call ResRW(ImgBanner		,"@ImgBanner adVarChar		")
'Call ResRW(isCSGoods		,"@isCSGoods adChar			")
'Call ResRW(SGoodsCode		,"@CSGoodsCode adVarChar		")
'Call ResRW(GoodsMaterial	,"@GoodsMaterial adVarChar	")
'Call ResRW(GoodsCarton		,"@GoodsCarton adInteger		")
'Call ResRW(GoodsSize		,"@GoodsSize adVarChar		")
'Call ResRW(GoodsColor		,"@GoodsColor adVarChar		")





'Response.End

	'형식오류 추가 ( -2146824867 (0x800A0D5D))
	If GoodsPoint		= "" Then GoodsPoint= 0
'	If GoodsDeliveryFee = "" Then GoodsDeliveryFee= 0


	Call Db.beginTrans(Nothing)


'	Call Db.exec("DKPT_DDD",DB_PROC,Nothing,Nothing)

	isImgType = "S"

	arrParams = Array(_
		Db.makeParam("@Category",adVarChar,adParamInput,20,Category),_
		Db.makeParam("@GoodsType",adChar,adParamInput,1,GoodsType),_
		Db.makeParam("@GoodsName",adVarWChar,adParamInput,100,GoodsName),_
		Db.makeParam("@GoodsComment",adVarWChar,adParamInput,300,GoodsComment),_
		Db.makeParam("@GoodsSearch",adVarWChar,adParamInput,200,GoodsSearch),_

		Db.makeParam("@GoodsPrice",adDouble,adParamInput,16,GoodsPrice),_
		Db.makeParam("@GoodsCustomer",adDouble,adParamInput,16,GoodsCustomer),_
		Db.makeParam("@GoodsCost",adDouble,adParamInput,16,GoodsCost),_
		Db.makeParam("@GoodsStockType",adChar,adParamInput,1,GoodsStockType),_
		Db.makeParam("@GoodsStockNum",adDouble,adParamInput,16,GoodsStockNum),_

		Db.makeParam("@GoodsPoint",adInteger,adParamInput,16,GoodsPoint),_
		Db.makeParam("@GoodsMade",adVarWChar,adParamInput,60,GoodsMade),_
		Db.makeParam("@GoodsProduct",adVarWChar,adParamInput,50,GoodsProduct),_
		Db.makeParam("@GoodsBrand",adVarWChar,adParamInput,60,GoodsBrand),_
		Db.makeParam("@GoodsModels",adVarWChar,adParamInput,100,GoodsModels),_

		Db.makeParam("@GoodsDate",adDBTimeStamp,adParamInput,16,GoodsDate),_
		Db.makeParam("@GoodsViewTF",adChar,adParamInput,1,GoodsViewTF),_
		Db.makeParam("@flagBest",adChar,adParamInput,1,flagBest),_
		Db.makeParam("@flagNew",adChar,adParamInput,1,flagNew),_
		Db.makeParam("@FlagVote",adChar,adParamInput,1,flagVote),_
		Db.makeParam("@flagMain",adVarChar,adParamInput,1,flagMain),_



		Db.makeParam("@GoodsContent",adVarWChar,adParamInput,MAX_LENGTH,GoodsContent),_
		Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,GoodsDeliveryType),_
		Db.makeParam("@GoodsDeliveryFee",adDouble,adParamInput,16,GoodsDeliveryFee),_
		Db.makeParam("@GoodsDeliPolicyType",adChar,adParamInput,1,GoodsDeliPolicyType),_
		Db.makeParam("@GoodsDeliPolicy",adVarWChar,adParamInput,MAX_LENGTH,GoodsDeliPolicy),_

		Db.makeParam("@RegID",adVarChar,adParamInput,30,DK_MEMBER_ID),_
		Db.makeParam("@RegHost",adVarChar,adParamInput,30,getUserIP),_
		Db.makeParam("@OptionVal",adChar,adParamInput,1,OptionVal),_
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



		Db.makeParam("@isViewMemberNot",adChar,adParamInput,1,isViewMemberNot),_
		Db.makeParam("@isViewMemberAuth",adChar,adParamInput,1,isViewMemberAuth),_
		Db.makeParam("@isViewMemberDeal",adChar,adParamInput,1,isViewMemberDeal),_
		Db.makeParam("@isViewMemberVIP",adChar,adParamInput,1,isViewMemberVIP),_

		Db.makeParam("@intPriceNot",adDouble,adParamInput,16,intPriceNot),_
		Db.makeParam("@intPriceAuth",adDouble,adParamInput,16,intPriceAuth),_
		Db.makeParam("@intPriceDeal",adDouble,adParamInput,16,intPriceDeal),_
		Db.makeParam("@intPriceVIP",adDouble,adParamInput,16,intPriceVIP),_
		Db.makeParam("@intMinNot",adDouble,adParamInput,16,intMinNot),_
		Db.makeParam("@intMinAuth",adDouble,adParamInput,16,intMinAuth),_
		Db.makeParam("@intMinDeal",adDouble,adParamInput,16,intMinDeal),_
		Db.makeParam("@intMinVIP",adDouble,adParamInput,16,intMinVIP),_
		Db.makeParam("@intPointNot",adDouble,adParamInput,16,intPointNot),_
		Db.makeParam("@intPointAuth",adDouble,adParamInput,16,intPointAuth),_
		Db.makeParam("@intPointDeal",adDouble,adParamInput,16,intPointDeal),_
		Db.makeParam("@intPointVIP",adDouble,adParamInput,16,intPointVIP),_

		Db.makeParam("@strShopID",adVarChar,adParamInput,30,strShopID),_
		Db.makeParam("@isImgType",adChar,adParamInput,1,isImgType),_

		Db.makeParam("@imgMobMain",adVarWChar,adParamInput,512,imgMobMain),_
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR"), _
		Db.makeParam("@IDENTITY_NUM",adInteger,adParamOutput,0,0) _
	)


	Call Db.exec("DKSP_GOODS_INSERT",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams)-1)(4)
	IDENTITY_NUM = arrParams(UBound(arrParams))(4)


	If OptionVal = "T" And IDENTITY_NUM <> "" Then
		O_TITLE = Split(optiontitle,",")
		O_VALUE = Split(optionValues,",")
		For i = 0 to UBound(O_TITLE)
'			Call ResRw(O_TITLE(i),"타이틀")
'			Call ResRw(O_VALUE(i),"내용")

			SQL = ""
			SQL = SQL & "SELECT ISNULL(MAX([sort]),0) FROM [DK_GOODS_OPTION] WHERE [GoodsIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,IDENTITY_NUM) _
			)
			max_num = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))

			max_num = max_num + 1

			SQL = "INSERT INTO [DK_GOODS_OPTION]( "
			SQL = SQL & " [GoodsIDX],[OptionTitle],[OptionValues],[Sort] "
			SQL = SQL & " ) VALUES (?,?,?,?) "
			arrParams = Array(_
				Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,IDENTITY_NUM), _
				Db.makeParam("@OptionTitle",adVarChar,adParamInput,100,Trim(O_TITLE(i))), _
				Db.makeParam("@OptionValues",adVarChar,adParamInput,MAX_LENGTH,Trim(O_VALUE(i))), _
				Db.makeParam("@max_num",adInteger,adParamInput,0,max_num) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		Next
	End If

	Call Db.finishTrans(Nothing)




	If Err.Number = 0 Then
		'PRINT "SUCCESS"
		Call ALERTS("정상적으로 저장되었습니다.","go","goods_list.asp?nc="&strNationCode)
	Else
		'PRINT "ERROR"
		Call ALERTS("저장중 오류가 발생하였습니다..","back","")
	End If



%>
