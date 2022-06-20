
<%
	If IS_LANGUAGESELECT = "T" Then
%>

	<div id="language">
		<!-- <div class="select" onclick="views();"><span></span><i class="icon-angle-down"></i></div> -->
		<div class="select"><span></span></div>
		<ul>
			<li class="kr"><span><img src="/images/nation/kr-ci.svg" alt=""></span></li>
			<li class="us"><span><img src="/images/nation/us-ci.svg" alt=""></span></li>
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
			$('.select').addClass('<%=LCase(DK_MEMBER_LNG_CODE)%>').html($('#language li.<%=LCase(DK_MEMBER_LNG_CODE)%>').html());
            //$('#language .select').html($('#language li.<%=LCase(DK_MEMBER_LNG_CODE)%>').html());
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