<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 2
	'sview = gRequestTF("sview",True)

	If view= 2 Then
		CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If
%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<style type="text/css">
	#target {   
	}
	.page {
	   border: 1px solid black;
	   padding: 5px;
	   font-size: 30px; 
	}
	span {
	  width: 100%; background: #eaeaea; float: left;
	}

</style>
<script type="text/javascript">
	var contentBox = $('#target');
var words = contentBox.html().split(' ');
function paginate() {
    var newPage = $('<div class="page" />');
    contentBox.empty().append(newPage);
    var pageText = null;
    for(var i = 0; i < words.length; i++) {
        var betterPageText;
        if(pageText) {
            betterPageText = pageText + ' ' + words[i];
        } else {
            betterPageText = words[i];
        }
        newPage.html(betterPageText);
        if(newPage.height() > $(window).height()) {
            newPage.html(pageText);
            newPage.clone().insertBefore(newPage)
            pageText = null;
        } else {
            pageText = betterPageText;             
        }
    }    
}

$(window).resize(paginate).resize();
</script>
<div id="pages">
<%Select Case view%>
	<%Case "1"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "2"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "3"%>
		<div id="target">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at commodo enim. Integer dolor elit, <span>asdfadfasfaadfasfd</span>elementum vitae mollis eu, lobortis fringilla diam. Maecenas consectetur malesuada sodales. Fusce nec est est, ut bibendum orci. Aenean tellus lectus, consectetur a mattis a, lobortis sit amet mauris. In vitae orci odio. Integer id massa ac elit suscipit bibendum. Vivamus a magna vitae felis ullamcorper elementum. Mauris aliquam euismod elit a mattis. Nam eu felis sed dolor sodales egestas. Sed quis quam augue. Proin bibendum iaculis felis vel pretium. Praesent ultrices sapien eget ante convallis ac iaculis lectus porta. Quisque vel lectus vel nibh facilisis auctor. Donec ac erat est, non pulvinar urna.

Mauris ut adipiscing lorem. Donec sit amet nisl non erat vestibulum auctor. Pellentesque mauris nibh, pharetra sit amet tincidunt et, tincidunt non velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam sed nisl et lorem sagittis venenatis id eget lectus. Donec nunc diam, pulvinar eget pulvinar sit amet, fermentum ac libero. Morbi sed posuere lorem. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed interdum, diam sit amet bibendum ullamcorper, arcu dolor rhoncus neque, a ultricies lectus nisl vitae tortor. Sed ut arcu nec dui vehicula pretium. Mauris urna arcu, tincidunt id euismod et, laoreet ac massa. Nullam at facilisis libero. Ut viverra mollis nisi, in feugiat dolor pharetra at. In pretium lacinia leo, eu lobortis ligula aliquet eu. Praesent quis dui massa.

Phasellus sed nibh vel urna lacinia egestas. Curabitur porttitor turpis ac felis tempus faucibus commodo facilisis sapien. Aliquam a lorem a purus adipiscing posuere quis quis felis. Duis id purus augue, vel adipiscing dolor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi orci tortor, consectetur a egestas a, condimentum quis diam. Nulla hendrerit vulputate turpis, non luctus ligula tempor et. Donec sit amet libero sapien.

Sed libero arcu, euismod et ullamcorper sed, cursus et erat. Aenean eu lectus lectus, quis placerat nisi. In et velit eu mauris elementum consequat. Aliquam vitae est ac dolor blandit tempus. Suspendisse placerat nunc sit amet orci hendrerit fringilla interdum a dolor. Cras tempus, libero in venenatis sodales, ligula leo eleifend mauris, id dictum risus est et odio. Pellentesque blandit laoreet risus vitae aliquam. Aliquam ac turpis ut quam facilisis interdum vel quis sem. Duis tempor felis non enim fermentum pharetra. Praesent semper congue ipsum et ultrices.

Integer vitae enim at orci aliquam gravida id non lectus. Suspendisse congue purus vitae sapien ultrices lacinia. Ut et euismod tellus. Nulla facilisi. Pellentesque ut libero nec enim tincidunt ornare tempor id lectus. Donec varius lacinia mattis. Sed consectetur massa ut magna semper eu rutrum lacus varius. In egestas massa in tortor lacinia vehicula. Nullam vel neque faucibus diam fermentum sagittis. Aenean at purus eu sem placerat aliquam eget nec neque. Nulla erat lectus, semper ut luctus malesuada, scelerisque sed ipsum. Donec aliquam, nulla non suscipit consectetur, nunc felis consectetur tellus, vitae tincidunt lacus erat in risus. Nulla eleifend tincidunt ipsum ac elementum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed sagittis imperdiet erat, ac sollicitudin nunc pellentesque nec.
</div>
	<%Case "4"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "5"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




