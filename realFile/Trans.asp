<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	' 데이터가 있다는 가정하에
	strData1 = "bafc56d1b52eb82b64df26b3cf45805bc8afb8dcce83084a1966958c82897984"
	strData2 = "bafc56d1b52eb82b64df26b3cf45805bc8afb8dcce83084a1966958c82897955"
%>
<script>
	function fTrans(files) {
		location.href = "/realFile/transH.asp?filename="+encodeURIComponent(files);
	}
</script>

<a href="javascript:fTrans('<%=FN_HR_ENC(strData1)%>');">[다운로드]</a>
<a href="javascript:fTrans('<%=FN_HR_ENC(strData2)%>');">[다운로드(없는파일)]</a>