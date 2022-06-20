<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%

	MaxFileAbort = 2 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = 2 * 1024 * 1024 ' 실제 Data1의 업로드 시킬 파일 사이즈



	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage = 65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode = upForm("mode",True)





	Select Case mode
		Case "INSERT"
			strNationCode	= upForm("strNationCode",True)
			strCateName		= upForm("strCateName",True)
			strCateParent	= upForm("strCateParent",True)
			intCateDepth	= upForm("intCateDepth",True)
			isView			= upForm("isView",True)

			isBest			= upForm("isBest",False)
			isVote			= upForm("isVote",False)
			isNew			= upForm("isNew",False)
			isTopImgView	= upForm("isTopImgView",False)
			'strTopImg		= upForm("strTopImg",False)
			strTopImg		= uploadImg("strTopImg",REAL_PATH("Category_O"),REAL_PATH("Category_T"),780,500)

			isCateType		= upForm("isCateType",False)
			isLinkType		= upForm("isLinkType",False)
			strLink			= upForm("strLink",False)

			If isBest = ""		Then isBest = "F"
			If isVote = ""		Then isVote = "F"
			If isNew = ""		Then isNew = "F"
			If isTopImgView	= "" Then isTopImgView = "F"

			If isLinkType = ""	Then isLinkType = "S"
			If strLink = ""		Then strLink = "#"
			If strLisCateTypeink = ""	Then isCateType = "S"





			'Call resRW(strCateName		,"strCateName		")
			'Call resRW(strCateParent	,"strCateParent		")
			'Call resRW(intCateDepth		,"intCateDepth		")
			'Call resRW(isView			,"isView			")
			'Call resRW(isBest			,"isBest			")
			'Call resRW(isVote			,"isVote			")
			'Call resRW(isTopImgView		,"isTopImgView		")
			'Call resRW(strTopImg		,"strTopImg			")


			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@strCateName",adVarWChar,adParamInput,100,strCateName), _
				Db.makeParam("@strCateParent",adVarChar,adParamInput,20,strCateParent), _
				Db.makeParam("@intCateDepth",adInteger,adParamInput,4,int(intCateDepth)), _

				Db.makeParam("@isView",adChar,adParamInput,1,isView), _
				Db.makeParam("@isBest",adChar,adParamInput,1,isBest), _
				Db.makeParam("@isVote",adChar,adParamInput,1,isVote), _
				Db.makeParam("@isNew",adChar,adParamInput,1,isNew), _

				Db.makeParam("@isTopImgView",adChar,adParamInput,1,isTopImgView), _
				Db.makeParam("@strTopImg",adVarWChar,adParamInput,250,strTopImg), _

				Db.makeParam("@isCateType",adChar,adParamInput,1,isCateType), _
				Db.makeParam("@isLinkType",adChar,adParamInput,1,isLinkType), _
				Db.makeParam("@strLink",adVarWChar,adParamInput,250,strLink), _


				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKSP_SHOP_CATEGORY_INSERT",DB_PROC,arrParams,Nothing)
		Case "UPDATE"
			strCateCode		= upForm("strCateCode",True)
			strCateParent	= upForm("strCateParent",True)
			strNationCode	= upForm("strNationCode",True)
			strCateName		= upForm("strCateName",True)
			isView			= upForm("isView",True)

			isBest			= upForm("isBest",False)			: If isBest			= "" Then isBest		= "F"
			isVote			= upForm("isVote",False)			: If isVote			= "" Then isVote		= "F"
			isNew			= upForm("isNew",False)				: If isNew			= "" Then isNew			= "F"
			isTopImgView	= upForm("isTopImgView",False)		: If isTopImgView	= "" Then isTopImgView	= "F"

			OriStrImg		= upForm("OriStrImg",False)

			If Upload.Form("strTopImg") <> "" Then
				Call sbDeleteFiles(REAL_PATH("Category_O")&"\"&OriStrImg)
				Call sbDeleteFiles(REAL_PATH("Category_T")&"\"&OriStrImg)

				strTopImg = uploadImg("strTopImg",REAL_PATH("Category_O"),REAL_PATH("Category_T"),780,500)
			Else
				strTopImg = OriStrImg
			End If

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _

				Db.makeParam("@strCateName",adVarWChar,adParamInput,100,strCateName), _
				Db.makeParam("@isView",adChar,adParamInput,1,isView), _
				Db.makeParam("@isBest",adChar,adParamInput,1,isBest), _
				Db.makeParam("@isVote",adChar,adParamInput,1,isVote), _
				Db.makeParam("@isNew",adChar,adParamInput,1,isNew), _
				Db.makeParam("@isTopImgView",adChar,adParamInput,1,isTopImgView), _
				Db.makeParam("@strTopImg",adVarWChar,adParamInput,250,strTopImg), _

				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_
			)
			Call Db.exec("DKSP_SHOP_CATEGORY_UPDATE",DB_PROC,arrParams,Nothing)
		Case "DELETE"
			strCateCode		= upForm("strCateCode",True)
			strCateParent	= upForm("strCateParent",True)
			strNationCode	= upForm("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@ThisUpFile",adVarchar,adParamOutput,512,""), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"")_

			)
			Call Db.exec("DKSP_SHOP_CATEGORY_DELETE",DB_PROC,arrParams,Nothing)
			'Call Db.exec("DKPA_SHOP_CATEGORY_DELETE",DB_PROC,arrParams,Nothing)
			ThisUpFile = arrParams(UBound(arrParams)-1)(4)
			Call sbDeleteFiles(REAL_PATH("Category_O")&"\"&ThisUpFile)
			Call sbDeleteFiles(REAL_PATH("Category_T")&"\"&ThisUpFile)

		Case "SORTUP"
			strCateCode		= upForm("strCateCode",True)
			strCateParent	= upForm("strCateParent",True)
			strNationCode	= upForm("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTUP"), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKSP_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
			'Call Db.exec("DKPA_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
		Case "SORTDOWN"
			strCateCode		= upForm("strCateCode",True)
			strCateParent	= upForm("strCateParent",True)
			strNationCode	= upForm("strNationCode",True)

			arrParams = Array( _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@sortMode",adVarchar,adParamInput,8,"SORTDOWN"), _
				Db.makeParam("@CateCode",adVarchar,adParamInput,20,strCateCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

			)
			Call Db.exec("DKSP_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
			'Call Db.exec("DKPA_SHOP_CATEGORY_SORT",DB_PROC,arrParams,Nothing)
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
		<form name="ff" action="Category.asp" method="post">
			<input type="hidden" name="Cate" value="<%=strCateParent%>" />
		</form>
		<script type="text/javascript">
			<!--
				var ff = document.ff;
				alert("정상적으로 처리되었습니다.");
				ff.submit();
			//-->
		</script>
		</body>
		</html>
		<%
End Select
		%>
