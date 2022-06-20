<div class="clear">
	<div class="branch">
		<div class="fleft manager1"><%=viewImgSt(VIR_PATH("manager")&"/temps.gif",55,55,"","border:1px solid #ccc;","")%></div>
		<div class="fleft manager2">안녕하세요.<br />I Love KT 입니다.</div>
		<div class="floatDiv">
			<div class="counsel" id="chgCounsel">
				<div class="tit"><%=viewImgSt(IMG_FLOATING&"/counsel_tit.jpg",166,14,"", "margin:10px 0px;","")%></div>
				<form name="leftFrm" action="" method="post">
					<table <%=tableatt%> style="width:166px;">
						<tr>
							<th>
								<%=viewImgStJs(IMG_FLOATING&"/counsel_th_btn02_on.jpg",70,16,"","","cp","onclick=""chgCounsel('sms')""")%>
								<%=viewImgStJs(IMG_FLOATING&"/counsel_th_btn01_off.jpg",70,16,"","","cp","onclick=""chgCounsel('counsel')""")%>
							</th>
						</tr><tr>
							<td class="lcontent tright"><textarea cols="8" rows="8" class="leftcontent" name="left_content"></textarea></td>
						</tr><tr>
							<td class="byte tright">0/80 byte</td>
						</tr><tr>
							<td class="number"><input type="text" name="tel1" class="input_text" style="width:40px;" />-<input type="text" name="tel2" class="input_text" style="width:50px;" />-<input type="text" name="tel3" class="input_text" style="width:50px;" /></td>
						</tr><tr>
							<td class="submit_area"><input type="image" src="<%=IMG_FLOATING%>/counsel_submit.jpg" /></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<div class="btns">
		<%=aImg("#",IMG_FLOATING&"/left_quick_btn01.jpg",200,55,"")%>
		<%=aImg("#",IMG_FLOATING&"/left_quick_btn02.jpg",200,55,"")%>
		<%=aImg("#",IMG_FLOATING&"/left_quick_btn03.jpg",200,55,"")%>
		<%=aImg("#",IMG_FLOATING&"/left_quick_btn04.jpg",200,55,"")%>
		<%=aImg("#",IMG_FLOATING&"/left_quick_btn05.jpg",200,56,"")%>
		<%=aImg("#",IMG_FLOATING&"/left_quick_btn06.jpg",200,54,"")%>

	</div>
</div>
