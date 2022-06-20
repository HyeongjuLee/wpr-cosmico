				<%
					schType = gRequestTF("stype", False)
					If schType = "" Then schType = "oneday"

					'엘라이프2017 마이오피스 일정관리(2017-02-27)
					Select Case schType
						Case "oneday"
							view = 1
							SCHEDULE_TYPE_TXT = LNG_SCHEDULE_01
							INFO_MODE	 = "NOTICE1-2"
						Case "success"
							view = 2
							SCHEDULE_TYPE_TXT = LNG_SCHEDULE_02
							INFO_MODE	 = "NOTICE1-3"
						Case Else
						Call ALERTS(LNG_BOARD_LIST_TEXT02,"BACK","")
					End Select


					syear = checkNumeric(gRequestTF("syear", False))
					smonth = checkNumeric(gRequestTF("smonth", False))

					to_day = Day(nowTime)

					If Not IsDate(syear &"-"& smonth &"-1") Then
						syear = Year(nowTime)
						smonth = Month(nowTime)
					End If

					params = "syear="& syear &"&smonth="& smonth

					sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-01"
					sYearMonthP = DateAdd("m",-1,sYearMonth)
					sYearMonthN = DateAdd("m",1,sYearMonth)

					nowParams = "syear="& Year(nowTime)		&"&smonth="& Month(nowTime)		&"&stype="&schType
					prevParam = "syear="& Year(sYearMonthP) &"&smonth="& Month(sYearMonthP)	&"&stype="&schType
					nextParam = "syear="& Year(sYearMonthN) &"&smonth="& Month(sYearMonthN)	&"&stype="&schType

					sdate = syear &"-"& smonth &"-1"
					firstWeek = Weekday(sdate)
					lastDay = getLastDay(syear, smonth)

					sYearMonth = syear &"-"& setZeroFill(smonth, 2) &"-"


					SQL = "SELECT [intIDX], [Date], [StartTime], [EndTime], [strSubject], [Place], [strContent],[strScheduleType] FROM [DK_DIARY]"
					SQL = SQL &" WHERE [Date] LIKE ? "
					SQL = SQL &" AND [strNation] = '"&Lang&"' "
					SQL = SQL &" ORDER BY [Date] ASC, [StartTime] ASC"

					arrParams = Array( _
						Db.makeParam("@Date",adVarchar,adParamInput,10,sYearMonth &"%") _
					)
					Set Rs = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

					If Not Rs.bof And Not Rs.eof Then
						flagRs = True
						DDRS_strScheduleType = Rs("strScheduleType")
						DDRS_Date = Rs("Date")
					Else
						flagRs = False
						DDRS_strScheduleType = ""
						Call closeRs(Rs)
					End If

					If Lang = "kr" Or Lang = "" Then
						txtbg = "txtbg"
					Else
						txtbg = ""
					End If

					'관리자/판매원에따른 주소호출
					Select Case DK_MEMBER_TYPE
						Case "ADMIN"
							SCHEDULE_FLD = "/schedule"
						Case Else
							SCHEDULE_FLD = "/myoffice"
					End Select
				%>
				<div id="schedulearea" class="fright">
					<div id="schedule" class="width100 fleft">
						<div style="position:relative;">
							<img src="<%=IMG_INDEX%>/index_calender_tit_img.jpg" alt="세미나일정" usemap="#index_bn01" />
							<div style="position:absolute;top:20px;left:52px;color:#fff;width:50px;height:22px;text-align:right;font-weight:bold;font-size:17px;"><%=smonth%>월</div>
							<map name="index_bn01" id="index_bn01">
								<area shape="rect" coords="110,14,170,32" href="<%=SCHEDULE_FLD%>/schedule.asp?stype=oneday">
								<area shape="rect" coords="175,14,235,32" href="<%=SCHEDULE_FLD%>/schedule.asp?stype=success">
							</map>
						</div>
						<%
							'RowCnt
							viewDayCnt = 1
							For RowCnt = 1 To 6
								For ColCnt = 1 To 7
									If (RowCnt = 1 And ColCnt < firstWeek) Or (viewDayCnt > lastDay) Then
										'PRINT "<td class=""hts""></td>"
									Else
										viewDayCnt = viewDayCnt + 1
									End If
								Next
								If viewDayCnt > lastDay Then Exit For
							Next

							Select Case RowCnt
								Case "4"
									thHeight = "height:32px;"
									tdHeight = "height:50px;"
								Case "5"
									thHeight = "height:31px;"
									tdHeight = "height:40px;"
								Case "6"
									thHeight = "height:32px;"
									tdHeight = "height:33px;"
							End Select
						%>
						<table <%=tableatt%> class="width100 sche">
							<colgroup>
								<col width="14%" />
								<col width="14%" />
								<col width="14%" />
								<col width="14%" />
								<col width="14%" />
								<col width="14%" />
								<col width="14%" />
							</colgroup>
							<thead>
								<tr>
									<th class="sun" style="<%=thHeight%>"><%=LNG_SCHEDULE_TEXT02%></th>
									<th><%=LNG_SCHEDULE_TEXT03%></th>
									<th><%=LNG_SCHEDULE_TEXT04%></th>
									<th><%=LNG_SCHEDULE_TEXT05%></th>
									<th><%=LNG_SCHEDULE_TEXT06%></th>
									<th><%=LNG_SCHEDULE_TEXT07%></th>
									<th class="sat"><%=LNG_SCHEDULE_TEXT08%></th>
								</tr>
							</thead>
							<tbody>
							<%
								viewDay = 1
								diaryCnt = 0

								'공휴일
								SQL = "SELECT [day],[comment] FROM [DK_HOLIDAY] WHERE [year] = ? AND [month] = ?"
								arrParams = Array(_
									Db.makeParam("@year",adInteger,adParamInput,0,syear),_
									Db.makeParam("@smonth",adInteger,adParamInput,0,smonth)_
								)
								arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)

								'일정체크
								SQL2 = "SELECT [Date],[strScheduleType] FROM [DK_DIARY]"
								SQL2 = SQL2 &" WHERE [Date] LIKE ? "
								SQL2 = SQL2 &" AND [strNation] = '"&Lang&"' "
								arrParams2 = Array( _
									Db.makeParam("@Date",adVarchar,adParamInput,10,sYearMonth &"%") _
								)
								arrList2 = Db.execRsList(SQL2,DB_TEXT,arrParams2,listLen2,Nothing)

								For Row = 1 To 6
									PRINT "<tr>"

									For Col = 1 To 7
										If (Row = 1 And Col < firstWeek) Or (viewday > lastDay) Then
											PRINT "<td class=""hts""></td>"
										Else
											targetDate = syear &"-"& setZeroFill(smonth, 2) &"-"& setZeroFill(viewDay, 2)

											Select Case col
												Case 1 : FontColor = "sun"
												Case 7 : FontColor = "sat"
												Case Else : FontColor = "week"
											End Select
											holiday = ""
											cosmos = ""

										'오늘날짜 강조
										If syear = Year(nowTime) And smonth = Month(nowTime) And viewday = to_day Then
											FontColor = "today"
										End If

											'arrHoliday = ""
											If IsArray(arrList) Then
												For i = 0 To listLen
													If viewDay = arrList(0,i) Then
														holiday = "sun"
														If arrList(1,i) <> "" Or Not IsNull(arrList(1,i)) Then
															'cosmos = " <span class=""cosmos"">("&arrList(1,i)&")</span>"
															FontColor = "today"
														End If
													End If
												Next
											End If

											'OneDay, Success 배경
											linkF = ""
											linkL = ""
											If IsArray(arrList2) Then
												For k = 0 To listLen2
													If targetDate = arrList2(0,k) Then
														'print  arrList2(1,k)
														If arrList2(1,k) = "oneday" then
															FontColor = "todayOneday"
															linkF = "<a href="""&SCHEDULE_FLD&"/schedule.asp?stype=oneday"">"
															linkL = "</a>"
														ElseIf arrList2(1,k) = "success" then
															FontColor = "todaySuccess"
															linkF = "<a href="""&SCHEDULE_FLD&"/schedule.asp?stype=success"">"
															linkL = "</a>"
														Else
															linkF = ""
															linkL = ""
														End if
													End If
												Next
											End If

											'If InStr(arrHoliday,viewDay) > 0 Then holiday = "sun"

											param = syear&Right("00"&smonth,2)&Right("00"&viewDay,2)

											PRINT "<td class=""hts "&FontColor&""" style="""&tdHeight&"""><div class=""days""><p class="""&FontColor&" "&holiday&""" style="""" >"&linkF&" "&viewDay&" "&linkL&" "&cosmos&"</p>"
											If flagRs Then
												Do Until Rs.eof
													'uid		= Trim(Rs("intIDX"))
													nDate		= Trim(Rs("Date"))
													'startTime	= Trim(Rs("StartTime"))
													'endTime	= Trim(Rs("EndTime"))
													subject		= Trim(Rs("strSubject"))
													'place		= Trim(Rs("Place"))
													'content	= Trim(Rs("strContent"))

													If nDate = targetDate Then
							%>
													<div class="" >
														<!-- <span class="layers"><%=cutString2(subject,10)%></span> -->
													</div>
							<%
													Rs.MoveNext
													ElseIf nDate > targetDate Then
														Exit Do
													End If
												Loop
											End If

											PRINT "</div></td>"
										viewDay = viewDay + 1

										End If
									Next
									PRINT "</tr>"
									If viewDay > lastDay Then Exit For
								Next
							%>
							</tbody>
						</table>
					</div>
				</div>