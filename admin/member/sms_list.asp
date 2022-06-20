<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	'INFO_MODE = "MEMBER1-5"


	Dim strCate, strType
	strCate = gRequestTF("cate", True)
%>
<!--#include file = "smsCONFIG.asp"-->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	'한국만 선택
	Call FN_KR_LANG_ONLY()

' ===================================================================
' 데이터 가져오기
' ===================================================================
	SELECT_SQL = " SELECT strSubject, smsContent, strImg, kakaoTemplatecode, kakaoButtonJson  FROM DK_SMS_CONTENT WHERE delTF = 'F' "
	SELECT_SQL = SELECT_SQL & " AND strCate = ? "
	arrParams = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
	Set DKRS = Db.execRs(SELECT_SQL,DB_TEXT,arrParams,DB3)

	If Not DKRS.EOF And Not DKRS.BOF Then
		strSubject = DKRS("strSubject")
		smsContent = DKRS("smsContent")
		If PPURIO_USE_TF = "T" And PPURIO_MMS_TF = "T" Then
			strImg = DKRS("strImg")
		Else
			strImg = ""
		End If
		If PPURIO_USE_TF = "T" Then
			kakaoTemplatecode = DKRS("kakaoTemplatecode")
			kakaoButtonJson = DKRS("kakaoButtonJson")
		End If

	Else
		smsContent = ""
		strImg = ""
	End If
' ===================================================================

%>
<link rel="stylesheet" href="/admin/css/member.css" />
<style>
	.btns {display:block; line-height:30px; height:30px; width:90px; border-radius:5px; text-align:center; float: left;}
	.btns.color1 {background-color:#4f47f1; font-size:13px; font-weight:300; color:#fff;}
	.btns.color2 {background-color:#474747; font-size:13px; font-weight:300; color:#fff;}
	.mg10 {margin-right:10px;}

		/* loading */
	.loadingsA {position: fixed; height: 100%; width: 100%; background:url(/images_kr/join/loading_bg70_1.png) 0 0 repeat; z-index:999; display: none; top: 0px; left: 0px;}
	.loadingsInnerA {position: relative; top:40%; text-align:center;}
</style>
<script type="text/javascript">
	var strSubjectInit = "";
	var smsContentInit = "";
	var kakaoTemplatecodeInit = "";
	var kakaoButtonJsonInit = "";

	$(function(){
		$("#btnSubmit").on("click", fnSmsSubmit);
		$("#btnInit").on("click", fnSmsInit);

		strSubjectInit = $("#strSubject").val();
		smsContentInit = $("#smsContent").val();
		smsImageInit = $("#result_image").html();
		smsStrImgInit = $("#strImg").val();
		kakaoTemplatecodeInit = $("#kakaoTemplatecode").val();
		kakaoButtonJsonInit = $("#kakaoButtonJson").val();
	});

	//뿌리오 MMS 이미지 삭제
	function fnSmsImgDel(){
		var strImg = $("#strImg").val();
		var askYn = confirm("이미지를 삭제하시겠습니까");
		if (askYn) {
			$.ajax({
				type: "post",
				url: "smsImgDel.asp",
				data : {
					"strCate" : '<%=strCate%>',
					"strImg" : strImg
				},
				dataType: 'json',
				beforeSend: function(){
					$("#btnSubmit").off("click");
				},
				complete : function(){
					$("#btnSubmit").on("click", fnSmsSubmit);
				},
				success: function(data) {
					alert(data.resultMsg);
					$("#strImg").val('');
					$("#result_image").html('');
					return false;
				},
				error:function(data) {
					alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText);
					$("#loadingsA").hide();
					return false;
				}
			});
		}
	}

	function fnSmsInit(){
		$("#strSubject").val(strSubjectInit);
		$("#smsContent").val(smsContentInit);
		$("#result_image").html(smsImageInit);
		$("#strImg").val(smsStrImgInit);
		$("#kakaoTemplatecode").val(kakaoTemplatecodeInit);
		$("#kakaoButtonJson").val(kakaoButtonJsonInit);
	}

	function fnSmsSubmit(){
		var strSubject = $("#strSubject").val();
		var smsContent = $("#smsContent").val();

		var kakaoTemplatecode = $("#kakaoTemplatecode").val();
		var kakaoButtonJson = $("#kakaoButtonJson").val();
		//뿌리오 MMS 이미지
		var strImg = $("#strImg").val();

		if ($.trim(strSubject) == ""){
			alert("MMS 제목을 입력 해 주세요.\n(※ MMS 전송시 입력됩니다.)");
			$("#strSubject").focus();
			return false;
		}
		if ($.trim(smsContent) == ""){
			alert("<%=THIS_SUBJECT%> 메세지 내용을 입력해 주세요.");
			$("#smsContent").focus();
			return false;
		}
		<%If strType_at = "T" Then%>
		if ($.trim(kakaoTemplatecode) == ""){
			alert("카카오 템플릿코드를 입력해주세요.");
			$("#kakaoTemplatecode").focus();
			return false;
		}
		if ($.trim(kakaoButtonJson) == ""){
			alert("kakao button json형식의 배열값을 입력해주세요.");
			$("#kakaoButtonJson").focus();
			return false;
		}
		if (!IsJsonString(kakaoButtonJson)){
			alert("json Syntax Error!! \n\nkakao 버튼의 정확한 json 규칙을 확인해주세요.");
			return false;
		}
		//버튼 json 연속된공백 하나의 공백처리
		/*
			kakaoButtonJson = kakaoButtonJson.replace(/ +/g, " ");
			$("#kakaoButtonJson").val(kakaoButtonJson);
			console.log( kakaoButtonJson );
		*/
		<%End If%>

		$.ajax({
			type: "post",
			url: "smsSaveProc.asp",
			data : {
				"strSubject" : strSubject,
				"smsContent" : smsContent,
				"strCate" : '<%=strCate%>',
				"kakaoTemplatecode" : kakaoTemplatecode,
				"kakaoButtonJson" : kakaoButtonJson,
				"strImg" : strImg
			},
			dataType: 'json',
			beforeSend: function(){
				$("#btnSubmit").off("click");
				$("#loadingsA").show();
			},
			complete : function(){
				$("#btnSubmit").on("click", fnSmsSubmit);
				$("#loadingsA").hide();
			},
			success: function(data) {
				alert(data.resultMsg);
				strSubjectInit = strSubject;
				smsContentInit = smsContent;
				return false;
			},
			error:function(data) {
				alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText);
				$("#loadingsA").hide();
				return false;
			}
		});
	}

	function IsJsonString(str) {
		try {
			var json = JSON.parse(str);
			return (typeof json === 'object');
		} catch (e) {
			return false;
		}
	}
