<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache

	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage =65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode = upForm("mode",True)



	' 모드 값에 따른 필수 정보값 확인
		intCateDepth				= upForm("intCateDepth",False)
		strCateParent				= upForm("strCateParent",False)

		strCateNameKor				= upForm("strCateNameKor",False)
		strCateNameEng				= upForm("strCateNameEng",False)
		PkPageSetting				= upForm("PkPageSetting",False)


		intMainAxisX				= upForm("intMainAxisX",False)
		intSubAxisX					= upForm("intSubAxisX",False)

		isView						= upForm("isView",False)
		isSubView					= upForm("isSubView",False)



'		OriStrImg					= upForm("OriStrImg",False)

		isShop						= upForm("isShop",False)
		isTargetType				= upForm("isTargetType",False)
		strLinkURL					= upForm("strLinkURL",False)

		overColor					= upForm("overColor",False)
		outColor					= upForm("outColor",False)
		subOverColor				= upForm("subOverColor",False)
		subOutColor					= upForm("subOutColor",False)
		leftOverColor				= upForm("leftOverColor",False)
		leftOutColor				= upForm("leftOutColor",False)


		' 수정시 필수 필드



		' 다음 버전 업데이트 예정 필드
		intletterSpacing			= 0

		isTopImgMenu				= "F"

		TopImgOn					= ""
		TopImgOff					= ""

		LeftImgTop					= ""
		LeftImgBottom				= ""

		isLeftImgMenu				= "F"
		leftImgOn					= ""
		leftImgOff					= ""
		' 다음 버전 업데이트 예정 필드


		overColor					= Right(overColor,6)
		outColor					= Right(outColor,6)
		subOverColor				= Right(subOverColor,6)
		subOutColor					= Right(subOutColor,6)
		leftOverColor				= Right(leftOverColor,6)
		leftOutColor				= Right(leftOutColor,6)



		If intMainAxisX = ""		Then intMainAxisX = 0
		If intSubAxisX = ""			Then intSubAxisX = 0
		If isView = ""				Then isView = "F"
		If isSubView = ""			Then isSubView = "F"
		If isShop = ""				Then isShop = "F"
		If targetType = ""			Then targetType = "S"

		If strLinkURL = "" Or strLinkURL = "포럼은 도메인을 제외한 주소를 넣어야합니다." Then strLinkURL = "#"



		SQL = "SELECT TOP(1)* FROM [DK_CATEGORY_DEFAULT_COLOR] WHERE [delTF] = 'F' ORDER BY [intIDX] DESC"
		Set DKRS = Db.execRs(SQL,DB_TEXT,Nothing,Nothing)

		If Not DKRS.BOF And Not DKRS.EOF Then
			o_overColor		= DKRS("OverColor")
			o_outColor		= DKRS("OutColor")
			o_soverColor	= DKRS("subOverColor")
			o_soutColor		= DKRS("subOutColor")
			o_loverColor	= DKRS("leftOverColor")
			o_loutColor		= DKRS("leftOutColor")
		Else
			o_overColor		= "000000"
			o_outColor		= "000000"
			o_soverColor	= "000000"
			o_soutColor		= "000000"
			o_loverColor	= "000000"
			o_loutColor		= "000000"
		End If

		If overColor		= "" Then overColor			= o_overColor
		If outColor			= "" Then outColor			= o_outColor
		If subOverColor		= "" Then subOverColor		= o_soverColor
		If subOutColor		= "" Then subOutColor		= o_soutColor
		If leftOverColor	= "" Then leftOverColor		= o_loverColor
		If leftOutColor		= "" Then leftOutColor		= o_loutColor





	Select Case mode
		Case "INSERT"

