<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	ADMIN_LEFT_MODE = "MENU1"
	INFO_MODE = "MENU1-1-2"
	Call ONLY_CS_MEMBER()


	OrderNumber = gRequestTF("on",True)
'	print OrderNumber
	'SQL = "SELECT * FROM DK_MEMBER A,DK_MEMBER_FINANCIAL B WHERE a.STRUSERID = b.STRUSERID AND a.strUserID = ?"
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@OrderNumber",adVarChar,adParamInput,50,OrderNumber) _
	)
	Set DKRS = Db.execRs("DKP_ORDER_PRINT",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_M_name				= DKRS("M_name")
		DKRS_mbid				= DKRS("mbid")
		DKRS_mbid2				= DKRS("mbid2")
		DKRS_cpno				= DKRS("cpno")
		DKRS_hptel				= DKRS("hptel")
		DKRS_OrderNumber		= DKRS("OrderNumber")
		DKRS_ncode				= DKRS("ncode")
		DKRS_name				= DKRS("name")
		DKRS_ItemCount			= DKRS("ItemCount")
		DKRS_ItemPrice			= DKRS("ItemPrice")
		DKRS_ItemPv				= DKRS("ItemPv")
		DKRS_etc1				= DKRS("etc1")
		DKRS_etc2				= DKRS("etc2")
		DKRS_Addcode1			= DKRS("Addcode1")
		DKRS_Address1			= DKRS("Address1")
		DKRS_Address2			= DKRS("Address2")
		DKRS_Get_Name1			= DKRS("Get_Name1")
		DKRS_Get_ZipCode		= DKRS("Get_ZipCode")
		DKRS_Get_Address1		= DKRS("Get_Address1")
		DKRS_Get_Address2		= DKRS("Get_Address2")
		DKRS_Get_Tel1			= DKRS("Get_Tel1")
		DKRS_Get_Tel2			= DKRS("Get_Tel2")
		DKRS_SellDate			= DKRS("SellDate")



	Else
		Call ALERTS("주문정보가 로드되지 못했습니다. 배송지 정보가 누락되었을 수 있습니다.","close","")
	End If
	Call closeRS(DKRS)

'onload="printPage();"


%>
<!--#include virtual = "/_include/document.asp"-->
<script language="javascript">

function printPage() {
	factory.printing.header = "";     //헤더 정보
	factory.printing.footer = "";     //푸더 정보
	factory.printing.portrait = true;    //false : 가로출력, true : 세로 출력
	factory.printing.leftMargin = 12.0;
	factory.printing.topMargin = 12.0;
	factory.printing.rightMargin = 12.0;
	factory.printing.bottomMargin = 12.0;
	//factory.printing.SetMarginMeasure(2);   //테두리 여백 사이즈 단위를 인치로 설정
	//factory.printing.printer = "";    //프린터명
	//factory.printing.paperSize = "A4";   //종이 사이즈
	//factory.printing.paperSource = "Manual feed"; //종이 Fedd 방식
	//factory.printing.collate = true;    //순서대로 출력하기
	//factory.printing.copies = "2";    //인쇄할 매수
	//factory.printing.SetPageRange(false, 1, 3); //true 로 설정하고 1,3 이면 1에서 3페이지까지 출력
	//factory.printing.Printing(true);    //바로 출력하기
	factory.printing.Print(false, window);   //false : 프린트 대화창 안열기, true : 대화창 열기
}

</script>
<style>
	#letter {font-family:dotum;position:absolute;}
	#letter td {border:1px solid #777; text-align:center;font-size:16px; padding:4px 0px;}
	#letter td.th {background-color:#d3d3d3; font-weight:bold; }
	.po_ab {position:absolute;}
	.fon1 {font-family:malgun gothic;font-size:16pt;font-weight:bold; color:#000;}
	.fon2 {font-family:malgun gothic;font-size:14pt;font-weight:bold; color:#000;}
</style>
</head>
<body >
<%
%>
<object id="factory" style="display:none;" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=7,0,0,8"></object>

<div style="page-break-before:always;width:1000px;">
	<div class="po_ab fon1" style="margin:170px 0px 0px 250px;"><%=DKRS_M_name%></div>
	<div class="po_ab fon1" style="margin:170px 0px 0px 750px;"><%=DKRS_mbid%></div>
	<div class="po_ab fon1" style="margin:170px 0px 0px 800px;">-</div>
	<div class="po_ab fon1" style="margin:170px 0px 0px 840px;"><%=DKRS_mbid2%></div>
	<div class="po_ab fon1" style="margin:210px 0px 0px 240px; letter-spacing:14px;"><%=Left(DKRS_cpno,6)%></div>
	<div class="po_ab fon1" style="margin:210px 0px 0px 425px; letter-spacing:14px;"><%=Right(DKRS_cpno,7)%></div>
	<div class="po_ab fon1" style="margin:210px 0px 0px 750px;"><%=DKRS_hptel%></div>
	<div class="po_ab fon2" style="margin:257px 0px 0px 240px;">(<%=Left(DKRS_Addcode1,3)%>-<%=Right(DKRS_Addcode1,3)%>) <%=DKRS_Address1%> <%=DKRS_Address2%></div>

	<div class="po_ab fon2" style="margin:325px 0px 0px 330px;">(<%=DKRS_Get_ZipCode%>) <%=DKRS_Get_Address1%> <%=DKRS_Get_Address2%></div>
	<div class="po_ab fon1" style="margin:375px 0px 0px 330px;"><%=DKRS_Get_Tel1%></div>
	<div class="po_ab fon1" style="margin:375px 0px 0px 585px;"><%=DKRS_Get_Tel2%></div>
	<div class="po_ab fon2" style="margin:375px 0px 0px 830px;"><%=DKRS_M_name%></div>

	<div class="po_ab fon2" style="margin:506px 0px 0px 110px;"><%=DKRS_ncode%></div>
	<div class="po_ab fon2" style="margin:506px 0px 0px 234px;"><%=DKRS_name%></div>
	<div class="po_ab fon2" style="margin:506px 0px 0px 430px;"><%=DKRS_ItemCount%></div>
	<div class="po_ab fon2" style="margin:506px 0px 0px 510px;"><%=num2cur(DKRS_ItemPrice)%></div>
	<div class="po_ab fon2" style="margin:506px 0px 0px 630px;"><%=num2cur(DKRS_ItemPrice*DKRS_ItemCount)%></div>
	<div class="po_ab fon2" style="margin:506px 0px 0px 755px;"><%=num2cur(DKRS_ItemPv)%></div>
	<div class="po_ab fon2" style="margin:506px 0px 0px 855px;"><%=num2cur(DKRS_ItemPv*DKRS_ItemCount)%></div>

	<div class="po_ab fon2" style="width:800px; height:200px;padding:20px 0px 0px 20px; margin:550px 0px 0px 100px; background-color:#fff;">
		<div class=" fon2">주문번호 : <%=DKRS_OrderNumber%></div>
		<div class=" fon2"><%=DKRS_etc2%></div>
		<div class=" fon2">기타사항 : <%=DKRS_etc1%></div>
	</div>
	<div class="po_ab fon1" style="margin:1165px 0px 0px 220px;"><%=Left(DKRS_SellDate,4)%></div>
	<div class="po_ab fon1" style="margin:1165px 0px 0px 330px;"><%=Mid(DKRS_SellDate,5,2)%></div>
	<div class="po_ab fon1" style="margin:1165px 0px 0px 400px;"><%=Right(DKRS_SellDate,2)%></div>
	<div class="po_ab fon2" style="margin:1200px 0px 0px 720px; background-color:#fff;"><%=viewImg("/stamp.png",90,90,"")%></div>
<img src="/6.png" width="1000" height="1415" alt="" />
</div>
<div style="page-break-before:always;width:1000px;">
<div class="po_ab" style=""></div>
<img src="/7.png" width="1000" height="1415" alt="" />
</div>
</body>
</html>
DKRS_OrderNumber
DKRS_ncode
DKRS_name
DKRS_ItemCount
DKRS_ItemPrice
DKRS_ItemPv
DKRS_etc1

