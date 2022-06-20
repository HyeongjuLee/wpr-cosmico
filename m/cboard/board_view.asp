<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	strBoardName = gRequestTF("bname",True)
	intIDX = gRequestTF("num",True)
	gCate = gRequestTF("cate",False)
	ContentPass = pRequestTF("strPass",False)

%>
<!--#include file="board_config.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->
<%

	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)
	Set DKRS = Db.execRs("DKPA_FORUM_CONFIG_READ",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		intEmailLevel		= DKRS("intEmailLevel")
		intMobileLevel		= DKRS("intMobileLevel")
		intTelLevel			= DKRS("intTelLevel")
		intData1Level		= DKRS("intData1Level")
		intData2Level		= DKRS("intData2Level")
		intData3Level		= DKRS("intData3Level")
		intLinkLevel		= DKRS("intLinkLevel")

		isEmail				= DKRS("isEmail")
		isMobile			= DKRS("isMobile")
		isTel				= DKRS("isTel")
		isData1				= DKRS("isData1")
		isData2				= DKRS("isData2")
		isData3				= DKRS("isData3")
		isLink				= DKRS("isLink")
	Else
		Call ALERTS(LNG_BOARD_VIEW_TEXT06,"back","")
	End If
	Call closeRS(DKRS)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKP_NBOARD_VIEW",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		intCate				= DKRS("intCate")
		intNum				= DKRS("intNum")
		intList				= DKRS("intList")
		intDepth			= DKRS("intDepth")
		intRIDX				= DKRS("intRIDX")
		strDomain			= DKRS("strDomain")
		strUserID			= DKRS("strUserID")
		strName				= DKRS("strName")
		regDate				= DKRS("regDate")
		readCnt				= DKRS("readCnt")
		strSubject			= DKRS("strSubject")
		strContent			= DKRS("strContent")
		strEmail			= DKRS("strEmail")
		strTel				= DKRS("strTel")
		strMobile			= DKRS("strMobile")
		strPass				= DKRS("strPass")
		isSecret			= DKRS("isSecret")
		strPic				= DKRS("strPic")
		strData1			= DKRS("strData1")
		strData2			= DKRS("strData2")
		strData3			= DKRS("strData3")
		strLink				= DKRS("strLink")
		strMovie			= DKRS("strMovie")
		editDate			= DKRS("editDate")
		REPLYCNT			= DKRS("REPLYCNT")
		HostIP				= DKRS("HostIP")
		strPass2			= DKRS("strPass2")
		'이미지 1,2,3 추가
		strPic1				= DKRS("strPic1")
		strPic2				= DKRS("strPic2")
		strPic3				= DKRS("strPic3")

		movieType			= DKRS("movieType")		'추가
		movieURL			= DKRS("movieURL")		'추가

	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRS(DKRS)

	Select Case DK_MEMBER_TYPE
		Case "MEMBER","COMPANY"
			If DK_MEMBER_LEVEL < intLevelView Then
				Call ALERTS(LNG_BOARD_LIST_TEXT01,"back","")
			Else
				If isSecret = "T" Then
					arrParams = Array(_
						Db.makeParam("@intList",adInteger,adParamInput,0,intList), _
						Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
					)
					WRITEIDCNT = Db.execRsData("DKP_NBOARD_VIEW_MEMBERS",DB_PROC,arrParams,Nothing)
					If WRITEIDCNT < 1 Then
						Call ALERTS(LNG_BOARD_VIEW_TEXT09,"back","")
					End If
				End If
			End If
		Case "GUEST"
			If DK_MEMBER_LEVEL < intLevelView Then
			'	Call ALERTS("게시판보기 권한이 없습니다. 관리자에게 문의해주세요.","back","")
				'Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1) '고객지원-회사소식, 자료실-상품교육자료실 : 회원공개
				Call CONFIRM(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT05,"go_back","/m/common/member_login.asp?backURL="&Replace(ThisPageURL,"&","§")&"","")
			Else
				If isSecret = "T" Then
					If ContentPass = "" Then Call ALERTS(LNG_BOARD_VIEW_TEXT10,"BACK","")
					If ContentPass <> strPass2 Then Call ALERTS(LNG_BOARD_VIEW_TEXT11,"BACK","")
				End If
			End If
		Case "ADMIN","OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelView Then
					Call ALERTS(LNG_BOARD_VIEW_TEXT08,"back","")
				Else
					If isSecret = "T" Then
						arrParams = Array(_
							Db.makeParam("@intList",adInteger,adParamInput,0,intList), _
							Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
						)
						WRITEIDCNT = Db.execRsData("DKP_NBOARD_VIEW_MEMBERS",DB_PROC,arrParams,Nothing)
						If WRITEIDCNT < 1 Then
							Call ALERTS(LNG_BOARD_VIEW_TEXT09,"back","")
						End If
					End If
				End If
			End If
	End Select


	'■QnA 본인 작성글만 확인
	If strBoardName = "qna" And UCase(DK_MEMBER_TYPE) <> "ADMIN" Then

		SQL_OR = "SELECT [strUserID] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [intDepth] = 0 AND [intList] = ?"
		arrParams_OR = Array(_
			Db.makeParam("@intList",adInteger,adParamInput,4,intList)_
		)
		ORI_WRITE_MEMBER_ID = Db.execRsData(SQL_OR,DB_TEXT,arrParams_OR,Nothing)

		IF ORI_WRITE_MEMBER_ID <> DK_MEMBER_ID Then  Call ALERTS("본인이 작성한 글만 확인할 수 있습니다.","BACK","")
	End If


	arrParams4 = Array(_
		Db.makeParam("@strMatchingID",adVarChar,adParamInput,100,strName) _
	)
	WriterImg = Db.execRsData("DKP_NBOARD_WRITER_IMG",DB_PROC,arrParams4,Nothing)

	If WriterImg = "" Or IsNull(WriterImg) Then
		Writer = strName
	Else
		imgPath = VIR_PATH("matching")&"/"&WriterImg
		imgWidth = 0
		imgHeight = 0
		Call ImgInfo(imgPath,imgWidth,imgHeight,"")
		Writer = viewImgOpt(imgPath,imgWidth,imgHeight,"","")
	End If

	If gCate <> "" Then getCate = "&amp;cate="&intCate



		printData1 = ""
		If strData1 <> "" And DK_MEMBER_LEVEL >= intData1Level Then
			strDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/data1")&"\"&strData1) / 1024)
			printData1 = printData1&tabs(2)&"<tr>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<th>"&LNG_TEXT_FILE1&"</th>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<td colspan=""2""><a href=""javascript:fTrans('"&FN_HR_ENC(strData1)&"','"&FN_HR_ENC("down1")&"');"">"&strData1&"</a>&nbsp;("&strDataSize1&" KB)</td>"
			printData1 = printData1&tabs(2)&"</tr>" &VbCrlf
		End If

		printData2 = ""
		If strData2 <>"" And DK_MEMBER_LEVEL >= intData2Level Then
			strDataSize2 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/data2")&"\"&strData2) / 1024)
			printData2 = printData2&tabs(2)&"<tr>" &VbCrlf
			printData2 = printData2&tabs(2)&"	<th>"&LNG_TEXT_FILE2&"</th>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<td colspan=""2""><a href=""javascript:fTrans('"&FN_HR_ENC(strData2)&"','"&FN_HR_ENC("down2")&"');"">"&strData1&"</a>&nbsp;("&strDataSize1&" KB)</td>"
			printData2 = printData2&tabs(2)&"</tr>" &VbCrlf
		End If


		printData3 = ""
		If strData3 <>"" And DK_MEMBER_LEVEL >= intData3Level Then
			strDataSize3 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/data3")&"\"&strData3) / 1024)
			printData3 = printData3&tabs(2)&"<tr>" &VbCrlf
			printData3 = printData3&tabs(2)&"	<th>"&LNG_TEXT_FILE3&"</th>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<td colspan=""2""><a href=""javascript:fTrans('"&FN_HR_ENC(strData3)&"','"&FN_HR_ENC("down3")&"');"">"&strData1&"</a>&nbsp;("&strDataSize1&" KB)</td>"
			printData3 = printData3&tabs(2)&"</tr>" &VbCrlf
		End If


%>
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<%
	Select Case DK_MEMBER_TYPE
		Case "MEMBER","COMPANY"
			If DK_MEMBER_LEVEL < intLevelView Then
				Call ALERTS(LNG_BOARD_LIST_TEXT01,"back","")
			Else
				If isSecret = "T" Then
					arrParams = Array(_
						Db.makeParam("@intList",adInteger,adParamInput,0,intList), _
						Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
					)
					WRITEIDCNT = Db.execRsData("DKP_NBOARD_VIEW_MEMBERS",DB_PROC,arrParams,Nothing)
					If WRITEIDCNT < 1 Then
						Call ALERTS(LNG_BOARD_VIEW_TEXT09,"back","")
					End If
				End If
			End If
		Case "GUEST"
			If DK_MEMBER_LEVEL < intLevelView Then
			'	Call ALERTS("게시판보기 권한이 없습니다. 관리자에게 문의해주세요.","back","")
				'Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1) '고객지원-회사소식, 자료실-상품교육자료실 : 회원공개
				Call CONFIRM(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT05,"go_back","/m/common/member_login.asp?backURL="&Replace(ThisPageURL,"&","§")&"","")
			Else
				If isSecret = "T" Then
					If ContentPass = "" Then Call ALERTS(LNG_BOARD_VIEW_TEXT10,"BACK","")
					If ContentPass <> strPass2 Then Call ALERTS(LNG_BOARD_VIEW_TEXT11,"BACK","")
				End If
			End If
		Case "ADMIN","OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelView Then
					Call ALERTS(LNG_BOARD_VIEW_TEXT08,"back","")
				Else
					If isSecret = "T" Then
						arrParams = Array(_
							Db.makeParam("@intList",adInteger,adParamInput,0,intList), _
							Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
						)
						WRITEIDCNT = Db.execRsData("DKP_NBOARD_VIEW_MEMBERS",DB_PROC,arrParams,Nothing)
						If WRITEIDCNT < 1 Then
							Call ALERTS(LNG_BOARD_VIEW_TEXT09,"back","")
						End If
					End If
				End If
			End If
	End Select
%>
<!-- <link href="board.css" rel="stylesheet" type="text/css" /> -->
<link href="/m/css/style.css?v0" rel="stylesheet" type="text/css" />
<style type="text/css">
 .embed-container {position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%;margin-left:0%;}
 .embed-container iframe, .embed-container object,.embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
</style>
<script type="text/javascript" src="board.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		//현재글 (추천)

		$("#board img").each(function(){
			$(this).css({"width" : "100%", "height" : "100%"});
		});


		$(document).on("click","#ClickVote",function () {
			$.ajax({
				type: "POST"
				,url: "/cboard/board_vote.asp"
				,cache : false
				,data: {
					 "ointIDX"		: <%=intIDX%>
				}
				,async : false
				,success: function(data) {
					//console.log(data);
					var obj = jQuery.parseJSON(data);
					var rData = obj.returnData;
					var rMsg = obj.returnMessage;
					var rCnt = obj.rCnt;

					if (rData == 'ERROR') {
						alert(rMsg);
						return false;
					} else if (rData == 'SUCCESS') {
						//alert('현재 게시물을 추천했습니다');
						$("#Tcnt").html(formatComma(rCnt));
						$("#voteArea").html(rMsg);
						return false;
					} else if (rData == 'ERROR2') {
						alert('이미 추천한 게시물입니다.');
						$("#voteArea").html(rMsg);
						return false;
					} else if (rData == 'CANCEL') {
						//alert('추천을 취소했습니다.');
						$("#Tcnt").html(formatComma(rCnt));
						$("#voteArea").html(rMsg);
						return false;
					}
				}
				,error:function(data){alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);}
			});
		});

	});

	//현재글의 댓글(추천)
	function thisArticleVote(ointIDX) {
		//console.log(ointIDX);
		$.ajax({
			type: "POST"
			,url: "/cboard/board_comment_vote.asp"
			,cache : false
			,data: {
				 "ointIDX"		: ointIDX
			}
			,async : false
			,success: function(data) {
				//console.log(data);
				var obj = jQuery.parseJSON(data);
				var rData = obj.returnData;
				var rMsg = obj.returnMessage;
				var rCnt = obj.rCnt;

				if (rData == 'ERROR') {
					alert(rMsg);
					return false;
				} else if (rData == 'SUCCESS') {
					//alert('현재 게시물을 추천했습니다');
					$("#voteArea_2"+ointIDX).html(rMsg);
					return false;
				} else if (rData == 'ERROR2') {
					alert('이미 추천한 게시물입니다.');
					$("#voteArea_2"+ointIDX).html(rMsg);
					return false;
				} else if (rData == 'CANCEL') {
					//alert('추천을 취소했습니다.');
					$("#voteArea_2"+ointIDX).html(rMsg);
					return false;
				}
			}
			,error:function(data){alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);}
		});
	}

	$(function() {
		$('.remainingTXT').each(function() {
			// count 정보 및 count 정보와 관련된 textarea/input 요소를 찾아내서 변수에 저장한다.
			var $count = $('.count', this);
			var $input = $(this).prev();
			// .text()가 문자열을 반환하기에 이 문자를 숫자로 만들기 위해 1을 곱한다.
			var maximumCount = $count.text() * 1;
			// update 함수는 keyup, paste, input 이벤트에서 호출한다.
			var update = function() {
				var before = $count.text() * 1;
				var now = maximumCount - $input.val().length;
				// 사용자가 입력한 값이 제한 값을 초과하는지를 검사한다.
				if (now < 0) {
					var str = $input.val();
					//alert('글자 입력수가 초과하였습니다.');
					alert(maximumCount+ '자까지 입력할 수 있습니다.');
					$input.val(str.substr(0, maximumCount));
					now = 0;
				}
				// 필요한 경우 DOM을 수정한다.
				if (before != now) {
					$count.text(now);
				}
			};
			// input, keyup, paste 이벤트와 update 함수를 바인드한다
			$input.bind('input keyup paste', function() {
				setTimeout(update, 0)
			});
			update();
		});
	});




	function delOk(num) {
		var f = document.dFrm
		if (confirm("<%=LNG_BOARD_VIEW_TEXT21%>")) {
			f.appIDX.value = num;
			f.target = "hiddenFrame";
			f.submit();
		}
	}
	function delFrm(idx) {
		var f = document.w_form;
		if (confirm("<%=LNG_JS_DELETE_POST%>")) {
			f.action = 'board_delete.asp';
			f.target = "_self";
			f.submit();
		}

	}
	<%IF DK_MEMBER_TYPE = "GUEST" And strUserID = "GUEST" THEN%>
	function ChkdFrm() {
		var f = document.dgfrm;
		if (confirm("<%=LNG_JS_DELETE_POST%>")) {
			if (f.strPass.value=='')
			{
				alert("<%=LNG_BOARD_VIEW_TEXT02%>");
				f.strPass.focus();
				return false;
			}
		}else{
			return false
		}

	}
	function ChkmFrm(f) {
		if (f.strPass.value=='')
		{
			alert("<%=LNG_BOARD_VIEW_TEXT23%>");
			f.strPass.focus();
			return false;
		}
	}
	function onoffabs(eleid1,eleid2) {
		if (document.getElementById(eleid2).style.display == "block"){
			document.getElementById(eleid2).style.display = "none";
			document.getElementById(eleid1).style.display = "block";
		} else {
			document.getElementById(eleid1).style.display = "block";
		}
	}
	<%END IF%>
	function repFrm(idx) {
		var f = document.w_form;
		f.action = 'board_reply.asp';
		f.target = "_self";
		f.submit();
	}
