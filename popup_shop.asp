<script type="text/javascript">
<!--
	//이부분부터  수정할 필요 없습니다.
	function getCookie(name){
		var Found = false
		var start, end
		var i = 0

		while(i<= document.cookie.length) {
			start = i
			end = start +name.length

			if(document.cookie.substring(start, end)== name) {
				Found = true
				break
			}
				i++
			}

			if(Found == true) {
				start = end + 1
				end = document.cookie.indexOf(";",start)
				if(end < start)
				end = document.cookie.length
				return document.cookie.substring(start, end)
			}
			return ""
		}
// -->
</script>
<%
	'isViewShop(메인 or 쇼핑몰메인)
	SQL = "SELECT * FROM [DK_POPUP] WHERE [useTF] = 'T' AND [popKind] = 'P' AND [isViewCom] ='T' AND [isViewShop] = 'T' AND [strNation] = '"&Lang&"' ORDER BY [intIDX] ASC"
	arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)

	If IsArray(arrList) Then
		For i = 0 To listLen
			POPUPWIDTH = arrList(5,i)
			POPUPHEIGHT = arrList(6,i) + 20


%>
<script type="text/javascript">
<!--
	function popUpOpen()
	{
		var thisCookie = getCookie("<%=arrList(1,i)%>");
		var Popup;
		if (thisCookie != "no") {
			//alert(screen.height)
			if (parseInt(screen.height,10) > parseInt('<%=POPUPHEIGHT + 100%>',10)) {
				Popup = window.open("/popupDetail.asp?popName=<%=arrList(0,i)%>","<%=arrList(1,i)%>","scrollbars=no,width=<%=POPUPWIDTH%>,height=<%=POPUPHEIGHT%>,top=<%=arrList(8,i)%>,left=<%=arrList(9,i)%>");
			}else{
				Popup = window.open("/popupDetail.asp?popName=<%=arrList(0,i)%>","<%=arrList(1,i)%>","scrollbars=yes,width=<%=POPUPWIDTH + 20%>,height=<%=POPUPHEIGHT%>,top=<%=arrList(8,i)%>,left=<%=arrList(9,i)%>");
			}
		}

		if (Popup) {
			Popup.focus();
		}
	}
	popUpOpen();


//-->
</script>
<%
		Next
	End If
%>
