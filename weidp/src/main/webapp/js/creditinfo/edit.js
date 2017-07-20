$(function() {
	$("#editBtn").click(function() {
		var rows = getRowsSeleced();
		var conNo = getIdSelections(rows);
		if (conNo == "") {
			layer.msg("请勾选要修改的数据", {
				icon : 2
			})
			return false;
		}
		var array = conNo.split("|");
		if (array.length > 1) {
			layer.msg("请勾选一条数据", {
				icon : 2
			})
			return false;
		}
		var params = getParamsSeleced(rows);
		var conNo = params[0];
		layer.open({
			title : [ '修改', 'font-size:18px;' ],
			type : 2,
			area : [ '1000px', '300px' ],
			content : 'edit?conNo='+conNo,
			cancel : function() {
				// 右上角关闭回调
			}
		});
	});

	function getRowsSeleced() {
		var rows = $('#reprotdata-table').bootstrapTable('getSelections');
		return rows;
	}
	;

	function getParamsSeleced(rows) {
		var params = new Array();
		for (var i = 0; i < 1; i++) {
			params[i] = rows[i].conNo;
		}
		return params;
	}
	;

	function getIdSelections(rows) {
		var conNo = "";
		for (var i = 0; i < rows.length; i++) {
			if ("" == conNo) {
				conNo = rows[i].conNo;
			} else {
				conNo = conNo + "|" + rows[i].conNo;
			}
		}
		return conNo;
	}
	;

});