</script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="loadingsA" class="loadingsA">
	<div class="loadingsInnerA">
		<img src="<%=IMG%>/159.gif" width="60" alt="" />
	</div>
</div>
<div id="member" class="member_list fleft" style="width:49%;">
	<p class="titles"><%=THIS_SUBJECT%> 메시지<p>
	<table <%=tableatt%> class="width100">
		<col width="120" />
		<col width="" />
		<tr>
			<th colspan="2">메세지</th>
		</tr>
		<tr>
			<td colspan="2" style="height: 380px; padding:10px;">
				<textarea style="width:100%; height:100%; width: 100%; border: none; resize: none;" id="smsContent"><%=smsContent%></textarea>
			</td>
		</tr>
		<tr>
			<th>MMS 제목</th>
			<td>
				<input type="text" name="strSubject" id="strSubject" class="input_text width100" value="<%=strSubject%>" maxlength="60" />
				<span>mms 전송시 필수값</span>
			</td>
		</tr>

		<%If PPURIO_USE_TF = "T" And PPURIO_MMS_TF = "T" And strType_at <> "T" Then%>
		<tr>
			<th rowspan="2">MMS 이미지 등록</th>
			<td>
				<a name="modal" href="/admin/member/sms_fileup.asp" title="MMS File Upload"><input type="button" class="a_submit design3" value="등록/수정" /></a>
				<span id="result_image">
					<%If strImg <> "" Then%>
						<img src="<%=IMG_ICON%>/icon_picT.gif" alt="" class="vmiddle" /> <span><a href="<%=VIR_PATH("MMS_T")%>/<%=strImg%>" target="_blank" class="strImg"><%=strImg%></a></span>
						<input type="button" class="a_submit design2" id="delete Img" onclick="fnSmsImgDel();" value="삭제" />
					<%End If%>
				</span>
				<input type="hidden" name="strImg" id="strImg" value="<%=strImg%>" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td>
				<span class="alert red">※ 이미지 첨부시 mms 전송 처리됩니다.</span>
			</td>
		</tr>
		<%Else%>
			<span id="result_image"></span>
			<input type="hidden" name="strImg" id="strImg" value="" readonly="readonly" />
		<%End If%>

		<!-- <tr>
			<td colspan="2" style="border-left:0px; border-right:0px; border-bottom:0px; padding-top: 20px;">
				<span class="btns color1 cp" id="btnSubmit">등록/수정</span>
				<span class="btns color2 mg10 cp" id="btnInit">초기화</span>
			</td>
		</tr> -->
	</table>
