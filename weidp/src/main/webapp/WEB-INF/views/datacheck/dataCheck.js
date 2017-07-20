$(function () {
	 $exportBtn = $('#exportBtn'),
     selections = [];
	 dataGrid = $('#dataGrid')
		 
	 /*
	 导出数据文件
	 */
	 $exportBtn.click(function () {
            var seqs = getIdSelections();
            if(seqs==""){
            	alert("请勾选要导出的数据");
            	return false;
            }
            window.location.href="exportSelfCheckDataFile?seqs="+seqs;
        });
		 
	 	function getIdSelections() {
	        var rows = $('#dataGrid').bootstrapTable('getSelections');
	        var seqs = "";
	        for(var i=0;i<rows.length;i++){
	        	if(""==seqs){
	        		seqs = rows[i].seq ;
	        	}else{
	        		seqs = seqs +"," + rows[i].seq ;
	        	}
	        }
	        return   seqs;
	 	}
		
		$("#resetBtn").click(function(){
			  $('.form-control').val('');
		});
		
		$("#queryBtn").click(function(){
			var param = {
		        url: "queryDataCheck",
		        query:{
		       	  	pageNumber:1, 
			 	  	pageSize: 25,
			 	  	quarter : $("#quarter").val()
		        }      
			} 
			 $('#dataGrid').bootstrapTable('refresh',  param );
		});
		initTable();
	});

 
	function initTable(){
	    $('#dataGrid').bootstrapTable({
	        method:'GET',
	        dataType:'json',
	        contentType: "application/json;charset=utf-8",
	        striped: true,  
	        pagination: true,  
	        sidePagination: "server",          
	        url:'queryDataCheck',
	        pageNumber:1,                     
	        pageSize: 10,                      
	        pageList: [10, 50, 100,500],       
	        uniqueId: "id",                   
	        queryParamsType : "undefined",
	        queryParams: function queryParams(params) { 
	              var param = {    
	            		  	pageSize: params.pageSize,
	            		  	pageNumber: params.pageNumber, 
	            		  	quarter : $("#quarter").val()
	              };    
	              return param;                   
	            }, 
	        columns: [{
                field: 'state',
                checkbox: true,
                align: 'center'
            },{
	            field: '',
	            title: '序号',
	            width:20,
	            formatter: function (value, row, index) {
	            	return index+1;
	            }
	        },{
	            field : 'seq',
	            title : '编号',
	            align : 'left',
	            width : 80,
	            sortable : true
	        },{
	            field : 'quatr',
	            title : '季度',
	            align : 'center',
	            width : 80,
	            sortable : true
	        }, {
	            field : 'fileName',
	            title : '文件名称',
	            width : 300,
	            align : 'left'
	        }, {
	            field : 'bussDate',
	            title : '数据日期',
	            width : 200,
	            align : 'left'
	        }]
	    });
}