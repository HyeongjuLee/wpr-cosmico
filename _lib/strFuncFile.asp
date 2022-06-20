<%
	'### 이미지 업로드 바이러스 체크함수 적용중 FN_IMAGEUPLOAD.###
		CONST_TABS_VIRUSCHECK_TF = "T"			'바이러스 프로그램 Defender 사용
		If getUserIP = "127.0.0.1" Then CONST_TABS_VIRUSCHECK_TF = "F"

		If Ucase(DK_MEMBER_NATIONCODE) = "KR" Then
			patternUploadFile = "^[a-zA-Z0-9가-힣\.\-\_\[\]()]*$"
		Else
			patternUploadFile = "^[a-zA-Z0-9\.\-\_\[\]()]*$"
		End If
%>
<%
	' *****************************************************************************
	' Function Name		: upfORM
	' Discription		: 탭스업로드 이용 업로드 함수
	' *****************************************************************************
		Function upfORM(ByVal key, ByVal method)
			Dim value
				value = Upload.Form(key)
			If method = False Then
				If value = "" Or value = Null Then
					upfORM = ""
				Else
					value = convSql(value)
					upfORM = value
				End If
			ElseIf method = True Then
				If value = "" Or value = Null Then
					'Call ALERTS("필수값이 없습니다."&key,"back","")
					Call ALERTS(LNG_STRFUNC_TEXT06&key,"back","")
					Response.End
				Else
					value = convSql(value)
					upfORM = value
				End If
			End If
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name		: FN_chkFileName
	' Discription		: 이미지 파일 이름 체크 (True / False 리턴)
	' *****************************************************************************
		Function FN_chkFileName(ByVal Img_FileNameValue)
			Dim value, chkFile
				Img_FileName = Img_FileNameValue

				Img_FileName = Replace(Img_FileName," ","")
				Img_FileName = Replace(Img_FileName,"'","")
				Img_FileName = Replace(Img_FileName,"..","")
				Img_FileName = Replace(Img_FileName,"%00","")
				Img_FileName = Replace(Img_FileName,"0x00","")
				Img_FileName = Replace(Img_FileName,"%","")
				Img_FileName = Replace(Img_FileName,";","")
				Img_FileName = Replace(Img_FileName,":","")
				Img_FileName = Replace(Img_FileName,"?","")
				Img_FileName = Replace(Img_FileName,"*","")
				Img_FileName = Replace(Img_FileName, "<", "")
				Img_FileName = Replace(Img_FileName, ">", "")
				Img_FileName = Replace(Img_FileName,"&","")
				Img_FileName = Replace(Img_FileName,"=","")
				Img_FileName = Replace(Img_FileName,"/","")

				chkFile =			 InStr(Img_FileName,".asp") > 0
				chkFile = chkFile Or InStr(Img_FileName,".aspx") > 0
				chkFile = chkFile Or InStr(Img_FileName,".htm") > 0
				chkFile = chkFile Or InStr(Img_FileName,".html") > 0
				chkFile = chkFile Or InStr(Img_FileName,".asa") > 0
				chkFile = chkFile Or InStr(Img_FileName,".exe") > 0
				chkFile = chkFile Or InStr(Img_FileName,".php") > 0
				chkFile = chkFile Or InStr(Img_FileName,".php3") > 0
				chkFile = chkFile Or InStr(Img_FileName,".inc") > 0
				chkFile = chkFile Or InStr(Img_FileName,".jsp") > 0
				chkFile = chkFile Or InStr(Img_FileName,".jspx") > 0
				chkFile = chkFile Or InStr(Img_FileName,".cgi") > 0
				chkFile = chkFile Or InStr(Img_FileName,".pl") > 0
				chkFile = chkFile Or InStr(Img_FileName,".pm") > 0
				chkFile = chkFile Or InStr(Img_FileName,".py") > 0
				chkFile = chkFile Or InStr(Img_FileName,".lib") > 0
				chkFile = chkFile Or InStr(Img_FileName,".in") > 0
				chkFile = chkFile Or InStr(Img_FileName,".bat") > 0
				chkFile = chkFile Or InStr(Img_FileName,".cer") > 0
				chkFile = chkFile Or InStr(Img_FileName,".cdx") > 0
				chkFile = chkFile Or InStr(Img_FileName,".war") > 0
				chkFile = chkFile Or InStr(Img_FileName,".htaccess") > 0
				FN_chkFileName = chkFile
		End Function
	' *****************************************************************************



	' *****************************************************************************
	' Function Name : ChkPathToCreate
	' Discription : 업로드 시 폴더 체크 후 폴더 생성
	' *****************************************************************************
		Function ChkPathToCreate(ByVal Path)
			Dim Fso
			Dim ResultPath
			Dim arrPath
			Dim f

			resultPath = Server.MapPath("/")

			Path = Replace(Path,"/","\")
			arrPath = Split(Path,"\",-1,1)

			Set Fso = Server.CreateObject("Scripting.FileSystemObject")

			For f = 0 To UBound(arrPath,1)
				If Trim(arrPath(f)) <> "" Then
					ResultPath = resultPath & "\" & Trim(arrPath(f))
					If Not Fso.FolderExists(ResultPath) Then Fso.CreateFolder(ResultPath)
				End If
			Next

			Set Fso = Nothing

			chkPathToCreate = ResultPath
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : sbDeleteFiles
	' Discription : 윈도우 시스템 파일 삭제
	' *****************************************************************************
		Function sbDeleteFiles(strPath)
			Dim objFSO
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
			If objFSO.FileExists(strPath) Then objFSO.DeleteFile(strPath)
			Set objFSO = Nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : ChkPathToFile
	' Discription : 파일 있는지 확인 (T/F 리턴)
	' *****************************************************************************
		Function ChkPathToFile(strPath)
			Dim objFSO
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
			If objFSO.FileExists(strPath) Then
				ChkPathToFile = True
			Else
				ChkPathToFile = False
			End If
			Set objFSO = Nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : ChkFileSize
	' Discription : 윈도우 시스템 파일 사이트 체크 (byte 로 리턴)
	' *****************************************************************************
		Function ChkFileSize(strPath)
			Dim objFSO
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
			If objFSO.FileExists(strPath) Then
				Set myfile = objFSO.GetFile(strPath)
				ChkFileSize = myfile.size
			Else
				ChkFileSize = "0"
			End If
			Set objFSO = Nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : getUniqueFilename
	' Discription : 유니크한 파일명 만들기 (Tabs 이후 안 씀)
	' *****************************************************************************
		Function getUniqueFilename(ByVal path, ByVal filename)
			Dim Fso
			Dim f
			Dim fName, fExt
			Dim newFName

			fName = Trim(Left(filename, InstrRev(filename, ".")-1))
			fExt = Trim(Mid(filename, InstrRev(filename, ".")+1))

			newFName = fName

			Set Fso = Server.CreateObject("Scripting.FileSystemObject")

			f = 1
			Do While True
				If Fso.FileExists(path &"\"& newFName &"."& fExt) Then
					newFName = fName &"("& f &")"
				Else
					Exit Do
				End If
				f = f + 1
			Loop

			Set Fso = Nothing

			getUniqueFilename = newFName &"."& fExt
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : ChkPathToFileOrNotImg
	' Discription : 이미지 없으면 특정 이미지 출력
	' *****************************************************************************
		Function ChkPathToFileOrNotImg(strPath)
			Dim objFSO
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
			target = Server.MapPath("/")&strPath
			If objFSO.FileExists(target) Then
				imgWidth = 0
				imgHeight = 0
				Call ImgInfo(strPath,imgWidth,imgHeight,0)
				ChkPathToFileOrNotImg = viewImg(strPath,imgWidth,imgHeight,"")
			Else
				ChkPathToFileOrNotImg = viewImg(IMG_SHARE&"/notImg170.gif",170,170,"")
			End If
			Set objFSO = Nothing
		End Function
	' *****************************************************************************

	' ****************************************************************************************
	' Function Name : upImgInfo
	' Discription : 이미지업로드(원본이미지 저장 후 저장된 가로세로크기 반환)
	'	내부함수 FN_IMAGEUPLOAD	: (바이러스 체커 포함, 파일 확장자 허용 포함)
	' ****************************************************************************************
		Function upImgInfo(ByVal keys,ByVal ThPath1,ByRef imgWidth, ByRef imgHeight)
			If Upload.Form(keys) <> "" Then
				upImgInfo = FN_IMAGEUPLOAD(keys, "T", MaxDataSize1, ThPath1, "", "F", "", "", "", "", "", "")
				imgWidth = Upload.Form(keys).ImageWidth
				imgHeight = Upload.Form(keys).ImageHeight
			Else
				upImgInfo = ""
			End If
		End Function
	' ****************************************************************************************

	' ****************************************************************************************
	' Function Name : uploadImg
	' Discription : 이미지업로드(1. 원본이미지 저장, 2.입력한 가로세로크기로 저장)
	'	내부함수 FN_IMAGEUPLOAD	: (바이러스 체커 포함, 파일 확장자 허용 포함)
	' ****************************************************************************************
		Function uploadImg(ByVal keys,ByVal ThPath1, ByVal ThPath2,ByVal ThWidth, ByVal ThHeight)
			If Upload.Form(keys) <> "" Then
				uploadImg = FN_IMAGEUPLOAD(keys, "T", MaxDataSize1, ThPath1, ThPath2, "T", ThWidth, ThHeight, "", "", "", "")
			Else
				uploadImg = ""
			End If
		End Function
	' ****************************************************************************************

	' ****************************************************************************************
	' Function Name : upImg
	' Discription : 이미지업로드(원본이미지 저장)
	'	내부함수 FN_IMAGEUPLOAD	: (바이러스 체커 포함, 파일 확장자 허용 포함)
	' ****************************************************************************************
		Function upImg(ByVal keys,ByVal ThPath1)
			If Upload.Form(keys) <> "" Then
				upImg = FN_IMAGEUPLOAD(keys, "T", MaxDataSize1, ThPath1, "", "F", "", "", "", "", "", "")
			Else
				upImg = ""
			End If
		End Function
	' ****************************************************************************************

	' ****************************************************************************************
	' Function Name : ThumImg
	' Discription : 확장자체크1 / 특수문자체크 / 특수문자치환 / 변조확장자체크
	' ****************************************************************************************
		Function ThumImg(ByVal files,ByVal ThPath1, ByVal ThPath2,ByVal ThWidth, ByVal ThHeight)

			If files <> "" Then

				Img_FileType = LCase(files)
				Select Case Right(Img_FileType,3)
					Case "jpg","gif","png"
					Case Else
						Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY,"BACK","")
						Response.End
				End Select

				Img_FileName = LCase(files)
				If Not eRegiTest(Img_FileName, patternUploadFile) Then
					Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY&"!!","BACK","")
					Response.End
				End If

				chkFile = FN_chkFileName(Img_FileName)
				If chkFile Then
					Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY&"!!!","BACK","")
					Response.End
				End If

				Dim Image, Status																				'추가
				Set Image = Server.CreateObject("TABSUpload4.Image")		'추가
				Dim strOpenFileName    '해당 원본 이미지 파일
				Dim strSaveFileName    '저장될 이미지 파일

				strOpenFileName = ThPath1&"\"& files
				strSaveFileName = ThPath2&"\"& files

				Status = Image.Load(strOpenFileName)

				If Status = Ok Then
					If Image.Width > ThWidth Then image.Resize ThWidth,0,ItpModeBicubic
					If Image.Height > ThHeight Then image.Resize 0,ThHeight,ItpModeBicubic
					Image.Save strSaveFileName, 100, True
					Image.Close
				Else
					Call ALERTS("이미지 파일을 열 수 없습니다. 오류 코드: " & Status,"BACK","")
					'Response.Write "이미지 파일을 열 수 없습니다. "&keys&" 오류 코드: " & Status
				End If

				ThumImg = files

			Else
				ThumImg = ""
			End If

		End Function
	' ****************************************************************************************

	' ****************************************************************************************
	' Function Name : upLoopImg
	' Discription : 확장자체크1 / 확장자체크2 / 특수문자체크 / 특수문자치환 / 변조확장자체크
	' ****************************************************************************************
		Function upLoopImg(ByVal keys,ByVal Thisnum, ByVal ThPath1, ByVal ThPath2,ByVal ThWidth, ByVal ThHeight)
			If Upload.Form(keys)(thisNum) <> "" Then

				Img_FileType = LCase(Upload.Form(keys)(thisNum).FileType)
				Select Case Img_FileType
					Case "jpg","gif","png"
					Case Else
						Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY,"BACK","")
						Response.End
				End Select


				'If Upload.Form(keys)(thisNum).ImageType <= 0 Then
				Img_ImageType = Upload.Form(keys)(thisNum).ImageType
				If Img_ImageType < 2 Or Img_ImageType > 4 Then				' 1:"bmp"  , 2:"gif", 3:"jpg", 4:"png"
					Call alerts(LNG_JS_IMAGE_UPLOAD_ONLY,"back","")
					Response.End
				Else

					Img_FileName = LCase(Upload.Form(keys)(thisNum))
					If Not eRegiTest(Img_FileName, patternUploadFile) Then
						Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY&"!!","BACK","")
						Response.End
					End If

					chkFile = FN_chkFileName(Img_FileName)

					If chkFile Then
						Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY&"!!!","BACK","")
						Response.End
					End If

					If Upload.Form(keys)(thisNum).FileSize < MaxDataSize1 Then
						Upload.Form(keys)(thisNum).Save(ThPath1)
						upLoopImg = Upload.Form(keys)(thisNum).ShortSaveName
					End If

					Set Image = Server.CreateObject("TABSUpload4.Image")

					strOpenFileName = ThPath1&"\"& upLoopImg
					strSaveFileName = ThPath2&"\"& upLoopImg

					Status = Image.Load(strOpenFileName)
					If Status = Ok Then
						If Image.Width > ThWidth Then image.Resize ThWidth,0,ItpModeBicubic
						If Image.Height > ThHeight Then image.Resize 0,ThHeight,ItpModeBicubic
						Image.Save strSaveFileName, 100, True
						Image.Close
					Else
						Call ALERTS("이미지 파일을 열 수 없습니다. 오류 코드: " & Status,"BACK","")
						'Response.Write "이미지 파일을 열 수 없습니다. "&keys&" 오류 코드: " & Status
					End If

				End If
			Else
				upLoopImg = ""
			End If
		End Function
	' ****************************************************************************************

	' ****************************************************************************************
	' Function Name : upImgSmartEditor
	' Discription : 확장자체크1 / 확장자체크2 / 특수문자체크 / 특수문자치환 / 변조확장자체크
	' ****************************************************************************************
		Function upImgSmartEditor(ByVal keys, ByVal DirectoryPath, ByVal newFileName, ByVal newFileExet)
			If Upload.Form(keys) <> "" Then

				Img_FileType = LCase(Upload.Form(keys).FileType)
				Select Case Img_FileType
					Case "jpg","gif","png"
					Case Else
						Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY,"BACK","")
						Response.End
				End Select

				Img_ImageType = Upload.Form(keys).ImageType
				If Img_ImageType < 2 Or Img_ImageType > 4 Then				' 1:"bmp"  , 2:"gif", 3:"jpg", 4:"png"
					'Call alerts("이미지파일만 업로드 가능합니다.","back","")
					CALL ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY,"BACK","")
					Response.End
				Else

					Img_FileName = LCase(Upload.Form(keys))
					If Not eRegiTest(Img_FileName, patternUploadFile) Then
						Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY&"!!","BACK","")
						Response.End
					End If

					chkFile = FN_chkFileName(Img_FileName)

					If chkFile Then
						Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY&"!!!","BACK","")
						Response.End
					End If

					If Upload.Form(keys).FileSize < MaxDataSize1 Then
						Upload.Form(keys).SaveAS(DirectoryPath&"\"&newFileName&"."&newFileExet)
						upImgSmartEditor = Upload.Form(keys).ShortSaveName
					End If
				End If
			Else
				upImgSmartEditor = ""
			End If
		End Function
	' ****************************************************************************************

		Function ThumImgTabs(ByVal files,ByVal ThPath1, ByVal ThPath2,ByVal ThWidth, ByVal ThHeight)
			If ThWidth = "" Then ThWidth = 0 Else ThWidth = CDbl(ThWidth)
			If ThHeight = "" Then ThHeight = 0 Else ThWidth = CDbl(ThWidth)

			Dim Image, Status
			Set Image = Server.CreateObject("TABSUpload4.Image")

			strOpenFileName = ThPath1&"\"& files
			strSaveFileName = ThPath2&"\"& files

			Status = Image.Load(strOpenFileName)
			If Status = Ok Then
				If Image.Width > ThWidth Then image.Resize ThWidth,0,ItpModeBicubic
				If Image.Height > ThHeight Then image.Resize 0,ThHeight,ItpModeBicubic
				Image.Save strSaveFileName, 100, True
				Image.Close
			Else
				Call ALERTS("이미지 파일을 열 수 없습니다. 275 오류 코드: " & Status,"BACK","")
				'Response.Write "이미지 파일을 열 수 없습니다. 275 "&files&" 오류 코드: " & Status
			End If
			ThumImgTabs = files

		End Function

		Function uploadImgTabs(ByVal keys,ByVal ThPath1, ByVal ThPath2,ByVal ThWidth, ByVal ThHeight)

			If ThWidth = "" Then ThWidth = 0 Else ThWidth = CDbl(ThWidth)
			If ThHeight = "" Then ThHeight = 0 Else ThWidth = CDbl(ThWidth)
			ImgName = ""
			If Upload.Form(keys) <> "" Then
				Select Case Upload.Form(keys).ImageType
					Case 1,3,4
						If Upload.Form(keys).FileSize < MaxDataSize1 Then
							Upload.Form(keys).Save(ThPath1)
							ImgName  = Upload.Form(keys).ShortSaveName
						End If

						Dim Image, Status
						Set Image = Server.CreateObject("TABSUpload4.Image")

						strOpenFileName = ThPath1&"\"& ImgName
						strSaveFileName = ThPath2&"\"& ImgName
						Status = Image.Load(strOpenFileName)

						If Status = Ok Then
							If Image.Width > ThWidth Then image.Resize ThWidth,0,ItpModeBicubic
							If Image.Height > ThHeight Then image.Resize 0,ThHeight,ItpModeBicubic
							Image.Save strSaveFileName, 100, True
							Image.Close
						Else
							Call ALERTS("이미지 파일을 열 수 없습니다. 오류 코드: " & Status,"BACK","")
							'Response.Write "이미지 파일을 열 수 없습니다. "&keys&" 오류 코드: " & Status
						End If
					Case Else
						Call alerts(LNG_STRFUNCFILE_TEXT01,"back","")
						response.End
				End Select
			Else
				ImgName = ""
			End If
			uploadImgTabs = ImgName
		End Function

		Function uploadImgTabs2(ByVal keys,ByVal ThPath1, ByVal ThPath2,ByVal ThWidth, ByVal ThHeight)
			ImgName = ""
			If Upload.Form(keys) <> "" Then
				Select Case Upload.Form(keys).ImageType
					Case 1,3,4
						If Upload.Form(keys).FileSize < MaxDataSize1 Then
							Upload.Form(keys).Save(ThPath1)
							ImgName  = Upload.Form(keys).ShortSaveName
						End If

						Dim Image, Status
						Set Image = Server.CreateObject("TABSUpload4.Image")

						strOpenFileName = ThPath1&"\"& ImgName
						strSaveFileName = ThPath2&"\"& ImgName

						Status = Image.Load(strOpenFileName)
						If Status = Ok Then
							If Image.Width > ThWidth Then image.Resize ThWidth,0,ItpModeBicubic
							If Image.Height > ThHeight Then image.Resize 0,ThHeight,ItpModeBicubic
							Image.Save strSaveFileName, 100, True
							Image.Close
						Else
							Call ALERTS("이미지 파일을 열 수 없습니다. 오류 코드: " & Status,"BACK","")
							'Response.Write "이미지 파일을 열 수 없습니다. "&keys&" 오류 코드: " & Status
						End If
					Case Else
						Call alerts(LNG_STRFUNCFILE_TEXT01,"back","")
						response.End
				End Select
			Else
				ImgName = ""
			End If
			uploadImgTabs2 = ImgName
		End Function



' 바이러스 프로그램 Defender : CONST_TABS_VIRUSCHECK_TF 확인
	' *****************************************************************************
	' Function Name : FN_FILEUPLOAD
	' Description : 파일업로드 함수 (바이러스 체커 포함, 파일 확장자 허용 포함)
	' keys : form name // TFs : 필수값여부 // MAX_SIZE : 최대사이즈 // ThPath1 : 저장될 경로
	' originF : 파일이 필수값이 아니고 빈값인 경우 원래 파일명
	' *****************************************************************************
		Function FN_FILEUPLOAD(ByVal keys, ByVal TFs, ByVal MAX_SIZE, ByVal ThPath1, ByVal originF)
			Set UPLOADFILE = Upload.Form(keys)

			If UPLOADFILE <> "" Then
				If UPLOADFILE.FileSize > MAX_SIZE Then
					Call ALERTS(LNG_ERROR_MSG_10&" "&(MAX_SIZE/1024/1024)&"MB 입니다","BACK","")
					Response.End
				End If

				ThisFileName = LCase(UPLOADFILE)
				If Not eRegiTest(ThisFileName, patternUploadFile) Then
					Call ALERTS(LNG_ERROR_MSG_07&"!!","BACK","")
					Response.End
				End If

				ThisFileType = LCase(UPLOADFILE.FileType)

				If InStr(TX_FileAccTYPE,","&ThisFileType&",") < 1 Then
					Call ALERTS(LNG_ERROR_MSG_06&"1","BACK","")
				Else

					If CONST_TABS_VIRUSCHECK_TF = "T" Then		'바이러스 체커 사용
						Set Vc = Server.CreateObject("TABSUpload4.VirusChecker")
						If Vc.Open(19978) Then
							'임시 파일 형태로 저장된 업로드 파일에 대해 바이러스를 검사한다.

							'Response.Write "Connected to the TABSUpload 5 Utility Service.<br>"
							'Response.Write "Scanning " & UPLOADFILE.TmpFileName & "<br>"
							Vc.CheckVirus UPLOADFILE.TmpFileName, True, Found, VirusName
							Vc.Close
							If Found Then
								'Response.Write "Infected by " & VirusName & " and removed immediately."
								Call FN_TraceLog("/error/virusChk","")
								Call FN_TraceLog("/error/virusChk","▣ 바이러스체크 S =============")
								Call FN_TraceLog("/error/virusChk","IP : " & Request.ServerVariables("REMOTE_ADDR"))
								Call FN_TraceLog("/error/virusChk","RF : " & Request.ServerVariables("HTTP_REFERER"))
								Call FN_TraceLog("/error/virusChk","FN : " & UPLOADFILE.TmpFileName)
								Call FN_TraceLog("/error/virusChk","VN : " & VirusName)
								Call FN_TraceLog("/error/virusChk","▣ 바이러스체크 E =============")
								Call ALERTS(LNG_ERROR_MSG_05,"BACK","")
							Else
								'바이러스가 없을 경우 최종 목적지로 저장한다.
								If vc.Open(19978) Then
									vc.CheckUnsafeFileType UPLOADFILE, found, foundName
									If found Then
										Call FN_TraceLog("/error/virusChk","")
										Call FN_TraceLog("/error/virusChk","▣ 위험파일체크 S =============")
										Call FN_TraceLog("/error/virusChk","IP : " & Request.ServerVariables("REMOTE_ADDR"))
										Call FN_TraceLog("/error/virusChk","RF : " & Request.ServerVariables("HTTP_REFERER"))
										Call FN_TraceLog("/error/virusChk","FN : " & UPLOADFILE.TmpFileName)
										Call FN_TraceLog("/error/virusChk","VN : " & foundName)
										Call FN_TraceLog("/error/virusChk","▣ 위험파일체크 E =============")
										Call ALERTS(LNG_ERROR_MSG_05_02,"BACK","")
									Else
										vc.CheckRunnableFile UPLOADFILE, found, foundName
										If Found Then
											Call FN_TraceLog("/error/virusChk","")
											Call FN_TraceLog("/error/virusChk","▣ 실행파일체크 S =============")
											Call FN_TraceLog("/error/virusChk","IP : " & Request.ServerVariables("REMOTE_ADDR"))
											Call FN_TraceLog("/error/virusChk","RF : " & Request.ServerVariables("HTTP_REFERER"))
											Call FN_TraceLog("/error/virusChk","FN : " & UPLOADFILE.TmpFileName)
											Call FN_TraceLog("/error/virusChk","VN : " & foundName)
											Call FN_TraceLog("/error/virusChk","▣ 실행파일체크 E =============")
											Call ALERTS(LNG_ERROR_MSG_05_01,"BACK","")
										Else

											FN_FILEUPLOAD = FN_FILEUPLOAD_BASIC(UPLOADFILE, ThPath1)

										End If
									End If
									vc.Close
								End If
							End If
						Else
							Call ALERTS(LNG_ERROR_MSG_09,"BACK","")
						End If

					Else	'바이러스 체커 사용X
						FN_FILEUPLOAD = FN_FILEUPLOAD_BASIC(UPLOADFILE, ThPath1)
					End If

				End If
			Else
				If TFs = "F" Then
					FN_FILEUPLOAD = originF
				Else
					Call ALERTS(LNG_ERROR_MSG_08,"BACK","")
					Response.End
				End If
			End If
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : FN_IMAGEUPLOAD
	' Description : 이미지업로드 함수  (바이러스 체커 포함, 파일 확장자 허용 포함)
	' keys : form name // TFs : 필수값여부 // MAX_SIZE : 최대사이즈 // ThPath1 : 저장될 경로 // ThPath2 : 썸네일 경로
	' ThumnailTF : 썸네일 생성여부 // ThumWidth : 썸네일 가로 사이즈 // ThumHeight : 썸네일 세로 사이즈 // 나머지 예비함수
	' originF : 파일이 필수값이 아니고 빈값인 경우 원래 파일명
	' TempVal1 : ALERTS_METHOD
	' TempVal2 : newFileName
	' *****************************************************************************
		Function FN_IMAGEUPLOAD(ByVal keys, ByVal TFs, ByVal MAX_SIZE, ByVal ThPath1, ByVal ThPath2, ByVal ThumnailTF, ByVal ThumWidth, ByVal ThumHeight, ByVal originF, ByVal TempVal1, ByVal TempVal2, ByVal TempVal3)

			If ThumWidth = "" Then ThumWidth = 0 Else ThumWidth = CDbl(ThumWidth)
			If ThumHeight = "" Then ThumHeight = 0 Else ThumHeight = CDbl(ThumHeight)
			If TempVal1 = "" Or Lcase(TempVal1) = "t1" Then
				ALERTS_METHOD = "back"
			Else
				ALERTS_METHOD = TempVal1
			End If

			Set UPLOADFILE = Upload.Form(keys)

			If UPLOADFILE <> "" Then
				chkFile = FN_chkFileName(LCase(UPLOADFILE))
				If chkFile Then
					Call ALERTS(LNG_JS_IMAGE_UPLOAD_ONLY&"!!!",ALERTS_METHOD,"")
					Response.End
				End If

				If UPLOADFILE.FileSize > MAX_SIZE Then
					Call ALERTS(LNG_ERROR_MSG_10&" "&(MAX_SIZE/1024/1024)&"MB 입니다",ALERTS_METHOD,"")
					Response.End
				End If

				ThisFileName = LCase(UPLOADFILE)
				If Not eRegiTest(ThisFileName, patternUploadFile) Then
					Call ALERTS(LNG_ERROR_MSG_07&"!!",ALERTS_METHOD,"")
					Response.End
				End If

				If UPLOADFILE.ImageType < 2 Or UPLOADFILE.ImageType > 4 Then	' 1:"bmp", 2:"gif", 3:"jpg", 4:"png"
					Call ALERTS(LNG_ERROR_MSG_11,ALERTS_METHOD,"")
					Response.End
				End If

				ThisFileType = LCase(UPLOADFILE.FileType)

				If InStr(TX_imgAccTYPE,","&ThisFileType&",") < 1 Then
					Call ALERTS(LNG_ERROR_MSG_06&"1",ALERTS_METHOD,"")
					Response.End
				Else

					If CONST_TABS_VIRUSCHECK_TF = "T"  Then		'바이러스 체커 사용
						Set Vc = Server.CreateObject("TABSUpload4.VirusChecker")
						If Vc.Open(19978) Then
							'임시 파일 형태로 저장된 업로드 파일에 대해 바이러스를 검사한다.
							'Response.Write "Connected to the TABSUpload 5 Utility Service.<br>"
							'Response.Write "Scanning " & UPLOADFILE.TmpFileName & "<br>"
							Vc.CheckVirus UPLOADFILE.TmpFileName, True, Found, VirusName
							Vc.Close
							If Found Then
								'Response.Write "Infected by " & VirusName & " and removed immediately."
								Call FN_TraceLog("/error/virusChk","")
								Call FN_TraceLog("/error/virusChk","▣ 바이러스체크 S =============")
								Call FN_TraceLog("/error/virusChk","IP : " & Request.ServerVariables("REMOTE_ADDR"))
								Call FN_TraceLog("/error/virusChk","RF : " & Request.ServerVariables("HTTP_REFERER"))
								Call FN_TraceLog("/error/virusChk","FN : " & UPLOADFILE.TmpFileName)
								Call FN_TraceLog("/error/virusChk","VN : " & VirusName)
								Call FN_TraceLog("/error/virusChk","▣ 바이러스체크 E =============")
								Call ALERTS(LNG_ERROR_MSG_05,ALERTS_METHOD,"")
							Else
								If vc.Open(19978) Then
									vc.CheckUnsafeFileType UPLOADFILE, found, foundName
									If found Then
										Call FN_TraceLog("/error/virusChk","")
										Call FN_TraceLog("/error/virusChk","▣ 위험파일체크 S =============")
										Call FN_TraceLog("/error/virusChk","IP : " & Request.ServerVariables("REMOTE_ADDR"))
										Call FN_TraceLog("/error/virusChk","RF : " & Request.ServerVariables("HTTP_REFERER"))
										Call FN_TraceLog("/error/virusChk","FN : " & UPLOADFILE.TmpFileName)
										Call FN_TraceLog("/error/virusChk","VN : " & foundName)
										Call FN_TraceLog("/error/virusChk","▣ 위험파일체크 E =============")
										Call ALERTS(LNG_ERROR_MSG_05_02,ALERTS_METHOD,"")
									Else
										vc.CheckRunnableFile UPLOADFILE, found, foundName
										If Found Then
											Call FN_TraceLog("/error/virusChk","")
											Call FN_TraceLog("/error/virusChk","▣ 실행파일체크 S =============")
											Call FN_TraceLog("/error/virusChk","IP : " & Request.ServerVariables("REMOTE_ADDR"))
											Call FN_TraceLog("/error/virusChk","RF : " & Request.ServerVariables("HTTP_REFERER"))
											Call FN_TraceLog("/error/virusChk","FN : " & UPLOADFILE.TmpFileName)
											Call FN_TraceLog("/error/virusChk","VN : " & foundName)
											Call FN_TraceLog("/error/virusChk","▣ 실행파일체크 E =============")
											Call ALERTS(LNG_ERROR_MSG_05_01,ALERTS_METHOD,"")
										Else

											FN_IMAGEUPLOAD = FN_IMAGEUPLOAD_BASIC(UPLOADFILE, ThPath1, ThPath2, ThumnailTF, ThumWidth, ThumHeight, ThisFileType, TempVal1, TempVal2, TempVal3)

										End If

									End If
								End If
							End If
						Else
							Call ALERTS(LNG_ERROR_MSG_09,ALERTS_METHOD,"")
						End If

					Else		'바이러스 체커 사용X
							FN_IMAGEUPLOAD = FN_IMAGEUPLOAD_BASIC(UPLOADFILE, ThPath1, ThPath2, ThumnailTF, ThumWidth, ThumHeight, ThisFileType, TempVal1, TempVal2, TempVal3)
					End If

				End If
			Else
				If TFs = "F" Then
					FN_IMAGEUPLOAD = originF
				Else
					Call ALERTS(LNG_ERROR_MSG_08&"!!!",ALERTS_METHOD,"")
					Response.End
				End If
			End If
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : FN_IMAGEUPLOAD_BASIC
	' Description : FN_IMAGEUPLOAD() 함수내 기본 이미지 업로드
	' *****************************************************************************
		Function FN_IMAGEUPLOAD_BASIC(ByVal UPLOADFILE, ByVal ThPath1, ByVal ThPath2, _
				ByVal ThumnailTF, ByVal ThumWidth, ByVal ThumHeight, ByVal ThisFileType, _
				ByVal TempVal1, ByVal TempVal2, ByVal TempVal3)

				'newFileName check
				If TempVal2 = "" Or Lcase(TempVal2) = "t2" Then
					ALERTS_METHOD = "back"
					UPLOADFILE.Save(ThPath1)
				Else
					ALERTS_METHOD = TempVal1
					UPLOADFILE.SaveAS(ThPath1&"\"&TempVal2&"."&ThisFileType)
				End If

				ThisFileUp = UPLOADFILE.ShortSaveName			'디스크에 저장된 전체 파일 명에서 경로 명을 제외한 파일 이름을 반환합니다.

				Set FormatDetector = Server.CreateObject("TABSUpload4.FormatDetector")
				Set FormatInfo = FormatDetector.GuessFormat(ThPath1&"\"&ThisFileUp)
					FormatName = FormatInfo.Name
					FormatMime = FormatInfo.MimeType
				Set FormatDetector = Nothing
				'Call ResRW(FormatName,"FormatName")
				'Call ResRW(FormatMime,"FormatMime")

				If InStr(TX_imgAccTYPE,","&FormatName&",") < 1 Then
					Upload.Delete
					Call ALERTS(LNG_ERROR_MSG_06&"2",ALERTS_METHOD,"")
					Response.End
				Else
					If InStr(TX_imgAccMIME,","&FormatMime&",") < 1 Then
						Upload.Delete
						Call ALERTS(LNG_ERROR_MSG_06&"3",ALERTS_METHOD,"")
						Response.End
					Else

						If ThumnailTF = "T" Then
							Dim Image, Status
							Set Image = Server.CreateObject("TABSUpload4.Image")

							strOpenFileName = ThPath1&"\"& ThisFileUp
							strSaveFileName = ThPath2&"\"& ThisFileUp
							Status = Image.Load(strOpenFileName)			'이미지 파일을 읽습니다. 상태코드

							If Status = Ok Then
								If Image.Width > ThumWidth Then Image.Resize ThumWidth,0,ItpModeBicubic					'ItpModeBicubic 알고리즘 (사이즈 변경시 품질손상 최소화)
								If Image.Height > ThumHeight Then Image.Resize 0,ThumHeight,ItpModeBicubic
								Image.Save strSaveFileName, 100, True
								Image.Close
							Else
								Call ALERTS("이미지 파일을 열 수 없습니다. 오류 코드: " & Status,ALERTS_METHOD,"")
								'Response.Write "이미지 파일을 열 수 없습니다. "&keys&" 오류 코드: " & Status
							End If

						End If
						FN_IMAGEUPLOAD_BASIC = ThisFileUp
					End If
				End If
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : FN_FILEUPLOAD_BASIC
	' Description : FN_IMAGEUPLOAD() 함수내 기본 파일 업로드
	' *****************************************************************************
		Function FN_FILEUPLOAD_BASIC(ByVal UPLOADFILE, ByVal ThPath1)
				UPLOADFILE.Save(ThPath1)
				ThisFileUp = UPLOADFILE.ShortSaveName

				Set FormatDetector = Server.CreateObject("TABSUpload4.FormatDetector")
				Set FormatInfo = FormatDetector.GuessFormat(ThPath1&"\"&ThisFileUp)
					FormatName = FormatInfo.Name
					FormatMime = FormatInfo.MimeType
				Set FormatDetector = Nothing

				'Call ResRW(FormatName,"FormatName")
				'Call ResRW(FormatMime,"FormatMime")

				If InStr(TX_FileAccTYPE,","&FormatName&",") < 1 Then
					Upload.Delete
					Call ALERTS(LNG_ERROR_MSG_06&"2","BACK","")
					Response.End
				Else
					If InStr(TX_FileAccMIME,","&FormatMime&",") < 1 Then
						Upload.Delete
						Call ALERTS(LNG_ERROR_MSG_06&"3","BACK","")
						Response.End
					Else
						FN_FILEUPLOAD_BASIC = ThisFileUp
					End If
				End If
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : FN_chkFileTabsDownload
	' Description : 파일다운로드 함수  (파일명, 경로데이터, 다운로드 가능 체크)
	'		trans.asp 기준!!
	' filename : filename // path : 저장될 경로 // Encrypter : 파일명 암호화여부TF
	' *****************************************************************************
		Function FN_chkFileTabsDownload(ByVal filename, ByVal path, ByVal Encrypter)

			If Encrypter = "T" Then
			'▣ 파일명 복호화 S
				errorTF = "F"
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					'objEncrypter.Key = con_EncryptKey
					'objEncrypter.InitialVector = con_EncryptKeyIV
					objEncrypter.Key = con_EncryptKey_FD
					objEncrypter.InitialVector = con_EncryptKeyIV_FD
					On Error Resume Next
						If filename <> ""	Then filename	= objEncrypter.Decrypt(filename)
						If path <> ""		Then path		= objEncrypter.Decrypt(path)
						If Err.Number <> 0 Then	errorTF = "T"
					On Error GoTo 0
					Err.clear
				Set objEncrypter = Nothing

				'Call ResRW(filename,"filename2")

				If errorTF = "T" Then
					Call FN_TraceLog("/error/downLog","▣ 암호화오류 S =============")
					Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
					Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
					Call FN_TraceLog("/error/downLog","FN : " & filename)
					Call FN_TraceLog("/error/downLog","PT : " & path)
					Call FN_TraceLog("/error/downLog","==================================")
					Call ALERTS(LNG_ERROR_MSG_01,"BACK","")
					Response.End
				End If
			'▣ 파일명 복호화 E
			End If

			'▣ 파일명 체크 S
				chkInj = 0
				If InStr(filename,"../") > 0 Then chkInj = chkInj + 1
				If InStr(filename,"..") > 0 Then chkInj = chkInj + 1
				If InStr(filename,"/") > 0 Then chkInj = chkInj + 1

				'Call ResRW(chkInj,"chkInj")
				If chkInj > 0 Then
					'PRINT LNG_ERROR_MSG_02
					Call FN_TraceLog("/error/downLog","▣ 파일명 부모경로존재 S =============")
					Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
					Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
					Call FN_TraceLog("/error/downLog","FN : " & filename)
					Call FN_TraceLog("/error/downLog","PT : " & path)
					Call FN_TraceLog("/error/downLog","==================================")
					Call ALERTS(LNG_ERROR_MSG_02,"BACK","")
					Response.End
				End If
			'▣ 파일명 체크 E

			'▣ 경로데이터 체크 S
				Select Case path
					Case "down1"		: DFilepath = Server.Mappath("/uploadData/data1/")
					Case "down2"		: DFilepath = Server.Mappath("/uploadData/data2/")
					Case "down3"		: DFilepath = Server.Mappath("/uploadData/data3/")
					Case "counsel1"		: DFilepath = Server.Mappath("/uploadData/counselData1/")		'1:1문의
					Case "counsel2"		: DFilepath = Server.Mappath("/uploadData/counselData2/")		'1:1문의
					Case "counsel3"		: DFilepath = Server.Mappath("/uploadData/counselData3/")		'1:1문의
					Case "counselR"		: DFilepath = Server.Mappath("/uploadData/counselReply/")		'1:1문의 답변
					'Case "data"			: DFilepath = Server.Mappath("/upload/")
					Case "downR"		: DFilepath = Server.Mappath("/uploadData/reply/")
					Case "m_down1"		: DFilepath = Server.Mappath("/uploadData/myoffice/")		'admin/myoffice/board_view.asp
					Case "m_down2"		: DFilepath = Server.Mappath("/uploadData/myoffice/")		'SID 첨부2 추가 (2013-09-24)

					Case "joinDoc"		: DFilepath = Server.Mappath("/joinDoc/")			'회원가입서류

					Case Else
						Call FN_TraceLog("/error/downLog","▣ 존재하지 않는 경로 S =============")
						Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
						Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
						Call FN_TraceLog("/error/downLog","FN : " & filename)
						Call FN_TraceLog("/error/downLog","PT : " & path)
						Call FN_TraceLog("/error/downLog","==================================")
						Call ALERTS(LNG_ERROR_MSG_03,"BACK","")
						Response.End
				End Select
			'▣ 경로데이터 체크 E


			'▣ 다운로드 가능한 파일인지 체크 S - 탭스 필요
				DFilepath = DFilepath & "\"& Replace(Replace(Replace(filename,"../",""),"..",""),"/","")

				Set FormatDetector = Server.CreateObject("TABSUpload4.FormatDetector")
				On Error Resume Next
					Set FormatInfo = FormatDetector.GuessFormat(DFilepath)
						FormatName = FormatInfo.Name
						FormatMime = FormatInfo.MimeType
					Set FormatDetector = Nothing
					If Err.Number <> 0 Then	errorTF = "T"
				On Error GoTo 0
				Err.clear

				If errorTF = "T" Then
					Call FN_TraceLog("/error/downLog","▣ 실존하지 않은 파일 S =============")
					Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
					Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
					Call FN_TraceLog("/error/downLog","FN : " & filename)
					Call FN_TraceLog("/error/downLog","PT : " & path)
					Call FN_TraceLog("/error/downLog","==================================")
					Call ALERTS(LNG_ERROR_MSG_01,"BACK","")
					Response.End
				End If

				'Call ResRW(FormatName,"FormatName")
				'Call ResRW(FormatMime,"FormatMime")
				'Response.End
				If InStr(TX_FileAccTYPE,","&FormatName&",") < 1 Then
					Call FN_TraceLog("/error/downLog","▣ 업로드 불가능한 파일(확장자)에 대한 다운로드 요청 S =============")
					Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
					Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
					Call FN_TraceLog("/error/downLog","FN : " & filename)
					Call FN_TraceLog("/error/downLog","PT : " & path)
					Call FN_TraceLog("/error/downLog","FormatName : " & FormatName)
					Call FN_TraceLog("/error/downLog","FormatMime : " & FormatMime)
					Call FN_TraceLog("/error/downLog","==================================")
					Call ALERTS(LNG_ERROR_MSG_04,"BACK","")
					Response.End
				Else
					If InStr(TX_FileAccMIME,","&FormatMime&",") < 1 Then
						Call FN_TraceLog("/error/downLog","▣ 업로드 불가능한 파일(미디어타입)에 대한 다운로드 요청 S =============")
						Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
						Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
						Call FN_TraceLog("/error/downLog","FN : " & filename)
						Call FN_TraceLog("/error/downLog","PT : " & path)
						Call FN_TraceLog("/error/downLog","FormatName : " & FormatName)
						Call FN_TraceLog("/error/downLog","FormatMime : " & FormatMime)
						Call FN_TraceLog("/error/downLog","==================================")
						Call ALERTS(LNG_ERROR_MSG_04,"BACK","")
						Response.End
					Else

						Set Download = Server.CreateObject("TABSUpload4.Download")

						Download.FilePath = DFilepath
						Download.TransferFile True, True

						Set Download = Nothing

					End If
				End If

			'▣ 다운로드 가능한 파일인지 체크 E

		End Function
	' *****************************************************************************
%>

<%
	'에디터 이미지, 파일 처리관련 함수 추가
	' *****************************************************************************
	'	Function name	: sqBracket
	'	Description		: DB데이터 저장시 [ ] 허용
	' *****************************************************************************
			Function sqBracket(ByVal s)
				s = Trim(s)
				If Not s = "" Or Not IsNull(s) Then
					s = Replace(s, "&#35;", "#")
					s = Replace(s, "&#91;", "[")
					s = Replace(s, "&#93;", "]")
					s = Replace(s, "&amp;", "&")
					s = Replace(s, "&#39;", "")
					s = Replace(s, "'", "")
					's = Replace(s, "<", "")
					's = Replace(s, ">", "")
				End If
				sqBracket  = s
			End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : unifyImageTags
	' Discription : tag표기 통일 / 비교, 쌍따옴표처리, [] 처리
	'		getImageTags....
	' *****************************************************************************
		Function unifyImageTags(ByVal value)
			value = Trim(value)
			If Not value = "" Or Not IsNull(value) Then
				value = Replace(value, "&amp;quot;", "&#34;")		'쌍따옴표처리
				value = Replace(value, """", "&#34;")
				value = sqBracket(value)
			End If
			unifyImageTags  = value
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : sbDeleteFolder
	' Discription : 윈도우 시스템 폴더 삭제(비정상 생성 폴더 확인시!!)
	' *****************************************************************************
		Function sbDeleteFolder(strPath)
			Dim objFSO
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
			If objFSO.FolderExists(strPath) Then objFSO.DeleteFolder(strPath)
			Set objFSO = Nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	'	Function name	: ChkAbnormalFolder
	'	Description		: 비정상 폴더 체크(위변조 방지): "_TEMP" 를 제외한 실 저장폴더명 검색
	' *****************************************************************************
		Function ChkAbnormalFolder(imagePath)
			sourcePath = Server.MapPath(imagePath)
			destinationPath = Replace(sourcePath, "_TEMP", "")
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
				If Not objFSO.FolderExists(destinationPath) Then
					Call ALERTS(LNG_ALERT_WRONG_ACCESS&"DD","back","")
				End if
			Set objFSO = Nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	'	Function name	: getLastNameInPath
	'	Description		: 경로에서 파일명(폴더명) 가져오기
	' *****************************************************************************
			Function getLastNameFromPath(value)
				FileName = ""
				FileName = Replace(value,"\","/")
				FileArray = Split(FileName,"/")
				getLastNameFromPath = FileArray(Ubound(FileArray))
			End Function
	' *****************************************************************************

	' *****************************************************************************
	'	Function name	: CopyFileToReal
	'	Description		: 원본폴더(Temp)에서 대상(real)폴더로 파일복사
	'									성공시 Temp파일 삭제
	'	getTempImageTagsAndCopy
	' *****************************************************************************
		Function CopyFileToReal(ByVal source, ByVal destination)
			Dim fso, f
			Set fso = CreateObject("Scripting.FileSystemObject")
				If fso.FileExists(source) Then
					Set f = fso.GetFile(source)
					f.Copy destination
					Set f = nothing

					If fso.FileExists(destination) Then 	'파일 복사되면
						fso.DeleteFile(source)	'source file(_TEMP file) 삭제
					Else
						Set fso = nothing
						Call ALERTS("File copy failed.","BACK","")
					End If

				Else
					Set fso = nothing
					Call ALERTS("The file does not exist.","BACK","")
				End If

			Set fso = nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	'	Function name	: getTempImageTagsAndCopy
	'	Description		: GoodsContent TEMP 저장된 이미지태그 정보를 정규식으로 추출후 본 폴더로 복사
	' *****************************************************************************
		Function getTempImageTagsAndCopy(values, imagePath)
			Patrn = "(src\s{0,}=\s{0,}&#34;)\/(.*?)\.(gif|jpg|jpeg|png|bmp)&#34;"		'src이미지 전체경로 추출

			values = unifyImageTags(values)		'쌍따옴표처리, UrlDecode, []

			Dim ObjRegExp
			Set ObjRegExp = New RegExp
			ObjRegExp.Pattern = Patrn       ' 정규 표현식 패턴
			ObjRegExp.Global = True         ' 문자열 전체를 검색함
			ObjRegExp.IgnoreCase = True     ' 대.소문자 구분 안함

				Set Matches = ObjRegExp.Execute(values)
				RetStr = ""
				For Each Match in Matches 'Matches 컬렉션을 반복
					Match = Replace(Replace(Match,"src=",""),"&#34;","")

					'conetent 이미지경로에서 파일명 추출
					imgTagFilename = Replace(Match, imagePath, "")
					'UrlDecode
					If imgTagFilename <> "" Then imgTagFilename = UrlDecode_GBToUtf8(imgTagFilename)
					'conetent 이미지경로 추출
					imgTagPath = Replace(Match, imgTagFilename, "")

					'/upload/board/content_TEMP (저장,수정시 editor삽입 이미지일 경우 Copy)
					If Cstr(imagePath) = Cstr(imgTagPath) Then
						sourcePath = Server.MapPath(imagePath)
						destinationPath = Replace(sourcePath, "_TEMP", "")
						sourceFile = sourcePath & imgTagFilename
						destinationFile = destinationPath & imgTagFilename
						'print destinationPath

						Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
							'비정상 폴더 검색(위변조 방지): "_TEMP" 를 제외한 실 저장폴더명 검색
							If Not objFSO.FolderExists(destinationPath) Then
								Call sbDeleteFolder(sourcePath)					'비정상 폴더 삭제
								Set objFSO = Nothing
								Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")
							End if
						Set objFSO = Nothing

						Call CopyFileToReal(sourceFile, destinationFile)	'파일복제
					End If

				RetStr = RetStr &"<br>" & Match
				RetStr = Replace(Replace(RetStr,"src=",""),"&#34;","")
			Next

			getTempImageTagsAndCopy = RetStr

			Set ObjRegExp = Nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	'	Function name	: getImageTagsDelete
	'	Description		: GoodsContent 저장된 이미지태그 정보를 정규식으로 추출후 삭제(_TEMP)
	'	/cboard/board_delete
	' *****************************************************************************
		Function getImageTagsDelete(values, imagePath)
			Patrn = "(src\s{0,}=\s{0,}&#34;)\/(.*?)\.(gif|jpg|jpeg|png|bmp)&#34;"		'src이미지 전체경로 추출

			values = unifyImageTags(values)		'쌍따옴표처리, UrlDecode, []

			Dim ObjRegExp
			Set ObjRegExp = New RegExp
			ObjRegExp.Pattern = Patrn       ' 정규 표현식 패턴
			ObjRegExp.Global = True         ' 문자열 전체를 검색함
			ObjRegExp.IgnoreCase = True     ' 대.소문자 구분 안함

				Set Matches = ObjRegExp.Execute(values)
				RetStr = ""
				For Each Match in Matches 'Matches 컬렉션을 반복
					Match = Replace(Replace(Match,"src=",""),"&#34;","")

					'conetent 이미지경로에서 파일명 추출
					imgTagFilename = Replace(Match, imagePath, "")

					'삭제
					If imgTagFilename <> "" And Not IsNull(imgTagFilename) Then
						imgTagFilename = UrlDecode_GBToUtf8(imgTagFilename)		'UrlDecode
						sourceFile = Server.MapPath(imagePath & imgTagFilename)
						sourceFile_TEMP = Server.MapPath(imagePath&"_TEMP" & imgTagFilename)
						Call sbDeleteFiles(sourceFile)
						Call sbDeleteFiles(sourceFile_TEMP)
					End If

					RetStr = RetStr &"<br>" & Match
					RetStr = Replace(Replace(RetStr,"src=",""),"&#34;","")
				Next

			getImageTagsDelete = RetStr

			Set ObjRegExp = Nothing
		End Function
	' *****************************************************************************

	' *****************************************************************************
	'	Function name	: deleteTempFolderFiles
	'	Description		: _TEMP 폴더에 저장된 트래쉬 파일 정리(-2days)
	'								: 폴더명 TEMP 로 끝나야만 삭제가능!
	'		tempFolderPath = Server.MapPath("/upload/board/content_TEMP")
	'		Call deleteTempFolderFiles(Server.MapPath("/upload/board/content_TEMP"))
	' *****************************************************************************
		Function deleteTempFolderFiles(ByVal folderPath)
			Dim objFSO
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")

			On Error Resume Next
				Set objFolder = objFSO.GetFolder(folderPath)
				deleteTempFolderFiles = ""
				TempFolderChk = 0
				TempFolderChk = InStr(UCase(getLastNameFromPath(folderPath)),"TEMP")	'폴더명 TEMP포함체크

				If objFSO.FolderExists(objFolder) And TempFolderChk > 0 Then
					Set objFilenames  = objFolder.files  '폴더내 파일정보
					If objfilenames.count <> 0 then
						For Each i In objFilenames
							filename = i.name
							standardDelDate = Cstr(Replace(DateAdd("d",date(),-2),"-",""))	'삭제 기준일

							If CDbl(Left(filename,8)) <= CDbl(standardDelDate) Then
								'PRINT filename&"<br>"
								objFSO.DeleteFile(folderPath&"\"&filename)		'파일 삭제
								deleteTempFolderFiles = "OK"
							End if
						Next
					End If
				Else
					deleteTempFolderFiles = "That folder does not exist."
				End If
			On Error Goto 0

			Set objfilenames  = nothing
			Set objFolder = nothing
			Set objFSO = Nothing
		End Function
	' *****************************************************************************

%>
<%
	' *****************************************************************************
	' Function Name : ChkFolderExists
	' Discription : 업로드 시 폴더 체크
	' *****************************************************************************
		Function ChkFolderExists(ByVal Path)
			Dim Fso
			Dim ResultPath
			Dim arrPath
			Dim f
			resultPath = Server.MapPath("/")

			Path = Replace(Path,"/","\")
			arrPath = Split(Path,"\",-1,1)

			Set Fso = Server.CreateObject("Scripting.FileSystemObject")

			For f = 0 To UBound(arrPath,1)
				If Trim(arrPath(f)) <> "" Then
					ResultPath = resultPath & "\" & Trim(arrPath(f))
					If Not Fso.FolderExists(ResultPath) Then
						ChkFolderExists = False
					Else
						ChkFolderExists = True
					End If
				End If
			Next

			Set Fso = Nothing
		End Function
	' *****************************************************************************
%>
