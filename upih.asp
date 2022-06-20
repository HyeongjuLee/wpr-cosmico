<!--#include virtual = "/_lib/strFunc.asp"-->
<%
If webproIP<>"T" Then Response.Redirect "/index.asp"

	Call noCache
    Server.ScriptTimeOut = 7200

	MaxFileAbort = 50 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize  = 10
	MaxDataSize1 = MaxDataSize * 1024 * 1024


	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Codepage = 65001
	Call ChkPathToCreate(BVIR_PATH("upload"))
	Upload.Start BREAL_PATH("upload")

%>
<%
	imgPath = REAL_PATH("goods2\Original")
	imgPath1 = REAL_PATH("goods2\img1")
	IMG_WIDTH = upImgWidths_Default	'330
	IMG_HEIGHT = upImgHeight_Default	'340

	IMG_WIDTH = ""
	IMG_HEIGHT = ""

	'uploadImg , ThumImg test
	Imgs1 = uploadImg("Filedata",REAL_PATH("goods2\Original"),REAL_PATH("goods2\img1"),IMG_WIDTH,IMG_HEIGHT)
	ImgThum = ThumImg(Imgs1,REAL_PATH("goods2\img1"),REAL_PATH("goods2\thum"),upImgWidths_Thum,upImgHeight_Thum)

	'upImg test
	'Imgs1 = upImg("Filedata",imgPath)

	'upImgInfo test
	'Imgs1 = upImgInfo("Filedata",imgPath,imgWidth,imgHeight)

	print "<hr>"
	print Imgs1& " _OK<br />"
	print imgWidth& " _OK<br />"
	print imgHeight& " _OK<br />"
	print ImgThum& " _OK"

	Response.End
	Response.End


'	strData1 = FN_IMAGEUPLOAD("Filedata","F",MaxDataSize1,REAL_PATH2("uploadData\reply"),"","F","0","0","","t1","t2","t3")
	strData1 = FN_FILEUPLOAD("Filedata","F",MaxDataSize1,REAL_PATH2("uploadData\reply"),"")


%>