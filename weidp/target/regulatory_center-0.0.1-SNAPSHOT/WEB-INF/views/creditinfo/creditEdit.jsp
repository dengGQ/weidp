<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>信贷信息管理_修改页面</title>
</head>
<body>
	<div class="container">
		<div id="toolbar" class="btn-group group3">
			 <div class="btn-group">
			       <button class="btn btn-primary" id="editBtn">修改</button>
			 </div>
		</div>
		<table id="edit-table"></table>
	</div>
		
	<script>
		$(function() {
			/**
			 * 修改实际还款信息
			 */
			$("#editBtn").click(function() {
				var rows = getRowsSeleced();
				var conNo = getIdSelections(rows);
				if (conNo == "") {
					layer.msg("请勾选要修改的数据", {
						icon : 2
					})
					return false;
				}
				var json = getParamsSeleced(rows);
				$.ajax({
					type : 'post',
					url : '${webRoot}/actualrepay/editData',
					data : { mydata : json },
					dataType : 'json',
					success : function(data) {
						if (data.success == "true") {
							layer.alert('修改成功');
						} else {
							layer.alert(data.msg);
						}
					},
					error : function() {
						layer.alert("修改失败");
					},

				});
			});
			
			initTable();
			$('#edit-table').bootstrapTable('hideColumn', 'ACTUALID');
		});
		
		/**
		 * 获取选中行数据
		 * @returns
		 */
		function getRowsSeleced() {
			var rows = $('#edit-table').bootstrapTable('getSelections');
			return rows;
		};

		/**
		 * 封装选中行所需字段
		 * @param rows
		 * @returns json
		 */
		function getParamsSeleced(rows) {
			var paramsListA = [];
			for (var i = 0; i < rows.length; i++) {
				var paramsListB = {};
				paramsListB.actualId = rows[i].ACTUALID;//实际还款表ID
				paramsListB.actualAmt = String(rows[i].ACTUALAMT);//实际还款总额
				paramsListB.conNo = rows[i].CONNO;//合同号
				paramsListB.actualPrnpl = String(rows[i].ACTUALPRNPL);//实际还款本金
				paramsListB.actualIntes = String(rows[i].ACTUALINTES);//实际还款利息
				paramsListB.intesPnlty = String(rows[i].INTESPNLTY);//实际罚息金额
				paramsListB.actualRepayDate = "";
				var actualDate = String(rows[i].ACTUALREPAYDATE);
				if(actualDate.indexOf("-")==-1){
					var date = dateFormatUtil(actualDate);//格式化日期
					paramsListB.actualRepayDate = date;
				}else{
					paramsListB.actualRepayDate = actualDate;
				}
				console.log(paramsListB.actualRepayDate);
				paramsListA.push(paramsListB);
			}
			var json = JSON.stringify(paramsListA); 
			return json;
		};

		/**
		 * 判断是否选中
		 * @param rows
		 * @returns
		 */
		function getIdSelections(rows) {
			var conNo = "";
			for (var i = 0; i < rows.length; i++) {
				if ("" == conNo) {
					conNo = rows[i].CONNO;
				} else {
					conNo = conNo + "|" + rows[i].CONNO;
				}
			}
			return conNo;
		};
		
		/**
		 * 动态更新本月实还总额
		 * 本月实还总额=实还本金+实还利息+罚息
		 */
		function mathActualAmt(value,row){
			var actualPrnpl = row.ACTUALPRNPL;//实际还款本金
			var actualIntes = row.ACTUALINTES;//实际还款利息
			var intesPnlty = row.INTESPNLTY;//罚息金额
			var result = math.parser().eval(actualPrnpl + "+" + actualIntes+ "+" + intesPnlty)
		      if (isNaN(result)) { 
		        return; 
		      }
		     result = Math.round(result*100)/100;//四舍五入保留两位小数 
		    return result; 
		}
		
		/**
		 * 初始化table
		 */
		function initTable() {
			var url = "${webRoot}/creditinfo/queryEditInfoByConNo?conNo="+${conNo};
			$('#edit-table').bootstrapTable(
			{
				method : 'GET',
				url : url,
				columns : [ 
					{checkbox : true}
					,{
					field: 'rowId', 
					title: '序号', 
					valign : 'left', 
					formatter: function (value, row, index) { 
						return index+1;}
					},{
					field : 'ACTUALID',
					title : 'ID',
					align : 'left',
					valign : 'middle'
					}, {
					field : 'CONNO',
					title : '合同号',
					align : 'left',
					valign : 'middle'
					},{
					field : 'REPAYDATE',
					title : '本月应还日期',
					align : 'left',
					valign : 'middle',
					formatter: function (value) {
						return dateFormatUtil(value);
					}
					}, {
					field : 'REPAYAMT',
					title : '本月应还金额',
					align : 'left',
					valign : 'middle'
					},{
					field : 'ACTUALREPAYDATE',
					title : '本月实还日期',
					align : 'left',
					valign : 'middle',
					formatter: function (value) {
						return dateFormatUtil(value);
					},
					editable : {
					type : 'date',
					mode : 'inline',
					clear: false,
					title : '本月实还日期',
					placement: 'left',
					datepicker: {
				        language: 'cn'
				    },
					validate: function (value) { 
							if (!$.trim(value)) {
									return '不能为空';
								}
							}
						}
					},{
					field : 'ACTUALAMT',
					title : '本月实还金额',
					align : 'left',
					valign : 'middle',
						formatter: function(value,row){
							return mathActualAmt(value,row)
						}
					},{
					field : 'ACTUALPRNPL',
					title : '本月实还本金',
					align : 'left',
					valign : 'middle',
					editable : {
						type : 'text',
						mode : 'inline',
						title : '本月实还本金',
						validate: function (value) { 
							if (!$.trim(value)) { 
								return '不能为空'; 
							}
							if (isNaN(value)){
								return '只允许输入数字';
							}else if(value<0){
								return '数值不能小于0';
							}
						}
					},
					formatter: function (value) {
						return !value || value==''?"":value;}
					},{
					field : 'ACTUALINTES',
					title : '本月实还利息',
					align : 'left',
					valign : 'middle',
					editable : {
					type : 'text',
					mode : 'inline',
					title : '本月实还利息',
					validate: function (value) { 
						if (!$.trim(value)) { 
							return '不能为空'; 
						}
						if (isNaN(value)){
							return '只允许输入数字';
						}else if(value<0){
							return '数值不能小于0';
						}
					  }
					},
					formatter: function (value) { 
						return !value || value==''?"":value;}
					},{
					field : 'INTESPNLTY',
					title : '本月罚息金额',
					align : 'left',
					valign : 'middle',
					editable : {
					type : 'text',
					mode : 'inline',
					title : '本月罚息金额',
					validate: function (value) { 
						if (!$.trim(value)) { 
							return '不能为空';
							}
						if (isNaN(value)){
							return '只允许输入数字';
						}else if(value<0){
							return '数值不能小于0';
						}
					  }
					},
					formatter: function (value) { 
					return !value || value==''?"":value;
					}}
				],
				onEditableSave: function (field, row, oldValue, $el) {
					  $table = $('#edit-table').bootstrapTable({});
					  $table.bootstrapTable('updateRow', {index: row.rowId, row: row});
				}
			});
		}
	</script>
</body>
</html>