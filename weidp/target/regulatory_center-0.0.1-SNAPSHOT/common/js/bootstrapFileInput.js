
$(function() {
	
	
	var bootstrapFileInput = {
			//上传前, 执行方法, 主要用于验证
			preUpload : function(fileId, validateFn){preUpload(fileId, validateFn)}
	};
	
	$bootstrapFileInput = bootstrapFileInput;
	
 
	
	/**
	 * 文件上传初始化
	 * @param fileId		文件控件id
	 * @param uploadUrl		上传url
	 * @param fileExtensions	文件扩展名
	 * @param paramsJson	参数json
	 * @returns
	 */
	bindMethod(bootstrapFileInput, "load", function(fileId, uploadUrl, fileExtensions, paramsJson) {
		initBootstrapFileInput(fileId, uploadUrl, fileExtensions, paramsJson);
	});
	
	/**
	 * 文件上传初始化, 不限制扩展名
	 * @param fileId		文件控件id
	 * @param uploadUrl		上传url
	 * @param paramsJson	参数json
	 * @returns
	 */
	bindMethod(bootstrapFileInput, "load", function(fileId, uploadUrl, paramsJson) {
		initBootstrapFileInput(fileId, uploadUrl, [], paramsJson);
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
	 * 上传前, 执行方法, 主要用于验证
	 * @param fileId		文件控件id
	 * @param validateFn	验证方法, 自己写提示, 并返回布尔值
	 * @returns true:验证通过, false:验证失败
	 */
	function preUpload(fileId, validateFn){
		$("#"+fileId).on('filepreupload', function(event, data, previewId, index) {//上传前准备
		       // var form = data.form, files = data.files, extra = data.extra, response = data.response, reader = data.reader;
		    var flag = true;
		   
		    flag = validateFn();
		    if(!flag){
		    	return {
	                message: "", // upload error message
	                data:{} // any other data to send that can be referred in `filecustomerror`
	            }; 
		    }
		
	    })
	}

 
	/**
	 * 文件上传初始化
	 * @param fileId		文件控件id
	 * @param uploadUrl		上传url
	 * @param fileExtensions	文件扩展名
	 * @param paramsJson	参数json
	 * @returns
	 */
	function initBootstrapFileInput(fileId, uploadUrl, fileExtensions, paramsJson){
		$("#"+fileId).fileinput({
	        showUpload: true,
	        language:'zh',
	        uploadAsync:true,
	        dropZoneEnabled:true,
	        uploadUrl: uploadUrl,
	        maxFileCount: 1,
	        minFileCount: 1,
	        maxImageWidth: 600,
	        resizeImage: true,
	        showCaption: true, //标题
	        showPreview: false, //预览
	        showContainer : false,
	        browseClass: "btn btn-primary",
	        allowedFileExtensions : fileExtensions, //扩展名      ['excel', 'csv']
	        previewFileIcon: "<i class='glyphicon glyphicon-king'></i>",
	    	uploadExtraData: function() {//额外参数
	    		var param = {};
	    		for (x in paramsJson) {
					param[x] = paramsJson[x].val();
				}
	            return param;
	        }
	    }).on("fileuploaded", function(event, data, previewId, index) {//上传成功回调
	        var result = data.response; //后台返回的json
	        if(result.status==0){
	        	layer.msg('上传文件失败, 原因\ : ['+result.msg+']', {icon: 2});
	        }else{
	        	layer.msg('上传文件成功', {icon: 1});
	        }
		});
	}
	  
});
