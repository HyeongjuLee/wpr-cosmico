<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%

	MODE = pRequestTF("mode",True)




	Select Case MODE
		Case "CANCEL"
			intIDX = pRequestTF("intIDX",True)
			CancelCause = pRequestTF("CancelCause",False)


			'▣다나 : 일반상품결제시 CS포인트사용
			If isCSPOINTUSE_4_NORMALGOODS = "T" Then
				'==================================================================================================
				nowTime = Now
				RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
				Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

				'사용한 CS마일리지 불러오기 FROM 웹주문번호
				SQL = " SELECT [OrderNum],[strUserID],[totalPoint],[usePoint],[status] FROM [DK_ORDER] WHERE [intIDX] = ? "
				arrParams2 = Array( _
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
				)
				Set DKRS2 = Db.execRs(SQL,DB_TEXT,arrParams2,Nothing)
					If Not DKRS2.BOF And Not DKRS2.EOF Then
						OrderNum		= DKRS2("OrderNum")
						strUserID		= DKRS2("strUserID")
						totalPoint		= DKRS2("totalPoint")
						CS_USED_MILEAGE	= DKRS2("usePoint")
						status			= DKRS2("status")
					Else
						OrderNum		= ""
						strUserID		= ""
						CS_USED_MILEAGE	= 0
					End If
				Call closeRS(DKRS2)

				'=========================================================================
				'▣▣ CS사업자회원일때
				If Left(strUserID,3) = "CS_" Then		'CS 사업자회원 로그인 CS 정보호출

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


					'▶ 입금확인전 / 입금확인후 관리자취소시
					If status ="100" Or status ="101" Or status ="102" Then
						If CS_USED_MILEAGE > 0 Then
							'주문취소시 CS마일리지 반환 +
							Call Db.beginTrans(Nothing)
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
								Db.makeParam("@ETC1",adVarchar,adParamInput,300,"SHOP관리자 주문취소 "&status&" ->201(+)("&DK_MEMBER_ID&")") _
							)
							Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
							Call Db.finishTrans(Nothing)
						End If

						If Err.Number <> 0 Then
							Call alerts("자료를 처리하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","back","")
						End If
					End If

				End If
				'==================================================================================================
			End If


			'DK_MEMBER_ID, getUserIp 추가 2014-10-24
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@CancelCause",adVarChar,adParamInput,800,CancelCause) ,_
				Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_ORDER_CANCEL",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "UCANCEL"
			intIDX = pRequestTF("intIDX",True)


			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_ORDER_CANCEL_ADMIN_U",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		Case Else : PRINT "Undefined"
	End Select



	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"o_reloada","")
		Case Else : PRINT "Undefined"
	End Select
	Call ResRW(intIDX,"intIDX")
	Call ResRW(CancelCause,"CancelCause")

%>