'			If Upload.Form("strImg") <> "" Then
'				strImg = upImg("strImg",REAL_PATH("category"))
'			Else
'				Call ALERTS("이미지가 첨부되지 않았습니다.","back","")
'			End If

			arrParams = Array( _
				Db.makeParam("@PkPageSetting",adVarChar,adParamInput,20,PkPageSetting), _
				Db.makeParam("@strCateNameKor",adVarWChar,adParamInput,100,strCateNameKor), _
				Db.makeParam("@strCateNameEng",adVarChar,adParamInput,100,strCateNameEng), _
				Db.makeParam("@strCateParent",adVarChar,adParamInput,20,strCateParent), _
				Db.makeParam("@intCateDepth",adInteger,adParamInput,0,intCateDepth), _

				Db.makeParam("@isShop",adChar,adParamInput,1,isShop), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _
				Db.makeParam("@isSubView",adChar,adParamInput,1,isSubView), _
				Db.makeParam("@isTargetType",adChar,adParamInput,1,isTargetType), _
				Db.makeParam("@strLinkURL",adVarChar,adParamInput,512,strLinkURL), _

				Db.makeParam("@intMainAxisX",adInteger,adParamInput,0,intMainAxisX), _
				Db.makeParam("@intSubAxisX",adInteger,adParamInput,0,intSubAxisX), _
				Db.makeParam("@intLetterSpacing",adInteger,adParamInput,0,intLetterSpacing), _


				Db.makeParam("@overColor",adChar,adParamInput,6,overColor), _
				Db.makeParam("@outColor",adChar,adParamInput,6,outColor), _
				Db.makeParam("@subOverColor",adChar,adParamInput,6,subOverColor), _
				Db.makeParam("@subOutColor",adChar,adParamInput,6,subOutColor), _
				Db.makeParam("@leftOverColor",adChar,adParamInput,6,leftOverColor), _
				Db.makeParam("@leftOutColor",adChar,adParamInput,6,leftOutColor), _

				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKPA_CATEGORY_INSERT",DB_PROC,arrParams,Nothing)
		Case "UPDATE"
'			OriStrImg = upForm("OriStrImg",False)
'			If Upload.Form("strImg") <> "" Then
'				strImg = upImg("strImg",REAL_PATH("category"))
'				Call sbDeleteFiles(REAL_PATH("category")&"\"&OriStrImg)
'			Else
'				strImg = OriStrImg
'			End If
			strCateCode					= upForm("strCateCode",True)

			arrParams = Array( _
				Db.makeParam("@strCateCode",adVarchar,adParamInput,20,strCateCode), _

				Db.makeParam("@PkPageSetting",adVarChar,adParamInput,20,PkPageSetting), _
				Db.makeParam("@strCateNameKor",adVarWChar,adParamInput,100,strCateNameKor), _
				Db.makeParam("@strCateNameEng",adVarChar,adParamInput,100,strCateNameEng), _


				Db.makeParam("@isShop",adChar,adParamInput,1,isShop), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _
				Db.makeParam("@isSubView",adChar,adParamInput,1,isSubView), _
				Db.makeParam("@isTargetType",adChar,adParamInput,1,isTargetType), _
				Db.makeParam("@strLinkURL",adVarChar,adParamInput,512,strLinkURL), _

				Db.makeParam("@intMainAxisX",adInteger,adParamInput,0,intMainAxisX), _
				Db.makeParam("@intSubAxisX",adInteger,adParamInput,0,intSubAxisX), _
				Db.makeParam("@intLetterSpacing",adInteger,adParamInput,0,intLetterSpacing), _


				Db.makeParam("@overColor",adChar,adParamInput,6,overColor), _
				Db.makeParam("@outColor",adChar,adParamInput,6,outColor), _
				Db.makeParam("@subOverColor",adChar,adParamInput,6,subOverColor), _
				Db.makeParam("@subOutColor",adChar,adParamInput,6,subOutColor), _
				Db.makeParam("@leftOverColor",adChar,adParamInput,6,leftOverColor), _
				Db.makeParam("@leftOutColor",adChar,adParamInput,6,leftOutColor), _


				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_
			)
			Call Db.exec("DKPA_CATEGORY_UPDATE",DB_PROC,arrParams,Nothing)
		Case "DELETE"
					strCateCode					= upForm("strCateCode",True)

			arrParams = Array( _
				Db.makeParam("@strCateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,10,"ERROR")_

			)
			Call Db.exec("DKPA_CATEGORY_DELETE",DB_PROC,arrParams,Nothing)
			'ThisUpFile = arrParams(UBound(arrParams)-1)(4)
			'Call sbDeleteFiles(REAL_PATH("category")&"\"&ThisUpFile)

		Case "SORTUP"
					strCateCode					= upForm("strCateCode",True)

			arrParams = Array( _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTUP"), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKPA_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
		Case "SORTDOWN"
			strCateCode					= upForm("strCateCode",True)

			arrParams = Array( _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTDOWN"), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
	End Select


	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)



Select Case OUTPUT_VALUE
	Case "ERROR"
		Call alerts("카테고리 수정에 문제가 발생했습니다.","back","")
	Case "NODATA"
		Call alerts("처리할 데이터가 없습니다.","back","")
	Case "BEGIN"
		Call alerts("더이상 올릴 수 없습니다.","back","")
	Case "LAST"
		Call alerts("더이상 내릴 수 없습니다.","back","")
	Case "FINISH"
		%>
		<!--#include virtual = "/admin/_inc/document.asp"-->
		</head>
		<body>
		<form name="ff" action="menuList.asp" method="post">
			<input type="hidden" name="Cate" value="<%=strCateParent%>" />
		</form>
		<script type="text/javascript">
			<!--
				var ff = document.ff;
				alert("정상적으로 처리되었습니다");
				ff.submit();

		//-->
		</script>
		</body>
		</html>
		<%
End Select
		%>
