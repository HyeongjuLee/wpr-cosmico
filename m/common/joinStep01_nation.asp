<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"

	Response.Redirect "/m/common/joinStep_n02_g.asp"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	If Not checkRef(houUrl &"/m/common/joinStep01.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/m/common/joinStep01.asp")


	joinStep02_c = "joinStep01_nation.asp"

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/js/ajax.js"></script>
<!-- <script type="text/javascript" src="joinStep_01.js"></script> -->
<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="joinStep.css" />
<link rel="stylesheet" href="/css/nation.css" />
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_SUBTITLE_SELECT_NATION%></div>
<div id="joinStep01_Zone width100">
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
								joinStep02_c = "joinStep02_u.asp"
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
<!--#include virtual = "/m/_include/copyright.asp"-->