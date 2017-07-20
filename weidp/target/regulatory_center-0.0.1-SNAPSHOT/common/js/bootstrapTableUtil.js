/*获取表格高度，根据浏览器自适应*/
function getTableHeight() {
	return $(window).height() - 95;
}

$(function() {
	
	
	var bootstrapTable = {
		query : function(tableId){queryBootstrapTable(tableId)}
	};
	
	$bootstrapTable = bootstrapTable;
	
	/**
	 * bootstrap封装
	 * @param tableId		表名
	 * @param url			后台url
	 * @param columns		表字段--json格式
	 * @returns
	 */
	bindMethod(bootstrapTable, "load", function(tableId, url, columns) {
		initBootstapTable(tableId, url, columns, null, false, null);
	});
	
	/**
	 * bootstrap封装
	 * @param tableId		表名
	 * @param url			后台url
	 * @param columns		表字段--json格式
	 * @param paramsJson	参数--没有查询条件可以不填
	 * @returns
	 */
	bindMethod(bootstrapTable, "load", function(tableId, url, columns, queryParams) {
		initBootstapTable(tableId, url, columns, queryParams, false, null);
	});
	
	/**
	 * bootstrap封装
	 * @param tableId		表名
	 * @param url			后台url
	 * @param columns		表字段--json格式
	 * @param paramsJson	参数--没有查询条件可以不填
	 * @param ifExport		是否要导出--true or false
	 * @param exportType	导出数据格式--['excel','csv']等
	 * @returns
	 */
	bindMethod(bootstrapTable, "load", function(tableId, url, columns, queryParams,
			ifExport, exportType) {
		initBootstapTable(tableId, url, columns, queryParams, ifExport,
				exportType);
	});
	
	function bindMethod(obj, name, fn) {
		var old = obj[name]; //每个方法中都会存在一个各自的old对象，产生了闭包
		obj[name] = function() {
			if (fn.length == arguments.length) { //这里的fn.length是方法定义参数的个数，和arguments.length传入的个数是两回事
				return fn.apply(this, arguments); //返回传入在匿名函数，执行
			} else {
				return old.apply(this, arguments); //返回数组的方法,再次向上进行查找
			}
		}
	}

	/**
	 * 查询
	 * @param tableId	表名
	 * @returns
	 */
	function queryBootstrapTable(tableId){
		var param = { pageSize : 10, pageNumber : 1 };
		var params = { query : param }
		$('#' + tableId).bootstrapTable('refresh');
	}
	
	/**
	 * bootstrap封装
	 * @param tableId		表名
	 * @param url			后台url
	 * @param columns		表字段--json格式
	 * @param paramsJson	参数--没有查询条件可以不填
	 * @param ifExport		是否要导出--true or false
	 * @param exportType	导出数据格式--['excel','csv']等
	 * @returns
	 */
	function initBootstapTable(tableId, url, columns, paramsJson, ifExport, exportType) {
		$('#' + tableId).bootstrapTable({
			method : 'GET',
			dataType : 'json',
			contentType : "application/json;charset=utf-8",
			pagination : true, //是否显示分页（*）
			cache : false,
			height : getTableHeight(),
			showRefresh : true,
			striped : true, //是否显示行间隔色
			sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
			clickToSelect : true, //是否启用点击选中行
			showToggle : false, //是否显示详细视图和列表视图的切换按钮
			url : url,
			showColumns : true,
			exportTypes : exportType,
			minimumCountColumns : 2,
			pageNumber : 1, //初始化加载第一页，默认第一页
			pageSize : 10, //每页的记录行数（*）
			pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
			uniqueId : "id", //每一行的唯一标识，一般为主键列
			showExport : ifExport, //是否显示导出      
			exportDataType : 'all', //basic', 'all', 'selected'
			//设置为undefined可以获取pageNumber，pageSize，searchText，sortName，sortOrder  
			//设置为limit可以获取limit, offset, search, sort, order  
			queryParamsType : "undefined",
			queryParams : function queryParams(params) { //设置查询参数  
				var param = {
					pageSize : params.pageSize,
					pageNumber : params.pageNumber
				};
				for (x in paramsJson) {
					param[x] = paramsJson[x].val();
				}

				return param;
			},

			columns : columns
		});
	}
});
