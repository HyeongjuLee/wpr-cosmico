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

		intContentMinLimit	= DKRS("intContentMinLimit")
		intReplyMinLimit	= DKRS("intReplyMinLimit")
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

<%=CONST_SmartEditor_JS%>
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
<div id="forum" class="view">
	<div class="width100">
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="*" />
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
					<td class="borT date" align="right"><span><%=regDate%></span></td>
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
							<%=backword_title(strContent)%>
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
										If DK_MEMBER_ID <> "GUEST" And isCommentUse = "T" And isVote = "T" Then
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
	</div>
</div>

<%
	'BTN_CLICK_REPLY  = aImgOpt("javascript:repFrm('"&intIDX&"')","S","images/btn_blog07.gif",60,23,"","")
	'BTN_CLICK_REPLY  = "<input type=""button"" class=""input_submit design3"" value="""&LNG_BOARD_BTN_REPLY&""" onclick=""javascript:repFrm('"&intIDX&"')""/>"

	ReplyCnt = 0
	arrParams3 = Array(_
		Db.makeParam("@intList",adInteger,adParamInput,0,intList) _
	)
	ReplyCnt_T = CDbl(Db.execRsData("DKSP_NBOARD_KIN_LIST_DATA_T_COUNT",DB_PROC,arrParams3,Nothing))
	'리플중 답변선택한 내용이 있는지 확인
	REPLY_WRITE_TF = "T"
	If ReplyCnt_T > 0 Then '리플중 답변을 선택한 게시물이라면
		REPLY_WRITE_TF = "F"
	End If



	arrParams3 = Array(_
		Db.makeParam("@intList",adInteger,adParamInput,0,intList), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
	)
	ReplyCnt_M = CDbl(Db.execRsData("DKSP_NBOARD_KIN_DATA_COUNT_MEMBER",DB_PROC,arrParams3,Nothing))
	If ReplyCnt_M > 0 Then '
		REPLY_WRITE_TF = "F"
	End If
	If UCase(DK_MEMBER_ID) = UCase(strUserID) Then REPLY_WRITE_TF = "F"

	If REPLY_WRITE_TF = "T" Then
%>
	<script type="text/javascript">
		function replyView() {
			$(".kin_reply_area").toggle();
		}
		function refrmCheck(f) {
			oEditors.getById["ir2"].exec("UPDATE_CONTENTS_FIELD", []);
			if(!chkNull(f.content1, "<%=LNG_JS_CONTENTS%>")) return false;

			//Editor 공백체크 추가
			let content = document.getElementById("ir2").value;
			content = content.replace(/&nbsp;/gi,"");
			content = content.replace(/<br>/gi,"");
			content = content.replace(/ /gi,"");
			content = content.replace(/<p>/gi,"");
			content = content.replace(/<\/p>/gi, "");
			content = content.replace(/<spanstyle="color:#888;">/gi, "");
			content = content.replace(/<span>/gi, "");
			//console.log(content);

			if (content == "<p></p>" || content == "" || content == "</span>")
			{
				alert("<%=LNG_JS_CONTENTS%>");
				return false;
			}

			if (checkDataImages(form.content1.value)) {
				alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
				return false;
			}

		/* 최저 글자수 확인 S */
			<%IF intReplyMinLimit > 0 THEN%>
			chkTextMin = f.content1.value.replace(/(<([^>]+)>)/ig,"");
			var chkTextCnt = chkTextMin.length;
			if (chkTextCnt < <%=intReplyMinLimit%>) {
				alert("해당 게시판의 입력 최저 글자수는 "+<%=intReplyMinLimit%>+"글자 입니다\n현재 입력된 글자수는 "+chkTextCnt+"글자 입니다.");
				return false;
			}
			//return false;
			<%END IF%>
		/* 최저 글자수 확인 E */

		}

	</script>
	<div class="kin_reply_T">
		<div class="kin_reply_title">답변하기</div>
		<div class="kin_reply_area">
			<form name="reFrm" action="boardHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return refrmCheck(this)">
				<input type="hidden" name="mode" value="REPLY" />
				<input type="hidden" name="intIDX" value="<%=intIDX%>" />
				<input type="hidden" name="strUserID" value="<%=DK_MEMBER_ID%>" />
				<input type="hidden" name="strName" value="<%=DK_MEMBER_NAME%>" />
				<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
				<input type="hidden" name="strDomain" value="<%=LOCATIONS%>" />
				<input type="hidden" name="intList" value="<%=intList%>" />
				<input type="hidden" name="intDepth" value="<%=intDepth%>" />
				<input type="hidden" name="intRIDX" value="<%=intRIDX%>" />
				<input type="hidden" name="strSubject" value="<%=intIDX%> 답변" />
				<input type="hidden" name="PB" value="view" />

				<input type="hidden" id="WYG_MOD" name="WYG_MOD" value="T" />
				<textarea name="content1" id="ir2" style="width:100%;height:250px;min-width:610px;display:none;" cols="50" rows="10"><%=backword(defaultWord1)%></textarea>
				<input type="hidden" name="firstChk" value="T" />
				<%=FN_Print_SmartEditor("ir2","board_content",UCase(DK_MEMBER_NATIONCODE),"","","")%>

				<%IF intReplyMinLimit > 0 THEN%>
				<div class="tcenter" style="color:#ff0000; border-top:1px solid #dedede;border-bottom:1px solid #dedede; padding:5px 0px;">답변의 경우 최소 <%=num2cur(intReplyMinLimit)%> 글자 수 제한이 있습니다.</div>
				<%End If%>
				<div class="tcenter" style="padding:4px 0px;"><input type="submit" class="input_submit design1" value="작성완료" /></div>
			</form>
		</div>
	</div>

