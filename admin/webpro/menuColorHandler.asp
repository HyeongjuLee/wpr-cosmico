<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%



	OverColor    	= pRequestTF("overColor",True)
	OutColor		= pRequestTF("outColor",True)
	subOverColor 	= pRequestTF("subOverColor",True)
	subOutColor  	= pRequestTF("subOutColor",True)
	leftOverColor	= pRequestTF("leftOverColor",True)
	leftOutColor 	= pRequestTF("leftOutColor",True)

	OverColor2d    	= pRequestTF("overColor2d",True)
	OutColor2d		= pRequestTF("outColor2d",True)
	subOverColor2d 	= pRequestTF("subOverColor2d",True)
	subOutColor2d  	= pRequestTF("subOutColor2d",True)
	leftOverColor2d	= pRequestTF("leftOverColor2d",True)
	leftOutColor2d 	= pRequestTF("leftOutColor2d",True)

	OverColor3d    	= pRequestTF("overColor3d",True)
	OutColor3d		= pRequestTF("outColor3d",True)
	subOverColor3d 	= pRequestTF("subOverColor3d",True)
	subOutColor3d  	= pRequestTF("subOutColor3d",True)
	leftOverColor3d	= pRequestTF("leftOverColor3d",True)
	leftOutColor3d 	= pRequestTF("leftOutColor3d",True)

	OverColor    		= Right(overColor,6)
	OutColor			= Right(outColor,6)
	subOverColor 		= Right(subOverColor,6)
	subOutColor  		= Right(subOutColor,6)
	leftOverColor		= Right(leftOverColor,6)
	leftOutColor 		= Right(leftOutColor,6)

	OverColor2d    		= Right(overColor2d,6)
	OutColor2d			= Right(outColor2d,6)
	subOverColor2d 		= Right(subOverColor2d,6)
	subOutColor2d  		= Right(subOutColor2d,6)
	leftOverColor2d		= Right(leftOverColor2d,6)
	leftOutColor2d 		= Right(leftOutColor2d,6)

	OverColor3d    		= Right(overColor3d,6)
	OutColor3d			= Right(outColor3d,6)
	subOverColor3d 		= Right(subOverColor3d,6)
	subOutColor3d  		= Right(subOutColor3d,6)
	leftOverColor3d		= Right(leftOverColor3d,6)
	leftOutColor3d 		= Right(leftOutColor3d,6)


	arrParams = Array(_
		Db.makeParam("@overColor",adChar,adParamInput,6,overColor), _
		Db.makeParam("@outColor",adChar,adParamInput,6,outColor), _
		Db.makeParam("@subOverColor",adChar,adParamInput,6,subOverColor), _
		Db.makeParam("@subOutColor",adChar,adParamInput,6,subOutColor), _
		Db.makeParam("@leftOverColor",adChar,adParamInput,6,leftOverColor), _
		Db.makeParam("@leftOutColor",adChar,adParamInput,6,leftOutColor), _

		Db.makeParam("@overColor2d",adChar,adParamInput,6,overColor2d), _
		Db.makeParam("@outColor2d",adChar,adParamInput,6,outColor2d), _
		Db.makeParam("@subOverColor2d",adChar,adParamInput,6,subOverColor2d), _
		Db.makeParam("@subOutColor2d",adChar,adParamInput,6,subOutColor2d), _
		Db.makeParam("@leftOverColor2d",adChar,adParamInput,6,leftOverColor2d), _
		Db.makeParam("@leftOutColor2d",adChar,adParamInput,6,leftOutColor2d), _

		Db.makeParam("@overColor3d",adChar,adParamInput,6,overColor3d), _
		Db.makeParam("@outColor3d",adChar,adParamInput,6,outColor3d), _
		Db.makeParam("@subOverColor3d",adChar,adParamInput,6,subOverColor3d), _
		Db.makeParam("@subOutColor3d",adChar,adParamInput,6,subOutColor3d), _
		Db.makeParam("@leftOverColor3d",adChar,adParamInput,6,leftOverColor3d), _
		Db.makeParam("@leftOutColor3d",adChar,adParamInput,6,leftOutColor3d), _

		Db.makeParam("@modifyIP",adVarChar,adParamInput,50,getUserIP), _
		Db.makeParam("@modifyID",adVarChar,adParamInput,50,DK_MEMBER_ID), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_CATEGORY_DEFAULT_COLOR_INSERT",DB_PROC,arrParams,Nothing)


	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS("저장중 오류가 발생하였습니다.","back","")
		Case "FINISH" : Call ALERTS("정상처리되었습니다.","go","menuColor.asp")
	End Select



%>