<% if DK_MEMBER_TYPE = "ADMIN" THEN%>
	function smsSend(idx) {
		openPopup('smsSend.asp?num='+idx+'&bname=<%=strBoardName%>', 'popSMS', 'top=100px,left=200px,width=600,height=325,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=no');
	}
<%END IF%>

	function rreplychk(f)
	{
		if (f.strContent.value=='')
		{
			alert("<%=LNG_BOARD_VIEW_TEXT01%>");
			f.strContent.focus();
			return false;
		}
	}


</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<div class="board view">
	<div class="title">
		<div><%=strSubject%></div>
		<p class="info">
			<span><%=Writer%></span>
			<i></i>
			<span><%=datevalue(regDate)%></span>
			<i></i>
			<span><%=LNG_TEXT_COUNT_NUMBER%> <%=readCnt%></span>
		</p>
	</div>

	<!-- <form name="ifrm" action="boardHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return mfrmCheck('basic')">
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<input type="hidden" name="idx" value="<%=intIDX%>" />
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="strUserID" value="<%=DK_MEMBER_ID%>" /> -->
		<table <%=tableatt%>>
			<col width="22%" />
			<col width="48%" />
			<col width="30%" />
			<tbody>
			<!-- <tr>
				<th class="tcenter em12 subjects" colspan="3"><%=strSubject%></th>
			</tr><tr>
				<td class="borT" colspan="2">
					<%=LNG_TEXT_WRITER%> : <span class="name"><%=Writer%></span>
				</td>
				<td class="borT" align="right"><span class="date"><%=datevalue(regDate)%><br /><%=timevalue(regDate)%></span></td>
			</tr> -->
			<tr>
				<td colspan="3" class="contentTD2">
					<%If Left(strBoardType,5) = "movie" Then '동영상 추가%>
						<%
							Select Case UCase(movieType)
								Case "Y"
									movieURL = Replace(movieURL,"http://youtu.be","http://www.youtube.com/embed")
								Case "V"
									movieURL = Replace(movieURL,"http://vimeo.com","http://player.vimeo.com/video")
							End Select
						%>
						<div class="embed-container">
							<iframe width="820" height="450" src="<%=movieURL%>" frameborder="0" allowfullscreen></iframe>
						</div>
						<br />
					<%End If%>

					<!-- 이미지 1,2,3 -->
					<%If strPic1 <> "" Then%>
						<div style="padding:20px 0px;">
							<img src="/upload/board/pic1/<%=strPic1%>" style="width:100%;" />
						</div>
					<%End If%>
					<%If strPic2 <> "" Then%>
						<div style="padding:20px 0px;">
							<img src="/upload/board/pic1/<%=strPic2%>" style="width:100%;" />
						</div>
					<%End If%>
					<%If strPic3 <> "" Then%>
						<div style="padding:20px 0px;">
							<img src="/upload/board/pic1/<%=strPic3%>" style="width:100%;" />
						</div>
					<%End If%>


					<%=backword_tag(strContent)%>

					<%If isVote = "T" Then%>
						<%
							SQL3 = "SELECT COUNT(*) FROM [DK_NBOARD_VOTE] WITH(NOLOCK) WHERE [bIDX] = ? AND [mode] = 'vote' "
							arrParams3 = Array(_
								Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
							)
							TotalVoteCnt = Db.execRsData(SQL3,DB_TEXT,arrParams3,Nothing)

							SQL2 = "SELECT COUNT(*) FROM [DK_NBOARD_VOTE] WITH(NOLOCK)  WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = 'vote' "
							arrParams = Array(_
								Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
								Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
							)
							ThisVoteCnt = Db.execRsData(SQL2,DB_TEXT,arrParams,Nothing)
						%>
						<div class="width100" style="margin:20px 0px 45px 0px;">
							<div class="fleft" style="width:50%;">
								<!-- <span class="heart1"></span><span class="heartTxt" id="Tcnt"><%=num2cur(TotalVoteCnt)%></span> -->
							</div>
							<div class="fright" style="width:50%;">
								<span id="voteArea" class="fright">
								<%If DK_MEMBER_ID <> "GUEST" And isCommentUse = "T" And isVote = "T" Then%>
									<%If ThisVoteCnt > 0 Then%>
										<!-- <span class="heart2"></span><span class="heartTxt2">추천함</span> -->
										<a id="ClickVote" class="cp ClickVoteT"><span class="heart2"></span><span class="heartTxt2_T">좋아요(<%=num2cur(TotalVoteCnt)%>)</span></a>
									<%Else%>
										<a id="ClickVote" class="cp ClickVoteF"><span class="heart3"></span><span class="heartTxt2 red">좋아요(<%=num2cur(TotalVoteCnt)%>)</span></a>
									<%End If%>
								<%Else%>
									<!-- <span class="heart3"></span><span class="heartTxt2">회원만 추천 가능</span> -->
								<%End If%>
								</span>
							</div>
						</div>
					<%End If%>

				</td>
			</tr>
			<%=printData1%>
			<%=printData2%>
			<%=printData3%>

			<!-- <%
				SNS_TF = "F"
				Select Case DK_MEMBER_TYPE
					Case "MEMBER","COMPANY"
						If DK_MEMBER_LEVEL >= intLevelWrite And DK_MEMBER_ID = strUserID Then
							SNS_TF = "T"
						End If
					Case "GUEST"
						If DK_MEMBER_LEVEL >= intLevelWrite And strUserID = "GUEST" Then
							SNS_TF = "T"
						End If
					Case "ADMIN","OPERATOR"
							SNS_TF = "T"
				End Select
			%>
			<%If SNS_TF = "T" Then %>
			<tr>
				<td colspan="3" class="tcenter" >
					<div class="sns">
						<ul>
							<li><a href="#"><img src="/m/images/facebook.svg" alt="" /></a></li>
							<li><a href="#"><img src="/m/images/twitter.svg" alt="" /></a></li>
							<li><a href="#"><img src="/m/images/kakao.svg" alt="" /></a></li>
							<li><a href="#"><img src="/m/images/kakao_story.svg" alt="" /></a></li>
							<li><a href="#"><img src="/m/images/insta.svg" alt="" /></a></li>
							<li><a href="#"><img src="/m/images/youtube.svg" alt="" /></a></li>
						</ul>
					</div>
				</td>
			</tr>
			<%End If%> -->
		</tbody>
		<tfoot>
			<tr>
				<td colspan="1" class="contentTD3">
					<%
						'BTN_CLICK_REPLY  = aImgOpt("javascript:repFrm('"&intIDX&"')","S","images/btn_blog07.gif",60,23,"","")
						BTN_CLICK_REPLY  = "<input type=""button"" class=""button answer"" value="""&LNG_BOARD_BTN_REPLY&""" onclick=""javascript:repFrm('"&intIDX&"')""/>"

						Select Case DK_MEMBER_TYPE
							Case "MEMBER","GUEST","COMPANY"
								If DK_MEMBER_LEVEL >= intLevelReply Then
									PRINT TABS(3)& BTN_CLICK_REPLY
								End If
							Case "ADMIN","OPERATOR"
								PRINT TABS(3)& BTN_CLICK_REPLY
							Case "SADMIN"
								If UCase(DK_MEMBER_GROUP) = LOCATIONS Then
									PRINT TABS(3)& BTN_CLICK_REPLY
								Else
									If DK_MEMBER_LEVEL >= intLevelReply Then
										PRINT TABS(3)& BTN_CLICK_REPLY
									End If
								End If
						End Select
					%>
				</td>
				<td colspan="2" class="contentTD3 tright">
					<%If DK_MEMBER_TYPE = "GUEST" And strUserID = "GUEST" Then%>
						<div class="fleft" id="bmodify"  style="position:absolute; z-index:10; top:30px; right:48px; background-color:#eee;border:1px solid #ccc;padding:10px; display:none;">
							<form name="mfrm" method="post" action="board_modify.asp?bname=<%=strBoardName%>&amp;num=<%=intIDX%>" onsubmit="return ChkmFrm(this);">
								<%=LNG_TEXT_PASSWORD%> : <input type="password" class="input_text_gr vmiddle" name="strPass" style="width:40%;" /> <input type="submit" class="button" value="<%=LNG_BOARD_BTN_MODIFY%>" />
							</form>
						</div>
						<div class="fleft" id="bdelete" style="position:absolute; z-index:10; top:30px; right:48px; background-color:#eee;border:1px solid #ccc; padding:10px; display:none;">
							<form name="dgfrm" method="post" action="board_delete.asp" onsubmit="return ChkdFrm(this);">
								<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
								<input type="hidden" name="intIDX" value="<%=intIDX%>" />
								<input type="hidden" name="list" value="<%=intList%>" />
								<input type="hidden" name="depth" value="<%=intDepth%>" />
								<input type="hidden" name="ridx" value="<%=intRIDX%>" />
								<%=LNG_TEXT_PASSWORD%> : <input type="password" class="input_text_gr vmiddle" name="strPass" style="width:40%;" /> <input type="submit" class="button" value="<%=LNG_BOARD_BTN_DELETE%>" />
							</form>
						</div>
					<%End If%>
					<%
						' 수정/삭제 타입별 확인
						Select Case DK_MEMBER_TYPE
							Case "MEMBER","ADMIN","OPERATOR","SADMIN","COMPANY"
								BTN_CLICK_DELETE  = "<input type=""button"" class=""button delete"" value="""&LNG_BOARD_BTN_DELETE&""" onclick=""javascript:delFrm('"&intIDX&"');""/>"
								BTN_CLICK_MODIFY  = "<input type=""button"" class=""button edit"" value="""&LNG_BOARD_BTN_MODIFY&""" onclick=""location.href='board_modify.asp?bname="&strBoardName&"&amp;num="&intIDX&"'""/>"
								'BTN_CLICK_DELETE  = aImgOpt("javascript:delFrm('"&intIDX&"');","","images/btn_blog05.gif",60,23,"","class=""vmiddle""")
								'BTN_CLICK_MODIFY  = aImgOpt("board_modify.asp?bname="&strBoardName&"&amp;num="&intIDX,"S","images/btn_blog06.gif",60,23,"","class=""vmiddle""")
							Case "GUEST"
								If strUserID = "GUEST" Then
									BTN_CLICK_DELETE  = "<input type=""button"" class=""button delete"" value="""&LNG_BOARD_BTN_DELETE&""" onclick=""javascript:onoffabs('bdelete','bmodify');""/>"
									BTN_CLICK_MODIFY  = "<input type=""button"" class=""button edit"" value="""&LNG_BOARD_BTN_MODIFY&""" onclick=""javascript:onoffabs('bmodify','bdelete');""/>"
									'BTN_CLICK_DELETE  = aImgOpt("javascript:onoffabs('bdelete','bmodify');","","images/btn_blog05.gif",60,23,"","class=""vmiddle""")
									'BTN_CLICK_MODIFY  = aImgOpt("javascript:onoffabs('bmodify','bdelete');","S","images/btn_blog06.gif",60,23,"","class=""vmiddle""")
								End If
						End Select
						' 수정/삭제 확인
						Select Case DK_MEMBER_TYPE
							Case "MEMBER","COMPANY"
								If DK_MEMBER_LEVEL >= intLevelWrite And DK_MEMBER_ID = strUserID Then
									PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
								End If
							Case "GUEST"
								If DK_MEMBER_LEVEL >= intLevelWrite And strUserID = "GUEST" Then
									PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
								End If
							Case "ADMIN","OPERATOR"
								PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
							Case "SADMIN"
								If UCase(DK_MEMBER_GROUP) = LOCATIONS Then
									PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
								Else
									If DK_MEMBER_LEVEL >= intLevelWrite And DK_MEMBER_ID = strUserID Then
										PRINT TABS(3)& BTN_CLICK_DELETE &" "& BTN_CLICK_MODIFY
									End If
								End If
						End Select
					%>
					<input type="button" class="button" value="<%=LNG_BOARD_BTN_LIST%>" onclick="location.href='board_list.asp?bname=<%=strBoardName%><%=getCate%>'" />
					</div>
				</td>
			</tr>
		</tfoot>
		</table>
	<!-- </form> -->
