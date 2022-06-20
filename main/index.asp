<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_MODE = "HOME"
	PAGE_SETTING = "INDEX"
	ISLEFT = "F"
	ISFULLPAGE = "T"
%>
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

'	CATEGORY		= gRequestTF("cate",True)

	pm = gRequestTF("pm",False)
	backUrl = gRequestTF("backUrl",False)

	If pm = "dv" And backUrl <> "" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If backUrl	<> "" Then backUrl	 = objEncrypter.Decrypt(backUrl)
		Set objEncrypter = Nothing

		Response.Redirect backUrl
		Response.End

	End If


	Dim tSEARCHTERM		:	tSEARCHTERM = pRequestTF("tSEARCHTERM",False)
	Dim tSEARCHSTR		:	tSEARCHSTR = pRequestTF("tSEARCHSTR",False)
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)

	If tSEARCHTERM = ""	Then tSEARCHTERM = "" End If
	If tSEARCHSTR = ""	Then tSEARCHSTR = "" End if

	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""

	If CATEGORY = "" Then CATEGORY = "101"


	PCONF_TOPCNT = 6 '페이지 사이즈에 맞춘 상품 나열 갯수 하단의 PCONF_LINECNT 의 제곱으로 나가야함
	PCONF_LINECNT = 3 '페이지 사이즈에 맞춘 상품 나열 갯수 (베스트, 추천, 새상품)

	' 총 WIDTH 값에서 상품갯수에 맞춰 LEFT-MARGIN 값 설정
	' 상품 넓이는 border 를 포함하여 2를 더해준다
	GoodsLeftMargin = Int((1200 - (278*PCONF_LINECNT)) / (PCONF_LINECNT-1))		'1200 - (35 * 2)

	'print GoodsLeftMargin

	'상품 리스트 표기
	PCONF_isNOTS = "F"
	PCONF_isAUTH = "F"
	PCONF_isDEAL = "F"
	PCONF_isVIPS = "F"
	PCONF_isALLS = "F"

	Select Case DK_MEMBER_LEVEL
		Case 0,1		: PCONF_isNOTS = "T"
		Case 2			: PCONF_isAUTH = "T"
		Case 3			: PCONF_isDEAL = "T"
		Case 4,5		: PCONF_isVIPS = "T"
		Case 9,10,11	: PCONF_isALLS = "T"
	End Select

%>

<!--#include virtual = "/_include/document.asp"-->
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual="/popup.asp" -->
<script type="text/javascript" src="/jscript/jcarousellite_1.0.1.min.js"></script>
<script type="text/javascript" src="/jscript/jquery-ui.min_custom_draggable.js"></script>
<style type="text/css">
	#bottom_wrap {margin: 0;}
</style>
</head>
<body>
<!--#include virtual="/popupLayer.asp" -->

