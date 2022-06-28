<!--#include virtual="/_lib/strFunc.asp" -->

<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BUY1-1"

	If Not (checkRef(houUrl &"/myoffice/buy/order_list.asp") _
			Or checkRef(houUrl &"/myoffice/buy/order_list_macco.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	'Call ONLY_CS_MEMBER()
	Call ONLY_CS_MEMBER_ALL()
	'Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	OrderNumber = gRequestTF("ord",False)

	'본인 주문번호 체크
	SQLOC = "SELECT [OrderNumber],[SellCode] FROM [tbl_Salesdetail] WITH(NOLOCK) WHERE [OrderNumber] = ? AND [mbid] = ?	AND [mbid2] = ?"
	arrParamsOC  = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,50,OrderNumber), _
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set HJRSC = Db.execRs(SQLOC,DB_TEXT,arrParamsOC,DB3)
	If Not HJRSC.BOF And Not HJRSC.EOF Then
		RS_OrderNumber  = HJRSC(0)
		RS_SellCode  = HJRSC(1)
	Else
		Call alerts(LNG_ALERT_WRONG_ACCESS&"_","close_p_modal","")
	End If
	Call closeRS(HJRSC)

	'OrderNumberCnt = Db.execRsData(SQLOC,DB_TEXT,arrParamsOC,DB3)
	'If OrderNumberCnt < 1 Then Call alerts(LNG_ALERT_WRONG_ACCESS&"_","close_p_modal","")

	'주문번호 승인체크
	SQLST = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WITH(NOLOCK) WHERE [OrderNumber] = ? "
	arrParamsST  = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,50,OrderNumber) _
	)
	isApproval = Db.execRsData(SQLST,DB_TEXT,arrParamsST,DB3)
%>
<!-- <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"> -->
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/style_cs.css" />
<link rel="stylesheet" href="/css/modal.css?" />
<link rel="stylesheet" href="/css/pay2.css?" />
<link rel="stylesheet" href="/css/myoffice.css?v1" />