<%Else%>
	<div class="kin_reply_F">본인질문 혹은 답글을 작성하셨거나 이미 질문에 대한 답변이 채택된 게시글입니다</div>
<%End If%>
<script type="text/javascript">
		function replySelect(idx) {
			if (confirm('해당 답변을 채택하시겠습니까? \n답변선택후에는 다른 답변을 채택할 수 없습니다.'))
			{
				var f = document.rs_frm;
				f.replyIdx.value = idx;
				f.submit();
			}
		}
</script>
<div class="kin_reply_list">
<%
	arrParams3 = Array(_
		Db.makeParam("@intList",adInteger,adParamInput,0,intList), _
		Db.makeParam("@isKinSelect",adChar,adParamInput,1,"T") _
	)
	arrList3 = Db.execRsList("[DKSP_NBOARD_REPLY_LIST_KIN]",DB_PROC,arrParams3,listLen3,Nothing)

	If IsArray(arrList3) Then
		For k = 0 To listLen3
			arrList3_intIDX			= arrList3(1,k)
			arrList3_intNum			= Int(arrList3(2,k))
			arrList3_intList		= arrList3(3,k)
			arrList3_intDepth		= Int(arrList3(4,k))
			arrList3_intRIDX		= arrList3(5,k)
			arrList3_strUserID		= arrList3(6,k)
			arrList3_strName		= arrList3(7,k)
			arrList3_regDate		= arrList3(8,k)

			arrList3_strContent		= arrList3(12,k)

%>
	<div class="reply_for selected">
		<div class="answer">
			<div class="aSubject">
				<span class="name"><%=arrList3_strName%></span>
				<span class="date"><%=arrList3_regDate%></span>
			</div>

			<div class="aContent">
				<div class="answerG">질문자가 채택한 답변입니다</div>
				<div class="answerText">
					<%=backword_tag(arrList3_strContent)%>
				</div>
			</div>
		</div>
	</div>

<%

		Next
	End If

%>

