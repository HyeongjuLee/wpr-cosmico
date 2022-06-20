<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"

	arrParams = Array(_
		Db.makeParam("@strSitePK",adVarChar,adParamInput,30,DK_SITE_PK) _
	)
	Set DKRS = Db.execRs("DKP_CONF_SITEPK",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX        	= DKRS("intIDX")
		DKRS_strSitePK     	= DKRS("strSitePK")
		DKRS_strSiteTitle  	= DKRS("strSiteTitle")
		DKRS_mapAPI        	= DKRS("mapAPI")
		DKRS_intAdminLevel 	= DKRS("intAdminLevel")
		DKRS_strSiteType   	= DKRS("strSiteType")
		DKRS_PGIDS         	= DKRS("PGIDS")
		DKRS_PGCOMPANY     	= DKRS("PGCOMPANY")
		DKRS_PGPASSKEY     	= DKRS("PGPASSKEY")
		DKRS_PGMOD         	= DKRS("PGMOD")
		DKRS_PGJAVA        	= DKRS("PGJAVA")
		DKRS_isEncType     	= DKRS("isEncType")
		DKRS_strSiteEng    	= DKRS("strSiteEng")
		DKRS_strFavicon    	= DKRS("strFavicon")
	Else
		Call ALERTS("기본정책이 없습니다.","BACK","")
	End If





%>
<link rel="stylesheet" href="pgSetting.css" />
<script type="text/javascript" src="pgSetting.js"></script>

</head>
<body>
intIDX
strSitePK
isDel
strSiteTitle
mapAPI
intAdminLevel
strSiteType
PGIDS
PGCOMPANY
PGPASSKEY
PGMOD
PGJAVA
isEncType
strSiteEng
strFavicon


<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="pgSetting">
	<form name="colorFrm" action="pgSetting_Handler.asp" method="post" enctype="multipart/form-data" onsubmit="return thisForm(this);">
		<table <%=tableatt%> class="adminFullWidth list">
			<col width="250" />
			<col width="200" />
			<col width="200" />
			<col width="350" />
			<tr>
				<th>구분</th>
				<th>현재설정값</th>
				<th>변경설정값</th>
				<th>설명</th>
			</tr>
			<tr>
				<th colspan="4">사이트 기본 설정</th>
			</tr>
			<tr>
				<th>사이트명</th>
				<td><%=DKRS_strSiteTitle%></td>
				<td><input type="text"  name="strSiteTitle" value="<%=DKRS_strSiteTitle%>"class="input_text" style="width:140px;" /></td>
				<td></td>
			</tr><tr>
				<th>암호화</th>
				<td></td>
				<td></td>
				<td></td>
			</tr><tr>
				<th>파비콘</th>
				<td><%=DKRS_strFavicon%></td>
				<td><input type="file" name="strFavicon" class="input_text" style="width:140px;" /></td>
				<td>좌측메뉴컬러</td>
			</tr>

			<tr>
				<th colspan="4">2차 메뉴 기본 컬러</th>
			</tr><tr>
				<th>대메뉴컬러</th>
				<td><input type="color" id="overColor2d" name="overColor2d" value="<%=DKRS_OverColor2d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="outColor2d" name="outColor2d" value="<%=DKRS_OutColor2d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 대메뉴 컬러</td>
			</tr><tr>
				<th>서브메뉴컬러</th>
				<td><input type="color" id="soverColor2d" name="subOverColor2d" value="<%=DKRS_subOverColor2d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="soutColor2d" name="subOutColor2d" value="<%=DKRS_subOutColor2d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 서브메뉴컬러</td>
			</tr><tr>
				<th>레프트메뉴컬러</th>
				<td><input type="color" id="loverColor2d" name="leftOverColor2d" value="<%=DKRS_leftOverColor2d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="loutColor2d" name="leftOutColor2d" value="<%=DKRS_leftOutColor2d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>좌측메뉴컬러</td>
			</tr>

			<tr>
				<th colspan="4">3차 메뉴 기본 컬러</th>
			</tr><tr>
				<th>대메뉴컬러</th>
				<td><input type="color" id="overColor3d" name="overColor3d" value="<%=DKRS_OverColor3d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="outColor3d" name="outColor3d" value="<%=DKRS_OutColor3d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 대메뉴 컬러</td>
			</tr><tr>
				<th>서브메뉴컬러</th>
				<td><input type="color" id="soverColor3d" name="subOverColor3d" value="<%=DKRS_subOverColor3d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="soutColor3d" name="subOutColor3d" value="<%=DKRS_subOutColor3d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>상단 서브메뉴컬러</td>
			</tr><tr>
				<th>레프트메뉴컬러</th>
				<td><input type="color" id="loverColor3d" name="leftOverColor3d" value="<%=DKRS_leftOverColor3d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td><input type="color" id="loutColor3d" name="leftOutColor3d" value="<%=DKRS_leftOutColor3d%>"class="input_text color vmiddle" style="width:140px;" maxlength="6" data-hex="true" /></td>
				<td>좌측메뉴컬러</td>
			</tr><tr>
				<td colspan="4" align="center" style="padding:10px 0px;"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>
		</table>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
