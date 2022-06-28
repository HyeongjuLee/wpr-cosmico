<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strBoardName = gRequestTF("bname",True)
	intIDX = gRequestTF("num",True)
	gCate = gRequestTF("cate",False)
	ContentPass = pRequestTF("strPass",False)

'	print strBoardName
'	print intIDX
'response.End
%>
<!--#include file = "board_config.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="css_common.css" />
<link rel="stylesheet" href="/css/board.css?v0" />
<%
'	If DK_MEMBER_LEVEL < intLevelView And (DK_MEMBER_TYPE <> "ADMIN" Or DK_MEMBER_TYPE <> "SADMIN") Then Call alerts("게시판보기 권한이 없습니다. 관리자에게 문의해주세요.","back","")

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
		isMovie				= DKRS("isMovie")
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
		isIDImg				= DKRS("isIDImg")
		imgPath				= DKRS("imgPath")
		strPass2			= DKRS("strPass2")
		'이미지 1,2,3 추가
		strPic1				= DKRS("strPic1")
		strPic2				= DKRS("strPic2")
		strPic3				= DKRS("strPic3")

		movieType			= DKRS("movieType")		'추가
		movieURL			= DKRS("movieURL")		'추가
		strReplyDateS		= DKRS("strReplyDateS")		'추가
		strReplyDateE		= DKRS("strReplyDateE")		'추가
		isMainView			= DKRS("isMainView")


		If NB_isViewNameType = "N" Then viewName = strName Else viewName = strUserID End If
		If UCase(DK_MEMBER_ID) = UCase(strUserID) Or DK_MEMBER_TYPE = "ADMIN" Then
			viewName = "<span class=""itme"">"&viewName&"</span>"
		Else
			If NB_isViewNameChg = "T" Then viewName = FNC_ID_CHANGE_STAR(viewName,NB_intViewNameCnt)
		End If
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
				Call CONFIRM(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT05,"go_back","/common/member_login.asp?backURL="&Replace(ThisPageURL,"&","§")&"","")
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

