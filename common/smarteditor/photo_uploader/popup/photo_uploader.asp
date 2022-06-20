<!--#include virtual = "/_lib/strFunc.asp" -->
<%
	ipath = gRequestTF("ipath",True)
	sLang = gRequestTF("sLang",True)

	'LANG = "JP"
	Select Case sLang
		Case "ko_KR"
			ThisPage_Text_01 = "<strong>2MB</strong>이하의 이미지 파일만 등록할 수 있습니다."
			ThisPage_Text_02 = "확인"
			ThisPage_Text_03 = "취소"
		Case "en_US"
			ThisPage_Text_01 = "Only image files of <strong>2MB</strong> or smaller can be registered."
			ThisPage_Text_02 = "Confirm"
			ThisPage_Text_03 = "Cancel"
		Case "ja_JP"
			ThisPage_Text_01 = "<strong>2MB</strong>以下の画像ファイルのみ登録できます。"
			ThisPage_Text_02 = "確認"
			ThisPage_Text_03 = "キャンセル"
		Case "zh_CN"
			ThisPage_Text_01 = "只能注册 <strong>2MB</strong> 或更小的图像文件。"
			ThisPage_Text_02 = "确定"
			ThisPage_Text_03 = "取消"
		Case "zh_TW"
			ThisPage_Text_01 = "只能注册 <strong>2MB</strong> 或更小的图像文件。"
			ThisPage_Text_02 = "确定"
			ThisPage_Text_03 = "取消"
		Case Else
			ThisPage_Text_01 = "Only image files of <strong>2MB</strong> or smaller can be registered."
			ThisPage_Text_02 = ""
			ThisPage_Text_03 = ""
	End Select
	'PRINT LANG
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>사진 첨부하기 :: SmartEditor2</title>
<style type="text/css">
/* NHN Web Standard 1Team JJS 120106 */
/* Common */
body,p,h1,h2,h3,h4,h5,h6,ul,ol,li,dl,dt,dd,table,th,td,form,fieldset,legend,input,textarea,button,select{margin:0;padding:0}
body,input,textarea,select,button,table{font-family:'돋움',Dotum,Helvetica,sans-serif;font-size:12px}
img,fieldset{border:0}
ul,ol{list-style:none}
em,address{font-style:normal}
a{text-decoration:none}
a:hover,a:active,a:focus{text-decoration:underline}

