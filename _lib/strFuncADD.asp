<%

	CONST_SmartEditor_JS = "<script type=""text/javascript"" src=""/common/SmartEditor/js/service/HuskyEZCreator.js""></script>"


	'▣ FN_Print_SmartEditor
	'▣ 기본 에디터 호출
	Function FN_Print_SmartEditor(ByVal callID, ByVal imagePath, ByVal sLangh,ByVal tValue1, ByVal tVlaue2, ByVal tValue3)
		Select Case sLangh
			Case "KR" : sLang = "ko_KR"
			Case "US" : sLang = "en_US"
			Case "JP" : sLang = "ja_JP"
			Case "CN" : sLang = "zh_CN"
			Case "TW" : sLang = "zh_TW"
			Case Else : sLang = "en_US"
		End Select

		'id구분 추가
		Select Case callID
			Case "ir1"
				cID_NO = ""
			Case "ir2"
				cID_NO = 2
		End Select

		PRINT "	<script type=""text/javascript"" language=""javascript"">"
		'PRINT "		var oEditors = [];"
		PRINT "		var oEditors"&cID_NO&" = [];"
		PRINT "		var sLang = """&sLang&""";	"
					'// 언어 (ko_KR/ en_US/ ja_JP/ zh_CN/ zh_TW), default = ko_KR"
		PRINT "		nhn.husky.EZCreator.createInIFrame({"
		'PRINT "		oAppRef: oEditors,"
		PRINT "		oAppRef: oEditors"&cID_NO&","
		PRINT "		elPlaceHolder: """&callID&""","
		PRINT "		sSkinURI: ""/common/smarteditor/SmartEditor2Skin_"&sLang&".html"","
		PRINT "		htParams : {"
		PRINT "			bUseToolbar : true,"			'	// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
		PRINT "			bUseVerticalResizer : false,	"	'	// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
		PRINT "			bUseModeChanger : false,"		'	// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
		'PRINT "			//bSkipXssFilter : true,"		'	// client-side xss filter 무시 여부 (true:사용하지 않음 / 그외:사용)
		'PRINT "			//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
		PRINT "			fOnBeforeUnload : function(){"
		'PRINT "				//alert("완료!");
		PRINT "			},"
		PRINT "			I18N_LOCALE : sLang,"
		PRINT "			ipath : """&imagePath&""" "
		PRINT "		},"	' //boolean
		PRINT "		ipath : ""111"" "	' //boolean
		PRINT "		,fOnAppLoad : function(){"
		'PRINT "			//예제 코드
		'PRINT "			//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
		PRINT "		},"
		PRINT "		fCreator: ""createSEditor2"""
		PRINT "		});"
		PRINT "	</script>"
	End Function

%>
