<!--#include virtual="/admin/_inc/adminPath.asp" -->
<!--#include virtual="/admin/_inc/auth_check.asp" -->
<%

	ADMIN_LANG = SESSION("ADMIN_LANG")

	If ADMIN_LANG = "" Then
		ADMIN_LANG = "KR"
	End If

	arrList_L1 = Db.execRsList("DKSP_SITE_NATION_LIST",DB_PROC,Nothing,listLen_L1,Nothing)
	If IsArray(arrList_L1) Then
		viewLeftLangOPTION = ""
		For	L1 = 0 To listLen_L1
			arrList_L1_strNationCode		= arrList_L1(0,L1)
			arrList_L1_strNationName		= arrList_L1(1,L1)
			arrList_L1_isUse				= arrList_L1(2,L1)
			arrList_L1_intSort				= arrList_L1(3,L1)

			viewLeftLangOPTION = viewLeftLangOPTION &	"<option value="""&arrList_L1_strNationCode&""" "&isSelect(ADMIN_LANG,arrList_L1_strNationCode)&">언어선택 : "&arrList_L1_strNationName&"</option>"

			If arrList_L1_strNationCode = ADMIN_LANG Then
				viewAdminLangName = arrList_L1_strNationName
				viewAdminLangCode = arrList_L1_strNationCode
			End If
		Next
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If
	viewAdminLang = viewAdminLangCode



	Function FN_WEBPRO_ONLY(NOWLEVEL)
		If DK_MEMBER_LEVEL < 11 Then Call ALERTS("개발중인 화면이거나 권한이 없습니다.","BACK","")
	End Function

	'다국어 한국만 선택
	Function FN_KR_LANG_ONLY()
		If viewAdminLangCode <> "KR" Then
			PRINT "<script type=""text/javascript"">"
			PRINT "		$(function(){"
			PRINT "			adminLangChange('KR');"
			PRINT "		});"
			PRINT "</script>"
		End If
	End Function

%>