<%
	arrParams3 = Array(_
		Db.makeParam("@intList",adInteger,adParamInput,0,intList), _
		Db.makeParam("@isKinSelect",adChar,adParamInput,1,"F") _
	)
	arrList3 = Db.execRsList("[DKSP_NBOARD_REPLY_LIST_KIN]",DB_PROC,arrParams3,listLen3,Nothing)

	If IsArray(arrList3) Then
		For k = 0 To listLen3
			arrList3_intIDX			= arrList3(1,k)
			arrList3_intNum			= Int(arrList3(2,k))
			arrList3_intList		= arrList3(3,k)
			arrList3_intDepth		= Int(arrList3(4,k))
			arrList3_intRIDX		= arrList3(5,k)
			arrList3_strUserID		= arrList3(6,k)
			arrList3_strName		= arrList3(7,k)
			arrList3_regDate		= arrList3(8,k)
			arrList3_readCnt		= arrList3(9,k)
			arrList3_editDate		= arrList3(10,k)
			arrList3_strSubject		= arrList3(11,k)
			arrList3_strContent		= arrList3(12,k)
			arrList3_strData1		= arrList3(13,k)
			arrList3_strData2		= arrList3(14,k)
			arrList3_strData3		= arrList3(15,k)
			arrList3_isSecret		= arrList3(16,k)
			arrList3_TOTALSCORE		= arrList3(17,k)
			arrList3_isIDImg		= arrList3(18,k)
			arrList3_imgPath		= arrList3(19,k)
			arrList3_VOTECNT		= arrList3(20,k)

			ATTRIBUTE = ""
			If DK_MEMBER_TYPE = "ADMIN" Then
			'	ATTRIBUTE = "class=""cp"" onclick=""viewMiniMemo('memMenu','"&arrList3_intIDX&"',event);"""
			End If

			arrParams4 = Array(_
				Db.makeParam("@strMatchingID",adVarChar,adParamInput,100,arrList3_strName) _
			)
			WriterImg = Db.execRsData("DKP_NBOARD_WRITER_IMG",DB_PROC,arrParams4,Nothing)

			If WriterImg = "" Or IsNull(WriterImg) Then
				arrList3_strName = "<a "&ATTRIBUTE&">"&arrList3_strName&"</a>"
			Else
				imgPath = VIR_PATH("matching")&"/"&WriterImg
				imgWidth = 0
				imgHeight = 0
				Call ImgInfo(imgPath,imgWidth,imgHeight,"")
				arrList3_strName = viewImgOpt(imgPath,imgWidth,imgHeight,"",ATTRIBUTE)
			End If


			'arrList3_regDate = Replace(Left(arrList3_regDate,10),"-",".")

			DataCnt		= 0
			ico_data	= ""
			ico_secret	= ""

			If isCommentUse = "T" Then
				comment_Cnt = arrList3_TOTALSCORE
				If comment_Cnt = 0 Or IsNull(comment_Cnt) Then
					comment_Cnt = ""
				Else
					comment_Cnt = "<span class=""cnt"">(<strong>"&comment_Cnt&"</strong>)</span>"
				End If
			Else
				comment_Cnt =""
			End If

			If arrList3_strData1 = "" Or IsNull(arrList3_strData1) Then DataCnt1 = 0 : Else DataCnt1 = 1
			If arrList3_strData2 = "" Or IsNull(arrList3_strData2) Then DataCnt2 = 0 : Else DataCnt2 = 1
			If arrList3_strData3 = "" Or IsNull(arrList3_strData3) Then DataCnt3 = 0 : Else DataCnt3 = 1

			DataCnt = DataCnt1 + DataCnt2 + DataCnt3
			'PRINT arrList3_isSecret

			If DataCnt > 0 Then ico_data = "<img src=""./images/files.gif"" width=""10"" height=""10"" class=""vmiddle"" alt="""&LNG_BOARD_TYPE_BOARD_TEXT08&"."" /> "
			If arrList3_isSecret = "T" Then
				ico_secret = "<img src=""./images/lock.gif"" width=""21"" height=""13"" alt=""비밀글입니다."" style=""vertical-align:middle;"" />"
			End If
			numView = ""
			If arrList3_intNum <> 0 Then numView = arrList3_intNum



