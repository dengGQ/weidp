/*获取表格高度，根据浏览器自适应*/
function getTableHeight() {
	return $(window).height() - 95;
}

$(function() {
	
	
	var bootstrapSelect = {
		//query : function(tableId){queryBootstrapTable(tableId)}
	};
	
	$bootstrapSelect = bootstrapSelect;
	
 
	
	/**
	 * 或向某下拉框中添加内容元素
	 * @param selectId		下拉框ID
	 * @param dataType		数据来源类型: json(json数据), url(后台取数据)
	 * @param dataOrUrl		json格式的数据{'text':'value'...} 或者 后台url
	 * @returns
	 */
	bindMethod(bootstrapSelect, "load", function(selectId, dataType, dataOrUrl) {
		if(dataType=='json'){
			initSelectpicker(selectId, null, dataOrUrl, null);
		}else{
			initSelectpicker(selectId, null, null, dataOrUrl);
		}
		
	});
	
	/**
	 * 或向某下拉框中添加内容元素
	 * @param selectId		下拉框ID
	 * @param dataType		数据来源类型: json(json数据), url(后台取数据)
	 * @param dataOrUrl		json格式的数据{'text':'value'...} 或者 后台url
	 * @returns
	 */
	bindMethod(bootstrapSelect, "load", function(selectId, parentEleId, dataType, dataOrUrl) {
		if(dataType=='json'){
			initSelectpicker(selectId, parentEleId, dataOrUrl, null);
		}else{
			initSelectpicker(selectId, parentEleId, null, dataOrUrl);
		}
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
	 * 向某元素(如:div、td)中添加一个下拉框, 或向某下拉框中添加内容元素, 根据是否有父节点ID(parentEleId)判断
	 * @param selectId		下拉框ID
	 * @param parentEleId	父节点ID
	 * @param data			json格式的数据{'text':'value'...}
	 * @param url			后台url,含参数
	 * @returns
	 */
	function initSelectpicker(selectId, parentEleId, data, url){
		var $select;
		if(!!parentEleId && parentEleId!=null){
			$select =  $("<select>");
			$select.attr('id',selectId);
			$select.attr('name',selectId);
			$("#"+parentEleId).append($select); 
		}else{
			$select = $("#"+selectId);
		}
		
		$select = addOption($select, data, url);
		   
		$select.selectpicker('render',{language:'zh_CN'});
	}
	
	
	/**
	 * select标签中添加option
	 * @param tagEle
	 * @param data
	 * @param url
	 * @returns
	 */
	function addOption(tagEle, data, url){
		$(tagEle).append('<option value=\"\"> --请选择-- </option>'); 
		//如果有select的json格式option传入, 解析json
		if(!!data && data!=''){
			for(item in data){
				var option = $("<option>").val(data[item]).text(item); 
				$(tagEle).append(option); 
			}
		}
		
		//如果使用后台查询封装option, 使用ajax查询
		if(!!data && data!=''){
			$.post(url , {}, 'json', function(dataStr){
				 var json = $.parseJSON(dataStr);
				 $.each(json,function(i,result){
					 var option = $("<option>").val(result['value'].val()).text(result['text']); 
					 $(tagEle).append(option); 
                 });
			});
		}
		return $(tagEle);
	}
});