/* Contents */
.blind{visibility:hidden;position:absolute;line-height:0}
#pop_wrap{width:383px}
#pop_header{height:26px;padding:14px 0 0 20px;border-bottom:1px solid #ededeb;background:#f4f4f3}
.pop_container{padding:11px 20px 0}
#pop_footer{margin:21px 20px 0;padding:10px 0 16px;border-top:1px solid #e5e5e5;text-align:center}
h1{color:#333;font-size:14px;letter-spacing:-1px}
.btn_area{word-spacing:2px}
.pop_container .drag_area{overflow:hidden;overflow-y:auto;position:relative;width:341px;height:129px;margin-top:4px;border:1px solid #eceff2}
.pop_container .drag_area .bg{display:block;position:absolute;top:0;left:0;width:341px;height:129px;background:#fdfdfd url(../../img/photoQuickPopup/bg_drag_image.png) 0 0 no-repeat}
.pop_container .nobg{background:none}
.pop_container .bar{color:#e0e0e0}
.pop_container .lst_type li{overflow:hidden;position:relative;padding:7px 0 6px 8px;border-bottom:1px solid #f4f4f4;vertical-align:top}
.pop_container :root .lst_type li{padding:6px 0 5px 8px}
.pop_container .lst_type li span{float:left;color:#222}
.pop_container .lst_type li em{float:right;margin-top:1px;padding-right:22px;color:#a1a1a1;font-size:11px}
.pop_container .lst_type li a{position:absolute;top:6px;right:5px}
.pop_container .dsc{margin-top:6px;color:#666;line-height:18px}
.pop_container .dsc_v1{margin-top:12px}
.pop_container .dsc em{color:#13b72a}
.pop_container2{padding:46px 60px 20px}
.pop_container2 .dsc{margin-top:6px;color:#666;line-height:18px}
.pop_container2 .dsc strong{color:#13b72a}
.upload{margin:0 4px 0 0;_margin:0;padding:6px 0 4px 6px;border:solid 1px #d5d5d5;color:#a1a1a1;font-size:12px;border-right-color:#efefef;border-bottom-color:#efefef;length:300px;}
:root  .upload{padding:6px 0 2px 6px;}

#btn_confirm {}
#btn_cancel	{}


	.a_submit  {font-size:13px; display: inline-block; padding: 0px 15px; vertical-align: middle; cursor: pointer; line-height:27px; height:29px;}
	.design1 {background-color: #337ab7; border:1px solid #2e6da4; border-radius: 3px; color:#fff !important;font-weight:300;}
	.design2 {background-color: #f9f9f9; border:1px solid #cccccc; border-radius: 3px; color:#666 !important;font-weight:300;}
	.design3 {background-color: #898989; border:1px solid #606060; border-radius: 3px; color:#fff !important;font-weight:300;}
	.design4 {background-color: #c40d0d; border:1px solid #880000; border-radius: 3px; color:#fff !important;font-weight:300;}
	.design5 {background-color: #33b793; border:1px solid #1a9473; border-radius: 3px; color:#fff !important;font-weight:300;}
	.design6 {background-color: #333333; border:1px solid #ffffff; border-radius: 3px; color:#fff !important;font-weight:300;}
	.design7 {background-color: #ffffff; border:1px solid #c40d0d; border-radius: 3px; color:#c40d0d !important;font-weight:300;}
	.design8 {background-color: #ffffff; border:1px solid #cccccc; border-radius: 3px; color:#303030 !important;font-weight: normal;}

</style>
</head>
<body>
<div id="pop_wrap">
	<!-- header -->
    <div id="pop_header">
        <h1>IMAGE UPLOAD</h1>
    </div>
    <!-- //header -->
    <!-- container -->

    <!-- [D] HTML5인 경우 pop_container 클래스와 하위 HTML 적용
	    	 그밖의 경우 pop_container2 클래스와 하위 HTML 적용      -->
	<div id="pop_container2" class="pop_container2">
    	<!-- content -->
		<form id="editor_upimage" name="editor_upimage" action="upload_image.asp" method="post" enctype="multipart/form-data" onSubmit="return false;">
        <div id="pop_content2">
			<input type="hidden" id="imagepaths" name="imagepaths" value="<%=ipath%>">
			<input type="file" class="upload" id="uploadInputBox" name="Filedata">
            <p class="dsc" id="info"><%=ThisPage_Text_01%><br>(JPG,GIF,PNG)</p>
        </div>
		</form>
        <!-- //content -->
    </div>
    <div id="pop_container" class="pop_container" style="display:none;">
    	<!-- content -->
        <div id="pop_content">
	        <p class="dsc"><em id="imageCountTxt">0장</em>/10장 <span class="bar">|</span> <em id="totalSizeTxt">0MB</em>/50MB</p>
        	<!-- [D] 첨부 이미지 여부에 따른 Class 변화
            	 첨부 이미지가 있는 경우 : em에 "bg" 클래스 적용 //첨부 이미지가 없는 경우 : em에 "nobg" 클래스 적용   -->

            <div class="drag_area" id="drag_area">
				<ul class="lst_type" >
				</ul>
            	<em class="blind">마우스로 드래그해서 이미지를 추가해주세요.</em><span id="guide_text" class="bg"></span>
            </div>
			<div style="display:none;" id="divImageList"></div>
            <p class="dsc dsc_v1"><em>한 장당 10MB, 1회에 50MB까지, 10개</em>의 이미지 파일을<br>등록할 수 있습니다. (JPG, GIF, PNG)</p>
        </div>
        <!-- //content -->
    </div>

    <!-- //container -->
    <!-- footer -->
    <div id="pop_footer">
	    <div class="btn_area">
			<a href="#" id="btn_confirm" class="a_submit design2"><%=ThisPage_Text_02%></a>
			<a href="#" id="btn_cancel" class="a_submit design2"><%=ThisPage_Text_03%></a>
            <!-- <a href="#"><img src="../../img/ko_KR/btn_confirm.png" width="49" height="28" alt="확인" id="btn_confirm"></a>
            <a href="#"><img src="../../img/ko_KR/btn_cancel.png" width="48" height="28" alt="취소" id="btn_cancel"></a> -->
        </div>
    </div>
    <!-- //footer -->
</div>
<script type="text/javascript" src="jindo.min.js" charset="utf-8"></script>
<script type="text/javascript" src="jindo.fileuploader.js" charset="utf-8"></script>
<script type="text/javascript" src="attach_photo.js?v=1" charset="utf-8"></script>
</body>
</html>