%>
	<div class="reply_for">
		<div class="answer">
			<div class="aSubject">
				<span class="name"><%=arrList3_strName%></span>
				<span class="date"><%=arrList3_regDate%></span>
			</div>

			<div class="aContent">
				<div class="answerText">
					<%=backword_tag(arrList3_strContent)%>
					<%If ReplyCnt_T < 1 Then%>
						<%If UCase(DK_MEMBER_ID) = UCase(strUserID) Or DK_MEMBER_TYPE="ADMIN" Then%>
							<div class="answerTbtn"><button type="button" class="Tbtn" onclick="replySelect('<%=arrList3_intIDX%>');">답변 채택</button></div>
						<%End If%>
					<%End If%>
				</div>
			</div>
		</div>
	</div>

<%

		Next
	End If

%>
<form name="rs_frm" action="type_board_kin_handler.asp" method="post">
	<input type="hidden" name="bidx" value="<%=intIDX%>" />
	<input type="hidden" name="replyIdx" value="" />
</form>

</div>

		<div class="fleft width100" >
			<div class="fleft btn_area" >

			</div>
			<div class="fright btn_area tright" style="width:300px;position:relative;">
			<%If DK_MEMBER_TYPE = "GUEST" And strUserID = "GUEST" Then%>
				<div class="fleft" id="bmodify"  style="position:absolute; z-index:10; top:10px; left:-230px; background-color:#eee;border:1px solid #ccc;padding:10px; display:none;">
					<form name="mfrm" method="post" action="board_modify.asp?bname=<%=strBoardName%>&amp;num=<%=intIDX%>" onsubmit="return ChkmFrm(this);">
						<%=LNG_TEXT_PASSWORD%> : <input type="password" class="input_text_gr vmiddle" name="strPass" style="width:150px;" /> <input type="image" src="./images/btn_blog06.gif" class="vmiddle" />
					</form>
				</div>
				<div class="fleft" id="bdelete" style="position:absolute; z-index:10; top:10px; left:-230px; background-color:#eee;border:1px solid #ccc; padding:10px; display:none;">
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
							BTN_CLICK_DELETE  = "<input type=""button"" class=""input_submit design4"" value="""&LNG_BOARD_BTN_DELETE&""" onclick=""javascript:delFrm('"&intIDX&"');""/>"
							BTN_CLICK_MODIFY  = "<input type=""button"" class=""input_submit design1"" value="""&LNG_BOARD_BTN_MODIFY&""" onclick=""location.href='board_modify.asp?bname="&strBoardName&"&amp;num="&intIDX&"'""/>"
							'BTN_CLICK_DELETE  = aImgOpt("javascript:delFrm('"&intIDX&"');","","images/btn_blog05.gif",60,23,"","class=""vmiddle""")
							'BTN_CLICK_MODIFY  = aImgOpt("board_modify.asp?bname="&strBoardName&"&amp;num="&intIDX,"S","images/btn_blog06.gif",60,23,"","class=""vmiddle""")
						Case "GUEST"
							If strUserID = "GUEST" Then
								BTN_CLICK_DELETE  = "<input type=""button"" class=""input_submit design4"" value="""&LNG_BOARD_BTN_DELETE&""" onclick=""javascript:onoffabs('bdelete','bmodify');""/>"
								BTN_CLICK_MODIFY  = "<input type=""button"" class=""input_submit design1"" value="""&LNG_BOARD_BTN_MODIFY&""" onclick=""javascript:onoffabs('bmodify','bdelete');""/>"
								'BTN_CLICK_DELETE  = aImgOpt("javascript:onoffabs('bdelete','bmodify');","","images/btn_blog05.gif",60,23,"","class=""vmiddle""")
								'BTN_CLICK_MODIFY  = aImgOpt("javascript:onoffabs('bmodify','bdelete');","S","images/btn_blog06.gif",60,23,"","class=""vmiddle""")
							End If
					End Select
					' 수정/삭제 확인
					Select Case DK_MEMBER_TYPE
						Case "MEMBER","COMPANY"
							If DK_MEMBER_LEVEL >= intLevelWrite And DK_MEMBER_ID = strUserID Then
								PRINT TABS(3)& BTN_CLICK_DELETE '&" "& BTN_CLICK_MODIFY
							End If
						Case "GUEST"
							If DK_MEMBER_LEVEL >= intLevelWrite And strUserID = "GUEST" Then
								PRINT TABS(3)& BTN_CLICK_DELETE '&" "& BTN_CLICK_MODIFY
							End If
						Case "ADMIN","OPERATOR"
							PRINT TABS(3)& BTN_CLICK_DELETE '&" "& BTN_CLICK_MODIFY
						Case "SADMIN"
							If UCase(DK_MEMBER_GROUP) = LOCATIONS Then
								PRINT TABS(3)& BTN_CLICK_DELETE '&" "& BTN_CLICK_MODIFY
							Else
								If DK_MEMBER_LEVEL >= intLevelWrite And DK_MEMBER_ID = strUserID Then
									PRINT TABS(3)& BTN_CLICK_DELETE '&" "& BTN_CLICK_MODIFY
								End If
							End If
					End Select
				%>
				<input type="button" class="input_submit design2" value="<%=LNG_BOARD_BTN_LIST%>" onclick="location.href='board_list.asp?bname=<%=strBoardName%><%=getCate%>'" />
				<!-- <a href="board_list.asp?bname=<%=strBoardName%><%=getCate%>"><img src="./images/btn_blog02.gif" width="60" height="23" alt="" class="vmiddle" /></a> -->
			</div>
		</div>



