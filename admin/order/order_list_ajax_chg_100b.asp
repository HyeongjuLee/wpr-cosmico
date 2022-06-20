<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

		intIDX			= pRequestTF_AJAX("intIDX",True)
		i				= pRequestTF_AJAX("Ri",True)
		strNationCode	= pRequestTF_AJAX("nc",False)		'국가코드


		'▣다나 : 일반상품결제시 CS포인트사용
		If isCSPOINTUSE_4_NORMALGOODS = "T" Then
			'==================================================================================================
			nowTime = Now
			RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
			Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

			SQL = " SELECT [OrderNum],[strUserID],[totalPoint],[usePoint],[status] FROM [DK_ORDER] WHERE [intIDX] = ? "
			arrParams2 = Array( _
			Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
			)
			Set DKRS2 = Db.execRs(SQL,DB_TEXT,arrParams2,Nothing)
				If Not DKRS2.BOF And Not DKRS2.EOF Then
					OrderNum		= DKRS2("OrderNum")
					strUserID		= DKRS2("strUserID")
					totalPoint		= DKRS2("totalPoint")		'적립금
					CS_USED_MILEAGE	= DKRS2("usePoint")			'사용한 CS마일리지
					status			= DKRS2("status")
				Else
					OrderNum		= ""
					strUserID		= ""
					CS_USED_MILEAGE	= 0
				End If
			Call closeRS(DKRS2)

			'==============================================================================================
			If Left(strUserID,3) = "CS_" Then

				arrMBID = Split(strUserID,"_")
				If Ubound(arrMBID) < 1 Then Call ALERTS("올바른CS_ID 형식이 아닙니다.","BACK","")
				CS_MBID0 = arrMBID(0)
				CS_MBID1 = arrMBID(1)
				CS_MBID2 = arrMBID(2)

				'▣CS회원정보호출
				arrParamsCS = Array(_
					Db.makeParam("@mbid",adVarChar,adParamInput,20,CS_MBID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,0,CS_MBID2) _
				)
				Set DKRSCS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParamsCS,DB3)
				If Not DKRSCS.BOF And Not DKRSCS.EOF Then
					CS_MBID1	= DKRSCS("mbid")
					CS_MBID2	= DKRSCS("mbid2")
					CS_MNAME	= DKRSCS("M_Name")
				Else
					Call  ALERTS("CS회원정보가 없습니다.","BACK","")
				End If
				Call closeRS(DKRSCS)

				If status ="102" Or  status ="103" Then	'입금확인상태			'201 관리자주문취소		(마일리지 +)

					If CS_USED_MILEAGE > 0 Then
						'Call Db.beginTrans(Nothing)
						SQL = "INSERT INTO [tbl_Member_Mileage] ("
						SQL = SQL & "[T_Time],[mbid],[mbid2],[M_Name],[PlusValue],[PlusKind],[Plus_OrderNumber],[User_id],[ETC1]"
						SQL = SQL & " ) VALUES ( "
						SQL = SQL & " ?,?,?,?,?,?,?,?,? "
						SQL = SQL & " )"
						arrParams = Array(_
							Db.makeParam("@T_Time",adVarchar,adParamInput,35,Recordtime), _
							Db.makeParam("@v_Mbid",adVarChar,adParamInput,20,CS_MBID1), _
							Db.makeParam("@v_Mbid2",adInteger,adParamInput,0,CS_MBID2), _
							Db.makeParam("@v_Name",adVarchar,adParamInput,30,CS_MNAME), _
							Db.makeParam("@v_InputMile",adInteger,adParamInput,30,CS_USED_MILEAGE), _
							Db.makeParam("@PlusKind",adVarchar,adParamInput,2,"22"), _
							Db.makeParam("@v_OrderNumber",adVarchar,adParamInput,30,"WEB_ORDERNO:"&OrderNum), _
							Db.makeParam("@User_id",adVarchar,adParamInput,30,"web"), _
							Db.makeParam("@ETC1",adVarchar,adParamInput,300,"SHOP관리자취소201("&DK_MEMBER_ID&")") _
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
						'Call Db.finishTrans(Nothing)
					End If

				End If

				If Err.Number <> 0 Then
					Call alerts("자료를 처리하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","back","")
				End If
			End If
			'======================================================================================================================
		End If





		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
			Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
			Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPA_ORDER_CHG_100B",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)



		Call FN_NationCurrency(strNationCode,Chg_CurrencyName,Chg_CurrencyISO)		'국가별통화

%>
<%If isMACCO = "T" Then%>
<!--#include file="order_list_ajax_chg_MACCO.asp" -->
<%Else%>
<!--#include file="order_list_ajax_chg.asp" -->
<%End If%>