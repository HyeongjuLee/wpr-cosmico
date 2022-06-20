/* 회원 - 메모 */
function openMemo(idv) {
	openPopup("pop_memo_list.asp?idv="+idv, "admin_memo", 100, 100, "left=200, top=200");
}
function openPointCalc(idv) {
	openPopup("pop_point_list.asp?idv="+idv, "pointCalc", 100, 100, "left=200, top=200");
}
function openPointDetail(idv) {
	openPopup("pop_point_detail.asp?idv="+idv, "pointlist", 100, 100, "left=200, top=200");
}
function popCateImg(idv) {
	openPopup("cateImg.asp?idv="+idv, "CateImg", 100, 100, "left=200, top=200");
}
function openPopReg() {
	openPopup("popup_regist.asp", "popReg", 100, 100, "left=200, top=200");
}
//Global Popup
function openPopRegGlobal(nc) {
	openPopup("popup_registGlobal.asp?nc="+nc, "popReg", 100, 100, "left=200, top=200");
}
function phoneImgView(fileName,paths) {
	openPopup("viewImg.asp?fn="+fileName+"&amp;fp="+paths, "phoneImgView", 100, 100, "left=200, top=200");
}
function openDelivery(idv) {
	openPopup("pop_delivery.asp?idv="+idv, "pop_delivery", 100, 100, "left=200, top=200");
}
function openOrderCancel(idv) {
	openPopup("cateImg.asp?idv="+idv, "CateImg", 100, 100, "left=200, top=200");
}
function openChgBranchDomain(idv) {
	openPopup("chgDomain.asp?idv="+idv, "CateImg", 100, 100, "left=200, top=200");
}
function openGoodsRelation(idv) {
	openPopup("pop_Relation.asp?idv="+idv, "CateImg", 100, 100, "left=200, top=200");
}
function openViewImg(mode,idv) {
	openPopup("pop_viewImg.asp?mode="+mode+"&amp;idv="+idv, "viewImg", 100, 100, "left=200, top=200");
}
function pop_MapInfo(idv,mode) {
	openPopup("pop_mapInfo.asp?mode="+mode+"&amp;idv="+idv, "MapInfo", 100, 100, "left=200, top=200");
}
function pop_ShowroomImg(mode,type) {
	openPopup("popBranchImg.asp?srname="+mode+"&amp;type="+type, "ShowroomImg", 100, 100, "left=200, top=200");
}
function popViewImg(mode,idv) {
	openPopup("/admin/pop_viewImg.asp?mode="+mode+"&amp;idv="+idv, "popImg", 100, 100, "left=200, top=200");
}
function evenImgBtn(idv) {
	openPopup("pop_Event.asp?idv="+idv, "evenImgBtn", 100, 100, "left=200, top=200");
}
function evenImgMap(idv) {
	openPopup("pop_EventMap.asp?idv="+idv, "evenImgBtn", 100, 100, "left=200, top=200");
}
function enImgMapDel(idv) {
	openPopup("pop_evenImgMapDel.asp?idv="+idv, "evenImgBtn", 100, 100, "left=200, top=200");
}


/* 디자인 페이지 맵 */
function openPageMap(idv) {openPopup("chgPageMap.asp?idv="+idv, "PageMap", 100, 100, "left=200, top=200");}

/*
//CS연동상품등록
function openCSGoodsSearch() {
	openPopup("pop_CSGoodsSearch.asp", "CSGoodsSearch", 100, 100, "left=200, top=200, scrollbars=yes");
}
// CS연동상품수정 
function openCSGoodsModify(ncode) {
	openPopup("pop_CSGoodsModify.asp?ncode="+ncode, "CSGoodsModify", 100, 100, "left=200, top=200, scrollbars=yes");
}
*/

/* CS연동상품등록 (국가별)*/
function openCSGoodsSearch(nc) {
	openPopup("pop_CSGoodsSearch.asp?nc="+nc, "CSGoodsSearch", 100, 100, "left=200, top=200, scrollbars=yes");
}

/* CS연동상품수정 */
function openCSGoodsModify(ncode,nc) {
	openPopup("pop_CSGoodsModify.asp?ncode="+ncode+"&nc="+nc, "CSGoodsModify", 100, 100, "left=200, top=200, scrollbars=yes");
}

/* 상품등록이미지 */
function goodsImgView(goodsIDX,paths) {
	openPopup("viewImg.asp?Gidx="+goodsIDX+"&fp="+paths, "goodsImgView", 100, 100, "left=200, top=200");
}