<div id="indexWrap" class="layout_wrap">
	<div id="mainVisual_Wrap" class="layout_wrap">
		<div id="mainVisual" class="layout_inner">
			<div id="mainVisual_a" class="mainVisual_a">
				<ul class="visual_img">
					<%
						arrParams = Array(_
							Db.makeParam("@TOPCNT",adInteger,adParamInput,4,4), _
							Db.makeParam("@strArea",adVarChar,adParamInput,20,"n01_a01"), _
							Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
						)
						arrList = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParams,listLen,Nothing)
						If IsArray(arrList) Then
							totalRowCnt = listLen + 1
							For i = 0 To listLen
								arrList_intIDX          = arrList(0,i)
								arrList_strArea         = arrList(1,i)
								arrList_intSort         = arrList(2,i)
								arrList_isUse           = arrList(3,i)
								arrList_isDel           = arrList(4,i)
								arrList_strTitle        = arrList(5,i)
								arrList_isLink          = arrList(6,i)
								arrList_isLinkTarget    = arrList(7,i)
								arrList_strLink         = BACKWORD(arrList(8,i))
								arrList_strImg          = BACKWORD(arrList(9,i))
								arrList_regDate         = arrList(10,i)
								arrList_regID           = arrList(11,i)
								arrList_regIP			= arrList(12,i)

								Select Case arrList_isLinkTarget
									Case "S" : targets = "target=""_self"""
									Case "B" : targets = "target=""_blank"""
								End Select
								If arrList_isLink = "T" Then
									linkF = "<a href="""&arrList_strLink&""" "&targets&" class=""btn01"">"
									linkL = "</a>"
								Else
									linkF = ""
									linkL = ""
								End If

					%>
					<li><%=linkF%><img src="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" alt="" /><%=linkL%></li>
					<%
								listLenCNT = listLen

								If i = 0 Then arr_TITLE01 = arrList_strTitle
								If i = 1 Then arr_TITLE02 = arrList_strTitle
								If i = 2 Then arr_TITLE03 = arrList_strTitle
								If i = 3 Then arr_TITLE04 = arrList_strTitle
							Next
						End If
					%>
				</ul>
				<!-- <span class="visual_dir visual_prev"><img src="/images/index/prev.png" alt="" /></span>
				<span class="visual_dir visual_next"><img src="/images/index/next.png" alt="" /></span> -->

				<div id="visual_menu">
					<ul class="visual_menu">
						<%
							For i = 0 To listLen
								PRINT "<li></li>"
							Next
						%>
					</ul>
				</div>

				<script type="text/javascript">
					$('#mainVisual_a').DB_tabArrowSlideMove({
						motionType:'fade',			//모션타입('none','x','y','fade')
						motionSpeed:300,
						autoRollingTime:5000,	//자동롤링속도(밀리초)
						menuVisible:true		//메뉴보이기(true,false)
					})
				</script>
			</div>
		</div>
	</div><!--mainVisual_Wrap E-->

	<div id="index_btn" class="layout_wrap">
		<ul class="layout_inner">
			<li class="index_btn"><a href="/page/company.asp?view=1">
				<span class="img"><i></i><img src="/images/index/index_btn01.jpg" alt="" /></span>
				<span class="tit"><%=LNG_INDEX_BTN_01%></span>
				<span class="txt"><%=LNG_INDEX_BTN_02%></span>
				<div><i></i><span><%=LNG_INDEX_BTN_03%></span></div>
			</a></li>
			<li class="index_notice">
				<div class="inner">
					<% 

						'공지사항 게시판 불러오기
						arrParams = Array( _
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,"notice"), _
							Db.makeParam("@intCate",adInteger,adParamInput,0,intCate), _
							Db.makeParam("@strBoardType",adVarChar,adParamInput,10,"board"), _
							Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,""), _
							Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,""), _
							Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,3), _
							Db.makeParam("@PAGE",adInteger,adParamInput,0,1), _
							Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(LANG)), _
							Db.makeParam("@All_Count",adInteger,adParamOutPut,0,0) _
						)

						arrList = Db.execRsList("DKP_NBOARD_BOARD_LIST_ORDER1",DB_PROC,arrParams,listLen,Nothing)

						If IsArray(arrList) Then
							
							For i = 0 To listLen
								PRINT "	<dl>"
								PRINT "		<a href=""/cboard/board_view.asp?bname=notice&amp;num="&arrList(1, i)&""">"
								PRINT "		<dt>"
								PRINT "			<span class=""tit"">"&right(Left(arrList(8, i), 10), 2)&"</span>"	'일자
								PRINT "			<span class=""txt"">"&Left(arrList(8, i), 7)&"</span>"				'년-월
								PRINT "			<i></i>"
								PRINT "		</dt>"
								PRINT "		<dd>"
								PRINT "			<span class=""tit"">"&arrList(11, i)&"</span>"	'타이틀
								'PRINT "			<span class=""txt"">"&arrList(12, i)&"</span>"	'내용
								PRINT "			<span class=""txt"">&nbsp;</span>"	'내용
								PRINT "		</dd>"
								PRINT "		</a>"
								PRINT "	</dl>"
							Next
						Else
					%>

					<table>
						<tr>
							<td><%=LNG_LEFT_TEXT18%></td>
						</tr>
					</table>
						
					<%
						End If
					%>
				</div>
			</li>
		</ul>
	</div>

	<div id="index_visual" class="layout_wrap">
		<div class="layout_inner">
			<div id="indexVisual_Wrap" class="layout_wrap">
				<div id="indexVisual" class="layout_inner">
					<div id="indexVisual_a" class="indexVisual_a">
						<ul class="visual_img">
							<%
								arrParams = Array(_
									Db.makeParam("@TOPCNT",adInteger,adParamInput,4,3), _
									Db.makeParam("@strArea",adVarChar,adParamInput,20,"n03_a01"), _
									Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
								)
								arrList = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_TOP",DB_PROC,arrParams,listLen,Nothing)
								If IsArray(arrList) Then
									
									li_Html = ""

									For i = 0 To listLen
										arrList_intIDX          = arrList(0,i)
										arrList_strArea         = arrList(1,i)
										arrList_intSort         = arrList(2,i)
										arrList_isUse           = arrList(3,i)
										arrList_isDel           = arrList(4,i)
										arrList_strTitle        = arrList(5,i)
										arrList_isLink          = arrList(6,i)
										arrList_isLinkTarget    = arrList(7,i)
										arrList_strLink         = BACKWORD(arrList(8,i))
										arrList_strImg          = BACKWORD(arrList(9,i))
										arrList_regDate         = arrList(10,i)
										arrList_regID           = arrList(11,i)
										arrList_regIP			= arrList(12,i)
										arrList_strSubtitle		= arrList(15,i)
										arrList_strScontent		= arrList(16,i)

										Select Case arrList_isLinkTarget
											Case "S" : targets = "target=""_self"""
											Case "B" : targets = "target=""_blank"""
										End Select
										If arrList_isLink = "T" Then
											linkF = "<a href="""&arrList_strLink&""" "&targets&" class=""btn01"">"
											linkL = "</a>"
										Else
											linkF = ""
											linkL = ""
										End If

										PRINT "	<li>"
										PRINT "		<span class=""line""><i></i></span>"
										PRINT "		<div class=""left"">"
										PRINT "			<span class=""tit"">"&arrList_strTitle&"</span>"
										PRINT "			<span class=""stit"">"&arrList_strSubtitle&"</span>"
										PRINT "			<span class=""txt"">"&arrList_strScontent&"</span>"
										If linkF <> "" Then 
										PRINT "			<div>"&linkF&"<i></i><span>"&LNG_INDEX_BTN_03&"</span>"&linkL&"</div>"
										End If
										PRINT "		</div>"
										PRINT "		<div class=""right"">"&linkF&"<img src="""&VIR_PATH("shop_design_Banner_T")&"/"&arrList_strImg&""" alt="""" />"&linkL&"</div>"
										PRINT "	</li>"

										If i = 0 Then
											li_Html = li_Html & "<li class=""DB_select""></li>"
										Else
											li_Html = li_Html & "<li></li>"
										End If
										
									Next
								End If
							%>
							<!--
							<li>
								<span class="line"><i></i></span>
								<div class="left">
									<span class="tit">닥터제이겔 씨놀Q</span>
									<span class="stit">하루 한포로 내 건강을 지킨다</span>
									<span class="txt">체력이 떨어진다는 생각이 들 때가 있습니다.<br />쳇바퀴 돌듯 사는 바쁜 일상에 몸과 마음이 지칠 때가 많습니다.<br />젊고 건강하게 활기찬 생활을 할 수 있도록 닥터제이겔 씨놀Q와<br />함께 하세요.</span>
									<div><a href="#"><i></i><span><%=LNG_INDEX_BTN_03%></span></a></div>
								</div>
								<div class="right"><a href="#;"><img src="<%=IMG_INDEX%>/index_visual01.jpg" alt="" /></a></div>
							</li>
							<li>
								<span class="line"><i></i></span>
								<div class="left">
									<span class="tit">닥터제이겔 씨놀Q</span>
									<span class="stit">하루 한포로 내 건강을 지킨다</span>
									<span class="txt">체력이 떨어진다는 생각이 들 때가 있습니다.<br />쳇바퀴 돌듯 사는 바쁜 일상에 몸과 마음이 지칠 때가 많습니다.<br />젊고 건강하게 활기찬 생활을 할 수 있도록 닥터제이겔 씨놀Q와<br />함께 하세요.</span>
									<div><a href="#"><i></i><span><%=LNG_INDEX_BTN_03%></span></a></div>
								</div>
								<div class="right"><a href="#;"><img src="<%=IMG_INDEX%>/index_visual01.jpg" alt="" /></a></div>
							</li>
							-->
						</ul>
						
						<div id="visual_menu">
							<ul class="visual_menu">
								<i></i>
							</ul>
						</div>

						<script type="text/javascript">
							$('#indexVisual_a').DB_tabArrowSlideMove({
								motionType:'fade',			//모션타입('none','x','y','fade')
								motionSpeed:300,
								autoRollingTime:5000,	//자동롤링속도(밀리초)
								menuVisible:true		//메뉴보이기(true,false)
							})
						</script>
					</div>
				</div>
			</div><!--mainVisual_Wrap E-->
		</div>
	</div>

	<div id="index_bn" class="layout_wrap">
		<div class="layout_inner">
			<ul>
				<li>
					<a href="/page/company.asp?view=2">
						<span><img src="/images/index/index_bn02.jpg" alt="" /></span>
						<dl>
							<dt><%=LNG_INDEX_BN_03%></dt>
							<dd><%=LNG_INDEX_BN_04%></dd>
							<em><i></i></em>
						</dl>
					</a>
				</li>
				<li>
					<a href="/page/business.asp?view=1">
						<span><img src="/images/index/index_bn01.jpg" alt="" /></span>
						<dl>
							<dt><%=LNG_INDEX_BN_01%></dt>
							<dd><%=LNG_INDEX_BN_02%></dd>
							<em><i></i></em>
						</dl>
					</a>
				</li>
				<li>
					<a href="/cboard/board_list.asp?bname=notice">
						<span><img src="/images/index/index_bn03.jpg" alt="" /></span>
						<dl>
							<dt><%=LNG_INDEX_BN_05%></dt>
							<dd><%=LNG_INDEX_BN_06%></dd>
							<em><i></i></em>
						</dl>
					</a>
				</li>
			</ul>
		</div>
	</div>

</div>

<!--#include virtual = "/_include/copyright.asp"-->
