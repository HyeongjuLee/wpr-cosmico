<%
	' *****************************************************************************
	' Function Name : FN_CLOSEPAY_TOTAL
	' Description : 수당발생 총합(주민번호 입력 조건)
	' 업체별 프로시져 확인 필요
	' *****************************************************************************
		Function FN_CLOSEPAY_TOTAL(ByVal mbid, ByVal mbid2)
			FN_CLOSEPAY_TOTAL = 0
			On Error Resume Next
			If UCase(DK_MEMBER_NATIONCODE) = "KR" And DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0" And (mbid <> "" And mbid2 > 0) Then
				arrParams = Array(_
					Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid), _
					Db.makeParam("@mbid2",adInteger,adParamInput,20,mbid2) _
				)
				CLOSEPAY_TOTAL = Db.execRsData("HJPS_CLOSEPAY_TOTAL",DB_PROC,arrParams,DB3)		'오르,엠제트.
				FN_CLOSEPAY_TOTAL = CDbl(CLOSEPAY_TOTAL)
			End IF
			On Error Goto 0
		End Function
%>