'	If DK_MEMBER_TYPE <> "ADMIN" And DK_MEMBER_TYPE <> "OPERATOR" And (DK_MEMBER_TYPE <> "SADMIN" OR UCase(DK_MEMBER_GROUP) <> LOCATIONS) Then
'		If isSecret = "T" Then
'			If ContentPass = "" Then Call ALERTS("비밀글입니다. 정상적인 경로로 접속해주세요1","BACK","")
'			If ContentPass <> strPass Then Call ALERTS("암호가 틀렸습니다.","BACK","")
'		End If
'	End If


	'▣ 코멘트 작성 확인 S
		NB_REPLY_CNT_CHK = 0
		If NB_intReplyLimit > 0 And DK_MEMBER_TYPE <> "GUEST" Then
			arrParams = array(_
				DB.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
				DB.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				DB.makeParam("@intBoardIDX",adInteger,adParamInput,4,intIDX) _
			)
			NB_REPLY_CNT_CHK = CDbl(Db.execRsData("[DKSP_NBOARD_CHECK_REPLY_LIMIT]",DB_PROC,arrParams,Nothing))
		End If
	'▣ 코멘트 작성 확인 E



	snsSubject = strSubject
	snsSubject = Replace(snsSubject,"&#34;","")
	snsSubject = Replace(snsSubject,"&#39;","")
	snsSubject = Replace(snsSubject,"'","")
	snsSubject = Replace(snsSubject,"""","")
	snsSubject = trim(snsSubject)
	snsURL = "http://"&Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("SCRIPT_NAME")&"?"&Request.ServerVariables("QUERY_STRING")


	arrParams4 = Array(_
		Db.makeParam("@strMatchingID",adVarChar,adParamInput,100,strName) _
	)
	WriterImg = Db.execRsData("DKP_NBOARD_WRITER_IMG",DB_PROC,arrParams4,Nothing)

	If WriterImg = "" Or IsNull(WriterImg) Then
		Writer = viewName
	Else
		imgPath = VIR_PATH("matching")&"/"&WriterImg
		imgWidth = 0
		imgHeight = 0
		Call ImgInfo(imgPath,imgWidth,imgHeight,"")
		Writer = viewImgOpt(imgPath,imgWidth,imgHeight,"","")
	End If

	If gCate <> "" Then getCate = "&amp;cate="&intCate



	printHostIP = ""
	If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE="OPERATOR" Or DK_MEMBER_TYPE = "SADMIN" Then
		'printHostIP = printHostIP & "<p class=""clear tright f8pt"">IP Address : "&HostIP&"</p>" &VbCrlf
		printHostIP = printHostIP&tabs(1)& "	<tr>" &VbCrlf
		printHostIP = printHostIP&tabs(1)& "		<td colspan=""2"" class=""tright f8pt"" style=""padding:4px 0px;"">IP Address : "&HostIP&"</td>"
		printHostIP = printHostIP&tabs(1)& "	</tr>" &VbCrlf
	End If


	' 카테고리 출력 설정
		printCategory = ""
		If isCategoryUse = "T" Then
			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
				Db.makeParam("@totalCnt",adInteger,adParamOutput,0,0) _
			)
			arrList = Db.execRsList("DKPA_FORUM_WIRTE_CATEGORY",DB_PROC,arrParams,listLen,Nothing)
			CateTotalCnt = arrParams(UBound(arrParams))(4)

			printCategory = ""
			If CateTotalCnt > 0 Then
				printCategory = printCategory&tabs(2)&"<tr>" &VbCrlf
				printCategory = printCategory&tabs(2)&"	<th>"&LNG_TEXT_CATEGORY&"</th>" &VbCrlf
				printCategory = printCategory&tabs(2)&"	<td>" &VbCrlf
				printCategory = printCategory&tabs(2)&"		<select name=""category"" class=""input_select"">" &VbCrlf

				If IsArray(arrList) Then
					For i = 0 To listLen
						printCategory = printCategory&tabs(2)&"			<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
					Next
				End If

				printCategory = printCategory&tabs(2)&"		</select>" &VbCrlf
				printCategory = printCategory&tabs(2)&"	</td>" &VbCrlf
				printCategory = printCategory&tabs(2)&"<tr>" &VbCrlf
			End If
		Else
			printCategory  = ""
		End If


		printEmail = ""
		If isEmail = "T" And DK_MEMBER_LEVEL >= intEmailLevel Then
			printEmail = printEmail&tabs(2)&"<tr>" &VbCrlf
			printEmail = printEmail&tabs(2)&"	<th>"&LNG_TEXT_EMAIL&"</th>" &VbCrlf
			printEmail = printEmail&tabs(2)&"	<td>"&strEmail&"</td>"
			printEmail = printEmail&tabs(2)&"</tr>" &VbCrlf
		End If

		printMobile = ""
		If isMobile = "T" And DK_MEMBER_LEVEL >= intMobileLevel Then
			printMobile = printMobile&tabs(2)&"<tr>" &VbCrlf
			printMobile = printMobile&tabs(2)&"	<th>"&LNG_TEXT_MOBILE&"</th>" &VbCrlf
			printMobile = printMobile&tabs(2)&"	<td>"&strMobile
			If isSMS = "T" And DK_MEMBER_TYPE="ADMIN" Then
				printMobile = printMobile&" "&viewImgOpt(IMG_ICON&"/gosms.gif",16,16,"","class=""vmiddle cp"" onclick=""smsSend('"&intIDX&"')""")
			End If
			printMobile = printMobile&"</td>"
			printMobile = printMobile&tabs(2)&"</tr>" &VbCrlf
		End If

		printTel = ""
		If isTel = "T" And DK_MEMBER_LEVEL >= intTelLevel Then
			printTel = printTel&tabs(2)&"<tr>" &VbCrlf
			printTel = printTel&tabs(2)&"	<th>"&LNG_TEXT_TEL&"</th>" &VbCrlf
			printTel = printTel&tabs(2)&"	<td>"&strTel&"</td>"
			printTel = printTel&tabs(2)&"</tr>" &VbCrlf
		End If

		'PRINT REAL_PATH("data/data1")&"\"&strData1

		printData1 = ""
		If strData1 <> "" And DK_MEMBER_LEVEL >= intData1Level Then
			strDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/data1")&"\"&strData1) / 1024)
			printData1 = printData1&tabs(2)&"<tr>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<th>"&LNG_TEXT_FILE1&"</th>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<td><a href=""javascript:fTrans('"&FN_HR_ENC(strData1)&"','"&FN_HR_ENC("down1")&"');"">"&strData1&"</a>&nbsp;("&strDataSize1&" KB)</td>"
			printData1 = printData1&tabs(2)&"</tr>" &VbCrlf
		End If

		printData2 = ""
		If strData2 <>"" And DK_MEMBER_LEVEL >= intData2Level Then
			strDataSize2 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/data2")&"\"&strData2) / 1024)
			printData2 = printData2&tabs(2)&"<tr>" &VbCrlf
			printData2 = printData2&tabs(2)&"	<th>"&LNG_TEXT_FILE2&"</th>" &VbCrlf
			printData2 = printData2&tabs(2)&"	<td><a href=""javascript:fTrans('"&FN_HR_ENC(strData2)&"','"&FN_HR_ENC("down2")&"');"">"&strData1&"</a>&nbsp;("&strDataSize2&" KB)</td>"
			printData2 = printData2&tabs(2)&"</tr>" &VbCrlf
		End If


		printData3 = ""
		If strData3 <>"" And DK_MEMBER_LEVEL >= intData3Level Then
			strDataSize3 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/data3")&"\"&strData3) / 1024)
			printData3 = printData3&tabs(2)&"<tr>" &VbCrlf
			printData3 = printData3&tabs(2)&"	<th>"&LNG_TEXT_FILE3&"</th>" &VbCrlf
			printData3 = printData3&tabs(2)&"	<td><a href=""javascript:fTrans('"&FN_HR_ENC(strData3)&"','"&FN_HR_ENC("down3")&"');"">"&strData1&"</a>&nbsp;("&strDataSize3&" KB)</td>"
			printData3 = printData3&tabs(2)&"</tr>" &VbCrlf
		End If