<div class="prenext">
	<%
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
			Db.makeParam("@strDomain",adVarChar,adParamInput,20,LOCATIONS), _
			Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) ,_
			Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
			Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG) _
		)
		Set DKRS = Db.execRs("[DKSP_NBOARD_PREV_CONTENT_DEPTH0]",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			PREV_IDX		= DKRS(0)
			PREV_SUBJECT	= DKRS(1)
			PREV_NAME		= DKRS(2)
			PREV_DATE		= Left(DKRS(3),10)
			PREV_SUBJECT = "<a href=""board_view_kin.asp?bname="&strBoardName&"&amp;num="&PREV_IDX&getCate&""">"&backword_title(PREV_SUBJECT)&"</a>"
		Else
			PREV_IDX		= ""
			PREV_SUBJECT	= LNG_BOARD_VIEW_TEXT32
			PREV_NAME		= ""
			PREV_DATE		= ""
		End If
		Call closeRS(DKRS)

		Set DKRS = Db.execRs("[DKSP_NBOARD_NEXT_CONTENT_DEPTH0]",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			NEXT_IDX		= DKRS(0)
			NEXT_SUBJECT	= DKRS(1)
			NEXT_NAME		= DKRS(2)
			NEXT_DATE		= Left(DKRS(3),10)
			NEXT_SUBJECT = "<a href=""board_view_kin.asp?bname="&strBoardName&"&amp;num="&NEXT_IDX&getCate&""">"&backword_title(NEXT_SUBJECT)&"</a>"
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
			<col width="90" />
			<col width="80" />
		</colgroup>
		<tr>
			<td class="tit"><%=LNG_BOARD_VIEW_TEXT34%></td>
			<td class="subject"><%=NEXT_SUBJECT%></td>
			<td><%=NEXT_NAME%></td>
			<td><%=NEXT_DATE%></td>
		</tr><tr>
			<td class="tit"><%=LNG_BOARD_VIEW_TEXT35%></td>
			<td class="subject"><%=PREV_SUBJECT%></td>
			<td><%=PREV_NAME%></td>
			<td><%=PREV_DATE%></td>
		</tr>
	</table>
</div>


<form name="dFrm" action="replyHandler.asp" method="post" target="hiddenFrame">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="appIDX" value="" />
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
