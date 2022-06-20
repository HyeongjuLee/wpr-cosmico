	 function chkCouns(f){

		 if(!chkNull(f.num, "\'해당 데이터에 대한 값 \'이 없습니다. 새로고침 후 재시도 해주세요.")) return false;
		 if(!chkNull(f.strReply, "\'답변내용\'을 입력해 주세요")) return false;


		 var msg = "위의 내용으로 답변을 저장하시겠습니까?";
		 if(confirm(msg)){
			return true;
		 }else{
			return false;
		 }
	  }