</div>
<div id="member" class="member_list fright" style="width:49%;">
	<p class="titles">고정 메시지 코드<p>
	<table <%=tableatt%> class="width100">
		<col width="50" />
		<col width="120" />
		<col width="120" />
		<tr>
			<th>No</th>
			<th>메세지 코드</th>
			<th>메세지 코드 명</th>
		</tr>
		<%
			'SELECT_SQL = " SELECT intIDX, smsCode, codeName FROM DK_SMS_CODE WHERE delTF = 'F' ORDER BY codeName ASC "
			SELECT_SQL = " SELECT intIDX, smsCode, codeName FROM DK_SMS_CODE WHERE delTF = 'F' ORDER BY intIDX ASC "
			arrList = Db.execRsList(SELECT_SQL,DB_TEXT,Nothing,listLen,DB3)

			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX 		= arrList(0, i)
					arrList_smsCode 	= arrList(1, i)
					arrList_codeName 	= arrList(2, i)

					PRINT "<tr>"
					'PRINT "	<td class=""tcenter"">"&((listLen + 1) - i)&"</td>"
					PRINT "	<td class=""tcenter"">"& arrList_intIDX &"</td>"
					PRINT "	<td class=""tcenter"">"& arrList_smsCode &"</td>"
					PRINT "	<td class=""tcenter"">"& arrList_codeName &"</td>"
					PRINT "</tr>"
				Next
			Else
				PRINT "<tr><td colspan=""4"" class=""tcenter"">등록된 데이터가 없습니다.</td></tr>"
			End If
		%>
	</table>
</div>

<%If PPURIO_USE_TF = "T" Then%>
<%If strType_at = "T" Then%>
	<div id="member" class="member_list fright" style="width:49%;">
		<p class="titles">kakao 템플릿 코드 입력<p>
		<table <%=tableatt%> class="width100">
			<col width="100" />
			<col width="" />
			<tr>
				<th>템플릿 코드</th>
				<td>
					<input type="text" name="kakaoTemplatecode" id="kakaoTemplatecode" class="input_text width100" value="<%=kakaoTemplatecode%>" maxlength="32" />
				</td>
			</tr>
		</table>
	</div>

	<div id="member" class="member_list fright" style="width: 100%;">
		<p class="titles"><%=THIS_SUBJECT%> 버튼 json 입력<p>
		<table <%=tableatt%> class="width100">
			<col width="400" />
			<col width="" />
			<tr>
				<th colspan="2">
					kakao button (json형식의 배열값 입력)
				</th>
			</tr><tr>
				<td class="tcenter"><img src="/images/admin/at_example.png" alt=""></td>
				<td>
					<p><span style="background: yellow;">"button": </span> 이하 <span style="background: #97d1e3;">&nbsp;[{"name":"이름", ~ ,"url_mobile":"http:www.."}] </span> 입력</p><br />
					<p><span class="red2">※ 승인된 템플릿 정보와 동일하게 입력되어야합니다.</p><br />
					<p><a href="https://codebeautify.org/jsonviewer"  target="_blank"><span class="blue">[json 형식 확인 사이트] https://codebeautify.org/jsonviewer</span></a></p>
				</td>

			</tr>
			<tr>
				<td colspan="2" style="height: 380px; padding: 15px;">
					<textarea name="kakaoButtonJson" style="width:100%; height:100%; width: 100%; border: 1px solid #e1e1e1; padding: 10px; resize: none;" id="kakaoButtonJson"><%=kakaoButtonJson%></textarea>
				</td>
			</tr>
		</table>
	</div>
<%End If %>
<%End If %>

<div class="fleft width100" style="display: flex; justify-content: center; padding: 20px 0;">
	<span class="btns color2 mg10 cp tcenter" id="btnInit">초기화</span>
	<span class="btns color1 cp tcenter" id="btnSubmit">등록/수정</span>
</div>




<!--#include virtual="/_include/modal_config.asp" -->
<!--#include virtual = "/admin/_inc/copyright.asp"-->
