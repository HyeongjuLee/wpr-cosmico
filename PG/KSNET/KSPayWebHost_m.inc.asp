<% 'Option Explicit %>
<%
	dim		i
	const	kwh_KSPAY_WEBHOST_URL		= "http://kspay.ksnet.to/store/KSPayMobileV1.4/web_host/recv_post.jsp"
	const	kwh_DEFAULT_RPARAMS			= "authyn`trno`trddt`trdtm`amt`authno`msg1`msg2`ordno`isscd`aqucd`result`halbu`cbtrno`cbauthno`cardno"
	const	kwh_DEFAULT_DELIMS			= "`"
	dim		kwh_payKey
	dim		kwh_rparams
	dim		kwh_mtype

	dim		kwh_rnames
    dim		kwh_rvalues

    ' authyn : O/X ����
    ' trno   : KSNET�ŷ���ȣ(������ �� ��� �� ���������Ϳ� KEY
    ' trddt  : �ŷ�����(YYYYMMDD)
    ' trdtm  : �ŷ��ð�(hhmmss)
    ' amt    : �ݾ�
    ' authno : ���ι�ȣ(�ſ�ī��:����������), �����ڵ�(�ſ�ī��:���ΰ�����), �����ڵ�(�������,������ü)
    ' ordno  : �ֹ���ȣ
    ' isscd  : �߱޻��ڵ�(�ſ�ī��), ������¹�ȣ(�������) ,��Ÿ���������� ��� �ǹ̾���
    ' aqucd  : ���Ի��ڵ�(�ſ�ī��)
    ' result : ���α���

	function KSPayWebHost(p_payKey, p_rparams)
		kwh_payKey		= p_payKey

		If IsNull(p_rparams) or (p_rparams = "") then
			kwh_rparams	= kwh_DEFAULT_RPARAMS
		Else
			kwh_rparams	= p_rparams
		End If

		kwh_rnames  = Split(kwh_rparams, kwh_DEFAULT_DELIMS)

		redim		kwh_rvalues(UBound(kwh_rnames))

		KSPayWebHost = true
	end function

	function kspay_send_msg(p_mtype)
		kwh_mtype = p_mtype
		dim rmsg : rmsg = kspay_send_url()
		dim	tmpvals

'response.write "kspay_send_msg..1=["&UBound(kwh_rnames)&":"&UBound(kwh_rvalues) & "]rmsg=["&InStr(rmsg,"`")&":"&rmsg&"]<br>"
		kspay_send_msg = false
		if InStr(rmsg,"`") <> 0 then
			tmpvals = Split(rmsg, kwh_DEFAULT_DELIMS)

'response.write "kspay_send_msg..2=["&UBound(kwh_rvalues)&":"&UBound(tmpvals)&"]<br>"

			if UBound(kwh_rvalues) < UBound(tmpvals) then
				for i = 0 To UBound(kwh_rvalues)
					kwh_rvalues(i) = tmpvals(i+1)
'response.write "kspay_send_msg.3=["&i&":"&kwh_rnames(i)&":"  & kwh_rvalues(i) & "]<br>"
				next
				kspay_send_msg = true
			end if
		end if
	end function

	function kspay_get_value(p_name)
		kspay_get_value = ""
		if IsNull(p_name) or (p_name = "") or False = IsArray(kwh_rnames) or False = IsArray(kwh_rvalues) or UBound(kwh_rnames) <> UBound(kwh_rvalues) then
			kspay_get_value = ""
		else
			for i = 0 To UBound(kwh_rnames)
				if False = IsNull(kwh_rnames(i)) and kwh_rnames(i) = p_name then
					kspay_get_value = kwh_rvalues(i)
					exit for
				end if
			next
		end if
	end function

	function kspay_send_url()
		dim resultPost : resultPost = ""

		kspay_send_url = ""
		on error resume next

		dim post_msgs : post_msgs = "sndCommConId=" & kwh_payKey & "&sndActionType=" & kwh_mtype & "&sndRpyParams=" & server.URLEncode(kwh_rparams)

'response.write "post_msgs=["  & post_msgs & "]"

		dim oHttp
		set oHttp = createobject("MSXML2.ServerXMLHTTP")

		oHttp.open "GET", kwh_KSPAY_WEBHOST_URL & "?" & post_msgs, false
		oHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		oHttp.Send ""

		if err.number > 0 or oHttp.status <> 200 then
		    'Response.Write "Error Number is " & Err.Number & "<br>" '������ȣ ȣ��
		    'Response.write "Error Description is "& Err.Description & "<br>" '�������� ȣ��
		    'Response.Write "Error Source is " & Err.Source & "<br>" '�����ҽ� ȣ��
			Err.Clear             '���� ������
		else
			'kspay_send_url = oHttp.ResponseText
			kspay_send_url = BinaryToText(oHttp.ResponseBody,"euc-kr")
'response.write "kspay_send_url=["  & kspay_send_url & "]<br>"
		end if

		Set oHttp = Nothing
	end function

	Function  BinaryToText(BinaryData, CharSet)

		Const adTypeText = 2
		Const adTypeBinary = 1

		Dim BinaryStream
		Set BinaryStream = CreateObject("ADODB.Stream")


		'���� ������ Ÿ��
		BinaryStream.Type = adTypeBinary

		BinaryStream.Open
		BinaryStream.Write BinaryData

		' binary -> text
		BinaryStream.Position = 0
		BinaryStream.Type = adTypeText

		'��ȯ�� ������ ĳ���ͼ�
		BinaryStream.CharSet = CharSet

		'��ȯ�� ������ ��ȯ
		BinaryToText = BinaryStream.ReadText
		'response.write "BinaryToText=["  & BinaryToText & "]<br>"

	End Function
%>