<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	intIDX			= pRequestTF("intIDX",True)
	intSort			= pRequestTF("intSort",True)
	SEARCHTERM		= pRequestTF("SEARCHTERM",False)
	SEARCHSTR		= pRequestTF("SEARCHSTR",False)
	PAGESIZE		= pRequestTF("PAGESIZE",False)
	PAGE			= pRequestTF("PAGE",False)
	ORDERS			= pRequestTF("ORDERS",False)

	cate1			= pRequestTF("cate1",False)
	cate2			= pRequestTF("cate2",False)
	cate3			= pRequestTF("cate3",False)

	isVIEWYN		= pRequestTF("isVIEWYN",False)
	isSOLDOUT		= pRequestTF("isSOLDOUT",False)
	minPrice		= pRequestTF("minPrice",False)
	maxPrice		= pRequestTF("maxPrice",False)

	strNationCode	= pRequestTF("strNationCode",False)


'Call ResRW(intIDX,"intIDX")
'Call ResRW(intSort,"intSort")
'Call ResRW(strNationCode,"strNationCode")

	arrParams = Array(_
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX),_
		Db.makeParam("@intSort",adInteger,adParamInput,4,intSort),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _

	)
	Call Db.exec("DKSP_GOODS_ORDER_CHG_ADMIN",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)







%>
</head>
<body>

<%Select Case OUTPUT_VALUE%>
<%Case "FINISH"%>
	<script type="text/javascript">
		$(document).ready(function() {
			document.frm.submit();
		});
	</script>
	<form name="frm" method="post" action="goods_list_sort.asp?nc=<%=strNationCode%>">
		<input type="hidden" name="intIDX" value="" />
		<input type="hidden" name="intSort" value="" />
		<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />

		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="ORDERS" value="<%=ORDERS%>" />

		<input type="hidden" name="cate1" value="<%=CATEGORYS1%>" />
		<input type="hidden" name="cate2" value="<%=CATEGORYS2%>" />
		<input type="hidden" name="cate3" value="<%=CATEGORYS3%>" />

		<input type="hidden" name="isVIEWYN" value="<%=isVIEWYN%>" />
		<input type="hidden" name="isSOLDOUT" value="<%=isSOLDOUT%>" />
		<input type="hidden" name="minPrice" value="<%=minPrice%>" />
		<input type="hidden" name="maxPrice" value="<%=maxPrice%>" />
	</form>
<%
	Case "LENGTHOUT"
		Call ALERTS("최대값을 벗어난 값을 지정했습니다","BACK","")
	Case Else
		Call ALERTS("변경프로세스중 문제가 발생하였습니다. 데이터 베이스를 롤백합니다.","BACK","")
	End Select
%>
</body>
</html>