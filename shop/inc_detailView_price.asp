<%
'	Call ResRW(pidx,"pidx")
'	Call ResRW(joinType,"joinType")
'	Call ResRW(feeCode,"feeCode")
'	Call ResRW(mType,"mType")

	'mType = 36

	arrParams = Array(_
		Db.makeParam("@phoneIDX",adInteger,adParamInput,0,pidx),_
		Db.makeParam("@joinType",adVarChar,adParamInput,5,joinType),_
		Db.makeParam("@price1",adVarChar,adParamInput,20,Left(feeCode,3)),_
		Db.makeParam("@price2",adInteger,adParamInput,0,mType)_
	)
	arrListR = Db.execRsList("DKP_REALPRICE",DB_PROC,arrParams,listLenR,Nothing)

	Select Case mType
		Case 12 : Monthly = 365
		Case 18 : Monthly = 548
		Case 24 : Monthly = 730
		Case 36 : Monthly = 1095
	End Select


	Select Case Left(feeCode,3)
		Case "101"
			PRINT "	<table "&tableatt&" class=""realPrice"">"
			PRINT "		<tr>"
			PRINT "			<th rowspan=""13"">고객<br />구매가</td>"
			PRINT "			<td colspan=""2"" class=""thsub"">요금제</br>(기본료)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"">출고가 (a)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"">KT 단말기할인 (b)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"">핸드폰 할인2 (c)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"">단말기 할부원금 (d=a-b-c)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td rowspan=""5"" class=""bgColor1"">KT<br />요금할인 (e)</td>"
			PRINT "			<td class=""inbgColor1"">기본요금할인</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td class=""inbgColor1"">추가할인(1년차)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td class=""inbgColor1"">추가할인(2년차)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td class=""inbgColor1"">프로모션 할인</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td class=""inbgColor1"">총 할인 금액</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"" class=""bgColor2"">실제 구매가(고객부담금, f=d-e)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"" class=""bgColor3"">월 납입 평균(g=f/"&mType&"개월)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"" class=""bgColor3"">월 예상 요금 (기본료 - g)</td>"
			PRINT "		</tr>"
			PRINT "	</table>"

			If IsArray(arrListR) Then
				For i = 0 To listLenR

					principal = arrListR(0,i) - arrListR(1,i) - arrListR(2,i)
					totalDisCount = arrListR(3,i) + arrListR(4,i) + arrListR(5,i) + arrListR(6,i)
					RealPrice = principal - totalDisCount

					MonthAvgPrice = RealPrice / mType
					MonthPrice = arrListR(8,i) + MonthAvgPrice

					tablewidths = 690 / (listLenR+1)



					PRINT "	<table "&tableatt&" class=""realPrice1"" style=""width:"&tablewidths&"px;"">"
					PRINT "		<tr>"
					PRINT "			<td class=""thsub"">"&arrListR(9,i)&"<br />"&spans("("&num2cur(arrListR(8,i))&"원)","",8,"")&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(0,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(1,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(2,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td><strong>"&num2cur(principal)&"</strong></td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(3,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(4,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(5,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(6,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(totalDisCount)&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td class=""bgColor2""><strong>"&num2cur(RealPrice)&"</strong></td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(MonthAvgPrice)&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(MonthPrice)&"</td>"
					PRINT "		</tr>"
					PRINT "	</table>"
				Next
			End If
			PRINT "	<p class=""alert"" style=""margin-top:20px;"">※ 스마트스폰서 / 약정 "&mType&"개월</p>"
			PRINT "	<p class=""alert""><span style=""color:#fff;"">※</span> 약정기간 미 준수(중도 해지/보상 기기변경) 시 위약금을 납부해야 합니다.</p>"
			PRINT "	<p class=""alert""><span style=""color:#fff;"">※</span> 위약금 = 핸드폰 할인2 * [("&Monthly&"일 - 사용일수)/"&Monthly&"일]</p>"
			PRINT "	<p class=""alert2"">※ 가입 첫달 요금할인은 일할 계산됩니다.</p>"
		Case "102"
			PRINT "	<table "&tableatt&" class=""realPrice"">"
			PRINT "		<tr>"
			PRINT "			<th rowspan=""13"">고객<br />구매가</td>"
			PRINT "			<td colspan=""2"" class=""thsub"">요금제</br>(기본료)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"">출고가 (a)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"">핸드폰 할인(b)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"">단말기 할부원금 (c=a-b)</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"" class=""bgColor2"">월 납입 평균(d=c/"&mType&"개월)</td>"
			PRINT "		</tr>"
			PRINT "	</table>"

			If IsArray(arrListR) Then
				For i = 0 To listLenR

					principal = arrListR(0,i) - arrListR(1,i) - arrListR(2,i)
					totalDisCount = arrListR(3,i) + arrListR(4,i) + arrListR(5,i) + arrListR(6,i) + arrListR(7,i)
					RealPrice = principal - totalDisCount

					MonthAvgPrice = RealPrice / mType
					MonthPrice = arrListR(8,i) + MonthAvgPrice

					tablewidths = 690 / (listLenR+1)

					PRINT "	<table "&tableatt&" class=""realPrice1"" style=""width:"&tablewidths&"px;"">"
					PRINT "		<tr>"
					PRINT "			<td class=""thsub"">"&arrListR(9,i)&"("&mType&" 개월)</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(0,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td>"&num2cur(arrListR(7,i))&"</td>"
					PRINT "		</tr><tr>"
					PRINT "			<td><strong>"&num2cur(RealPrice)&"</strong></td>"
					PRINT "		</tr><tr>"
					PRINT "			<td class=""bgColor2"">"&num2cur(MonthAvgPrice)&"</td>"
					PRINT "		</tr>"
					PRINT "	</table>"
				Next
			End If
			PRINT "<div class=""clear fleft"" style=""margin-top:20px;"">"
			PRINT "	<table "&tableatt&" class=""shockBasic"" style=""width:530px;"">"
			PRINT "		<tr>"
			PRINT "			<td colspan=""5"" class=""notbor"">"&viewImg(SIMG_SHOP&"/realPrice_shockBasic.gif",500,35,"")&"</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td colspan=""2"" class=""bgcolor1"">약정개월</td>"
			PRINT "			<td class=""bgcolor2"">12개월</td>"
			PRINT "			<td class=""bgcolor2"">18개월</td>"
			PRINT "			<td class=""bgcolor2"">24개월</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td rowspan=""2"">월 요금할인<br /> (월정액+국내통화료)</td>"
			PRINT "			<td class=""bgcolor3"">3만원초과<br />~<br />4만원이하</td>"
			PRINT "			<td class=""tright"">최대 3,300원</td>"
			PRINT "			<td class=""tright"">최대 5,500원</td>"
			PRINT "			<td class=""tright"">최대 11,000원</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td class=""bgcolor3"">4만원초과</td>"
			PRINT "			<td colspan=""3"" class=""singletd"">초과금액 10% 추가할인</td>"
			PRINT "		</tr>"
			PRINT "	</table>"
			PRINT "	<table "&tableatt&" class=""shockBasic"" style=""width:430px; margin-left:30px;"">"
			PRINT "		<tr>"
			PRINT "			<td colspan=""5"" class=""notbor"">"&viewImg(SIMG_SHOP&"/realPrice_shockBasic02.gif",430,35,"")&"</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td class=""tleft"" style=""height:80px;line-height:30px;"">"
			PRINT "				<p style=""margin-left:30px;"">■ 쇼킹스폰서 "&mType&" 개월 약정</p>"
			PRINT "				<p style=""margin-left:30px;"">■ 단말기 위약금 = "&num2cur(totalDisCount)&" 원 * (("&Monthly&"일-사용일수))/"&Monthly&"일)</p>"
			PRINT "			</td>"
			PRINT "		</tr><tr>"
			PRINT "			<td class=""notbor tcenter"" style=""height:40px;"">유의사항 : 개통 후 3개월 이내 해지,정지,기변,명의변경이 불가합니다.</td>"
			PRINT "		</tr>"
			PRINT "	</table>"
			PRINT "	</div>"
	End Select
%>
