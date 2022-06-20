<script>
	let vh = window.innerHeight * 0.01;
	document.documentElement.style.setProperty('--vh', `${vh}px`);

	window.onload = function(){
		var header = document.querySelector('header');
		var footer = document.querySelector('footer');
		var containW = document.getElementById('contain_wrap');
		var headerH = header.offsetHeight * 0.01;
		var footerH = footer.offsetHeight * 0.01;
		
		function containWH(vh, headerH, footerH){
			var containH = vh - headerH - footerH;
			//containW.style.setProperty('--containW-height', `${containH}px`);
		}
	};

	window.addEventListener('resize', () => {
		let vh = window.innerHeight * 0.01;
		document.documentElement.style.setProperty('--vh', `${vh}px`);
	});
	window.addEventListener('touchend', () => {
		let vh = window.innerHeight * 0.01;
		document.documentElement.style.setProperty('--vh', `${vh}px`);
	});

	
</script>

<style>
	#page {
		height: 100vh;
		height: calc(var(--vh, 1vh) * 100);
	}
</style>