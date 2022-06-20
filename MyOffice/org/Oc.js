	jQuery(document).ready(function() {
		$("#org").jOrgChart({
			chartElement : '#chart',
			dragAndDrop  : false
		});
	});

(function($) {

    $.fn.jOrgChart = function(options) {
        var opts = $.extend({}, $.fn.jOrgChart.defaults, options);
        var $appendTo = $(opts.chartElement);

        // build the tree
        $this = $(this);
        var $container = $("<div class='" + opts.chartClass + "'/>");
        if($this.is("ul")) {
            buildNode($this.find("li:first"), $container, 0, opts);
        }
        else if($this.is("li")) {
            buildNode($this, $container, 0, opts);
        }
        $appendTo.append($container);

        // add drag and drop if enabled
        if(opts.dragAndDrop){

            // Drag start event handler for nodes
            $('div.node').bind("dragstart", function handleDragStart( event, ui ){

                var sourceNode = $(this);
                sourceNode.parentsUntil('.node-container')
                .find('*')
                .filter('.node')
                .droppable('disable');
            });

            // Drag stop event handler for nodes
            $('div.node').bind("dragstop", function handleDragStop( event, ui ){

                /* reload the plugin */
                $(opts.chartElement).children().remove();
                $this.jOrgChart(opts);
            });

            // Drop event handler for nodes
            $('div.node').bind("drop", function handleDropEvent( event, ui ) {
                var sourceNode = ui.draggable;
                var targetNode = $(this);

                // finding nodes based on plaintext and html
                // content is hard!
                var targetLi = $('li').filter(function(){

                    li = $(this).clone()
                    .children("ul,li")
                    .remove()
                    .end();
                    var attr = li.attr('id');
                    if (typeof attr !== 'undefined' && attr !== false) {
                        return li.attr("id") == targetNode.attr("id");
                    }
                    else {
                        return li.html() == targetNode.html();
                    }

                });

                var sourceLi = $('li').filter(function(){

                    li = $(this).clone()
                    .children("ul,li")
                    .remove()
                    .end();
                    var attr = li.attr('id');
                    if (typeof attr !== 'undefined' && attr !== false) {
                        return li.attr("id") == sourceNode.attr("id");
                    }
                    else {
                        return li.html() == sourceNode.html();
                    }

                });

                var sourceliClone = sourceLi.clone();
                var sourceUl = sourceLi.parent('ul');

                if(sourceUl.children('li').size() > 1){
                    sourceLi.remove();
                }else{
                    sourceUl.remove();
                }

                var id = sourceLi.attr("id");

                if(targetLi.children('ul').size() >0){
                    if (typeof id !== 'undefined' && id !== false) {
                        targetLi.children('ul').append('<li id="'+id+'">'+sourceliClone.html()+'</li>');
                    }else{
                        targetLi.children('ul').append('<li>'+sourceliClone.html()+'</li>');
                    }
                }else{
                    if (typeof id !== 'undefined' && id !== false) {
                        targetLi.append('<ul><li id="'+id+'">'+sourceliClone.html()+'</li></ul>');
                    }else{
                        targetLi.append('<ul><li>'+sourceliClone.html()+'</li></ul>');
                    }
                }

            }); // handleDropEvent

        } // Drag and drop
    };

    // Option defaults
    $.fn.jOrgChart.defaults = {
        chartElement : 'body',
        depth : -1,
        chartClass : "jOrgChart",
        dragAndDrop: false
    };

    // Method that recursively builds the tree
    function buildNode($node, $appendTo, level, opts) {

        var $table = $("<table cellpadding='0' cellspacing='0' border='0'/>");
        var $tbody = $("<tbody/>");

        // Construct the node container(s)
        var $nodeRow = $("<tr/>").addClass("node-cells");
        var $nodeCell = $("<td/>").addClass("node-cell").attr("colspan", 2);
        var $childNodes = $node.children("ul:first").children("li");
        var $nodeDiv;

        if($childNodes.length > 1) {
            $nodeCell.attr("colspan", $childNodes.length * 2);
        }
        // Draw the node
        // Get the contents - any markup except li and ul allowed
        var $nodeContent = $node.clone()
        .children("ul,li")
        .remove()
        .end()
        .html();

        var new_node_id = $node.attr("id")
        if (typeof new_node_id !== 'undefined' && new_node_id !== false) {
            $nodeDiv = $("<div>").addClass("node").attr("id", $node.attr("id")).append($nodeContent);
        }else{
            $nodeDiv = $("<div>").addClass("node").append($nodeContent);
        }

/*        // Expand and contract nodes
        if ($childNodes.length > 0) {
            $nodeDiv.click(function() {
                var $this = $(this);
                var $tr = $this.closest("tr");
                $tr.nextAll("tr").fadeToggle("fast");

                if($tr.hasClass('contracted')){
                    $this.css('cursor','n-resize');
                    $tr.removeClass('contracted');
                    $tr.addClass('expanded');
                }else{
                    $this.css('cursor','s-resize');
                    $tr.removeClass('expanded');
                    $tr.addClass('contracted');
                }
            });
        }
*/
        $nodeCell.append($nodeDiv);
        $nodeRow.append($nodeCell);
        $tbody.append($nodeRow);

        if($childNodes.length > 0) {
            // if it can be expanded then change the cursor
////        $nodeDiv.css('cursor','pointer').addClass('expanded');
            $nodeDiv.addClass('expanded');

            // recurse until leaves found (-1) or to the level specified
            if(opts.depth == -1 || (level+1 < opts.depth)) {
                var $downLineRow = $("<tr/>");
                var $downLineCell = $("<td/>").attr("colspan", $childNodes.length*2);
                $downLineRow.append($downLineCell);

                // draw the connecting line from the parent node to the horizontal line
                $downLine = $("<div></div>").addClass("line down");
                $downLineCell.append($downLine);
                $tbody.append($downLineRow);

                // Draw the horizontal lines
                var $linesRow = $("<tr/>");
                $childNodes.each(function() {
                    var $left = $("<td>&nbsp;</td>").addClass("line left top");
                    var $right = $("<td>&nbsp;</td>").addClass("line right top");
                    $linesRow.append($left).append($right);
                });

                // horizontal line shouldn't extend beyond the first and last child branches
                $linesRow.find("td:first")
                .removeClass("top")
                .end()
                .find("td:last")
                .removeClass("top");

                $tbody.append($linesRow);
                var $childNodesRow = $("<tr/>");
                $childNodes.each(function() {
                    var $td = $("<td class='node-container'/>");
                    $td.attr("colspan", 2);
                    // recurse through children lists and items
                    buildNode($(this), $td, level+1, opts);
                    $childNodesRow.append($td);
                });

            }
            $tbody.append($childNodesRow);
        }

        // any classes on the LI element get copied to the relevant node in the tree
        // apart from the special 'collapsed' class, which collapses the sub-tree at this point
        if ($node.attr('class') != undefined) {
            var classList = $node.attr('class').split(/\s+/);
            $.each(classList, function(index,item) {
                if (item == 'collapsed') {
                    $nodeRow.nextAll('tr').css('display', 'none');
                    $nodeRow.removeClass('expanded');
                    $nodeRow.addClass('contracted');
                    $nodeDiv.css('cursor','s-resize');
                } else {
                    $nodeDiv.addClass(item);
                }
            });
        }


        $table.append($tbody);
        $appendTo.append($table);
    };

})(jQuery);




 var request = null;         // request란 아이는 요청객체를 담을 변수입니다.
 function createRequest(){
  try{

   //XMLHttpRequest는 마이크로소프트의 브라우저를 제외한 모든 브라우져에서 작동합니다.
   request = new XMLHttpRequest();     //XMLHttpRequest란 타입으로 요청객체를 가져올꺼예염
  } catch(trymicrosoft){                      // 근데만약 이 자식이 팅긴다면?!
   try{

    //ActiveXObject는 마이크로소프트의 브라우져에서 지원하는 타입이죠.

    //단! 맥 IE 5 버젼에서 아직 안됩니다.

    //Msxml2.XMLHTTP를 대부분의 I.E에서 지원하지만 몇몇은 지원하지 않아요.
    request = new ActiveXObject("Msxml2.XMLHTTP");       // 다시 가져와야죠
   } catch(othermicrosoft){
    try{

     //몇몇 지원하지 않는 브라우져를 위한 부분입니다.
     request = new ActiveXObject("Microsoft.XMLHTTP");
    } catch(failed){

     // 이렇게 했는데도 계속 팅긴다면 null이겠죠.
     request = null;
    }
   }
  }
  //request가 계속 팅김을 한다면 이렇게 나와주면 되요.
  if(request == null) alert("계속 팅기네! request 객체 오류");

 }


 	function chkNameSponsor() {
		f = document.chkFrm;
		if (f.sname.value == '')
		{
			alert("검색하실 하선회원의 이름을 입력하셔야합니다.");
			f.sname.focus();
			return false;
		}

		var values = encodeURIComponent(f.sname.value);

		createRequest();

		var url = '/ajax/ajax_tree_ss_v2.asp?sname='+values;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("sList").innerHTML = newContent;
			}
		  }
		}
		request.send(null);

	}

 	function chkNameVoter() {
		f = document.chkFrm;
		if (f.sname.value == '')
		{
			alert("검색하실 하선회원의 이름을 입력하셔야합니다.");
			f.sname.focus();
			return false;
		}

		var values = encodeURIComponent(f.sname.value);

		createRequest();

		var url = '/ajax/ajax_tree_vt_v2.asp?sname='+values;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("sList").innerHTML = newContent;
			}
		  }
		}
		request.send(null);

	}



/* 화면 확대 축소 시작 IE 전용 : 2013-08-21 */
var nowZoom = 100; // 현재비율
var maxZoom = 100; // 최대비율(500으로하면 5배 커진다)
var minZoom = 10; // 최소비율

 //화면 키우기.
function zoomIn() {
	if (nowZoom < maxZoom)
	{
		nowZoom += 10; //25%씩 커진다.
	} else {
	return false;
	}
  //document.body.style.zoom = nowZoom + "%";
  document.getElementById("chart").style.zoom = nowZoom + "%";
}

 //화면 줄이기.
function zoomOut() {
	if (nowZoom > minZoom)
	{
		nowZoom -= 10; //25%씩 작아진다.
	} else {
	return false;
  }
  //document.body.style.zoom = nowZoom + "%";
  document.getElementById("chart").style.zoom = nowZoom + "%";
}