<div style="padding: 0 15px;">
<%
		'▣결제상세내역
		arrParams2 = Array(_
			Db.makeParam("@orderNum",adVarChar,adParamInput,50,OrderNumber)_
		)
		arrList2 = Db.execRsList("DKP_ORDER_DETAIL_CACU",DB_PROC,arrParams2,listLen2,DB3)

		'PRINT TABS(1) & "			<div class=""width95a""><span class=""title2"">"&LNG_TEXT_PAYMENT_RECORD&"</span></div>"
		If IsArray(arrList2) Then
			PRINT TABS(1) & "	<div class=""pay_totals width100"">"
			PRINT TABS(1) & "		<table "&tableatt&" class=""innerTablePay width100"">"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<thead>"
			PRINT TABS(1) & "				<tr>"
			PRINT TABS(1) & "					<th colspan=""7"">"&LNG_TEXT_PAYMENT_RECORD&"</th>"
			PRINT TABS(1) & "				</tr>"
			PRINT TABS(1) & "			</thead>"
			PRINT TABS(1) & "			<tr>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_PAYMENT_METHOD&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_PAYMENT_AMOUNT&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT04&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT05&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT06&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_CS_ORDER_LIST_CACU_TEXT07&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_DEPOSITOR&"</th>"
			'PRINT TABS(1) & "				<th>"&LNG_TEXT_REMARKS&"</th>"
			PRINT TABS(1) & "			</tr>"
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				For k = 0 To listLen2
					arrList2_C_index				= arrList2(0,k)
					arrList2_OrderNumber			= arrList2(1,k)
					arrList2_C_TF					= arrList2(2,k)
					arrList2_C_Code					= arrList2(3,k)
					arrList2_C_CodeName				= arrList2(4,k)
					arrList2_C_Name1				= arrList2(5,k)
					arrList2_C_Name2				= arrList2(6,k)
					arrList2_C_Number1				= arrList2(7,k)
					arrList2_C_Number2				= arrList2(8,k)
					arrList2_C_Number3				= arrList2(9,k)
					arrList2_C_Price1				= arrList2(10,k)
					arrList2_C_Price2				= arrList2(11,k)
					arrList2_C_AppDate1				= arrList2(12,k)
					arrList2_C_AppDate2				= arrList2(13,k)
					arrList2_C_CancelTF				= arrList2(14,k)
					arrList2_C_CancelDate			= arrList2(15,k)
					arrList2_C_CancelPrice			= arrList2(16,k)
					arrList2_C_Period1				= arrList2(17,k)
					arrList2_C_Period2				= arrList2(18,k)
					arrList2_C_Installment_Period	= arrList2(19,k)
					arrList2_C_Etc					= arrList2(20,k)
					arrList2_C_Base_Index			= arrList2(21,k)

					arrList2_C_HY_ApNum			= arrList2(22,k)		'현금영수증 승인번호(거래번호)

					arrPGNAME = ""
					IF arrList2_C_Etc <> "" Then
						If Instr(arrList2_C_Etc,"/") > 0 Then
							On Error Resume Next
							arrCEtc = Split(arrList2_C_Etc,"/")
							arrPGNAME = arrCEtc(0)
							On Error Goto 0
						End IF
					End IF

					'현금영수증(ONOFFKOREA 가상계좌)
					If isApproval = "1" Then
						If arrPGNAME = "ONOFFKOREA" And arrList2_C_TF = "5" And arrList2_C_HY_ApNum <> "" Then
							'cashReceiptBtn ="<a onclick=""openPopup('https://store.onoffkorea.co.kr/api/receipt/cash.html?tran_seq="&arrList2_C_HY_ApNum&"','cashReceipt', 100, 100, 'left=300, top=200, scrollbars=yes')"" ><input type=""button"" class=""input_submit2 design1"" value=""현금영수증"" /></a>"
							cashReceiptBtn ="<a name=""modal"" href=""/myoffice/buy/cashReceipt.asp?seq="&arrList2_C_HY_ApNum&""" title=""현금영수증""><input type=""button"" class=""input_submit2 design1"" value=""현금영수증"" /></a>"
							PRINT "<div class=""fright"" style=""margin: 5px;"" >"&cashReceiptBtn&"</div>"
						End If
					End If

					Select Case arrList2_C_TF
						Case "1" : ThisPayment = LNG_TEXT_ORDER_CASH		'"현금"
						Case "2" : ThisPayment = LNG_TEXT_ORDER_BANK		'"무통장"
							arrList2_C_Name2 = arrList2_C_Name1
							arrList2_C_Name1 = ""
						Case "3" : ThisPayment = LNG_TEXT_ORDER_CARD		'"카드"
						Case "5"  : ThisPayment = LNG_TEXT_VIRTUAL_ACCOUNT			'가상계좌
						Case "50" : ThisPayment = LNG_TEXT_POINT_S			'S포인트
					End Select

					On Error Resume Next
						If arrList2_C_Number1	<> "" Then arrList2_C_Number1	= objEncrypter.Decrypt(arrList2_C_Number1)
					On Error Goto 0

					'If arrList2_C_Number1 <> "" And arrList2_C_TF = "3" Then
					'	arrList2_C_Number1_LEN = Len(arrList2_C_Number1) - 4
					'	arrList2_C_Number1 = Left(arrList2_C_Number1,arrList2_C_Number1_LEN) & "****"
					'End If

					If arrList2_C_TF = "3" Then
						If arrList2_C_Number1 <> "" Then
							'카드번호* 처리
							C_Number_LEN = 0
							C_Number_LEN = Len(arrList2_C_Number1)

							cStars = ""
							If C_Number_LEN >= 14 Then
								For s = 1 To 8				'1234********1234
									cStars = cStars&"*"
								Next
								arrList2_C_Number1 = Left(arrList2_C_Number1,4) & cStars & Right(arrList2_C_Number1,C_Number_LEN - (4+8))
							Else
								For s = 1 To 8
									cStars = cStars&"*"		'1234********8
								Next
								arrList2_C_Number1 =	Left(arrList2_C_Number1,4) & cStars & Right(arrList2_C_Number1,1)
							End If
						End If
					End If

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td>"&ThisPayment&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList2_C_Price1)&"</td>"
					PRINT TABS(1) & "		<td>"&date8to10(arrList2_C_AppDate1)&"</td>"
					PRINT TABS(1) & "		<td>"&arrList2_C_CodeName&"</td>"
					PRINT TABS(1) & "		<td>"&arrList2_C_Number1&"</td>"
					PRINT TABS(1) & "		<td>"&arrList2_C_Name1&"</td>"
					PRINT TABS(1) & "		<td>"&arrList2_C_Name2&"</td>"
					'PRINT TABS(1) & "		<td>"&arrList2_C_Etc&"</td>"
					PRINT TABS(1) & "	</tr>"
				Next
			Set objEncrypter = Nothing
			PRINT TABS(1) & "		</table>"
			PRINT TABS(1) & "	</div>"
		Else
			PRINT TABS(1) & "		<div class=""pay_totals width100"">"
			PRINT TABS(1) & "			<table "&tableatt&" class=""innerTablePay"">"
			PRINT TABS(1) & "				<tr>"
			PRINT TABS(1) & "					<td colspan=""1"" class=""nodata"">"&LNG_TEXT_NO_SALES_DETAIL&"</td>"
			PRINT TABS(1) & "				</tr>"
			PRINT TABS(1) & "			</table>"
			PRINT TABS(1) & "		</div>"
		End If


		'▣구매상세내역
		arrParams1 = Array(_
			Db.makeParam("@orderNum",adVarChar,adParamInput,50,OrderNumber)_
		)
		arrList1 = Db.execRsList("DKP_ORDER_DETAIL2",DB_PROC,arrParams1,listLen1,DB3)

		'PRINT TABS(1) & "		<div class=""width95a""><span class=""title2"">"&LNG_CS_ORDER_LIST_PURCHASE_PRODUCT&"</span></div>"
		If IsArray(arrList1) Then
			PRINT TABS(1) & "	<div class=""pay_totals width100"">"
			PRINT TABS(1) & "		<table "&tableatt&" class=""innerTableBuy width100"">"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<col width="""" />"
			PRINT TABS(1) & "			<thead>"
			PRINT TABS(1) & "			<tr>"
			PRINT TABS(1) & "				<th colspan=""9"">"&LNG_CS_ORDER_LIST_PURCHASE_PRODUCT&"</th>"
			PRINT TABS(1) & "			</tr>"
			PRINT TABS(1) & "			</thead>"
			PRINT TABS(1) & "			<tr>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_NUMBER&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_ITEM_NAME&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_CONSUMER_PRICE&"</th>"	'(소비자가)
			PRINT TABS(1) & "				<th>"&LNG_TEXT_PURCHASE_PRICE&"</th>"	'(구매가)
			PRINT TABS(1) & "				<th>"&CS_PV&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_ITEM_NUMBER&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_TOTAL_SALES_PRICE&"</th>"
			PRINT TABS(1) & "				<th>"&LNG_TEXT_DELIVERY_INFO&"</th>"
			PRINT TABS(1) & "			</tr>"

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				For j = 0 To listLen1
					arr_name			= arrList1(1,j)
					arr_price			= arrList1(2,j)			'소비자가
					arr_ItemPrice		= arrList1(3,j)			'회원가
					arr_ItemPV			= arrList1(4,j)			'PV
					arr_ItemCount		= arrList1(5,j)
					arr_ItemTotalPrice	= arrList1(6,j)
					arr_ItemTotalPV		= arrList1(7,j)
					arr_Receive_Method	= arrList1(8,j)
					arr_Delivery_No		= arrList1(9,j)
					arr_DCode			= arrList1(10,j)
					arr_Get_Name1		= arrList1(11,j)
					arr_Get_ZipCode		= arrList1(12,j)
					arr_Get_Address1	= arrList1(13,j)
					arr_Get_Address2	= arrList1(14,j)
					arr_Get_Tel1		= arrList1(15,j)
					arr_Get_Tel2		= arrList1(16,j)
					arr_Rece_OrderNo	= arrList1(17,j)
					arr_NCODE			= arrList1(18,j)
					arr_Sell_VAT_Price			= arrList1(19,j)	'부가세
					arr_Sell_Except_VAT_Price	= arrList1(20,j)	'공급가
					arr_Get_Etc1				= arrList1(21,j)
					arr_Get_Etc2				= arrList1(22,j)
					arr_ItemCV					= arrList1(23,j)
					arr_ItemTotalCV				= arrList1(24,j)

					On Error Resume Next
						If arr_Get_Address1		<> "" Then arr_Get_Address1		= objEncrypter.Decrypt(arr_Get_Address1)
						If arr_Get_Address2		<> "" Then arr_Get_Address2		= objEncrypter.Decrypt(arr_Get_Address2)
						If arr_Get_Tel1			<> "" Then arr_Get_Tel1			= objEncrypter.Decrypt(arr_Get_Tel1)
						If arr_Get_Tel2			<> "" Then arr_Get_Tel2			= objEncrypter.Decrypt(arr_Get_Tel2)
					On Error Goto 0

					'소비자가 변경체크
					arrParams = Array(_
						Db.makeParam("@ncode",adVarChar,adParamInput,20,arr_NCODE) _
					)
					Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
					If Not DKRS.BOF And Not DKRS.EOF Then
						arr_price	= DKRS("price1")
					Else
						arr_price	= arr_price
					End If
					Call CloseRS(DKRS)

					Select Case arr_Receive_Method
						Case "1"
							DELIVERY_WAY = LNG_TEXT_DIRECT_RECEIPT		'"직접수령"
						Case "2"
							DELIVERY_WAY = LNG_TEXT_PARCEL_RECEIPT		'"택배"
						Case "3"
							DELIVERY_WAY = LNG_TEXT_CENTER_RECEIPT		'"센타수령"
						Case Else
							DELIVERY_WAY = LNG_CS_ORDER_LIST_DETAIL_TEXT15		'"미등록"
					End Select

					'SQL = " SELECT [strDtoDTrace] FROM [DK_DTOD] WHERE [useTF] = 'T' AND [CS_NCODE] = '"&arr_DCode&"' "
					SQL = " SELECT [strDtoDTrace] FROM [DK_DTOD] WHERE [useTF] = 'T' AND [defaultTF] ='T' "
					DTOD_ADDRESS = Db.execRsData(SQL,DB_TEXT,Nothing,Nothing)
					If arr_Delivery_No <> "" Then	'송장번호가 있을때
						DTOD_NUMBER = Replace(arr_Delivery_No,"-","")
						If arr_DCode = "" Or isNull(arr_DCode) Then
							'DTOD_LINK = "javascript:alert('배송사코드 미입력으로 조회할 수가 없습니다.\n\n본사로 문의해 주십시오.');"
							DTOD_LINK = "javascript:alert('"&LNG_CS_ORDER_LIST_DETAIL_TEXT16&"');"
							DELIVERY_NO = arr_Delivery_No&"&nbsp;<a href="""&DTOD_LINK&""" class=""input_submit2 design4"" target=""_self"">"&LNG_CS_ORDER_LIST_DETAIL_TEXT17&"</a>"
						Else
							DTOD_LINK = DTOD_ADDRESS&DTOD_NUMBER
							DELIVERY_NO = arr_Delivery_No&"&nbsp;<a href="""&DTOD_LINK&""" class=""input_submit2 design4"" target=""_blank"">"&LNG_CS_ORDER_LIST_DETAIL_TEXT17&"</a>"
						End If
					Else
							DELIVERY_NO = "--"
					End If

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td>"&j+1&"</td>"
					PRINT TABS(1) & "		<td>"&arr_name&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_price)&" "&Chg_CurrencyISO&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_ItemPrice)&" "&Chg_CurrencyISO&"</td>"
					'PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_Sell_Except_VAT_Price)&" "&Chg_CurrencyISO&"</td>"
					'PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_Sell_VAT_Price)&" "&Chg_CurrencyISO&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2curINT(arr_ItemPV)&"</td>"
					PRINT TABS(1) & "		<td>"&arr_ItemCount&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arr_ItemTotalPrice)&" "&Chg_CurrencyISO&"</td>"
					'If arr_Receive_Method = 1 Then
					'	PRINT TABS(1) & "	<td><span class="""">"&LNG_TEXT_DIRECT_RECEIPT&"</span></td>"	'직접수령
					'ElseIf arr_Receive_Method = 3 Then
					'	PRINT TABS(1) & "	<td><span class="""">"&LNG_TEXT_CENTER_RECEIPT&"</span></td>"	'센터수령
					'Else
					'	If arr_Rece_OrderNo <> "" Then		'배송정보토글
					'		PRINT TABS(1) & "<td><span class=""btn01 fon1""><a href=""javascript:toggle_content('deliveryInfo"&i&j&"')"" id=""detail_deliveryInfo"&i&j&""">"&LNG_BTN_DETAIL&"</span></a></td>"
					'	Else
					'		PRINT TABS(1) & "<td><span class=""red"">미등록</span></td>"
					'	End If
					'End If

					'◆배송정보 1번만
					If j = 0 Then
						PRINT TABS(1) & "	<td><span>"&DELIVERY_WAY&"</span></td>"
					Else
						PRINT TABS(1) & "	<td></td>"
					End If
					PRINT TABS(1) & "	</tr>"

					If arr_Receive_Method = 2 Then DELIVERY_CNT = DELIVERY_CNT + 1 Else DELIVERY_CNT = 0

				Next
			Set objEncrypter = Nothing
			PRINT TABS(1) & "		</table>"
			PRINT TABS(1) & "	</div>"

			If DELIVERY_CNT > 0 Then
				If arr_Get_Tel1	<> "" And arr_Get_Tel2 <> "" Then
					arr_Get_Tel2 = " / "&arr_Get_Tel2
				End If
				PRINT TABS(1) & "<div class=""pay_totals width100"">"
				PRINT TABS(1) & "	<table "&tableatt&" class=""innerTable width100"">"
				PRINT TABS(1) & "		<col width=""150"" />"
				PRINT TABS(1) & "		<col width="""" />"
				PRINT TABS(1) & "		<thead>"
				PRINT TABS(1) & "			<tr>"
				PRINT TABS(1) & "				<th colspan=""2"">"&LNG_CS_ORDER_LIST_DETAIL_TEXT18&"</th>"
				PRINT TABS(1) & "			</tr>"
				PRINT TABS(1) & "		</thead>"
				PRINT TABS(1) & "		<tr>"
				PRINT TABS(1) & "			<th>"&LNG_CS_ORDER_LIST_DETAIL_TEXT21&"</th>"
				PRINT TABS(1) & "			<td class=""tleft"">"&DELIVERY_NO&"</td>"
				PRINT TABS(1) & "		</tr><tr>"
				PRINT TABS(1) & "			<th>"&LNG_TEXT_RECIPIENT&"</th>"
				PRINT TABS(1) & "			<td class=""tleft"">"&arr_Get_Name1&"</td>"
				PRINT TABS(1) & "		</tr><tr>"
				PRINT TABS(1) & "			<th>"&LNG_TEXT_CONTACT_NUMBER&"</th>"
				PRINT TABS(1) & "			<td class=""tleft"">"&arr_Get_Tel1&" "&arr_Get_Tel2&"</td>"
				PRINT TABS(1) & "		</tr><tr>"
				PRINT TABS(1) & "			<th>"&LNG_TEXT_ADDRESS1&"</th>"
				PRINT TABS(1) & "			<td class=""tleft"">["&arr_Get_ZipCode&"] "&arr_Get_Address1&"&nbsp;"&arr_Get_Address2&"</td>"
				PRINT TABS(1) & "		</tr>"
				PRINT TABS(1) & "	</table>"
				PRINT TABS(1) & "</div>"
			End If

		Else
			PRINT TABS(1) & "		<div class=""pay_totals width100"">"
			PRINT TABS(1) & "			<table "&tableatt&" class=""innerTable width95a"">"
			PRINT TABS(1) & "				<tr>"
			PRINT TABS(1) & "					<td colspan=""1"" class=""nodata"">"&LNG_CS_ORDER_LIST_DETAIL_TEXT26&"</td>"
			PRINT TABS(1) & "				</tr>"
			PRINT TABS(1) & "			</table>"
			PRINT TABS(1) & "		</div>"
		End If
%>
</div>



<%
	'현금영수증 2중 modal
	If cashReceiptBtn <> "" Then
%>
<script type="text/javascript" src="/jscript/jquery-ui-1.12.1/jquery-ui.min.js?v0"></script>
<link rel="stylesheet" type="text/css" href="/css/modal.css?v1">
<style type="text/css">
	.ui-dialog .ui-dialog-titlebar { padding: 1rem 2.25rem;	}
	.ui-dialog .ui-dialog-title { font-size: 19px; }
	.ui-dialog .ui-dialog-title i:before { background: #fff; }
</style>
<script type="text/javascript">
	$(document).ready(function() {
		let cw = 700;
		let ch = 560;
		if(isNaN(cw) == true || cw == "" || cw < 1) cw = 600;
		$("a[name=modal]").click(function() {
			let $this = $(this);
			let url = $this.attr('href');
			let dialogOpts = {
				title: ($this.attr('title')) ? $this.attr('title') : "",
				autoOpen: true,
				bgiframe: true,
				width: cw,
				height: ch-10,
				modal: true,
				resizable: false,
				autoResize: true,
				draggable: false,

				open: function() {
					$('.ui-widget-overlay').on('click', function() {
						$('#modal_view').dialog('destroy');
					})
				}
			};
			setTimeout(function() {
				$("#modal_view").dialog(dialogOpts);
				$(".ui-dialog").css({"position":"absolute", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)" , "width": cw+"px", "z-index":"999999" });
				$(".ui-dialog .ui-dialog-titlebar-close").html('<i class="icon-close-outline"></i>');
				$('.ui-dialog-title').wrapInner('<i></i>');
			},300);
			$("#modalIFrame").attr('src',url);
			return false;
		});
	});
</script>
<div id="modal_view" style="display:none;">
	<iframe src="/hiddens.asp"  id="modalIFrame" width="100%" height="89%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="yes" ></iframe>
</div>
<%End If%>
