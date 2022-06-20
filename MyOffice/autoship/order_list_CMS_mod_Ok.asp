<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_include/document.asp"-->
<%

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

%>
<!--#include virtual = "/Myoffice/autoship/_autoship_CONFIG.asp"-->
<%


	mode	= pRequestTF("mode",True)
	oIDX	= pRequestTF("oIDX",True)

	INFO_CHANGE_TF	= pRequestTF("INFO_CHANGE_TF",True)

	If INFO_CHANGE_TF <> "T" Then Call ALERTS("결제 예정일 2일 전까지 수정 할 수 있습니다.","BACK","")


	Select Case MODE
		''Case "MODIFY"		'배송정보, 카드정보 수정

		Case "DELETE_G"

			All_Count1	= pRequestTF("All_Count1",False)
			If All_Count1 < 2 Then Call ALERTS("마지막 상품은 삭제할 수 없습니다.","BACK","")

			intIDX			= pRequestTF("intIDX",True)			'Salesitemindex

			arrParams = Array(_
				Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
				Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX), _
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_GOODS_INFO_DELETE_CMS",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case Else : Call ALERTS("올바르지 않은 모드값이 전송되었습니다.\n\n새로고침 후 다시 시도해주세요.","BACK","")
	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT08,"BACK","")
		Case "FINISH"

			'▣ CMS회원  주 테이블에 주문번호(A_Seq)에 따른 총 합계 금액(A_ProcAmt)을 넣어준다. (상품 등록, 수정, 삭제 시)
			If mode = "REGIST_G" Or mode = "MODIFY_G" Or mode = "DELETE_G" Then
				arrParams1 = Array(_
					Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
					Db.makeParam("@A_Seq",adInteger,adParamInput,4,oIDX)_
				)
				arrList1 = Db.execRsList("HJP_ORDER_LIST_CMS_ITEM_DETAIL",DB_PROC,arrParams1,listLen1,DB3)
				selfPrice = 0
				TOTAL_GOODS_PRICE = 0
				If IsArray(arrList1) Then
					For j = 0 To listLen1
						arr_mbid            = arrList1(0,j)
						arr_mbid2           = arrList1(1,j)
						arr_ItemCode        = arrList1(2,j)
						arr_Salesitemindex  = arrList1(3,j)			'등록 상품 일련번호 (수동 증가 처리!!)
						arr_ItemCount       = arrList1(4,j)			'오토쉽 수
						arr_price2		= arrList1(16,j)
						arr_price4		= arrList1(17,j)
						'변경체크
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,arr_ItemCode) _
						)
						Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							arr_price2	= DKRS("price2")
							arr_price4	= DKRS("price4")
						Else
							arr_price2	= arr_price2
							arr_price4	= arr_price4
						End If
						Call CloseRS(DKRS)

						selfPrice = Int(arr_ItemCount) * Int(arr_price2)
						TOTAL_GOODS_PRICE = TOTAL_GOODS_PRICE + selfPrice
					Next
				End If
				'print TOTAL_GOODS_PRICE
				'Response.end

				If TOTAL_GOODS_PRICE > 0  Then
					SQL10 = "UPDATE [tbl_Memberinfo_A] SET [A_ProcAmt] = ? WHERE [mbid] = ? AND [mbid2] = ? AND [A_Seq] = ? "
					arrParams10 = Array(_
						Db.makeParam("@A_ProcAmt",adInteger,adParamInput,4,TOTAL_GOODS_PRICE),_

						Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
						Db.makeParam("@A_Seq",adInteger,adParamInput,4,oIDX)_
					)
					Call Db.exec(SQL10,DB_TEXT,arrParams10,DB3)
				End If
			End If

			Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT09,"go","/myoffice/autoship/order_list_CMS_mod.asp?oIDX="&oIDX)

		Case Else		: Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT10,"BACK","")
	End Select



%>