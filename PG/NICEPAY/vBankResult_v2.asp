<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'NICEPAY �Ա��뺸 ���� DBó�� 'https://www.onmong.co.kr/PG/NICEPAY/vBankResult.asp  2021-08-04~
	'V2 : �Աݽ� �ֹ� ����, �Ա����� ������Ʈ


	'**********************************************************************************
	' �����ڰ� �Ա��ϸ� ���������� �뺸�� �����Ͽ� DB ó�� �ϴ� �κ� �Դϴ�.
	' ���ŵǴ� �ʵ忡 ���� DB �۾��� �����Ͻʽÿ�.
	' �����ʵ� �ڼ��� ������ �޴��� ����
	'**********************************************************************************

	PayMethod       = Request("PayMethod")          '���Ҽ���
	M_ID            = Request("MID")                '����ID
	MallUserID      = Request("MallUserID")         'ȸ���� ID
	Amt             = Request("Amt")                '�ݾ�
	name            = Request("name")               '�����ڸ�
	GoodsName       = Request("GoodsName")          '��ǰ��
	TID             = Request("TID")                '�ŷ���ȣ
	MOID            = Request("MOID")               '�ֹ���ȣ
	AuthDate        = Request("AuthDate")           '�Ա��Ͻ� (yyMMddHHmmss)
	ResultCode      = Request("ResultCode")         '����ڵ� ('4110' ��� �Ա��뺸)
	ResultMsg       = Request("ResultMsg")          '����޽���
	VbankNum        = Request("VbankNum")           '������¹�ȣ
	FnCd            = Request("FnCd")               '������� �����ڵ�
	VbankName       = Request("VbankName")          '������� �����
	VbankInputName  = Request("VbankInputName")     '�Ա��� ��
	CancelDate      = Request("CancelDate")         '����Ͻ�

	'**********************************************************************************
	'�������, ������ü�� ��� ���ݿ����� �ڵ��߱޽�û�� �Ǿ������ ���޵Ǹ�
	'RcptTID �� ���� �ִ°�츸 �߱�ó�� ��
	'**********************************************************************************
	RcptTID         = Request("RcptTID")            '���ݿ����� �ŷ���ȣ
	RcptType        = Request("RcptType")           '���� ������ ����(0:�̹���, 1:�ҵ������, 2:����������)
	RcptAuthCode    = Request("RcptAuthCode")       '���ݿ����� ���ι�ȣ


	AuthCode        = Request("AuthCode")           '���ι�ȣ(�߰�) / �� �Ѱ��ٴ� ��쵵 ����


	If TID ="" Or MOID = "" Then Response.End

	CardLogss = "log_vBank"

	On Error Resume Next
	Dim Fso22 : Set  Fso22=CreateObject("Scripting.FileSystemObject")
	Dim LogPath22 : LogPath22 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
	Dim Sfile22 : Set  Sfile22 = Fso22.OpenTextFile(LogPath22,8,true)

		Sfile22.WriteLine "=========== VBANK AUTH ============= "
		Sfile22.WriteLine "Date : " & now()
		Sfile22.WriteLine "PayMethod     	: " & PayMethod
		Sfile22.WriteLine "M_ID          	: " & M_ID
		Sfile22.WriteLine "MallUserID    	: " & MallUserID
		Sfile22.WriteLine "Amt           	: " & Amt
		Sfile22.WriteLine "name          	: " & name
		Sfile22.WriteLine "GoodsName     	: " & GoodsName
		Sfile22.WriteLine "TID           	: " & TID
		Sfile22.WriteLine "MOID          	: " & MOID
		Sfile22.WriteLine "AuthDate      	: " & AuthDate
		Sfile22.WriteLine "ResultCode    	: " & ResultCode
		Sfile22.WriteLine "ResultMsg     	: " & ResultMsg
		Sfile22.WriteLine "VbankNum      	: " & VbankNum
		Sfile22.WriteLine "FnCd          	: " & FnCd
		Sfile22.WriteLine "VbankName     	: " & VbankName
		Sfile22.WriteLine "VbankInputName	: " & VbankInputName
		Sfile22.WriteLine "RcptTID			: " & RcptTID
		Sfile22.WriteLine "RcptType		: " & RcptType
		Sfile22.WriteLine "RcptAuthCode	: " & RcptAuthCode
		Sfile22.WriteLine "AuthCode	: " & AuthCode
		'Sfile22.WriteLine "CancelDate    	: " & CancelDate


	'������ DBó��

	'**************************************************************************************************
	'**************************************************************************************************
	'���� ������ �뺸 ���� > ��OK�� üũ�ڽ��� üũ�� ���" �� ó�� �Ͻñ� �ٶ��ϴ�.
	'**************************************************************************************************
	'TCP�� ��� OK ���ڿ� �ڿ� �����ǵ� �߰�
	'������ ���� �����ͺ��̽��� ��� ���������� ���� �����ÿ��� "OK"�� NICEPAY��
	'�����ϼž��մϴ�. �Ʒ� ���ǿ� �����ͺ��̽� ������ �޴� FLAG ������ ��������
	'(����) OK�� �������� �����ø� NICEPAY ������ "OK"�� �����Ҷ����� ��� �������� �õ��մϴ�
	'��Ÿ �ٸ� ������ PRINT(response.write)�� ���� �����ñ� �ٶ��ϴ�


		vBankTRX		= TID		'�ŷ���ȣ
		vBankAmt		= Amt		'�� �Աݾ�
		vBankSetDate	= AuthDate	'�Ա��Ͻ� (yyMMddHHmmss)
		PGAcceptNum		= AuthCode	'���ι�ȣ

