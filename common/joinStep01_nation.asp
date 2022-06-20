<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->

<%

	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	Response.Redirect "/common/joinStep_n02_g.asp"


	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MEMBERSHIP"
		ptshop = "?pt=shop"
	Else
		PAGE_SETTING = "MEMBERSHIP"
		ptshop = ""
	End If

	'PAGE_SETTING = "MEMBERSHIP"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 1
	sview = 7

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	If Not checkRef(houUrl &"/common/joinStep01.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/common/joinStep01.asp")

%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="/css/nation.css" />
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->
<!-- <div id="joinStep" class="">
	<div class="title_area">
		<p class="c_b_title tweight" style=""><%=LNG_SUBTITLE_SELECT_NATION%></p>
		<p class="c_s_title tweight" style=""><%=LNG_SUBTITLE_SELECT_NATION_STITLE%></p>
	</div>
</div> -->
<div id="member_join">
	<!-- <div class="area01">
		<p><%=viewImg(IMG_JOIN&"/tit_member_join.gif",275,45,"")%></p>
		<p class="timeline"><%=viewImg(IMG_JOIN&"/step_01.gif",770,65,"")%></p>
		<p class="timeline"><%=viewImg(IMG_JOIN&"/step01_e.jpg",770,50,"")%></p>
	</div> -->
	<!-- <div class="tit_area"><%=viewImg(IMG_JOIN&"/join_tit_01_01.gif",606,30,"")%></div> -->
	<div class="clear">
		<div id="nation">
			<%
				If UCase(Lang) = "KR" Then
					SQL = "SELECT * FROM [DK_NATION] WHERE [isUse] = 'T' AND [devViewChk] = 'T' AND [Using] = 1 AND [nationCode] = 'KR' "
					'SQL = "SELECT * FROM [DK_NATION] WHERE [isUse] = 'T' AND [devViewChk] = 'T' AND [Using] = 1 "
				Else
					SQL = "SELECT * FROM [DK_NATION] WHERE [isUse] = 'T' AND [devViewChk] = 'T' AND [Using] = 1 AND [nationCode] <> 'KR' "		'외국사이트 한국가입제외
				End If
				arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
				If IsArray(arrLisT) Then
					PrevFirstName = "A"
					For i = 0 To listLen

						arr_intIDX			= arrList(0,i)
						arr_nationNameKo	= arrList(1,i)
						arr_nationNameEn	= arrList(2,i)
						arr_nationCode		= arrList(3,i)
						arr_isUse			= arrList(4,i)
						arr_className		= arrList(5,i)

						thisFirstName = Left(arr_nationNameEn,1)
						If thisFirstName <> PrevFirstName Then
							If i = 0 Then
								PRINT TABS(1)& "	<div class=""Wraps""><ul>"
							Else
								PRINT TABS(1)& "	</ul></div><div class=""Wraps""><ul class=""ss"">"
							End If

							If UCase(arr_nationCode) ="KR" Then
								joinStep02_c = "joinStep02_c.asp"
							Else
								'joinStep02_c = "joinStep02_u.asp"
								joinStep02_c = "joinStep03_u.asp"		'▣더화이트요청:약관동의삭제(2016-05-18)
							End If
			%>

				<li class="lineTop">Country Code Initial <span class="nhighlight">" <%=thisFirstName%> "</span> Group</li>
			<%
						End If
			%>
			<li class="li_list"><span class="nat <%=arr_className%>"></span>&nbsp;<a href="<%=joinStep02_c%>?cnd=<%=arr_nationCode%>"><span class="ncd">[<%=arr_nationCode%>]</span>&nbsp;<%=arr_nationNameEn%>&nbsp;<span style="color:#838383;">(<%=arr_nationNameKo%>)</span></a></li>
			<%
						PrevFirstName = Left(arr_nationNameEn,1)
					Next
				Else
					PRINT "Sorry. There is no registered contry code."
				End If
			%>
			</ul></div>
		</div>
	</div>
</div>
<!--#include virtual="/_include/copyright.asp" -->
