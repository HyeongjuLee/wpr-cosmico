<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 824
		popHeight = 600


	Dim PAGESIZE		:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE				:	PAGE = Request("PAGE")

	If PAGESIZE = "" Then PAGESIZE = 100
	If PAGE = "" Then PAGE = 1

	'strNationCode = grequestTF("nc",True)
	strNationCode = viewAdminLangCode

' ===================================================================
' ===================================================================
' 데이터 가져오기
' ===================================================================
	arrParams = Array( _
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0), _
		Db.makeParam("@MAX_NUM",adInteger,adParamOutput,0,0) _

	)

	arrList = Db.execRsList("DKSP_GOODS_EMPTY_NUMBER",DB_PROC,arrParams,listLen,Nothing)
	MAX_NUM = arrParams(Ubound(arrParams))(4)
	ALL_COUNT = arrParams(Ubound(arrParams)-1)(4)

	MAX_NUM = MAX_NUM + PAGESIZE

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(MAX_NUM) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = MAX_NUM
	Else
		CNT = MAX_NUM - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If



	Dim thisArray(100)
	If IsArray(arrList) Then
		For i = 0 To listLen
			ArrayNum = arrList(0,i)

			If PAGE > 1 Then
				ArrayNum = arrList(0,i) - ((PAGE-1) * PAGESIZE)
			End If

			'PRINT ArrayNUM
			thisArray(ArrayNum) = arrList(0,i)
		Next
	End If

	'print thisArray(100)



%>
<style>
	td {border:1px solid #ccc; height:40px; text-align:center;}
</style>
</head>
<body>
<div class="top"><%=viewImg(IMG_POP&"/pop_CSGoodsSearch.gif",250,40,"")%></div>

<div class="">총 상품갯수 : <%=(ALL_COUNT)%></div>
<div class="">
<table <%=tableatt%> class="width100">
	<col span="10" width="10%" />
	<%
		For rows = 0 To 9
			PRINT "<tr>"
			For cols = 1 To 10
				viewNumber = ((PAGE-1)*100) + (rows*10) + cols

				ArrayNumber = (rows*10) + cols
				If thisArray(ArrayNumber) <> "" Then
					ThisClass = " style=""background-color:#d7d7d7"""
				Else
					ThisClass = " style=""background-color:#fff"""
				End If
				PRINT "<td "&ThisClass&">"&viewNumber&"</td>"
			Next
			PRINT "</tr>"
		Next
	%>

</table>
<%Call pageList(PAGE,PAGECOUNT)%>

<form name="frm" method="post" action="">
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
</form>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>


</body>
</html>
