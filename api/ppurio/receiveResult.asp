<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
	'### ppurio receive Result(application/json) ###
	' ���� ��� ���� : URL PUSH ���
	' ���� ����� ���翡�� ������ ��� ��û�� URL �� PUSH ������� �����մϴ� (ppurio �� ��ϵ� URL)
	' bizppurio@daou.co.kr ���Ͽ�û : URL, ����ID
	' /API/ppurio/receiveResult.asp
	' ����Ȯ�� ����
	'		Biz Lounge > ��⿬�� ȯ�漳��
	'		����Ʈ ���� ���� '��(���۰���� �������� ����')
	'		���� �ȵǴ� ���(�߸��� ��û ���� �߻� ��) �Ѹ��� �������� ������û �ؾ���!
	'
	' metac21g 2022-04-14 ~
	'	/API/ppurio/receiveResult.asp

	If Request.TotalBytes > 0 Then
		Dim lngBytesCount, jsonText
		lngBytesCount = Request.TotalBytes

		jsonText = BytesToStr(Request.BinaryRead(lngBytesCount))
		'jsonText = BinaryToText (Request.BinaryRead(lngBytesCount),"UTF-8")
		'sResponse = binarytotext (oXmlhttp1.responseBody,"UTF-8")
		Response.Clear

		Dim json_result : Set json_result = JSON.parse(join(array(jsonText)))

		REQUEST_METHOD					= Replace(Request.ServerVariables("REQUEST_METHOD")," ","")				'POST
		CHEADER_CONTENT_TYPE		= Replace(Request.ServerVariables("HTTP_CONTENT_TYPE")," ","")		'.setRequestHeader "Content-Type"			application/json; charset=utf-8
		CHEADER_AUTHORIZATION		= Replace(Request.ServerVariables("HTTP_AUTHORIZATION")," ","")		'.setRequestHeader "Authorization"

		On Error Resume Next
			CardLogss = "/API/ppurio/receiveResult"
			Dim Fso : Set Fso = CreateObject("Scripting.FileSystemObject")
			Dim LogPath : LogPath = Server.MapPath (CardLogss&"/rr_") & Replace(Date(),"-","") & ".log"
			Dim Sfile : Set Sfile = Fso.OpenTextFile(LogPath,8,true)

			Sfile.WriteLine chr(13)
			Sfile.WriteLine "Date	: "	& now()
			Sfile.WriteLine "Domain	: "	& Request.ServerVariables("HTTP_HOST")
			Sfile.WriteLine "==== ppurio receive Result ==================="
			'Sfile.WriteLine "REQUEST_METHOD	: " & REQUEST_METHOD
			'Sfile.WriteLine "CHEADER_CONTENT_TYPE	: " & CHEADER_CONTENT_TYPE
			Sfile.WriteLine "jsonText	: " & jsonText
			Sfile.WriteLine "=============================================="

			Sfile.Close
			Set Fso= Nothing
			Set objError= Nothing

			'��� �ڵ�

			'�⺻
			'{"DEVICE":"SMS","CMSGID":"220414115950389sms021853meta4a63","MSGID":"0414me_SL3951730519000020481","PHONE":"01082860240","MEDIA":"SMS","UNIXTIME":"1649905190","RESULT":"4100","USERDATA":"","WAPINFO":"LGT"}

			'������
			'{"DEVICE":"AT","CMSGID":"220428133747010#at269328meta5oja","MSGID":"0428me_DD2037332066603108417","PHONE":"01045610123","MEDIA":"KAT","UNIXTIME":"1651120667","RESULT":"7318","USERDATA":"","WAPINFO":"KTF","TELRES":"6600","TELTIME":"1651120675","RETRY_FLAG":"S","RESEND_FLAG":"M"}

			r_DEVICE		= Replace(json_result.DEVICE," ","")			'�޽��� ����
			r_CMSGID		= Replace(json_result.CMSGID," ","")			'�޽��� Ű(* �� ���� �� ����Ʈ �� ��û ���� Ű)
			r_MSGID			= Replace(json_result.MSGID," ","")				'����Ѹ��� �޽��� Ű
			r_PHONE			= Replace(json_result.PHONE," ","")				'���� ��ȣ
			r_MEDIA			= Replace(json_result.MEDIA," ","")				'���� �߼۵� �޽��� �� ���� * MEDIA ����
			r_UNIXTIME	= Replace(json_result.UNIXTIME," ","")		'�߼� �ð�
			r_RESULT		= Replace(json_result.RESULT," ","")			'����� īī�� RCS ��� �ڵ� * 9 . ���� ��� �ڵ� ����
			r_USERDATA	= Replace(json_result.USERDATA," ","")		'����� �μ� �ڵ�
			r_WAPINFO		= Replace(json_result.WAPINFO," ","")			'����� īī�� ���� * SKT/KTF/LGT/KAO

			'��ü���۰��
			r_TELRES		= ""
			r_KAORES		= ""
			r_RCSRES		= ""
			If InStr(json_result,"TELRES") > 0 Then
				r_TELRES	= Replace(json_result.TELRES," ","")			'����� ��ü ���� ���
			End If
			If InStr(json_result,"KAORES") > 0 Then
				r_KAORES	= Replace(json_result.KAORES," ","")			'īī�� ��ü ���� ���
			End If
			If InStr(json_result,"RCSRES") > 0 Then
				r_RCSRES	= Replace(json_result.RCSRES," ","")			'RCS ��ü ���� ���
			End If


			If Err.Number = 0 Then  ' catch
				'slave ID �󿡼� ���� ���ǿ��� ������ ok ��κ� 4420 6610 ��Ÿ���� �߻���
				'mater ID �󿡼��� ����� ���� �ȵǴ� ��찡 �¹�
				Select Case r_RESULT
					Case "4100","6600","7000"
						r_RESULT = "OK"
					Case Else
						r_RESULT = r_RESULT		'FAIL
				End Select

				'��ü���� ����ڵ�ġȯ
				Select Case r_TELRES
					Case "4100","6600"
						r_TELRES = "OK"
					Case Else
						r_TELRES = r_TELRES		'FAIL
				End Select
				If r_KAORES = "7000" Then r_KAORES = "OK"

				'�� LOG ������Ʈ receiveResult
				arrParamsL2 = Array(_
					Db.makeParam("@strType",adChar,adParamInput,3,r_DEVICE),_
					Db.makeParam("@messagekey",adVarChar,adParamInput,32,r_CMSGID),_
					Db.makeParam("@receiveResult",adVarChar,adParamInput,500,jsonText),_
					Db.makeParam("@r_RESULT",adChar,adParamInput,4,r_RESULT),_
					Db.makeParam("@r_TELRES",adChar,adParamInput,4,r_TELRES),_
					Db.makeParam("@r_KAORES",adChar,adParamInput,4,r_KAORES),_
					Db.makeParam("@r_RCSRES",adChar,adParamInput,4,r_RCSRES),_
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("HJP_PPURIO_LOG_RECEIVE_RESULT_UPDATE",DB_PROC,arrParamsL2,DB3)

			End If


		On Error GoTo 0
		Response.End

	End If

%>
<%

%>

