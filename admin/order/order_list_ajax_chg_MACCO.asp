<%
				arrParams2 = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
				)
				Set DKRS = Db.execRs("DKPA_ORDER_CHG",DB_PROC,arrParams2,Nothing)

				If Not DKRS.BOF And Not DKRS.EOF Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV

						arrList_intIDX					= DKRS(0)
						arrList_strDomain				= DKRS(1)
						arrList_OrderNum				= DKRS(2)
						arrList_strIDX					= DKRS(3)
						arrList_strUserID				= DKRS(4)
						arrList_payWay					= DKRS(5)
						arrList_totalPrice				= DKRS(6)
						arrList_totalDelivery			= DKRS(7)
						arrList_totalOptionPrice		= DKRS(8)
						arrList_totalPoint				= DKRS(9)
						arrList_strName					= DKRS(10)
						arrList_strTel					= DKRS(11)
						arrList_strMob					= DKRS(12)
						arrList_strEmail				= DKRS(13)
						arrList_strZip					= DKRS(14)
						arrList_strADDR1				= DKRS(15)
						arrList_strADDR2				= DKRS(16)
						arrList_takeName				= DKRS(17)
						arrList_takeTel					= DKRS(18)
						arrList_takeMob					= DKRS(19)
						arrList_takeZip					= DKRS(20)
						arrList_takeADDR1				= DKRS(21)
						arrList_takeADDR2				= DKRS(22)
						arrList_orderMemo				= DKRS(23)
						arrList_strSSH1					= DKRS(24)
						arrList_strSSH2					= DKRS(25)
						arrList_status					= DKRS(26)
						arrList_status100Date			= DKRS(27)
						arrList_status101Date			= DKRS(28)
						arrList_status102Date			= DKRS(29)
						arrList_status103Date			= DKRS(30)
						arrList_status104Date			= DKRS(31)
						arrList_status201Date			= DKRS(32)
						arrList_status301Date			= DKRS(33)
						arrList_status302Date			= DKRS(34)
						arrList_DtoDCode				= DKRS(35)
						arrList_DtoDNumber				= DKRS(36)
						arrList_DtoDDate				= DKRS(37)
						arrList_CancelCause				= DKRS(38)
						arrList_bankIDX					= DKRS(39)
						arrList_bankingName				= DKRS(40)
						arrList_usePoint				= DKRS(41)
						arrList_totalVotePoint			= DKRS(42)
						arrList_PGorderNum				= DKRS(43)
						arrList_PGCardNum				= DKRS(44)
						arrList_PGAcceptNum				= DKRS(45)
						arrList_PGinstallment			= DKRS(46)
						arrList_PGCardCode				= DKRS(47)
						arrList_PGCardCom				= DKRS(48)
						arrList_bankingCom				= DKRS(49)
						arrList_bankingNum				= DKRS(50)
						arrList_bankingOwn				= DKRS(51)
						arrList_TOTAL_CNT				= DKRS(52)
						arrList_TOTAL_CNT102			= DKRS(53)

						'print arrList_TOTAL_CNT
						'print arrList_TOTAL_CNT102


						chg_State = CallState(arrList_status)
						'print arrList_strTel

						'If DKCONF_SITE_ENC = "T" Then
						'	If arrList_strADDR1		<> "" Then arrList_strADDR1			= Trim(objEncrypter.Decrypt(arrList_strADDR1))
						'	If arrList_strADDR2		<> "" Then arrList_strADDR2			= Trim(objEncrypter.Decrypt(arrList_strADDR2))
						'	If arrList_strTel		<> "" Then arrList_strTel			= Trim(objEncrypter.Decrypt(arrList_strTel))
						'	If arrList_strMob		<> "" Then arrList_strMob			= Trim(objEncrypter.Decrypt(arrList_strMob))

						'	If arrList_takeTel		<> "" Then arrList_takeTel			= Trim(objEncrypter.Decrypt(arrList_takeTel))
						'	If arrList_takeMob		<> "" Then arrList_takeMob			= Trim(objEncrypter.Decrypt(arrList_takeMob))
						'	If arrList_takeADDR1	<> "" Then arrList_takeADDR1		= Trim(objEncrypter.Decrypt(arrList_takeADDR1))
						'	If arrList_takeADDR2	<> "" Then arrList_takeADDR2		= Trim(objEncrypter.Decrypt(arrList_takeADDR2))
						'End if

					'CS ???????????? ??????
						SQL2 = "SELECT [OrderNumber] FROM [tbl_SalesDetail] WHERE [ETC2] = '???????????????:'+ ? "
						arrParams = Array(_
							Db.makeParam("@OrderNum",adVarChar,adParamInput,20,arrList_OrderNum) _
						)
						Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
						If Not HJRSC.BOF And Not HJRSC.EOF Then
							RS_OrderNumber   = HJRSC(0)
						Else
							RS_OrderNumber   = ""
						End If
						Call closeRS(HJRSC)

					'CS ????????????(???????????????) ??????
						SQL4 = "SELECT [OrderNumber] FROM [tbl_SalesDetail_Mod_Del] WHERE [ETC2] = '???????????????:'+ ? "
						arrParams = Array(_
							Db.makeParam("@OrderNum",adVarChar,adParamInput,20,arrList_OrderNum) _
						)
						Set HJRSC = DB.execRs(SQL4,DB_TEXT,arrParams,DB3)
						If Not HJRSC.BOF And Not HJRSC.EOF Then
							RS_OrderNumber_Del   = HJRSC(0)
						Else
							RS_OrderNumber_Del   = ""
						End If
						Call closeRS(HJRSC)


					'???????????????????????????
						SQL3 = "SELECT A.[OrderNumber],A.[INS_NUM],A.[INS_Num_Date] "
						SQL3 = SQL3 & " ,[isCanCel] = (SELECT COUNT(*) FROM [tbl_SalesDetail] WHERE A.[OrderNumber] = [Re_BaseOrderNumber]),A.[INS_Num_Cancel]"
						SQL3 = SQL3 & " FROM [tbl_salesdetail] AS A WHERE [OrderNumber] = ?"
						arrParams = Array(_
							Db.makeParam("@OrderNum",adVarChar,adParamInput,20,RS_OrderNumber) _
						)
						Set HJRSC = DB.execRs(SQL3,DB_TEXT,arrParams,DB3)
						If Not HJRSC.BOF And Not HJRSC.EOF Then
							RS_OrderNumber		 = HJRSC(0)		'CS????????????
							RS_INS_Num			 = HJRSC(1)		'????????????
							RS_INS_Num_Date		 = HJRSC(2)		'???????????? ?????????
							RS_isCanCel			 = HJRSC(3)		'1 =  ??????????????????
							RS_INS_Num_Cancel	 = HJRSC(4)		'Y =  ????????????

							If RS_isCanCel = 1 Then
								TxtClass1 = "style=""color:red;text-decoration:line-through;font-size:8pt;"""
								If RS_INS_Num_Cancel = "Y" Then
									INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:8pt;"">????????????</span>"
								Else
									INS_Num_STATE = "<br /><span style=""text-decoration:none;font-size:8pt;"">???????????????</span>"
								End If
								CS_OrderNumber = "<span style=""text-decoration:line-through;font-size:8pt;"">"&RS_OrderNumber&"</span><br /><span style=""text-decoration:none;font-size:8pt;"">????????????<!-- ???????????? --></span>"
							Else
								TxtClass1 = ""
								INS_Num_STATE = ""
								CS_OrderNumber = RS_OrderNumber
							End If
							If RS_INS_Num = "" Then
								insNums = "?????????<br />????????????"
							Else
								insNums = RS_INS_Num
							End If
						Else
							RS_INS_Num			 = ""
							RS_INS_Num_Date		 = ""
							RS_isCanCel			 = 0
							RS_INS_Num_Cancel	 = ""
							insNums				 = "--"
							INS_Num_STATE		 = ""
							CS_OrderNumber		 = ""
						End If
						Call closeRS(HJRSC)


						goBtn101 = aImg("javascript:go101Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_go101.gif",126,101,"")
						If arrList_TOTAL_CNT <> arrList_TOTAL_CNT102 Then
							goBtn102 = aImg("javascript:alert('??????/?????????????????? ??????????????? ??????????????????');viewInDiv('"&i&"','DivGoods','"&arrList_intIDX&"');",IMG_BTN&"/btn_order_go102n.gif",126,101,"")
						Else
							goBtn102 = aImg("javascript:go102Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_go102.gif",126,101,"")
						End If
						goBtn103 = aImg("javascript:go103Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_go103.gif",126,101,"")
						goBtn104 = viewImg(IMG_BTN&"/btn_order_104.gif",126,101,"")

						If RS_INS_Num <> "" Then
							backBtn100 = aImg("javascript:alert('??????????????? ????????? ???????????? ??????????????? ????????? ?????? ??? ????????????.');",IMG_BTN&"/btn_order_back100.gif",146,31,"")
						Else
							backBtn100 = aImg("javascript:back100Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
						End if
						backBtn101 = aImg("javascript:back101Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
						backBtn102 = aImg("javascript:back102Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_back102.gif",146,31,"")

						If RS_INS_Num <> "" And RS_INS_Num_Cancel <> "Y" And RS_isCanCel <> 1 Then
							goBtnCancel = aImg("javascript:alert('??????????????? ????????? ???????????? ????????? ??? ????????????.');",IMG_BTN&"/btn_order_go_cancel.gif",146,31,"")
						Else
							goBtnCancel = aImg("javascript:goCancelBtn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_go_cancel.gif",146,31,"")
						End If

						goBtnCancelN = aImg("javascript:alert('????????????????????? ????????? ????????? ??? ????????????. ????????? ????????????(?????????)??? ????????? ??????????????????.');",IMG_BTN&"/btn_order_go_cancelN.gif",146,31,"")
						'	goBtnDtoD = aImg("javascript:openDelivery('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_dtod.gif",146,31,"")

						CancelStat201 = viewImg(IMG_BTN&"/btn_cancel_admin.gif",126,101,"")
						CancelStat301 = viewImg(IMG_BTN&"/btn_cancel_customer.gif",126,101,"")
						CancelStat401 = viewImg(IMG_BTN&"/btn_cancel_customer_f.gif",126,101,"")

						goCancelStat401 = aImg("javascript:goCancelUBtn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_cancel_user.gif",146,31,"")

						'???????????? : ????????? ??????
						If RS_INS_Num <> "" And RS_INS_Num_Date <> "" Then
							goBackCancel102 = aImg("javascript:alert('??????????????? ????????? ???????????? ??????????????? ????????? ???????????? ????????????.');",IMG_BTN&"/btn_order_back100.gif",146,31,"")
							goBackCancel103 = aImg("javascript:alert('??????????????? ????????? ???????????? ???????????? ????????? ???????????? ????????????.')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
						Else
							goBackCancel102 = aImg("javascript:backc100Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
							goBackCancel103 = aImg("javascript:backc101Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
							'goBackCancel102 = aImg("javascript:backc100Btn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
							'goBackCancel103 = aImg("javascript:backc101Btn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")

							'goBackCancel104 = aImg("javascript:backc102Btn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_back102.gif",146,31,"")
						End If



						'CS ???????????? (??????????????? ???????????? ??????)
						If RS_OrderNumber_Del <> "" Then
							CS_OrderNumber = RS_OrderNumber_Del&"<br /><span class=""red"">CS????????????</span>"
						End If

						PRINT "<tr>"
						PRINT "	<td class='outTD'><strong>"&arrList_OrderNum&"</strong><br />"&CS_OrderNumber&"</td>"
						PRINT "	<td class='outTD'><span "&TxtClass1&">"&insNums&"</span>"&INS_Num_STATE&"</td>"
						PRINT "	<td class='outTD'>"&DateValue(arrList_status100Date)&"<br />"&TimeValue(arrList_status100Date)&"</td>"
						PRINT "	<td class='outTD'>"&arrList_strName&"<br />"&arrList_strUserID&"</td>"
						PRINT "	<td class='outTD'><strong>"&FormatNumber(arrList_totalPrice,0)&" ???</strong></td>"
						PRINT "	<td class='outTD'>"&FN_PAYWAY_VIEW(arrList_Payway)&"</td>"
						PRINT "	<td class='outTD'>"&chg_State&"</td>"
						PRINT "	<td class='outTD stateTD' rowspan='3'>"
						PRINT "		<div class=""btnZoneLeft"">"
						Select Case arrList_status
							Case "100" : PRINT goBtn101
							Case "101"
								SQL = "SELECT * FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
								arrParams = Array(_
									Db.makeParam("@intIDX",adInteger,adParamInput,0,arrList_intIDX) _
								)
								arrList2 = Db.execRsList(SQL,DB_TEXT,arrParams,listLen2,Nothing)
								chkCnt = 0
								If IsArray(arrList) Then
									For j = 0 To listLen2
										arrDtoD = arrList2(5,j)
										arrDtoDDate = arrList2(7,j)
										If arrDtoD = "" Or IsNull(arrDtoD) Or arrDtoDDate = "" Or IsNull(arrDtoDDate) Then
											chkCnt = chkCnt + 1
										Else
											chkCnt = chkCnt
										End If
									Next
								End If
								If chkCnt > 0 Then PRINT goBtn102 Else PRINT goBtn102 End If

							Case "102"
							If RS_INS_Num_Cancel = "Y" Then  '????????????????????? : ????????????????????????
							Else
								PRINT goBtn103
							End If


							Case "103" : PRINT goBtn104

							Case "201" : PRINT CancelStat201
							Case "301" : PRINT CancelStat301
							Case "302" : PRINT CancelStat401
						End Select
						PRINT "		</div>"
						PRINT "		<div class=""btnZoneRight"">"

						Select Case arrList_status
							Case "100"
								PRINT "<p class=""blines"">"&goBtnCancel&"</p>"
							Case "101"
								If RS_INS_Num_Cancel= "Y" Then						 '???????????????????????? : ??????????????? ????????????
								Else
									PRINT "<p class=""blines"">"&backBtn100&"</p>"
								End If
								PRINT "<p class=""blines"">"&goBtnCancel&"</p>"
							Case "102"
								If RS_INS_Num_Cancel= "Y" Then						 '???????????????????????? : ???????????? ????????????
								Else
									PRINT "<p class=""blines"">"&backBtn101&"</p>"
								End If
								PRINT "<p class=""blines"">"&goBtnCancel&"</p>"
							Case "103"
								PRINT "<p class=""blines"">"&backBtn102&"</p>"
								PRINT "<p class=""blines"">"&goBtnCancelN&"</p>"
							Case "201"
								If RS_INS_Num_Cancel= "Y" Then						 '???????????????????????? : ??????????????? ????????????
								Else
									PRINT "<p class=""blines"">"&goBackCancel102&"</p>"
								End If
								'PRINT "<p class=""blines"">"&goBackCancel103&"</p>"
								'PRINT "<p class=""blines"">"&goBackCancel104&"</p>"
							Case "301"
								If (RS_INS_Num_Cancel= "Y" And RS_isCanCel = "1") Or RS_OrderNumber_Del <> "" Then
									PRINT "<p class=""blines"">"&goCancelStat401&"</p>"	'????????????????????????/????????? ???????????????
								Else
									PRINT "<p class=""blines"">"&aImg("javascript:alert('CS?????? ???????????? ?????????????????? ???????????????.');",IMG_BTN&"/btn_cancel_user.gif",146,31,"")&"</p>"
								End If
							Case "302"
								If RS_INS_Num_Cancel= "Y" Or RS_OrderNumber_Del <> "" Then '???????????????????????? or CS??????????????? : ??????????????? ????????????
								Else
									PRINT "<p class=""blines"">"&goBackCancel102&"</p>"		'????????????????????? ????????????
								End If
								'PRINT "<p class=""blines"">"&goBackCancel103&"</p>"	'????????????  ?????? ????????????
								'PRINT "<p class=""blines"">"&goBackCancel104&"</p>"
						End Select

						PRINT "		</div>"

						calsGoodsPrice = 0
						realPrice = 0


						calsGoodsPrice = 0
						calsGoodsPrice = arrList_totalPrice + arrList_UsePoint - arrList_totalDelivery
						'???????????????
						realPrice = 0
						'		print arrtotalPrice
						'		print arrtotalDelivery
						'		print arrUsePoint

						realPrice = calsGoodsPrice + arrList_totalDelivery - arrList_UsePoint

						'?????????

						PRINT  "		</td>"
						PRINT  "	</tr><tr>"
						PRINT  "		<th colspan=""7"" class=""outTH"">??????????????????</th>"
						PRINT  "	</tr><tr>"
						PRINT  "		<td colspan=""7"" class=""outTD"">"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivPrice','');"">??????????????????</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivPayway','');"">????????????</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivDelivery','');"">???????????????</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivGoods','"&arrList_intIDX&"');"">??????/????????????</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""delete""></span><a href=""javascript:hiddInDiv('"&i&"');"">????????????</a></span>"
						PRINT  "		</td>"
						PRINT  "	</tr><tr>"
						PRINT  "		<td colspan=""8"" class=""tcenter viewCon"">"
						PRINT  "			<div class=""inDivs inDiv"&i&" DivPrice"&i&""" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">??????????????????</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100"">"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<tr>"
						PRINT  "						<th>????????????</th>"
						PRINT  "						<td>"&num2cur(calsGoodsPrice)&" ???</td>"
						PRINT  "						<th>????????????</th>"
						PRINT  "						<td>"&num2cur(arrList_totalOptionPrice)&" ???</td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>????????????</th>"
						PRINT  "						<td>"&num2cur(arrList_totalDelivery)&" ???</td>"
						PRINT  "						<th>????????? ????????????</th>"
						PRINT  "						<td>"&num2cur(arrList_usePoint)&" ???</td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>????????? ????????????</th>"
						PRINT  "						<td>"&num2cur(arrList_totalPoint)&" ???</td>"
						PRINT  "						<th>??????????????????</th>"
						PRINT  "						<td class=""red"">"&num2cur(arrList_totalPrice)&" ???</td>"
						PRINT  "					</tr>"
						PRINT  "				</table>"
						PRINT  "			</div>"
						PRINT  "			<div class=""inDivs inDiv"&i&" DivPayway"&i&""" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">????????????</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100"">"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<tr>"
						PRINT  "						<th>????????????</th>"
						PRINT  "						<td colspan=""3"">"&FN_PAYWAY_VIEW(arrList_Payway)&"</td>"
						PRINT  "					</tr>"
						Select Case LCase(arrList_Payway)
							Case "card"
								PRINT "						<tr>"
								PRINT  "						<th>PG??? ????????????</th>"
								PRINT  "						<td>"&arrList_PGorderNum&"</td>"
								PRINT  "						<th>????????????</th>"
								PRINT  "						<td>"&arrList_PGAcceptNum&"</td>"
								PRINT  "					</tr><tr>"
								PRINT  "						<th>????????????/??????</th>"
								PRINT  "						<td>"&arrList_PGCardCode&" / "&arrList_PGCardNum&"</td>"
								PRINT  "						<th>???????????????</th>"
								PRINT  "						<td class=""red"">"&arrList_PGinstallment&"</td>"
								PRINT  "					</tr>"
							Case "inbank"
								PRINT "						<tr>"
								PRINT  "						<th>????????????</th>"
								PRINT  "						<td>"&arrList_bankingCom&"</td>"
								PRINT  "						<th>????????????</th>"
								PRINT  "						<td>"&arrList_bankingNum&"</td>"
								PRINT  "					</tr><tr>"
								PRINT  "						<th>?????????</th>"
								PRINT  "						<td>"&arrList_bankingOwn&"</td>"
								PRINT  "						<th>???????????????</th>"
								PRINT  "						<td>"&arrList_bankingName&"</td>"
								PRINT  "					</tr>"
						End Select

						PRINT  "				</table>"
						PRINT  "			</div>"
						PRINT  "			<div class=""inDivs inDiv"&i&" DivDelivery"&i&""" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">???????????????</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100"">"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<tr>"
						PRINT  "						<th colspan=""2"">???????????????</th>"
						PRINT  "						<th colspan=""2"">???????????????</th>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>????????????</th>"
						PRINT  "						<td>"&arrList_strName&"</td>"
						PRINT  "						<th>???????????????</th>"
						PRINT  "						<td>"&arrList_takeName&"</td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>?????????</th>"
						PRINT  "						<td>"&arrList_strTel&"</td>"
						PRINT  "						<th>?????????</th>"
						PRINT  "						<td>"&arrList_takeTel&"</td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>???????????????</th>"
						PRINT  "						<td>"&arrList_strMob&"</td>"
						PRINT  "						<th>???????????????</th>"
						PRINT  "						<td><p class=""red"">"&arrList_takeMob&"</p></td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>??????</th>"
						PRINT  "						<td class=""addr""><p>("&arrList_strZip&")</p><p>"&arrList_strADDR1&"</p><p>"&arrList_strADDR2&"</p></td>"
						PRINT  "						<th>??????</th>"
						PRINT  "						<td class=""addr""><p class=""red"">("&arrList_takeZip&")</p><p class=""red"">"&arrList_takeADDR1&"</p><p class=""red"">"&arrList_takeADDR2&"</p></td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>?????????</th>"
						PRINT  "						<td>"&arrList_strEmail&"</td>"
						PRINT  "						<th>????????? ????????????</th>"
						PRINT  "						<td class=""red"">"&arrList_orderMemo&"</td>"
						PRINT  "					</tr>"
						PRINT  "				</table>"
						PRINT  "			</div>"


						PRINT  "			<div class=""inDivs inDiv"&i&" DivGoods"&i&" porel"" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">????????????</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100 GoodsTable tableFixed"">"
						PRINT  "					<col width=""100"" />"
						PRINT  "					<col width=""250"" />"
						PRINT  "					<col width=""50"" />"
						PRINT  "					<col width=""40"" />"
						PRINT  "					<col width=""80"" />"
						PRINT  "					<col width=""110"" />"
						PRINT  "					<col width=""130"" />"
						PRINT  "					<col width=""*"" />"
						PRINT  "					<tr>"
						PRINT  "						<th colspan=""2"">????????????</th>"
						PRINT  "						<th>??????</th>"
						PRINT  "						<th colspan=""2"">????????????</th>"
						PRINT  "						<th>?????????</th>"
						PRINT  "						<th>?????????</th>"
						PRINT  "						<th>????????????</th>"
						PRINT  "					</tr>"
						PRINT  "					<tbody id=""tbody"&i&""">1"
						PRINT  "					</tbody>"
						PRINT  "				</table>"
						PRINT  "			</div>"
						PRINT  "		</td>"
						PRINT  "	</tr>"
						If arrList_status = "301" Or arrList_status = "302" Then
							PRINT "	<tr>"
							PRINT "	<th>????????????</th>"
							PRINT "	<td colspan='4' class='td_lheight'>"&backword(arrList_CancelCause)&"</td>"
							PRINT "	<th>??????????????????</th>"
							PRINT "	<td class='td_lheight'>"&arrList_status301Date&"</td>"
							PRINT "	</tr>"
						End If

					Set objEncrypter = Nothing
				End If
%>