%>
<%
	'�Աݽ� �ֹ� ����, �Ա����� ������Ʈ
	If ResultCode = "4110" And vBankTRX <> "" Then

		'�� ���� �ֹ� üũ vBankTRX �ڸ���(50) Ȯ��!!
		SQL = "SELECT [OrderNum],[MBID],[MBID2],[totalPrice],[CSORDERNUM] FROM [DK_ORDER_TEMP] WITH(NOLOCK)"
		SQL = SQL &" WHERE [payType] = 'vBank' AND [vBankTRX] = ? "
		arrParams = Array(_
			Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX) _
		)
		Set HJRS = DB.execRs(SQL,DB_TEXT,arrParams,DB3)
		If Not HJRS.BOF And Not HJRS.EOF Then
			HJRS_OrderNum		= HJRS("OrderNum")
			HJRS_MBID			= HJRS("MBID")
			HJRS_MBID2			= HJRS("MBID2")
			HJRS_totalPrice		= HJRS("totalPrice")
			HJRS_CSORDERNUM		= HJRS("CSORDERNUM")		'*** �Է¿��� Ȯ��!
		End IF
		Call closeRS(HJRS)

		Sfile22.WriteLine "WEB_OrderNum		: " & HJRS_OrderNum
		Sfile22.WriteLine "CSORDERNUM		: " & HJRS_CSORDERNUM


		If HJRS_OrderNum <> "" And CStr(CDbl(vBankAmt)) = CStr(CDbl(HJRS_totalPrice)) Then
			Sfile22.WriteLine "UPDATE ~"

			'*** vBankStatus = 'ISSUE' ���� Ȯ��!!


			'�� ������� ���� ������Ʈ [SHOP]
				arrParamsS = array(_
					Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_OrderNum), _
					Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
					Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
					Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
					Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX) _
				)
				Call Db.exec("HJSP_VBANK_STATUS_UPDATE2_SHOP",DB_PROC,arrParamsS,Nothing)

			'�� ������� ���� ������Ʈ [CS]
				arrParamsCS = array(_
					Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_OrderNum), _
					Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
					Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
					Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
					Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX) _
				)
				Call Db.exec("HJSP_VBANK_STATUS_UPDATE2_CS",DB_PROC,arrParamsCS,DB3)

			'�� CS ���ι�ȣ UPDATE
				SQL_SCU = "UPDATE [tbl_Sales_Cacu] SET [C_Number2] = ? WHERE [OrderNumber] = ?"
				arrParamsSCU = Array(_
					Db.makeParam("@C_Number2",adVarWChar,adParamInput,100,PGAcceptNum), _
					Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				Call Db.exec(SQL_SCU,DB_TEXT,arrParamsSCU,DB3)

			'�� CS �ֹ���ȣ ����
				SQL_STF = "UPDATE [tbl_SalesDetail_TF] SET [SellTF] = 1 WHERE [OrderNumber] = ?"
				arrParamsSTF = Array(_
					Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				Call Db.exec(SQL_STF,DB_TEXT,arrParamsSTF,DB3)


			'�� CS �ֹ���ȣ �Ǹ����� UPDATE
				SQL_STF = "UPDATE [tbl_SalesDetail] SET [SellDate] = ? , [SellDate_2] = ? WHERE [OrderNumber] = ?"
				arrParamsSTF = Array(_
					Db.makeParam("@SellDate",adVarChar,adParamInput,10,RegTime), _
					Db.makeParam("@SellDate_2",adVarChar,adParamInput,10,RegTime), _
					Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				Call Db.exec(SQL_STF,DB_TEXT,arrParamsSTF,DB3)


			'�� ����üũ
				SQL_STF = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WITH(NOLOCK) WHERE [OrderNumber] = ? "
				arrParams_STF = Array(_
					Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				CS_ORDER_SellTF = DB.execRsData(SQL_STF,DB_TEXT,arrParams_STF,DB3)

				Sfile22.WriteLine "CS_ORDER_SellTF		: " & CS_ORDER_SellTF

				If CS_ORDER_SellTF = 1 Then
					Sfile22.WriteLine "OK"
					Response.Write "OK"
				Else
					Sfile22.WriteLine "FAIL"
					Response.Write "FAIL"
				End If

		End If

	End If


	Sfile22.Close
	Set Fso22= Nothing
	Set objError= Nothing
	On Error GoTo 0

	Response.End


	'IF (�����ͺ��̽� ��� ���� ���� ���Ǻ��� = true) THEN
	'Response.write "OK"                ' ����� ������������
	'ELSE
	'Response.write "FAIL"              ' ����� ������������
	'END IF
	'*************************************************************************************************
	'*************************************************************************************************
%>

