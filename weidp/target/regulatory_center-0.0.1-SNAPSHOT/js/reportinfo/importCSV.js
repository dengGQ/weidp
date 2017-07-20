$(function () {
	
	/**
	 * 文件上传初始化
	 * @returns
	 */
	var url = webRoot+'/fileOperate/upload';
	var paramsJson = {};
	$bootstrapFileInput.load('file', url, ['csv'], paramsJson);
	/**
	 * 上传前校验
	 */
	$bootstrapFileInput.preUpload('file', function(){
		if($("#jobName").val()==''){
        	layer.msg('请选择CSV文件类型',{icon: 2});
        	return false;
        }
		return true;
	});
})
