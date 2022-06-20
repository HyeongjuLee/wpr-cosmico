<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%
	'Call FN_NationCurrency(LANG,Chg_CurrencyName,Chg_CurrencyISO)

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	orderIDX = pRequestTF("orderIDX",False)
	tBodyID = pRequestTF("tBodyID",False)
	Ri		= pRequestTF("Ri",False)
	If orderIDX = "" Then

		PRINT "		<tr>"
		PRINT "		<td colspan=""8"" class=""notData tweight tcenter"">주문상품이 없거나 주문내역이 존재하지 않습니다. 새로고침 후 다시 시도해주세요.1</td>"
		PRINT "		</tr>"
	Else
		k = 0

		SQL = "SELECT [status] FROM [DK_ORDER] WHERE [intIDX] = ?"
		arrParams = Array(_
			Db.makeParam("@orderIDX",adInteger,adParamInput,4,orderIDX) _
		)
		ThisStatus = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)



		arrParams = Array(_
			Db.makeParam("@orderIDX",adInteger,adParamInput,4,orderIDX) _
		)
		arrList = Db.execRsList("DKP_ORDER_GOODS_VIEW",DB_PROC,arrParams,listLen,Nothing)
		If IsArray(arrList) Then
			For i = 0 To listLen
				arrList_intIDX					= arrList(0,i)
				arrList_orderIDX				= arrList(1,i)
				arrList_GoodIDX					= arrList(2,i)
				arrList_strOption				= arrList(3,i)
				arrList_orderEa					= Int(arrList(4,i))
				arrList_orderDtoD				= arrList(5,i)
				arrList_orderDtoDValue			= arrList(6,i)
				arrList_orderDtoDDate			= arrList(7,i)
				arrList_reviewTF				= arrList(8,i)
				arrList_GoodsPrice				= Int(arrList(9,i))
				arrList_goodsOptionPrice		= Int(arrList(10,i))
				arrList_goodsPoint				= Int(arrList(11,i))
				arrList_goodsCost				= Int(arrList(12,i))
				arrList_OrderNum				= arrList(13,i)
				arrList_isShopType				= arrList(14,i)
				arrList_strShopID				= arrList(15,i)
				arrList_GoodsName				= arrList(16,i)
				arrList_ImgThum					= arrList(17,i)
				arrList_GoodsDeliveryType		= arrList(18,i)
				arrList_GoodsDeliveryFeeType	= arrList(19,i)
				arrList_GoodsDeliveryFee		= arrList(20,i)
				arrList_GoodsDeliveryLimit		= arrList(21,i)

				arrList_ShopCNT					= arrList(22,i)
				arrList_DELICNT					= arrList(23,i)

				arrList_OrderDtoD				= arrList(24,i)
				arrList_OrderDtoDValue			= arrList(25,i)
				arrList_OrderDtoDDate			= arrList(26,i)
				arrList_Status					= arrList(27,i)

			'	imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_ImgThum)
			'	imgWidth = 0
			'	imgHeight = 0
			'	Call ImgInfo(imgPath,imgWidth,imgHeight,"")
			'	imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
			'	'viewImg(imgPath,imgWidth,imgHeight,"")

				If Left(LCase(arrList_ImgThum),7) = "http://" Or Left(LCase(arrList_ImgThum),8) = "https://" Then
					imgPath = backword(arrList_ImgThum)
					imgWidth = upImgWidths_Thum
					imgHeight = upImgHeight_Thum
					imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
				Else
					imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_ImgThum)
					imgWidth = 0
					imgHeight = 0
					Call ImgInfo(imgPath,imgWidth,imgHeight,"")
					imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
					'viewImg(imgPath,imgWidth,imgHeight,"")
				End If


					'CS상품 정보 유무 확인
					SQL4 = "SELECT "
					SQL4 = SQL4 & " [isCSGoods],[CSGoodsCode] "
					SQL4 = SQL4 & " FROM [DK_GOODS] WHERE [intIDX] = ?"
					arrParams4 = Array(_
						Db.makeParam("@GoodIDX",adInteger,adParamInput,4,arrList_GoodIDX) _
					)
					Set DKRS4 = Db.execRs(SQL4,DB_TEXT,arrParams4,Nothing)
					If Not DKRS4.BOF And Not DKRS4.EOF Then
						DKRS4_isCSGoods		= DKRS4("isCSGoods")
						DKRS4_CSGoodsCode	= DKRS4("CSGoodsCode")
					End If
					Call closeRs(DKRS4)

					If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE ="ADMIN" Then
						If DKRS4_isCSGoods	= "T" Then printGoodsIcon = "<span class=""icons"">"&viewImg(IMG_ICON&"/i_csgoodsT.gif",50,11,"")&"</span>"
					End If


				sum_optionPrice = 0
				arrResult = Split(CheckSpace(arrList_strOption),",")
				printOPTIONS = ""
				For j = 0 To UBound(arrResult)
					arrOption = Split(Trim(arrResult(j)),"\")
					arrOptionTitle = Split(arrOption(0),":")
					If arrOption(1) > 0 Then
						OptionPrice = " / + " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
					ElseIf arrOption(1) < 0 Then
						OptionPrice = "/ - " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
					ElseIf arrOption(1) = 0 Then
						OptionPrice = ""
					End If
					printOPTIONS = printOPTIONS & "<span style='font-size:8pt;color:#9e9e9e;'>[옵션] "& arrOptionTitle(0) & " : " & arrOptionTitle(1) & OptionPrice & "</span><br />"
					sum_optionPrice = Int(sum_optionPrice) + Int(arrOption(1))
				Next

				self_GoodsPrice			= arrList_orderEa * arrList_GoodsPrice
				self_GoodsPoint			= arrList_orderEa * arrList_goodsPoint
				self_GoodsOptionPrice	= arrList_orderEa * arrList_goodsOptionPrice
				self_TOTAL_PRICE		= self_GoodsPrice + self_GoodsOptionPrice


				If arrList_GoodsDeliveryType = "SINGLE" Then
					arrList_DELICNT		= 1
					self_DeliveryFee	= Int(arrList_orderEa) * Int(arrList_GoodsDeliveryFee)
					txt_DeliveryFee		= "<span class=""tweight"">선결제 "&spans(num2cur(self_DeliveryFee),"#FF6600","","")&""&Chg_CurrencyISO&"</span><br /><span class=""f11px lheight130""> 개당 "&num2cur(arrList_GoodsDeliveryFee)&""&Chg_CurrencyISO&"<br /> 단독배송상품</span>"

				Else
					If arrList_DELICNT = 1 Then
						If self_TOTAL_PRICE >= arrList_GoodsDeliveryLimit Then
							self_DeliveryFee	= "0"
							txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_CurrencyISO&" 이상<br /> 무료배송</span>"
						Else
							self_DeliveryFee	= Int(arrList_GoodsDeliveryFee)
							txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&""&Chg_CurrencyISO&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_CurrencyISO&" 이상<br /> 무료배송</span>"
						End If
					Else
						arrParams3 = Array(_
							Db.makeParam("@orderIDX",adInteger,adParamInput,4,orderIDX), _
							Db.makeParam("@strShopID",adVarChar,adParamInput,30,arrList_strShopID), _
							Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,arrList_GoodsDeliveryType) _
						)
						arrList3 = Db.execRsList("DKP_ORDER_DELIVERY_CALC",DB_PROC,arrParams3,listLen3,Nothing)

						self_TOTAL_PRICE = 0
						If IsArray(arrList3) Then
							For z = 0 To listLen3
								arrList3_GoodsPrice		= arrList3(0,z)
								arrList3_OrderEa		= arrList3(1,z)
								arrList3_strOption		= arrList3(2,z)

								'내부 옵션 가격 확인
								calc_optionPrice = 0
								arrResult3 = Split(CheckSpace(arrList3_strOption),",")

								For y = 0 To UBound(arrResult3)
									arrOption3 = Split(Trim(arrResult3(y)),"\")
									calc_optionPrice = Int(calc_optionPrice) + Int(arrOption3(1))
								Next
								self_TOTAL_PRICE = self_TOTAL_PRICE + (calc_optionPrice * arrList3_OrderEa) + (arrList3_GoodsPrice*arrList3_OrderEa)
							Next
						End If
						If self_TOTAL_PRICE >= arrList_GoodsDeliveryLimit Then
							self_DeliveryFee	= "0"
							txt_DeliveryFee		= "<span class=""tweight"">"&spans("무료배송","#FF6600","","")&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_CurrencyISO&" 이상<br /> 무료배송</span>"
						Else
							self_DeliveryFee	= Int(arrList_GoodsDeliveryFee)
							txt_DeliveryFee		= "<span class=""tweight"">"&arrList_GoodsDeliveryFeeType&" "&num2cur(self_DeliveryFee)&""&Chg_CurrencyISO&"</span><br /><span class=""f11px lheight130"">묶음배송 상품 <br />"&num2cur(arrList_GoodsDeliveryLimit)&" "&Chg_CurrencyISO&" 이상<br /> 무료배송</span>"
						End If
					End If
				End If
				'상태값 정보
					If ThisStatus = "101" Then
						readOnlys = " "
						readOnlyc = " "
						disables = ""
						clickDate = " onclick=""openCalendar(event, this, 'YYYY-MM-DD');"""
					Else
						readOnlys = " readonly=""readonly"""
						readOnlyc = " readonly"
						disables = " disabled=""disabled"""
						clickDate = " "
					End If


					Select Case arrList_Status
						Case "100" : printStatus = "<p class=""tcenter"">입금확인이 안된 상품</p>"
						'Case "101" : printStatus = "<a href=""javascript:go102Btn('"&arrList_intIDX&"','"&tBodyID&"','"&orderIDX&"');"">배송준비중으로 변경</a>"
						'Case "102" : printStatus = "<a href=""javascript:go103Btn('"&arrList_intIDX&"');"">배송완료으로 변경</a>"

						Case "101","102","103"
							If arrList_Status = "102" Then
								Form_submit_img = "dtod_modify"
							Else
								Form_submit_img = "dtod_input"
							End If
							printStatus = ""
							printStatus = printStatus & "			<form name='dtodFrm' method='post' onsubmit='return thisfrm(this)'>"
							printStatus = printStatus & "			<input type=""hidden"" name=""uptBodyID"" value=""tbody_"&arrList_OrderNum&""">"
							printStatus = printStatus & "			<input type=""hidden"" name=""tBodyID"" value="""&tBodyID&""">"
							printStatus = printStatus & "			<input type=""hidden"" name=""orderIDX"" value="""&orderIDX&""">"
							printStatus = printStatus & "			<input type=""hidden"" name=""Ri"" value="""&Ri&""">"
							printStatus = printStatus & "				<p>배송일자 : <input type='text' name='dtodDate' value='"&arrList_OrderDtoDDate&"' "&noDtoD&" class='input_text "&readOnlyc&"' "&clickDate&" "&disables&" style=""width:70px;""  readonly=""readonly"" />"
							If arrList_Status = "102" Or arrList_Status = "103" Then
								If arrList_orderDtoD <> "0" Then
									arrParams3 = Array(_
										Db.makeParam("@intIDX",adInteger,adParamInput,0,arrList_orderDtoD) _
									)
									Set DKRS1 = Db.execRs("DKP_DTOD_SELECTOR",DB_PROC,arrParams3,Nothing)
									If Not DKRS1.BOF And Not DKRS1.EOF Then
										'DKRS1_intIDX			= DKRS1("intIDX")
										'DKRS1_intSort			= DKRS1("intSort")
										'DKRS1_strDtoDName		= DKRS1("strDtoDName")
										'DKRS1_strDtoDTel		= DKRS1("strDtoDTel")
										'DKRS1_strDtoDURL		= DKRS1("strDtoDURL")
										DKRS1_strDtoDTrace		= DKRS1("strDtoDTrace")
										'DKRS1_useTF				= DKRS1("useTF")
										'DKRS1_defaultTF			= DKRS1("defaultTF")

										printStatus = printStatus & " <span class=""button small tnormal""><a href="""&DKRS1_strDtoDTrace&arrList_orderDtoDValue&""" target=""_blank"">배송추적</a></span>"
									Else
										'printStatus = printStatus & "("&arrList_orderDtoDDate&")<br />"
										printStatus = printStatus & "미등록 배송사"
									End If
								Else
									'PRINT "("&arrList_orderDtoDDate&")<br />"
									'PRINT "배송날짜만 존재 <br />"
									printStatus = printStatus & " <span class=""button small""><a href=""javascript:alert('직접수령, 퀵수령등 택배사를 이용하지 않는 배송입니다.');"">배송추적</a></span>"
								End If
							End If
							printStatus = printStatus & "				</p>"
							printStatus = printStatus & "				<p>배송업체 : <select name='dtod' "&noDtoD&" "&disables&">"
							printStatus = printStatus & "					<option value=''>배송업체선택</option>"
							printStatus = printStatus & "					<option value='date' style='color:red;'"&isSelect("0",arrList_OrderDtoD)&">배송일자만 입력</option>"
							printStatus = printStatus & "					<option value=''>----------------------</option>"
								SQL = "SELECT [intIDX] FROM [DK_DTOD] WHERE [useTF] = 'T' AND [defaultTf] = 'T'"
								basicDtoD = Db.execRsData(SQL,DB_TEXT,Nothing,Nothing)
								SQL = " SELECT * FROM [DK_DTOD] WHERE [useTF] = 'T' ORDER BY [intIDX] ASC "
								arrList2 = Db.execRsList(SQL,DB_TEXT,Nothing,listLen2,Nothing)
								If IsArray(arrList2) Then
									For g = 0 To listLen2
										If arrList_OrderDtoD = "" Or IsNull(arrList_OrderDtoD) Then
											printStatus = printStatus &  "<option value='"&arrList2(0,g)&"'"&isSelect(arrList2(0,g),basicDtoD)&">"&arrList2(2,g)&"</option>"
										Else
											printStatus = printStatus &  "<option value='"&arrList2(0,g)&"'"&isSelect(arrList2(0,g),arrList_OrderDtoD)&">"&arrList2(2,g)&"</option>"
										End If
									Next
								End If
							printStatus = printStatus & "			</select></p><p>송장번호 : <input type='text' name='dtodnum' class='input_text vmiddle "&readOnlyc&"' value='"&arrList_OrderDtoDValue&"' "&noDtoD&" "&readOnlys&" style=""width:150px;"" /></p>"
							If ThisStatus = "101" Then
							printStatus = printStatus & "			<p class=""tcenter"" style=""margin-top:4px;""><input type='image' src='"&img_btn&"/"&Form_submit_img&".gif' style='vertical-align:middle;' "&noDtoD&" /></p>"
							End If
							printStatus = printStatus & "				<input type='hidden' name='ChgIDX' value='"&arrList_intIDX&"' />"
							printStatus = printStatus & "			</form>"
							If arrList_Status = "103" Then printStatus = printStatus &	"		<p class=""tcenter red tweight"" style=""margin-top:4px;"">수취확인</p>"
						Case "104" : printStatus = "104"
						Case "201" : printStatus = "201"
						Case "301" : printStatus = "301"
						Case "302" : printStatus = "302"
					End Select

				'배송정보

				trClass = ""
				If arrList_ShopCNT = 1 Then
					rowSpans1 = ""
					k = 1

				Else
					trClass = "bgC1"
					If k = 0 Then
						k = 1
						rowSpans1 = " rowspan="""&arrList_ShopCNT&""" "
					Else
						k = k
					End If
				End If
				trClass2 = ""
				If i = listLen Then trClass2 = " lastTR"

				PRINT "		<tr>"
				PRINT "			<td class=""tcenter bor_nr"" style=""padding:10px 0px;""><div class=""thumImg"" style=""padding:"&imgPaddingH&"px 0px;"">"&viewImg(imgPath,imgWidth,imgHeight,"")&"</div></td>"
				PRINT "			<td class=""subject vtop bor_nl"" style=""padding:10px 0px;"">"
				PRINT "				<p>"&backword(printGoodsIcon)&"</p>"
				PRINT "				<p class=""goodsName""><strong>"&backword(arrList_GoodsName)&"</strong></p>"
				PRINT "				<p class=""goodsOption"">"&printOPTIONS&"</p>"
				PRINT "			</td>"
				PRINT "			<td class=""tcenter""><strong>"&arrList_orderEa&"</strong> ea</td>"
				PRINT "			<td class=""tcenter bor_nr"" style=""line-height:160%;""><strong>상품 : </strong><br />옵션 : <br />적립 : </td>"
				PRINT "			<td class=""tright bor_nl"" style=""line-height:160%; padding-right:4px;"">"
				PRINT "				<strong>"&spans(num2cur(self_GoodsPrice),"#FF6600","","")&" "&Chg_CurrencyISO&"</strong>"
				PRINT "				<br />"&spans(num2cur(self_GoodsOptionPrice),"#FF6600","","bold")&" "&Chg_CurrencyISO&""
				PRINT "				<br />"&num2cur(self_GoodsPoint)&" "&Chg_CurrencyISO&""
				PRINT "			</td>"
				If k = 1 Then
					PRINT "			<td class=""tcenter bor_l lheight160 lastTD"" "&rowSpans1&">"
								SQL = "SELECT [strComName] FROM [DK_DELIVERY_FEE_BY_COMPANY] WHERE [strShopID] = ?"
								arrParams2 = Array(_
									Db.makeParam("@strUserID",adVarChar,adParamInput,30,arrList_strShopID) _
								)
								txt_strComName = Db.execRsData(SQL,DB_TEXT,arrParams2,Nothing)
								PRINT "<strong>"&arrList_strShopID&"</strong><br /><span class=""f11px"">"&txt_strComName&"</span>"
					PRINT "			</td>"
				End If
				If arrList_DELICNT = 1 Then
					rowSpans2 = ""
					l = 1
				Else
					If l = 0 Then
						l = 1
						rowSpans2 = " rowspan="""&arrList_DELICNT&""" "
					Else
						l = l
					End If
				End If
				' 배송비 합산
					If l = 1 Then
						PRINT "		<td class=""tcenter bor_l lheight160"" "&rowSpans2&">"&txt_DeliveryFee&"</td>"
						PRINT "		<td class=""deliveryInfo bor_l lheight160"" "&rowSpans2&">"&printStatus&"</td>"
					End If
				' 배송비 합산
				PRINT "		</tr>"
				If arrList_DELICNT = 1 Or arrList_DELICNT = k Then
					l = 0
				Else
					l = l + 1
				End If

				If arrList_ShopCNT = 1 Or arrList_ShopCNT = k Then
					k = 0
				Else
					k = k + 1
				End If
			Next
		End If
	End If


%>


