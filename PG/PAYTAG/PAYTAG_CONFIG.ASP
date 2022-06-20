<%
	REAL_PAY_TF = "F"

	If REAL_PAY_TF = "T" Then
		'[REAL 가맹점 정보]
		TX_PAYTAG_shopcode	=	""						'필수 : 페이태그 가맹점 번호
		TX_PAYTAG_loginid	=	""						'필수 : 페이태그 로그인ID
		TX_PAYTAG_api_key	=	""	'필수 : 암호화 키값
	Else
		'[TEST 가맹점 정보]
		TX_PAYTAG_shopcode	=	"1901110002"						'필수 : 페이태그 가맹점 번호
		TX_PAYTAG_loginid	=	"paytag"							'필수 : 페이태그 로그인ID
		TX_PAYTAG_api_key	=	"Q)6FpZdJ~PQJ*I[l5fs$I_ADN@BS#$h)"	'필수 : 암호화 키값
	End If

%>
<%
	'===========================================================================
	' on error resumt Next 에러 처리 함수
	'===========================================================================
	sub onErrorCheckDefault()
		if err.number <> 0 Then

			errCode     =   err.number
			errMessage  =   err.description
			%>
				{
					"resultcode":"<%=errCode%>",
					"errmsg":"<%=errMessage%>"
				}
			<%
			response.end

		end if
	end Sub
%>