</div>



<%If isCommentUse = "T" Then%>
	<%If DK_MEMBER_LEVEL >= intLevelCommentWrite Then%>
		<div class="reply" style="margin-top:80px;">
			<table <%=tableatt%> style="width:100%;">
				<colgroup>
					<col width="120" />
					<col width="*" />
				</colgroup>
				<tr>
					<td class="replayTotal"><span class="tweight font15px">댓글(<%=num2cur(REPLYCNT)%>)</span></td>
					<td class="replayTotal"></td>
				</tr><tr>
					<td colspan="2">
						<form name="rFrm" action="replyHandler.asp" method="post" target="hiddenFrame" onsubmit="return rreplychk(this);">
							<input type="hidden" name="mode" value="INSERT" />
							<input type="hidden" name="appIDX" value="<%=intIDX%>" />
							<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
							<div class="input fleft" style="">
								<%If DK_MEMBER_TYPE="GUEST" Then%><div class="input1"><%=LNG_TEXT_WRITER%> : <input type="text" name="replyName" class="input_text" style="width:120px;" /> <%=LNG_TEXT_PASSWORD%> : <input type="password" name="replyPass" class="input_text" style="width:140px;" /> <label><input type="checkbox" name="replySecret" class="input_check" value="T" /><%=LNG_BOARD_VIEW_TEXT26%></label> <span class="f8pt">(<%=LNG_BOARD_VIEW_TEXT27%>)</span> </div><%End If%>
								<div class="width100 tcenter">
									<textarea name="strContent" style="width:98%;height:60px;resize:none;;" class="input_text" placeholder="<%=LNG_BOARD_VIEW_TEXT28%>"></textarea>
									<div class="remainingTXT fleft" style="padding:10px 8px 0px 8px;">
										<span class="count"><%=isVoteMaxLength%></span>/<%=isVoteMaxLength%>
									</div>
									<div class="fright" style="padding:10px 9px 0px 9px;">
										<span class="fright"><input type="submit" class="txtBtnC small gray" value="등 록" /></span>
									</div>
								</div>

							</div>
						</form>
					</td>
				</tr>
			</table>
		</div>
	<%End If%>
	<%If DK_MEMBER_LEVEL >= intLevelCommentList Then%>
		<div class="replylist fleft" style="width:100%;margin-top:30px;">
			<!-- <p style="padding:5px 0px;"><%=viewImg("./images/reply_title2.gif",49,13,"")%> <strong>(<%=num2cur(REPLYCNT)%>)</strong></p> -->
			<!-- <table <%=tableatt%> class="width100" > -->
			<table <%=tableatt%> class="" style="width:95%;margin:0 auto;">
				<colgroup>
					<col width="200" />
					<col width="*" />
				</colgroup>
				<%
					SQLC = "SELECT * FROM [DK_NBOARD_COMMENT] WITH(NOLOCK) WHERE [intBoardIDX] = ? AND [viewTF] = 'T' AND [intDepth] = 0 ORDER BY [intLIST] ASC, [intIDX] ASC"
					arrParamsC = Array(_
						Db.makeParam("@intAppIDX",adInteger,adParamInput,0,intIDX) _
					)
					arrListC = Db.execRsList(SQLC,DB_TEXT,arrParamsC,listLenC,Nothing)

					If IsArray(arrListC) Then

						For i = 0 To listLenC
							arrListC_intIDX			= arrListC(0,i)
							arrListC_intBoardIDX	= arrListC(1,i)
							arrListC_intList		= arrListC(2,i)
							arrListC_intDepth		= arrListC(3,i)
							arrListC_intRIDX		= arrListC(4,i)
							arrListC_strBoardName	= arrListC(5,i)
							arrListC_strUserID		= arrListC(6,i)
							arrListC_strName		= arrListC(7,i)
							arrListC_strPass		= arrListC(8,i)
							arrListC_strContent		= arrListC(9,i)
							arrListC_regDate		= arrListC(10,i)
							arrListC_viewTF			= arrListC(11,i)
							arrListC_isSecret		= arrListC(12,i)

							'arrListC_strContent = Replace(arrListC_strContent,"<br />"," ")
							'arrListC_strContent = Replace(arrListC_strContent,"<br/>"," ")
							'arrListC_strContent = Replace(arrListC_strContent,"<br>"," ")

							classed = ""
							If arrListC_intDepth > 0 Then
								cols = "  "
							Else
								PRINT "<col width=""750"" />"
								cols = " colspan=""2"" "
							End If

							If DK_MEMBER_ID = arrListC_strUserID Then
								HIGHLIGHT_NAME = "background:yellow;"
							Else
								HIGHLIGHT_NAME = ""
							End If
				%>
				<tr>
					<td class="bor0" <%=cols%>>
						<span class="name" style="<%=HIGHLIGHT_NAME%>"><%=arrListC_strName%></span><span class="date"><%=arrListC_regDate%>
						<span class="btnzone">
							<%If DK_MEMBER_LEVEL > 0 Then		'삭제%>
								<%If (DK_MEMBER_LEVEL > 0 And DK_MEMBER_ID = arrListC_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "SADMIN" Then%>
									<input type="button" class="vmiddle BtnXDel" value="&#10005;" onclick="javascript:delOk('<%=arrListC_intIDX%>');" />
								<%End If%>
							<%End If%>
						</span>
					</td>
				</tr><tr>
					<td class="bor2" <%=cols%>>
						<p class="rContent">
							<%If arrListC_isSecret = "T" Then%>
								<span style="color:#c0c0c0;"><%=LNG_BOARD_VIEW_TEXT29%></span>
								<%If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Or (DK_MEMBER_TYPE = "SADMIN" And UCase(DK_MEMBER_GROUP) <> LOCATIONS) Then%>
									<%=arrListC_strContent%>
								<%End If%>
							<%Else%>
								<%=arrListC_strContent%>
							<%End If%>
						</p>
					</td>
				</tr>
				<tr>
					<td class="bor1 borAS" >
					<%If DK_MEMBER_LEVEL > 0 Then%>
						<%If DK_MEMBER_LEVEL >= intLevelCommentReply And arrListC_intDepth = 0 Then%>
							<%
								'댓글갯수
								SQLCC = "SELECT COUNT(*) FROM [DK_NBOARD_COMMENT] WITH(NOLOCK) WHERE [intBoardIDX] = ? AND [intList] = ? AND [viewTF] = 'T' AND [intDepth] > 0 "
								arrParamsCC = Array(_
									Db.makeParam("@intAppIDX",adInteger,adParamInput,0,intIDX), _
									Db.makeParam("@intList",adInteger,adParamInput,0,arrListC_intList) _
								)
								AnswrTotalCNT = Db.execRsData(SQLCC,DB_TEXT,arrParamsCC,Nothing)

								If AnswrTotalCNT = 0 Then AnswrTotalCNT = ""
							%>
							<%
								'나의 댓글갯수
								SQLCCMY = "SELECT COUNT(*) FROM [DK_NBOARD_COMMENT] WITH(NOLOCK) WHERE [strUserID] = ? AND [intBoardIDX] = ? AND [intList] = ? AND [viewTF] = 'T' AND [intDepth] > 0 "
								arrParamsCC = Array(_
									Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
									Db.makeParam("@intAppIDX",adInteger,adParamInput,0,intIDX), _
									Db.makeParam("@intList",adInteger,adParamInput,0,arrListC_intList) _
								)
								MYAnswrTotalCNT = Db.execRsData(SQLCCMY,DB_TEXT,arrParamsCC,Nothing)

								If MYAnswrTotalCNT > 0 Then
									HIGHLIGHT_ANS_BTN = "background:yellow;"
								Else
									HIGHLIGHT_ANS_BTN = ""
								End If
							%>
							<input type="button" class="vmiddle BtnAnswer" style="<%=HIGHLIGHT_ANS_BTN%>" value="답글 <%=AnswrTotalCNT%>" onclick="javascript:rreplyView('replysT<%=arrListC_intIDX%>')"/>
						<%End If%>
					<%End If%>
					</td>
					<td class="bor1 borAS fright" >
						<span class="btnzone">
							<%If isVote = "T" Then%>
								<%
									SQL3 = "SELECT COUNT(*) FROM [DK_NBOARD_COMMENT_VOTE] WITH(NOLOCK) WHERE [bIDX] = ? AND [mode] = 'vote' "
									arrParams3 = Array(_
										Db.makeParam("@intIDX",adInteger,adParamInput,4,arrListC_intIDX) _
									)
									TotalCommentVoteCnt = Db.execRsData(SQL3,DB_TEXT,arrParams3,Nothing)

									SQL2 = "SELECT COUNT(*) FROM [DK_NBOARD_COMMENT_VOTE] WITH(NOLOCK)  WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = 'vote' "
									arrParams = Array(_
										Db.makeParam("@intIDX",adInteger,adParamInput,4,arrListC_intIDX), _
										Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
									)
									ThisCommentVoteCnt = Db.execRsData(SQL2,DB_TEXT,arrParams,Nothing)
								%>
								<%If DK_MEMBER_ID <> "GUEST" Then%>
									<span id="voteArea_2<%=arrListC_intIDX%>" class="fright">
										<%If ThisCommentVoteCnt > 0 Then%>
											<a id="ClickVote_2" class="cp ClickVoteT" onclick="thisArticleVote('<%=arrListC_intIDX%>');"><span class="thumbsUp2"></span><span class="heartTxt2_T" style="vertical-align:0px;"><%=num2cur(TotalCommentVoteCnt)%></span></a>
										<%Else%>
											<a id="ClickVote_2" class="cp ClickVoteF" onclick="thisArticleVote('<%=arrListC_intIDX%>');"><span class="thumbsUp3"></span><span class="heartTxt2 red" style="vertical-align:0px;"><%=num2cur(TotalCommentVoteCnt)%></span></a>
										<%End If%>
									</span>
								<%Else%>
									<!-- <span class="heart3"></span><span class="heartTxt2">회원만 추천 가능</span> -->
								<%End If%>
							<%End If%>

						</span>
					</td>
				</tr><tr>
					<td class="bor2" <%=cols%>>
						<%'댓글의 댓글%>
						<div id="replysT<%=arrListC_intIDX%>" name="replysT" style="display:none;">

							<table <%=tableatt%> class="fright" style="width:100%;">
								<colgroup>
									<col width="30" />
									<col width="*" />
								</colgroup>
								<%	'댓글의 댓글보기
									SQLC2 = "SELECT * FROM [DK_NBOARD_COMMENT] WITH(NOLOCK) WHERE [intBoardIDX] = ? AND [intList] = ? AND [viewTF] = 'T' AND [intDepth] > 0 ORDER BY [intLIST] ASC, [intIDX] ASC"
									arrParamsC2 = Array(_
										Db.makeParam("@intAppIDX",adInteger,adParamInput,0,intIDX), _
										Db.makeParam("@intList",adInteger,adParamInput,0,arrListC_intList) _
									)
									arrListC2 = Db.execRsList(SQLC2,DB_TEXT,arrParamsC2,listLenC2,Nothing)

									If IsArray(arrListC2) Then

										For j = 0 To listLenC2
											arrListC2_intIDX		= arrListC2(0,j)
											arrListC2_intBoardIDX	= arrListC2(1,j)
											arrListC2_intList		= arrListC2(2,j)
											arrListC2_intDepth		= arrListC2(3,j)
											arrListC2_intRIDX		= arrListC2(4,j)
											arrListC2_strBoardName	= arrListC2(5,j)
											arrListC2_strUserID		= arrListC2(6,j)
											arrListC2_strName		= arrListC2(7,j)
											arrListC2_strPass		= arrListC2(8,j)
											arrListC2_strContent	= arrListC2(9,j)
											arrListC2_regDate		= arrListC2(10,j)
											arrListC2_viewTF		= arrListC2(11,j)
											arrListC2_isSecret		= arrListC2(12,j)

											'arrListC2_strContent = Replace(arrListC2_strContent,"<br />"," ")
											'arrListC2_strContent = Replace(arrListC2_strContent,"<br/>"," ")
											'arrListC2_strContent = Replace(arrListC2_strContent,"<br>"," ")

											classed = ""
											If arrListC2_intDepth > 0 Then
												cols = "  "
											Else
												PRINT "<col width=""750"" />"
												cols = " colspan=""2"" "
											End If


											If DK_MEMBER_ID = arrListC2_strUserID Then
												HIGHLIGHT_NAME = "background:yellow;"
											Else
												HIGHLIGHT_NAME = ""
											End If

								%>
								<tr>
									<td class="bor1 rrBGC"><span class="fright" style="padding-right:5px;font-size:20px;"><!-- &#x2937; -->ㄴ</span></td>
									<td class="bor1 rrBGC" <%=cols%>>
										<span class="name" style="<%=HIGHLIGHT_NAME%>"><%=arrListC2_strName%></span><span class="date"><%=arrListC2_regDate%>
										<span class="btnzone">
											<%If DK_MEMBER_LEVEL > 0 Then	'삭제%>
												<%If (DK_MEMBER_LEVEL > 0 And DK_MEMBER_ID = arrListC2_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "SADMIN" Then%>
													<input type="button" class="vmiddle BtnXDel" value="&#10005;" onclick="javascript:delOk('<%=arrListC2_intIDX%>');" />
												<%End If%>
											<%End If%>
										</span>
									</td>
								</tr><tr>
									<td class="bor2 rrBGC"></td>
									<td class="bor2 rrBGC" <%=cols%>>
										<p class="rContent rrBGC">
											<%If arrListC2_isSecret = "T" Then%>
												<span style="color:#c0c0c0;"><%=LNG_BOARD_VIEW_TEXT29%></span>
												<%If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Or (DK_MEMBER_TYPE = "SADMIN" And UCase(DK_MEMBER_GROUP) <> LOCATIONS) Then%>
													<%=arrListC2_strContent%>
												<%End If%>
											<%Else%>
												<%=arrListC2_strContent%>
											<%End If%>
										</p>
									</td>
								</tr>

								<%
										Next
									Else
								%>
									<tr>
										<td class="bor1 rrBGC" colspan="2" style="height:0px;"><!-- <%=LNG_BOARD_VIEW_TEXT30%> --></td>
									</tr>
								<%

									End If
								%>
								<tr>
									<td class="rrBGC vtop"><span class="fright" style="padding-right:5px;font-size:20px;"><!-- &#x2937; -->ㄴ</span></td>
									<td class="rrBGC">
										<div class="reply fright" style="width:100%;">
											<form name="rFrm" action="replyHandler.asp" method="post" target="hiddenFrame" onsubmit="return rreplychk(this);">
												<input type="hidden" name="mode" value="REPLY" />
												<input type="hidden" name="appIDX" value="<%=intIDX%>" />
												<input type="hidden" name="upIDX" value="<%=arrListC_intIDX%>" />
												<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />

												<div class="input fleft" style="margin-bottom:15px;">
													<div class="width100 tcenter">
														<textarea name="strContent" style="width:92%;height:60px;resize:none;" class="input_text" placeholder="<%=LNG_BOARD_VIEW_TEXT28%>"></textarea>
														<div class="remainingTXT fleft" style="padding:10px 8px 0px 8px;">
															<span class="count"><%=isVoteMaxLength%></span>/<%=isVoteMaxLength%>
														</div>
														<div class="fright" style="padding:10px 9px 0px 9px;">
															<span class="fright"><input type="submit" class="txtBtnC small gray" value="등 록" /></span>
														</div>
													</div>
												</div>
											</form>
										</div>
									</td>
								</tr>

								<tr class="cp" onclick="javascript:rreplyView('replysT<%=arrListC_intIDX%>')">
									<td colspan="2" class="rrBGC tcenter borCL">답글접기 &#x2191;</td>
									<!-- <td class="bor1 rrBGC"></td> -->
								</tr>
							</table>

						</div>
					</td>
				</tr>


			<%
					Next
				Else
			%>
				<!-- <tr>
					<td class="bor3" colspan="2"><%=LNG_BOARD_VIEW_TEXT30%></td>
				</tr> -->
			<%

				End If
			%>
			</table>
		</div>

	<%Else%>
		<!-- <div class="replylist">
			<table <%=tableatt%> style="width:100%;">
				<colgroup>
					<col width="120" />
					<col width="*" />
				</colgroup>
				<tr>
					<td class="replayTotal"><span class="tweight font15px">댓글(<%=num2cur(REPLYCNT)%>)</span></td>
					<td class="replayTotal"></td>
				</tr><tr>
					<td colspan="2" class="bor3">
						<%=LNG_BOARD_VIEW_TEXT31%>
					</td>
				</tr>
			</table>
		</div> -->
	<%End If%>
<%Else%>
<%End If%>



<div class="prenext">
	<%
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
			Db.makeParam("@strDomain",adVarChar,adParamInput,20,LOCATIONS), _
			Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) ,_
			Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
			Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG) _
		)
		Set DKRS = Db.execRs("DKP_NBOARD_PREV_CONTENT",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			PREV_IDX		= DKRS(0)
			PREV_SUBJECT	= DKRS(1)
			PREV_NAME		= DKRS(2)
			PREV_DATE		= Left(DKRS(3),10)
			PREV_SUBJECT = "<a href=""board_view.asp?bname="&strBoardName&"&amp;num="&PREV_IDX&getCate&""">"&backword_title(PREV_SUBJECT)&"</a>"
		Else
			PREV_IDX		= ""
			PREV_SUBJECT	= LNG_BOARD_VIEW_TEXT32
			PREV_NAME		= ""
			PREV_DATE		= ""
		End If
		Call closeRS(DKRS)

		Set DKRS = Db.execRs("DKP_NBOARD_NEXT_CONTENT",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			NEXT_IDX		= DKRS(0)
			NEXT_SUBJECT	= DKRS(1)
			NEXT_NAME		= DKRS(2)
			NEXT_DATE		= Left(DKRS(3),10)
			NEXT_SUBJECT = "<a href=""board_view.asp?bname="&strBoardName&"&amp;num="&NEXT_IDX&getCate&""">"&backword_title(NEXT_SUBJECT)&"</a>"
		Else
			NEXT_IDX		= ""
			NEXT_SUBJECT	= LNG_BOARD_VIEW_TEXT33
			NEXT_NAME		= ""
			NEXT_DATE		= ""
		End If
		Call closeRS(DKRS)


	%>
	<table <%=tableatt%> class="width100">
		<colgroup>
			<col width="100" />
			<col width="*" />
			<!-- <col width="" />
			<col width="" /> -->
		</colgroup>
		<tr>
			<td class="tit"><%=LNG_BOARD_VIEW_TEXT34%></td>
			<td class="subject"><%=NEXT_SUBJECT%></td>
			<!-- <td><%=NEXT_NAME%></td>
			<td><%=NEXT_DATE%></td> -->
		</tr><tr>
			<td class="tit"><%=LNG_BOARD_VIEW_TEXT35%></td>
			<td class="subject"><%=PREV_SUBJECT%></td>
			<!-- <td><%=PREV_NAME%></td>
			<td><%=PREV_DATE%></td> -->
		</tr>
	</table>
</div>

<form name="dFrm" action="replyHandler.asp" method="post" target="hiddenFrame">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="appIDX" value="" />
	<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
	<input type="hidden" name="idx" value="<%=intIDX%>" />
</form>
<form name="w_form" method="post" action="">
	<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
	<input type="hidden" name="intIDX" value="<%=intIDX%>" />
	<input type="hidden" name="list" value="<%=intList%>" />
	<input type="hidden" name="depth" value="<%=intDepth%>" />
	<input type="hidden" name="ridx" value="<%=intRIDX%>" />
</form>
<!--#include virtual = "/m/_include/copyright.asp"-->