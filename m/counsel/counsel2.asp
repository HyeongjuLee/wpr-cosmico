<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"


	view = 5
	mNum = 5

'	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)



	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)		'고객지원 - 1:1상담 : 회원공개



%>
<script type="text/javascript">
<!--
	function chkThisForm(f) {

		if (!chkNull(f.strName,"고객님의 이름을 입력해주세요.")) return false;

		if (!checkEmail(f.strEmail.value)) {
			alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
			f.strEmail.focus();
			return false;
		}
		if (!chkNull(f.strMobile,"휴대폰번호를 입력해주세요.")) return false;
		if (!chkNull(f.strSubject,"상담제목을 입력해주세요.")) return false;
		if (!chkNull(f.strContent,"상담내용을 입력해주세요.")) return false;

	}

//-->
</script>
<link rel="stylesheet" href="counsel.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--#include virtual = "/_include/sub_title.asp"-->
<p class="infos"><%=viewImg("./images/consulation_alert.png",350,60,"")%></p>
	<form name="cfrm" action="counsel2Handler.asp" method="post" onSubmit="return chkThisForm(this);">
		<div id="page" class="afters userCWidth2" style="margin-top:20px;">
			<div class="clear fleft" style="margin-top:30px;margin-left:40px;">
				<table <%=tableatt%> class="userCWidth2 table_fixed">
					<col width="8%" />
					<col width="92%" />
					<tr>
						<th><%=viewImg("./images/consulation_stit_name.png",50,20,"")%></th>
						<td><input type="text" name="strName" class="input_text inputbg" style="width:250px;" value="" /></td>
					</tr><tr>
						<th><%=viewImg("./images/consulation_stit_mail.png",50,20,"")%></th>
						<td><input type="text" name="strEmail" class="input_text inputbg imes" style="width:250px;" value="" /></td>
					</tr><tr>
						<th><%=viewImg("./images/consulation_stit_mobile.png",50,20,"")%></th>
						<td><input type="text" name="strMobile" class="input_text inputbg" style="width:90%;" maxlength="12" <%=onlyKeys%> value="" /></td>
					</tr><tr>
						<th><%=viewImg("./images/consulation_stit_subject.png",50,20,"")%></th>
						<td><input type="text" name="strSubject" class="input_text inputbg" style="width:557px;" value="" /></td>
					</tr><tr>
						<th><%=viewImgOpt("./images/consulation_stit_content.png",50,20,"","style=""margin-top:10px;""")%></th>
						<td><textarea name="strContent" rows="10" cols="10" class="input_area inputbg" style="padding:7px; width:600px;height:210px; "></textarea></td>
					</tr>
				</table>
			</div>


		</div>
		<div class="userCWidth2 tcenter fleft" style="padding:40px 0px;"><input type="image" src="./images/consulation_submit.gif" /><input type="image" src="./images/consulation_reset.gif" onClick="this.form.reset();return false;" style="margin-left:3px;" /></div>
	</form>
<%
'	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
%>
<!--#include virtual = "/_include/copyright.asp"-->
