$(document).ready(function(){
    
    $("#chkAll").on("click", function(){
        var chkVal = $(this).prop("checked");
        $(".chkbox").each(function(){
            if (!$(this).attr("disabled")) {
                $(this).prop("checked", chkVal);
            }
        });
    });

    //개별 메세지 전송모달 오픈
    $(".btn_person").on("click", function(){
        $("#personSendModal #personToken").val($(this).attr("rel"));
        $("#personSendModal").modal();
    });

    //전체 메세지 전송모달 오픈
    $(".btn_group").on("click", function(){
        $("#groupSendModal").modal();
    });

    //센터별 메세지 전송모달 오픈
    $(".btn_center").on("click", function(){
        $("#centerSendModal").modal();
    });


    //개별 메세지 전송
    $(".btn_personSend").on("click", fnPersonSend);

    //전체 메세지 전송
    $(".btn_groupSend").on("click", fnGroupSend);

    //센터별 메세지 전송
    $(".btn_centerSend").on("click", fnCenterSend);
});

function fnPersonModalView(fileName){

    $("#modal").empty();
    $("#modal").append('<img src="/signature/'+fileName+'" width=100% />');
    $("#modal").modal({
        showClose : false
    });
}

function fnDownloadPdf(fileName){
    if (fileName != "") {
        location.href="download.asp?fileName="+fileName;
    }    
}

function fnPersonSend(){
    
    var token = $("#personSendModal #personToken").val();
    var message = $("#personSendModal #personSendMessage").val();
    var url = $("#personSendModal #personUrl").val();

    if (token == "") {
        alert("전송대상자의 정보가 필요합니다. 다시 선택해 주세요.");
        return false;
    }

    if (message == "" || $.trim(message) == ""){
        alert("전송메세지를 입력해 주세요.");
        return false;
    }

    $.ajax({
        type: "post",
        url: "pushSendProc.asp",
        data : {"token" : token, "message" : message.replace(/\n/gi, '\\n'), "url" : url},
        beforeSend: function(){
            $('#loadingPro').show();
            $(".btn_personSend").off("click");
        },
        complete : function(){
            $('#loadingPro').hide();
            $(".btn_personSend").on("click", fnPersonSend);
        },
        success: function(data) {
            var json = $.parseJSON(data);
            if (json.result == "success") {
                $("#personSendModal #personToken").val('');
                $("#personSendModal #personSendMessage").val('');
                $("#personSendModal #personUrl").val('');
                $.modal.close();
                alert(json.resultMsg);
            } else {
                alert(json.resultMsg);
            }
        },
        error:function(data) {
            alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText);
        }
    });
}

function fnGroupSend(){
   
    var groupType = $("input:radio[name=groupType]:checked").val();
    var message = $("#groupSendModal #groupSendMessage").val();
    var url = $("#groupSendModal #groupUrl").val();

    if (message == "" || $.trim(message) == ""){
        alert("전송메세지를 입력해 주세요.");
        return false;
    }

    $.ajax({
        type: "post",
        url: "pushSendGroupProc.asp",
        data : {"groupType" : groupType, "message" : message.replace(/\n/gi, '\\n'), "url" : url},
        beforeSend: function(){
            $('#loadingPro').show();
            $(".btn_groupSend").off("click");
        },
        complete : function(){
            $('#loadingPro').hide();
            $(".btn_groupSend").on("click", fnGroupSend);
        },
        success: function(data) {
            var json = $.parseJSON(data);
            if (json.result == "success") {
                $("#input:radio[name=groupType]").val('D');
                $("#groupSendModal #groupSendMessage").val('');
                $("#groupSendModal #groupUrl").val('');
                $.modal.close();
                alert(json.resultMsg);
            } else {
                alert(json.resultMsg);
            }
        },
        error:function(data) {
            alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText);
        }
    });
}

function fnCenterSend(){
    var centerType = $("input:radio[name=centerType]:checked").val();
    var centerCode = $("select[name=businessCode]").val();
    var message = $("#centerSendModal #centerSendMessage").val();
    var url = $("#centerSendModal #centerUrl").val();
    
    if (centerCode == "") {
        alert("대상센터를 선택해 주세요.");
        return false;
    }

    if (message == "" || $.trim(message) == ""){
        alert("전송메세지를 입력해 주세요.");
        return false;
    }

    $.ajax({
        type: "post",
        url: "pushSendCenterProc.asp",
        data : {"centerType" : centerType, "centerCode" : centerCode, "message" : message.replace(/\n/gi, '\\n'), "url" : url},
        beforeSend: function(){
            $('#loadingPro').show();
            $(".btn_centerSend").off("click");
        },
        complete : function(){
            $('#loadingPro').hide();
            $(".btn_centerSend").on("click", fnCenterSend);
        },
        success: function(data) {
            var json = $.parseJSON(data);
            if (json.result == "success") {
                $("select[name=businessCode]").val('');
                $("#centerSendModal #centerSendMessage").val('');
                $("#centerSendModal #centerUrl").val('');
                $.modal.close();
                alert(json.resultMsg);
            } else {
                alert(json.resultMsg);
            }
        },
        error:function(data) {
            alert("ajax error! .ERROR CODE : "+data.status+" "+data.statusText);
        }
    });
}