'		printPic = ""
'		If isPic = "T" Then
'			printPic = printPic&tabs(2)&"<tr>" &VbCrlf
'			printPic = printPic&tabs(2)&"	<th>썸네일</th>" &VbCrlf
'			printPic = printPic&tabs(2)&"	<td><input type=""file"" name=""strPic"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPicMB&" MB 이하의 gif,jpg,png,bmp)</td>"
'			printPic = printPic&tabs(2)&"</tr>" &VbCrlf
'		End If

'		printLink = ""
		If isLink = "T" And DK_MEMBER_LEVEL >= intLinkLevel Then
			If strBoardType = "gallery2" Then '게시판타입 썸네일리스트일경우 strLink → 짧은 설명 대체(2016-03-24)
				printLink = printLink&tabs(2)&"<tr>" &VbCrlf
				printLink = printLink&tabs(2)&"	<th>"&LNG_MOVIE_WRITE_TEXT05&"</th>" &VbCrlf
				printLink = printLink&tabs(2)&"	<td style=""padding:8px 4px;"">"&strLink&"</td>"
				printLink = printLink&tabs(2)&"</tr>" &VbCrlf
			Else
				printLink = printLink&tabs(2)&"<tr>" &VbCrlf
				printLink = printLink&tabs(2)&"	<th>링크</th>" &VbCrlf
				printLink = printLink&tabs(2)&"	<td>"&strLink&"</td>"
				printLink = printLink&tabs(2)&"</tr>" &VbCrlf
			End If
		End If

%>

