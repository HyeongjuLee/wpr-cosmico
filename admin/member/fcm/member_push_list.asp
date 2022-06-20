<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER1-6"
' ===================================================================
'
' ===================================================================
' ===================================================================


' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHTERM = Request.Form("SEARCHTERM")
		SEARCHSTR = Request.Form("SEARCHSTR")
		PAGE = Request.Form("page")
		PAGESIZE = 20

	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
' ===================================================================



' ===================================================================
' 데이터 가져오기
' ===================================================================
	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKP_MEMBER_PUSH_INFO",DB_PROC,arrParams,listLen,DB3)

	All_Count = arrParams(UBound(arrParams))(4)

' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If


%>
<link rel="stylesheet" href="/css/jquery.modal.min.css" />
<style>
	.modal table th {padding:5px 0px 5px 0px; background-color:#eee;color:#000;}
	.modal table td {padding:5px 0px 5px 0px;}
	.groupType {vertical-align:middle;}
	.centerType {vertical-align:middle;}
</style>
<link rel="stylesheet" href="/admin/css/member.css" />
<script type="text/javascript" src="member_push.js"></script>
<script type="text/javascript" src="/jscript/jquery.modal.min.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="member_list">
	<form name="sfrm" action="member_push_list.asp" method="post">
		<p class="titles">검색<p>
		<table <%=tableatt%> class="search width100">
			<colgroup>
				<col width="150" />
				<col width="*" />
                <col width="100" />
			</colgroup>
			<tr>
				<th>조건검색</th>
				<td>
					<select name="SEARCHTERM">
						<option value="" <%=isSelect(SEARCHTERM,"")%>>==조건을 선택해주세요==</option>
						<option value="strID" <%=isSelect(SEARCHTERM,"strID")%>>회원 아이디로 검색</option>
						<option value="strName" <%=isSelect(SEARCHTERM,"strName")%>>회원 이름으로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text" style="width:200px;" value="<%=SEARCHSTR%>" />
					<input type="submit" src="<%=IMG_BTN%>/btn_search.gif" class="input_submit design1" value="검색" />
					<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>" class="a_submit design3">검색초기화</a>
				</td>
			</tr>
		</table>
	</form>

	<table <%=tableatt%> class="width100" style="margin-top:10px; text-align:right;">
		<tr>
			<td style="border:none;">
				<input type="button" value="전체회원 메세지 전송" class="a_submit design1 btn_group" />
				<input type="button" value="센터별 메세지 전송" class="a_submit design5 btn_center" />
			</td>
		</tr>
	</table>
	<p class="titles">전송 대상자 리스트<p>
	<table <%=tableatt%> class="width100">
		<colgroup>
            <!--
			<col width="40" />
			-->
			<col width="50" />
            <col width="100" />
			<col width="140" />
			<col width="140" />
            <col width="140" />
            <col width="100" />
            <col width="100" />
		</colgroup>
		<thead>
			<tr>
				<!--
				<th><input type="checkbox" id="chkAll" />
				-->
                <th>No</th>
				<th>회원번호</th>
                <th>회원명</th>
                <th>센터</th>
				<th>웹아이디</th>
				<th>가입일</th>
                <th>개별전송</th>
			</tr>
		</tr>
	<%
		If IsArray(arrList) Then

            '** 가입서류 있는지 확인 S
			Set dkfs = Server.CreateObject("Scripting.FileSystemObject")

            Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
                objEncrypter.Key = con_EncryptKey
                objEncrypter.InitialVector = con_EncryptKeyIV

			For i = 0 To listLen

                arrList_mbid            = arrList(1, i)
                arrList_mbid2           = arrList(2, i)
                arrList_mName           = arrList(3, i)
                arrList_eMail           = arrList(4, i)
                arrList_WebID           = arrList(5, i)
                arrList_cpno            = arrList(6, i)
                arrList_nominName       = arrList(7, i)
                arrList_nominWebID      = arrList(8, i)
                arrList_regTime         = arrList(9, i)
                arrList_fcmToken        = arrList(10, i)
                arrList_businessCode    = arrList(11, i)
                arrList_businessName    = arrList(12, i)

                '==============================================================================================================

                On Error Resume Next
                    If arrList_eMail	<> "" Then arrList_eMail		= objEncrypter.Decrypt(arrList_eMail)
                    If arrList_cpno		<> "" Then arrList_cpno			= objEncrypter.Decrypt(arrList_cpno)
                On Error GoTo 0

                '==============================================================================================================
				ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1

                If arrList_eMail = "@" Then arrList_eMail = ""

                strDisabled = ""
                strHtml = ""

				PRINT "<tr>" & VbCrlf
                'PRINT "	<td class=""tcenter""><input type=""checkbox"" value="""&arrList_mbid&"-"&arrList_mbid2&""" class=""chkbox"" "&strDisabled&" /> </td>" &VbCrlf                                                          'No
				PRINT "	<td class=""tcenter"">" & ThisNum &"</td>" &VbCrlf                                                                          'No
				PRINT "	<td class=""tcenter"">" & arrList_mbid &"-"& Fn_MBID2(arrList_mbid2) &"</td>" &VbCrlf                    '회원번호
				PRINT "	<td class=""tcenter"">" & arrList_mName &"</td>" &VbCrlf                                                                    '회원명
                PRINT "	<td class=""tcenter"">" & arrList_businessName &"</td>" &VbCrlf                                                             '센터
'				PRINT "	<td class=""tcenter"">" & Left(arrList_cpno, 6) &"</td>" &VbCrlf                                                            '주민번호
'               PRINT "	<td class=""tcenter"">" & arrList_eMail &"</td>" &VbCrlf                                                                    'Email
				PRINT "	<td class=""tcenter"">" & arrList_WebID &"</td>" &VbCrlf                                                                    '웹아이디
                PRINT "	<td class=""tcenter"">" & date8to10(arrList_regTime) &"</td>" &VbCrlf                                                       '가입일
                PRINT " <td class=""tcenter""><input type=""button"" value=""전송"" class=""a_submit design4 btn_person"" rel="""&arrList_fcmToken&""" /></td>"           '개별전송 버튼
				PRINT "</tr>" & VbCrlf
			Next

            Set objEncrypter = Nothing
            Set dkfs = Nothing
		Else
			PRINT "<tr>"
			PRINT "	<td colspan=""8"" class=""notData"">메세지를 전송할 수 있는 회원이 없습니다</td>"
			PRINT "</tr>"
		End If


	%>
	</table>
	<div class="paging_area">
		<%Call pageList(PAGE,PAGECOUNT)%>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
			<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
			<input type="hidden" name="memberType" value="<%=memberType%>" />
			<input type="hidden" name="mid" value="" />
		</form>
	</div>
</div>
<div id="personSendModal" class="modal member_list"  style="line-height: 29px; width:800px; height:600px;">
    <input type="hidden" id="personToken" />
    <p class="titles">개별 메세지 전송</p>
	<table <%=tableatt%> class="width100">
        <tr>
            <th>전송메세지</th>
            <td style="padding:10px;">
                <textarea id="personSendMessage" style="width:100%; height:400px;"></textarea>
            </td>
        </tr>
		<tr>
			<th>이동할 URL</th>
			<td style="padding:10px;"><input type="text" id="personUrl" class="input_text" style="width:100%;" placeholder="푸시 클릭시 이동할 URL을 입력해 주세요." /></td>
		</tr>
        <tr>
            <td colspan="2" class="tcenter" style="border-left:none; border-right:none; border-bottom:none;">
                <input type="button" value="메세지전송" class="a_submit design4 btn_personSend" />
            </td>
        </tr>
    </table>
</div>

<div id="groupSendModal" class="modal member_list"  style="line-height: 29px; width:800px; height:660px;">
    <p class="titles">전체회원 메세지 전송</p>
	<table <%=tableatt%> class="width100">
        <tr>
			<th>전송방식</th>
			<td>
				<input type="radio" class="groupType" name="groupType" value="D" checked="checked"/>기본알람&nbsp;&nbsp;
				<input type="radio" class="groupType" name="groupType" value="N" />공지&nbsp;&nbsp;
				<input type="radio" class="groupType" name="groupType" value="C" />확인
			</td>
		</tr>
		<tr>
            <th>전송메세지</th>
            <td style="padding:10px;">
                <textarea id="groupSendMessage" style="width:100%; height:400px;"></textarea>
            </td>
        </tr>
		<tr>
			<th>이동할 URL</th>
			<td style="padding:10px;"><input type="text" id="groupUrl" class="input_text" style="width:100%;" placeholder="푸시 클릭시 이동할 URL을 입력해 주세요." /></td>
		</tr>
        <tr>
            <td colspan="2" class="tcenter" style="border-left:none; border-right:none; border-bottom:none;">
                <input type="button" value="메세지전송" class="a_submit design1 btn_groupSend" />
            </td>
        </tr>
    </table>
</div>

<div id="centerSendModal" class="modal member_list"  style="line-height: 29px; width:800px; height:700px;">
    <p class="titles">센터별 메세지 전송</p>
	<table <%=tableatt%> class="width100">
        <tr>
			<th>전송방식</th>
			<td>
				<input type="radio" class="centerType" name="centerType" value="D" checked="checked"/>기본알람&nbsp;&nbsp;
				<input type="radio" class="centerType" name="centerType" value="N" />공지&nbsp;&nbsp;
				<input type="radio" class="centerType" name="centerType" value="C" />확인
			</td>
		</tr>
		<tr>
			<th>대상센터</th>
			<td style="padding:10px;">
				<select name="businessCode">
					<option value="">::: 센터 선택 :::</option>
					<%
						'SQL = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = '"&R_NationCode&"' AND [U_TF] = 0 ORDER BY [ncode] ASC"
						SQL = "SELECT * FROM [tbl_Business] WHERE [U_TF] = 0 ORDER BY [ncode] ASC"
						arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
						If IsArray(arrList) Then
							For i = 0 To listLen
								PRINT TABS(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
							Next
						Else
							PRINT TABS(5)& "	<option value="""">센터가 존재하지 않습니다.</option>"
						End If
					%>
				</select>
			</td>
		</tr>
		<tr>
            <th>전송메세지</th>
            <td style="padding:10px;">
                <textarea id="centerSendMessage" style="width:100%; height:400px;"></textarea>
            </td>
        </tr>
		<tr>
			<th>이동할 URL</th>
			<td style="padding:10px;"><input type="text" id="centerUrl" class="input_text" style="width:100%;" placeholder="푸시 클릭시 이동할 URL을 입력해 주세요." /></td>
		</tr>
        <tr>
            <td colspan="2" class="tcenter" style="border-left:none; border-right:none; border-bottom:none;">
                <input type="button" value="메세지전송" class="a_submit design5 btn_centerSend" />
            </td>
        </tr>
    </table>
</div>
<div id="loadingPro" style="position:fixed; z-index:99999; width:100%; height:100%; top:0px; left:0px; background:url(/images_kr/loading_bg70.png) 0 0 repeat; display:none;">
	<div style="position:relative; top:40%; text-align:center;">
		<img src="<%=IMG%>/159.gif" width="80" alt="" />
	</div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
