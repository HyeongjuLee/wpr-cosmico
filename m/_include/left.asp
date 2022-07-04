	<%If PAGE_SETTING = "MYOFFICE" Then %>
	<%Else%>

	<article class="nav-left">
		<ul>
			<li class="depth1">
				<ol>
					<!--#include virtual = "/navi/depth1.asp"-->
				</ol>
			</li>
			<li class="depth2">
				<ol>
					<%Select Case PAGE_SETTING%>
					<%Case "COMPANY"%>
					<!--#include virtual = "/navi/company.asp"-->
					<%Case "BRAND"%>
					<!--#include virtual = "/navi/brand.asp"-->
					<%Case "PRODUCT"%>
					<!--#include virtual = "/navi/product.asp"-->
					<%Case "BUSINESS"%>
					<!--#include virtual = "/navi/business.asp"-->
					<%Case "GUIDE"%>
					<!--#include virtual = "/navi/guide.asp"-->
					<%Case "SHOP"%>
					<!--#include virtual = "/navi/shop.asp"-->
					<%Case "COMMUNITY"%>
					<!--#include virtual = "/navi/community.asp"-->
					<%Case "CUSTOMER"%>
					<!--#include virtual = "/navi/customer.asp"-->
					<%Case "MYPAGE"%>
					<!--#include virtual = "/navi/mypage.asp"-->
					<%Case "POLICY"%>
					<!--#include virtual = "/navi/policy.asp"-->
					<%Case "SNS"%>
					<!--#include virtual = "/navi/sns.asp"-->
					<%End Select%>
				</ol>
			</li>

		</ul>
	</article>
	
	<script type="text/javascript">
		$('.nav-left').each(function(){
			var links = function(){
				$('.nav-left ul li').each(function(){
					var $index = $(this).index();
					var $link = $(this).children('a').attr('href');
					var $ol = $(this).find('ol li');
					
					$(this).children('a').attr('href', '/m' + $link);
				});
			};
			links();
			var right = '<i class="right icon-down-open-big"></i>';
			$('li.main:last').addClass('view');
			$('li.main.view').children().not('.nav-sub').remove();

			$('#left').attr('id', '');

			$('.nav-left .depth1').each(function(){
				var main = $('.depth1 li.main');
				var depth = main.eq(<%=NAVI_P_NUM%> - 1);

				depth.addClass('depth');
				main.not(depth).find('i').remove();
			});

			$('.nav-left .depth2').each(function(){
				var main = $('.depth2 ul li');
				var depth = main.eq(<%=view%> - 1);
				var navSub = $('.depth2 .nav-sub');

				$('.depth2 ol').html(navSub.find('li'));
				depth.addClass('depth');
			});

			$('.depth').each(function(){
				$('.depth1 ol').before($('.depth1 li.depth').html());
				$('.depth1 > a').append(right).attr('href', '#;').addClass('depth');
				$('.depth1 ol').find('.depth');

				$('.depth2 ol').before($('.depth2 li.depth').html());
				$('.depth2 > a').append(right).attr('href', '#;').addClass('depth');
				$('.depth2 ol').find('.depth');
				$('.depth2 a.depth').attr('data-ripplet', '');
				//$('.depth2 a').attr('data-ripplet', '');
				return false;

			});

			$('.depth1, .depth2').each(function(){
				$(this).click(function(){
					if (!$(this).hasClass('view')) {
						!$(this).removeClass('view')
						$(this).addClass('view');
						$('li ol').addClass('view');
					}else{
						$(this).removeClass('view');
						$('li ol').removeClass('view');
					}
				});

				$(this).mouseleave(function(){
					setTimeout(function(){
						$('.depth1, .depth2').removeClass('view');
						$('li ol').removeClass('view');
					}, 0);
				});

			});

			console.log('<%=PAGE_SETTING%>', ' NAVI_P_NUM:' + '<%=NAVI_P_NUM%>', ' view : ' + '<%=view%>', ' mNum:' + '<%=mNum%>', ' sNum:' + '<%=sNum%>', ' sVar:' + '<%=sVar%>');
			console.log('sub_title_d2 : ' + '<%=sub_title_d2%>', ' sub_title_d3 : ' + '<%=sub_title_d3%>', ' sview:' + '<%=sview%>');

		});
	</script>
<%End If%>