<script type="text/javascript" src="/common/SmartEditor/js/HuskyEZCreator.js" charset="euc-kr"></script>
<script type="text/javascript" src="board.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		//현재글 (추천)
		$(document).on("click","#ClickVote",function () {

			var ThisCnt = $(this).closest("div").find("span.vote1");
			var ThisIcon = $(this).closest("div").find("i.voteIcon2");
			$.ajax({
				type: "POST"
				,url: "board_vote.asp"
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
						//alert(rCnt);
						ThisCnt.text(formatComma(rCnt));
						ThisIcon.removeClass("voteIcon2").addClass("voteIcon1");
						//$("#Tcnt").html(formatComma(rCnt));
						//$("#voteArea").html(rMsg);
						return false;
					} else if (rData == 'ERROR2') {
						alert('이미 추천한 게시물입니다.');
						//$("#voteArea").html(rMsg);
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

		$(document).on("click","#ClickBest",function () {

			var ThisIcon1 = $(this).find("i");
			var ThisIcon2 = $(this).find("span");
			$.ajax({
				type: "POST"
				,url: "board_best_ajax.asp"
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
						//alert(rCnt);
						ThisIcon1.removeClass("voteIcon2").addClass("voteIcon1");
						ThisIcon2.removeClass("vote2").addClass("vote1");
						//$("#Tcnt").html(formatComma(rCnt));
						//$("#voteArea").html(rMsg);
						return false;
					} else if (rData == 'SUCCESS2') {
						//alert('현재 게시물을 추천했습니다');
						//alert(rCnt);
						ThisIcon1.removeClass("voteIcon1").addClass("voteIcon2");
						ThisIcon2.removeClass("vote1").addClass("vote2");
						//$("#Tcnt").html(formatComma(rCnt));
						//$("#voteArea").html(rMsg);
						return false;
					}
				}
				,error:function(data){alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);}
			});
		});

		$(document).on("click","#ClickVote_2",function() {

			var ThisCnt = $(this).closest("div").find("span.vote1");
			var ThisIcon = $(this).closest("div");
			var ThisIDX = $(this).closest("div").find("input[name=cVoteIdx]").val();

			$.ajax({
				type: "POST"
				,url: "board_comment_vote.asp"
				,cache : false
				,data: {
					 "ointIDX"		: ThisIDX
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
						alert('현재 게시물을 추천했습니다');
						//$("#voteArea_2"+ointIDX).html(rMsg);
						ThisCnt.text(formatComma(rCnt));
						ThisIcon.find("i.voteIcon2").removeClass("voteIcon2").addClass("voteIcon1");
						return false;
					} else if (rData == 'ERROR2') {
						alert('이미 추천한 게시물입니다.');
						$("#voteArea_2"+ointIDX).html(rMsg);
						return false;
					} else if (rData == 'CANCEL') {
						alert('추천을 취소했습니다.');
						ThisCnt.text(formatComma(rCnt));
						ThisIcon.find("i.voteIcon1").removeClass("voteIcon1").addClass("voteIcon2");
						//$("#voteArea_2"+ointIDX).html(rMsg);
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

		var ThisCnt = $(this).closest("div").find("span.vote1");
		var ThisIcon = $(this).closest("div").find("i.voteIcon2");

		$.ajax({
			type: "POST"
			,url: "board_comment_vote.asp"
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
	/*
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
	*/



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

		// textarea에 입력된 문자의 바이트 수를 체크 S
			function checkByte(frm, limitByte) {
				var totalByte = 0;
				var message = frm.strContent.value;

				for(var i =0; i < message.length; i++) {
					var currentByte = message.charCodeAt(i);
					if(currentByte > 128) {
						totalByte += 2;
					} else {
						totalByte++;
					}
				}
				frm.messagebyte.value = totalByte;

				if(totalByte > limitByte) {
					alert( limitByte+"바이트까지 전송가능합니다.");
					frm.strContent.value = message.substring(0,limitByte);
				}
			}


</script>
</head>
<body>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%Else%>
<!--#include virtual = "/_include/header.asp"-->
<%End If%>
<!--#include file = "_inc_board_top.asp" -->
<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="forum" class="board view">
	<div class="width100">
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="200" />
				<col width="1000" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="2" class="viewSubject"><%=strSubject%></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="borT writer">
						<%=LNG_TEXT_WRITER%> : <span><%=Writer%></span>
					</td>
					<td class="borT date tright"><span><%=regDate%></span></td>
				</tr>
				<tr>
					<td colspan="2" class="contentTD width100">
						<%If isMovie = "T" And movieURL <> "" Then '동영상 추가%>
							<%
								Select Case UCase(movieType)
									Case "Y"
										movieURL = Replace(movieURL,"https://youtu.be","http://www.youtube.com/embed")
									Case "V"
										movieURL = Replace(movieURL,"http://vimeo.com","http://player.vimeo.com/video")
								End Select
							%>

							<div class="tcenter" style="margin-top:20px;"><iframe width="820" height="450" src="<%=movieURL%>" frameborder="0" allowfullscreen></iframe></div><br />
						<%End If%>

						<!-- 이미지 1,2,3 -->
						<%If strPic1 <> "" Then%>
							<div style="padding:20px 0px;" class="tcenter">
								<img src="/upload/board/pic1/<%=strPic1%>" >
							</div>
						<%End If%>
						<%If strPic2 <> "" Then%>
							<div style="padding:20px 0px;">
								<img src="/upload/board/pic1/<%=strPic2%>" >
							</div>
						<%End If%>
						<%If strPic3 <> "" Then%>
							<div style="padding:20px 0px;">
								<img src="/upload/board/pic1/<%=strPic3%>" >
							</div>
						<%End If%>

						<div style="padding:30px 0px;">
							<%=backword_tag(strContent)%>
						</div>

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
							<div class="width100" style="margin:20px 0px 45px 0px; text-align: center;">
								<!-- <div class="fleft" style="width:50%;">
									<span class="heart1"></span><span class="heartTxt" id="Tcnt"><%=num2cur(TotalVoteCnt)%></span>
								</div> -->
								<div class="select_btn">
									<span id="voteArea" class="fright">
										<%
											If DK_MEMBER_ID <> "GUEST" And isVote = "T" Then
												If UCase(DK_MEMBER_ID) = UCase(strUserID) Then
													PRINT "<div style=""border:1px solid #cbcbcb; width:60px; height:50px; "" class=""tcenter"" >"
													PRINT "	<a id="""" class=""ClickVote cp tcenter"" onclick=""alert('본인 게시물은 추천할 수 없습니다.');""><i class=""far fa-thumbs-up voteIcon1""></i><span class=""vote1"">"&num2cur(TotalVoteCnt)&"</span></a>"
													PRINT "	</div>"
												Else
													If ThisVoteCnt > 0 Then
														PRINT "<div style=""border:1px solid #cbcbcb; width:60px; height:50px; "" class=""tcenter"" >"
														PRINT "	<a id=""ClickVote"" class=""ClickVote cp tcenter""><i class=""far fa-thumbs-up voteIcon1""></i><span class=""vote1"">"&num2cur(TotalVoteCnt)&"</span></a>"
														PRINT "	</div>"
													Else
														PRINT "<div style=""border:1px solid #cbcbcb; width:60px; height:50px; "" class=""tcenter"" >"
														PRINT "	<a id=""ClickVote"" class=""ClickVote cp tcenter""><i class=""far fa-thumbs-up voteIcon2""></i><span class=""vote1"">"&num2cur(TotalVoteCnt)&"</span></a>"
														PRINT "	</div>"
													End If
												End If
											End If
										%>
									</span>
								</div>
								<span id="voteArea" class="fright">
								<%
									If isMainView = "T" Then
										bestIconType = "1"
									Else
										bestIconType = "2"
									End If

										If DK_MEMBER_TYPE = "ADMIN" Then
											PRINT "<div style=""border:1px solid #cbcbcb; width:85px; height:50px; "" class=""tcenter"" >"
											PRINT "	<a id=""ClickBest"" class=""ClickBest cp tcenter""><i class=""far fa-kiss-wink-heart voteIcon"&bestIconType&"""></i> <span class=""vote"&bestIconType&""">BEST</span></a>"
											PRINT "	</div>"
										End If
								%>
								</span>
							</div>
						<%End If%>

					</td>
				</tr>
				<%=printHostIP%>
				<%=printEmail%>
				<%=printTel%>
				<%=printMobile%>

				<%=printLink%>
				<%=printPic%>
				<%=printData1%>
				<%=printData2%>
				<%=printData3%>
			</tbody>
		</table>
		<div class="fleft width100" >
			<div class="fleft btn_area" >
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
			</div>
			<div class="fright btn_area" style="width:300px;position:relative;">
			<%If DK_MEMBER_TYPE = "GUEST" And strUserID = "GUEST" Then%>
				<div class="fleft" id="bmodify"  style="position:absolute; z-index:10; top:-50px; left:-80px; background-color:#eee;border:1px solid #ccc;padding:10px; display:none;">
					<form name="mfrm" method="post" action="board_modify.asp?bname=<%=strBoardName%>&amp;num=<%=intIDX%>" onsubmit="return ChkmFrm(this);">
						<%=LNG_TEXT_PASSWORD%> : <input type="password" class="input_text_gr vmiddle" name="strPass" style="width:150px;" /> <input type="image" src="./images/btn_blog06.gif" class="vmiddle" />
					</form>
				</div>
				<div class="fleft" id="bdelete" style="position:absolute; z-index:10; top:-50px; left:-160px; background-color:#eee;border:1px solid #ccc; padding:10px; display:none;">
					<form name="dgfrm" method="post" action="board_delete.asp" onsubmit="return ChkdFrm(this);">
						<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
						<input type="hidden" name="intIDX" value="<%=intIDX%>" />
						<input type="hidden" name="list" value="<%=intList%>" />
						<input type="hidden" name="depth" value="<%=intDepth%>" />
						<input type="hidden" name="ridx" value="<%=intRIDX%>" />
						<%=LNG_TEXT_PASSWORD%> : <input type="password" class="input_text_gr vmiddle" name="strPass" style="width:150px;" /> <input type="image" src="./images/btn_blog05.gif" class="vmiddle" />
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
				<!-- <a href="board_list.asp?bname=<%=strBoardName%><%=getCate%>"><img src="./images/btn_blog02.gif" width="60" height="23" alt="" class="vmiddle" /></a> -->
			</div>
		</div>
	</div>
</div>

<%If isCommentUse = "T" Then%>
	<div id="replyArea">
		<%If DK_MEMBER_LEVEL >= intLevelCommentWrite Then%>
			<div class="reply" style="margin-top:80px;">
				<table <%=tableatt%> style="width:100%;">
					<tr>
						<td class="replayTotal"><span class="tweight font15px">댓글(<%=num2cur(REPLYCNT)%>)</span></td>
					</tr><tr>
						<td>
							<%
								LimitReplyDateTF = "T"

								If NB_isReplyLimitDate = "T" Then
									LimitReplyDateTF = "F"
									If strReplyDateS = "" And strReplyDateE = "" Then LimitReplyDateTF = "T"
									If strReplyDateS <> "" And strReplyDateE <> "" Then
										If DateDiff("d",strReplyDateS,nowDateS) >= 0 And DateDiff("d",strReplyDateE,nowDateS) <= 0 Then
											LimitReplyDateTF = "T"
										End If
									End If
								End If

								ReplyViewContent = "" & _
													"<form name=""rFrm"" action=""replyHandler.asp"" method=""post"" target=""hiddenFrame"" onsubmit=""return rreplychk(this);"">" & _
													"	<input type=""hidden"" name=""mode"" value=""INSERT"" />" & _
													"	<input type=""hidden"" name=""bname"" value="""&strBoardNAme&""" />" & _
													"	<input type=""hidden"" name=""appIDX"" value="""&intIDX&""" />" & _
													"	<div class=""input fleft"" style=""width:100%;"">"
								If DK_MEMBER_TYPE="GUEST" Then
									ReplyViewContent = ReplyViewContent & "" &_
													"<div class=""input1"">"&LNG_TEXT_WRITER&" : <input type=""text"" name=""replyName"" class=""input_text"" style=""width:120px;"" />" & _
													LNG_TEXT_PASSWORD &" : <input type=""password"" name=""replyPass"" class=""input_text"" style=""width:140px;"" /> <label><input type=""checkbox"" name=""replySecret"" class=""input_check"" value=""T"" />" & _
													LNG_BOARD_VIEW_TEXT26 & " </label> <span class=""f8pt"">("&LNG_BOARD_VIEW_TEXT27&")</span> </div>"
								End If
								ReplyViewContent = ReplyViewContent & "" &_
												"		<div class=""tcenter width98 mgcenter"">" &_
												"			<div style=""position:relative; padding-right:85px;width:100%;"">" &_
												"				<textarea name=""strContent"" class=""input_area"" placeholder="""&LNG_BOARD_VIEW_TEXT28&""" onKeyUp=""checkByte(this.form,100);""></textarea>" &_
												"				<input type=""submit"" class=""tcenter replySubmit"" value=""등 록"">" &_
												"			</div>" &_
												"		</div>" &_
												"		<div class=""remainingTXT width98 mgcenter tright"" style=""""><input type=""text"" name=""messagebyte"" value=""0"" maxlength=""3"" readonly=""readonly"" class=""msgBox"">/"&isVoteMaxLength&" byte</div>" &_
												"	</div>" &_
												"</form>"


								If LimitReplyDateTF = "T" Then
									If NB_intReplyLimit > 0 Then
										If NB_REPLY_CNT_CHK < NB_intReplyLimit Then
											PRINT ReplyViewContent
										Else
							%>
								<div class="input fleft" style="width:100%;">
									<div class="tcenter width98 mgcenter">
										<div style="position:relative; padding-right:85px;width:100%;" class="replyInfo">
											해당 게시판은 게시물당 댓글작성이 회원별 <span><%=NB_intReplyLimit%></span>회로 제한되어있습니다.<br />
											<span><%=DK_MEMBER_ID%></span> 회원님은 <span class="text_red"><%=NB_REPLY_CNT_CHK%></span> 회의 댓글을 작성하여 댓글을 작성하실 수 없습니다
										</div>
									</div>
								</div>

							<%
										End If
									Else
										PRINT ReplyViewContent
									End If
								Else
							%>
								<div class="input fleft" style="width:100%;">
									<div class="tcenter width98 mgcenter">
										<div style="position:relative; padding-right:85px;width:100%;" class="replyInfo">
											해당 게시물은 <%=strReplyDateS%> 부터 <%=strReplyDateE%> 까지만 댓글작성이 허용되어있습니다.<br />
										</div>
									</div>
								</div>

							<%
								End If

							%>
						</td>
					</tr>
				</table>
			</div>
		<%End If%>

		<%If DK_MEMBER_LEVEL >= intLevelCommentList Then%>
			<div class="replylist " style="width:100%;margin-top:30px;">
				<!-- <p style="padding:5px 0px;"><%=viewImg("./images/reply_title2.gif",49,13,"")%> <strong>(<%=num2cur(REPLYCNT)%>)</strong></p> -->
				<!-- <table <%=tableatt%> class="userCWidth2" > -->
				<table <%=tableatt%> class="width100" style="margin:0 auto;">
					<col width="*" />
					<col width="90" />
					<%
						SQLC = "SELECT * FROM [DK_NBOARD_COMMENT] WITH(NOLOCK) WHERE [intBoardIDX] = ? AND [intDepth] = 0 ORDER BY [intLIST] ASC, [intIDX] ASC"
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


								If NB_isViewNameType = "N" Then viewNameC = arrListC_strName Else viewNameC = arrListC_strUserID End If
								If UCase(DK_MEMBER_ID) = UCase(arrListC_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Then
									viewNameC = "<span class=""itme"">"&viewNameC&"</span>"
								Else
									If NB_isViewNameChg = "T" Then viewNameC = FNC_ID_CHANGE_STAR(viewNameC,NB_intViewNameCnt)
								End If
								'arrListC_strContent = Replace(arrListC_strContent,"<br />"," ")
								'arrListC_strContent = Replace(arrListC_strContent,"<br/>"," ")
								'arrListC_strContent = Replace(arrListC_strContent,"<br>"," ")

								classed = ""
								'If arrListC_intDepth > 0 Then
								'	cols = "  "
								'Else
								'	PRINT "<col width=""750"" />"
								'	cols = " colspan=""2"" "
								'End If

								'If DK_MEMBER_ID = arrListC_strUserID Then
								'	HIGHLIGHT_NAME = "background: yellow;"
								'Else
								'	HIGHLIGHT_NAME = ""
								'End If

								If arrListC_viewTF = "F" Then
									arrListC_strContent = "<span style=""color:#de2507"">[삭제된 글입니다]</span>"
								End If
					%>
					<tr>
						<td class="rSubject" colspan="2">
							<span class="name"><%=viewNameC%></span><span class="date"><%=arrListC_regDate%></span>
							<span class="btnzone">
								<%If DK_MEMBER_LEVEL > 0 Then		'삭제%>
									<%If (DK_MEMBER_ID = arrListC_strUserID Or DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "SADMIN") And arrListC_viewTF = "T" Then%>
										<button type="button" onclick="javascript:delOk('<%=arrListC_intIDX%>');" class="replyDel cp"><i class="fas fa-times"></i></button>
									<%End If%>
								<%End If%>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rContent">
							<div class="rContentL">
								<%If arrListC_isSecret = "T" Then%>
									<span style="color:#c0c0c0;"><%=LNG_BOARD_VIEW_TEXT29%></span>
									<%If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Or (DK_MEMBER_TYPE = "SADMIN" And UCase(DK_MEMBER_GROUP) <> LOCATIONS) Then%>
										<%=arrListC_strContent%>
									<%End If%>
								<%Else%>
									<%=arrListC_strContent%>
								<%End If%>
							</div>

							<%

								rReplyBtn = "<button type=""button"" class=""reReplyBtn"" style="""&HIGHLIGHT_ANS_BTN&""" value=""답글 "&AnswrTotalCNT&""" onclick=""javascript:reInArea_View('reInArea_"&arrListC_intIDX&"')""> 답글</button>"

								If DK_MEMBER_TYPE = "ADMIN" Then
									PRINT rReplyBtn
								Else
									If NB_isReplyLimitDate = "T" Then '일자 사용 확인
										If LimitReplyDateTF = "T" Then '일자 범위 확인
											If DK_MEMBER_LEVEL > 0 Then '비회원 로직 추후 추가
												If DK_MEMBER_LEVEL >= intLevelCommentReply And arrListC_intDepth = 0 Then '0뎁스 확인 및 쓰기 권한 확인
													If NB_intReplyLimit > 0 Then
														If NB_REPLY_CNT_CHK < NB_intReplyLimit Then
															PRINT rReplyBtn
														End If
													Else
														PRINT rReplyBtn
													End If
												End If
											Else
												'비회원 로직 추후 추가
											End If
										End If
									Else
										If DK_MEMBER_LEVEL > 0 Then '비회원 로직 추후 추가
											If DK_MEMBER_LEVEL >= intLevelCommentReply And arrListC_intDepth = 0 Then '0뎁스 확인 및 쓰기 권한 확인
												If NB_intReplyLimit > 0 Then
													If NB_REPLY_CNT_CHK < NB_intReplyLimit Then
														PRINT rReplyBtn
													End If
												Else
													PRINT rReplyBtn
												End If
											End If
										Else
											'비회원 로직 추후 추가
										End If
									End If
								End If




							%>
						</td>
						<td class="rContent tright">
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
									<%If ThisCommentVoteCnt > 0 Then%>
										<div style="border:1px solid #cbcbcb; width:55px;" class="tcenter" >
											<input type="hidden" name="cVoteIdx" value="<%=arrListC_intIDX%>" />
											<a id="ClickVote_2" class="cp tcenter">
												<i class="far fa-thumbs-up voteIcon1" style=""></i><span class="vote1"><%=num2cur(TotalCommentVoteCnt)%></span>
											</a>
										</div>

										<!-- <a id="ClickVote_2" class="cp ClickVoteT" onclick="thisArticleVote('<%=arrListC_intIDX%>');"><span class="thumbsUp2"></span><span class="heartTxt2_T" style="vertical-align:0px;"><%=num2cur(TotalCommentVoteCnt)%></span></a> -->
									<%Else%>
										<!-- <a id="ClickVote_2" class="cp ClickVoteF" onclick="thisArticleVote('<%=arrListC_intIDX%>');"><span class="thumbsUp3"></span><span class="heartTxt2 red" style="vertical-align:0px;"><%=num2cur(TotalCommentVoteCnt)%></span></a> -->
										<div style="border:1px solid #cbcbcb; width:55px" class="tcenter" >
											<input type="hidden" name="cVoteIdx" value="<%=arrListC_intIDX%>" />
											<a id="ClickVote_2" class="cp tcenter">
												<i class="far fa-thumbs-up voteIcon2" style=""></i><span class="vote1"><%=num2cur(TotalCommentVoteCnt)%></span>
											</a>
										</div>
									<%End If%>
								<%Else%>
									<!-- <span class="heart3"></span><span class="heartTxt2">회원만 추천 가능</span> -->
								<%End If%>
							<%End If%>
						</td>
					</tr><tr>
						<td colspan="2" style="display:none;" name="reInArea" id="reInArea_<%=arrListC_intIDX%>">
							<table <%=tableatt%> style="width:100%;">
								<col width="35" />
								<col width="*" />
								<tr>
									<td class=" vtop"><span class="fright" style="padding-right:5px;font-size:20px;">&#x2937;</span></td>
									<td style="border-left:0px;">
										<div class="reply fright" style="width:100%;padding-right:8px;">
											<form name="rFrm" action="replyHandler.asp" method="post" target="hiddenFrame" onsubmit="return rreplychk(this);">
												<input type="hidden" name="mode" value="REPLY" />
												<input type="hidden" name="appIDX" value="<%=intIDX%>" />
												<input type="hidden" name="bname" value="<%=strBoardName%>" />
												<input type="hidden" name="upIDX" value="<%=arrListC_intIDX%>" />

												<div class="input fleft" style="margin-bottom:15px;">
													<div class="width98 mgcenter">
														<textarea name="strContent" class="input_area2" placeholder="<%=LNG_BOARD_VIEW_TEXT28%>" onKeyUp="checkByte(this.form,100);"></textarea>
														<div class="fright" style="padding:5px 9px 0px 9px;">
															<span class="fright"><input type="submit" class="txtBtnC small gray" value="등 록" /></span>
														</div>
														<div class="remainingTXT fright" style="padding:5px 8px 0px 8px;">
															<input type="text" name="messagebyte" value="0" maxlength="3" readonly="readonly" class="msgBox">/<%=isVoteMaxLength%>
														</div>
													</div>
												</div>
											</form>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr><tr>
						<td class="bor2" colspan="2">
							<%'댓글의 댓글%>
							<div id="replysT<%=arrListC_intIDX%>" name="replysT" style="disp lay:none;">
								<table <%=tableatt%> class="fright" style="width:100%;">
									<colgroup>
										<col width="35" />
										<col width="*" />
									</colgroup>
									<%	'댓글의 댓글보기
										SQLC2 = "SELECT * FROM [DK_NBOARD_COMMENT] WITH(NOLOCK) WHERE [intBoardIDX] = ? AND [intList] = ? AND  [intDepth] > 0 ORDER BY [intLIST] ASC, [intIDX] ASC"
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
												If NB_isViewNameType = "N" Then viewNameC2 = arrListC2_strName Else viewNameC2 = arrListC2_strUserID End If
												If UCase(DK_MEMBER_ID) = UCase(arrListC2_strUserID) Or DK_MEMBER_TYPE = "ADMIN" Then
													viewNameC2 = "<span class=""itme"">"&viewNameC2&"</span>"
												Else
													If NB_isViewNameChg = "T" Then viewNameC2 = FNC_ID_CHANGE_STAR(viewNameC2,NB_intViewNameCnt)
												End If
												classed = ""
												'If arrListC2_intDepth > 0 Then
												'	cols = "  "
												'Else
												'	PRINT "<col width=""750"" />"
												'	cols = " colspan=""2"" "
												'End If


												'If DK_MEMBER_ID = arrListC2_strUserID Then
												'	HIGHLIGHT_NAME = "background: yellow;"
												'Else
												'	HIGHLIGHT_NAME = ""
												'End If
												If arrListC2_viewTF = "F" Then
													arrListC2_strContent = "<span style=""color:#de2507"">[삭제된 글입니다]</span>"
												End If

									%>
									<tr>
										<td class="rrBGC"><span class="fright" style="padding-right:5px;font-size:20px;">&#x2937;</span></td>
										<td class="rrBGC">
											<span class="name" style="<%=HIGHLIGHT_NAME%>"><%=viewNameC2%></span><span class="date"><%=arrListC2_regDate%></span>
											<span class="btnzone">
												<%If DK_MEMBER_LEVEL > 0 Then	'삭제%>
													<%If (DK_MEMBER_ID = arrListC2_strUserID Or DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "SADMIN") And (arrListC2_viewTF = "T") Then%>
														<button type="button" onclick="javascript:delOk('<%=arrListC2_intIDX%>');" class="replyDel cp"><i class="fas fa-times"></i></button>
													<%End If%>
												<%End If%>
											</span>
										</td>
									</tr><tr>
										<td class=""></td>
										<td class="">
											<p class="rrContent">
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
										End If
									%>


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
	</div>




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
			PREV_ID			= DKRS(4)
			PREV_SUBJECT = "<a href=""board_view.asp?bname="&strBoardName&"&amp;num="&PREV_IDX&getCate&""">"&backword_title(PREV_SUBJECT)&"</a>"

			If NB_isViewNameType = "N" Then viewNameP = PREV_NAME Else viewNameP = PREV_ID End If
			If UCase(DK_MEMBER_ID) = UCase(PREV_ID) Or DK_MEMBER_TYPE = "ADMIN" Then
				viewNameP = "<span class=""itme"">"&viewNameP&"</span>"
			Else
				If NB_isViewNameChg = "T" Then viewNameP = FNC_ID_CHANGE_STAR(viewNameP,NB_intViewNameCnt)
			End If
		Else
			PREV_IDX		= ""
			PREV_SUBJECT	= LNG_BOARD_VIEW_TEXT32
			PREV_NAME		= ""
			PREV_DATE		= ""
			PREV_ID			= ""
		End If
		Call closeRS(DKRS)

		Set DKRS = Db.execRs("DKP_NBOARD_NEXT_CONTENT",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			NEXT_IDX		= DKRS(0)
			NEXT_SUBJECT	= DKRS(1)
			NEXT_NAME		= DKRS(2)
			NEXT_DATE		= Left(DKRS(3),10)
			NEXT_ID			= DKRS(4)
			NEXT_SUBJECT = "<a href=""board_view.asp?bname="&strBoardName&"&amp;num="&NEXT_IDX&getCate&""">"&backword_title(NEXT_SUBJECT)&"</a>"

			If NB_isViewNameType = "N" Then viewNameN = NEXT_NAME Else viewNameN = NEXT_ID End If
			If UCase(DK_MEMBER_ID) = UCase(NEXT_ID) Or DK_MEMBER_TYPE = "ADMIN" Then
				viewNameN = "<span class=""itme"">"&viewNameN&"</span>"
			Else
				If NB_isViewNameChg = "T" Then viewNameN = FNC_ID_CHANGE_STAR(viewNameN,NB_intViewNameCnt)
			End If
		Else
			NEXT_IDX		= ""
			NEXT_SUBJECT	= LNG_BOARD_VIEW_TEXT33
			NEXT_NAME		= ""
			NEXT_DATE		= ""
			NEXT_ID			= ""
		End If
		Call closeRS(DKRS)


	%>
	<table <%=tableatt%> class="width100">
		<colgroup>
			<col width="100" />
			<col width="*" />
			<col width="100" />
			<col width="100" />
		</colgroup>
		<tr>
			<td class="tit"><%=LNG_BOARD_VIEW_TEXT34%></td>
			<td class="subject"><%=NEXT_SUBJECT%></td>
			<td><%=viewNameN%></td>
			<td><%=NEXT_DATE%></td>
		</tr><tr>
			<td class="tit"><%=LNG_BOARD_VIEW_TEXT35%></td>
			<td class="subject"><%=PREV_SUBJECT%></td>
			<td><%=viewNameP%></td>
			<td><%=PREV_DATE%></td>
		</tr>
	</table>
</div>


<form name="dFrm" action="replyHandler.asp" method="post" target="hiddenFrame">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="appIDX" value="" />
	<input type="hidden" name="bname" value="<%=strBoardName%>" />
</form>
<form name="w_form" method="post" action="">
	<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
	<input type="hidden" name="intIDX" value="<%=intIDX%>" />
	<input type="hidden" name="list" value="<%=intList%>" />
	<input type="hidden" name="depth" value="<%=intDepth%>" />
	<input type="hidden" name="ridx" value="<%=intRIDX%>" />
</form>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
<%Else%>
<!--#include virtual = "/_include/copyright.asp"-->
<%End If%>
