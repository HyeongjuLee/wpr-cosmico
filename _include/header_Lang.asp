

<%
	If IS_LANGUAGESELECT = "T" Then
%>

	<div id="language">
		<!-- <div class="select" onclick="views();"><span></span><i class="icon-angle-down"></i></div> -->
		<div class="select"><span></span><i class="icon-angle-down"></i></div>
		<ul>
			<li class="kr">KOR</li>
			<li class="us">ENG</li>
		</ul>
	</div>
	<script type="text/javascript">
		$(function(){
			$('#language').click(function(){
				$(this).toggleClass('view');
			});

		  //var ul = $('#language ul');		//<%' views() 필요없음 %>

			$('#language li').each(function(){
				var lang = $(this).attr('class');
			  //$(this).attr('onclick', "dataInput('" + lang + "')'");
				$(this).attr('onclick', "dataInput('" + lang + "')");			//<%' lang우측  ' 오타삭제%>
			});
			$('.select').addClass('<%=LCase(DK_MEMBER_LNG_CODE)%>').find('span').text($('.<%=LCase(DK_MEMBER_LNG_CODE)%>').text());
			$('li.<%=LCase(DK_MEMBER_LNG_CODE)%>').toggleClass('hide');

			return false;

			/*
			function views() {					//<%' views() 필요없어보임 %>
				ul.toggle();
			}
			function dataInput(datas) {			//<%' 바깥 영역으로  %>
				document.location.href = '<%=ThisPageURL_LANG%>='+ datas;
				views();
			}
			*/
		});

		//<%' $(function() 바깥 영역으로 %>
		function dataInput(datas) {
				document.location.href = '<%=ThisPageURL_LANG%>='+ datas;
				//views();		//<%' views() 필요없음 %>
		}
	</script>

<%

	End If
%>