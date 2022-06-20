<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "PRODUCT"

	view = gRequestTF("view",True)
	sview = gRequestTF("sview",True)

%>
<!--#include virtual = "/m/_include/document.asp"-->
 <style type="text/css">
	.imagemap {position:relative;width:device-width;}
	 img{display:block;}
	.pro01_1 {position:absolute; top:10%; left:6%; width:88%; height:13%;}
	.pro01_2 {position:absolute; top:28%; left:6%; width:88%; height:13%;}
	.pro01_3 {position:absolute; top:45%; left:6%; width:88%; height:13%;}
	.pro01_4 {position:absolute; top:63%; left:6%; width:88%; height:13%;}
	.pro01_5 {position:absolute; top:80%; left:6%; width:88%; height:13%;}
 </style>

<!--#include virtual = "/m/_include/jqueryload.asp"-->
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id=" content" class="cleft">
	<div class="product" id="tabArea" style="border:0px;margin-top:0px;">

	<%
		li_class_num1 = "off"
		li_class_num2 = "off"
		li_class_num3 = "off"

		Select Case sview
			Case 1 : li_class_num1 = "on"
			Case 2 : li_class_num2 = "on"
			Case 3 : li_class_num3 = "on"
		End Select

		Select Case view
			Case "1"
				Select Case sview
					Case "1"
						PRINT " <div class=""imagemap"">"
						PRINT viewImgOpt(IMG_CONTENT&"/product01.jpg","100%","","","usemap=""#pro01""")&"</div>"
						PRINT "		<a class=""pro01_1"" href=""/m/page/product.asp?view=4&sview=1""></a>"
						PRINT "		<a class=""pro01_2"" href=""/m/page/product.asp?view=5&sview=1""></a>"
						PRINT "		<a class=""pro01_3"" href=""/m/page/product.asp?view=6&sview=1""></a>"
						PRINT "		<a class=""pro01_4"" href=""/m/page/product.asp?view=7&sview=1""></a>"
						PRINT "		<a class=""pro01_5"" href=""/m/page/product.asp?view=8&sview=1""></a>"
						PRINT " </div>"
			Case Else : Call ALERTS(LNG_PAGE_ALERT01,"back","")
				End Select
		End Select
	%>
    </div>

</div>

	<!-- <map name="pro01" id="pro01">
		<area shape="rect" coords="50,99,722,221" href="/page/product.asp?view=4&sview=1">
		<area shape="rect" coords="50,269,722,391" href="/page/product.asp?view=5&sview=1">
		<area shape="rect" coords="50,439,722,561" href="/page/product.asp?view=6&sview=1">
		<area shape="rect" coords="50,609,722,731" href="/page/product.asp?view=7&sview=1">
		<area shape="rect" coords="50,779,722,901" href="/page/product.asp?view=8&sview=1">
	</map> -->

<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/jscript/jquery.rwdImageMaps.min.js"></script>
<script>
	$(document).ready(function(e) {
		$('img[usemap]').rwdImageMaps();

		$('area').on('click', function() {
			alert($(this).attr('alt') + ' clicked');
		});
	});
</script>
 -->


</body>
</html>




<!--'include virtual = "/m/_include/copyright.asp"-->