	<script type="text/javascript">
		$(function(){
			let vh = window.innerHeight * 0.01;
			document.documentElement.style.setProperty('--vh', `${vh}px`);

			window.onload = function(){
				var header = document.querySelector('header');
				var footer = document.querySelector('footer');
				var containW = document.getElementById('contain_wrap');
				var headerH = header.offsetHeight * 0.01;
				var footerH = footer.offsetHeight * 0.01;
				
				var containWH = vh - headerH - footerH;
				containW.style.setProperty('--c-vh', `${containWH}px`);
				footer.style.setProperty('--f-vh', `${footerH}px`);
			};
		});

		$(window).on('resize', function(){
			let vh = window.innerHeight * 0.01;
			document.documentElement.style.setProperty('--vh', `${vh}px`);

			var header = document.querySelector('header');
			var footer = document.querySelector('footer');
			var containW = document.getElementById('contain_wrap');
			var headerH = header.offsetHeight * 0.01;
			var footerH = footer.offsetHeight * 0.01;

			var containWH = vh - headerH - footerH;
			footer.style.setProperty('--f-vh', `${footerH}px`);
			containW.style.setProperty('--c-vh', `${containWH}px`);

		});


		
	</script>