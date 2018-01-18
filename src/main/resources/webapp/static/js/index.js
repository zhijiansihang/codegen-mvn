window.app = window.app || {};
(function($, app) { "use strict";
	// app.base = 'http://47.94.241.207:7035';
    app.base = 'http://127.0.0.1:7035';
	//编辑时赋值，新增时赋值null
	app.editingService = null;
	//编辑时赋值，新增时赋值null
	app.editingParam = null;
	//编辑和新增时赋值，值为requestParams或者requestParams，参数列表table的id
	app.editingParamType = null;

	app.parseJSON = function(json){
	  var resType = typeof json;
		if(resType == 'string'){
			json = JSON.parse(json);
			resType = typeof json;
		}
		return json;
	}
	
	app.editService = function(button){
		button = $(button);
		if(button.hasClass('disabled')){
			return false;
		}
		button.addClass('disabled');
		var serviceName = button.parent().parent().data('serviceName');
		$.post(app.base + '/serviceDetail', {project:app.project, serviceName:serviceName}, function(response){
			button.removeClass('disabled');
			
			response = app.parseJSON(response);
			app.editingService = response;
			
			app.showServiceDetail();
		});
	}
	
	app.delService = function(button){
		if(!app.admin){
			return false;
		}
		if(!confirm("确定要删除该服务吗？")){
			return false;
		}
		//发送请求，保存成功后刷新列表
		button = $(button);
		if(button.hasClass('disabled')){
			return false;
		}
		button.addClass('disabled');
		var serviceName = button.parent().parent().data('serviceName');
		$.post(app.base + '/delService', {project:app.project, serviceName:serviceName}, function(response){
//			window.location.reload();
			app.loadServiceList();
		});
	}
	
	app.showServiceDetail = function(){
		
		$("#serviceName, #serviceTitle, #serviceDesc").val('');
		$("#requestParams").children("tbody").html('');
		$("#responseParams").children("tbody").html('');
		
		if(app.editingService){
			//赋值
			var service = app.editingService;
			$("#serviceName").val(service.serviceName);
			$("#serviceTitle").val(service.serviceTitle);
			$("#serviceDesc").val(service.serviceDesc);
			$('input:radio[name=needLogin]').each(function(){
				if($(this).val() == service.needLogin){
					$(this).prop('checked', true);
				}else{
					$(this).prop('checked', false);
				}
			});
			$('input:radio[name=isLogin]').each(function(){
				if($(this).val() == service.isLogin){
					$(this).prop('checked', true);
				}else{
					$(this).prop('checked', false);
				}
			});
			
			//生成数据行
	  		for(var i=0; i<service.requestParams.length; i++){
	  			var param = service.requestParams[i];
	  			$("#requestParams").children("tbody").append(app.generateParamTr(param));
	  		}
	  		for(var i=0; i<service.responseParams.length; i++){
	  			var param = service.responseParams[i];
	  			$("#responseParams").children("tbody").append(app.generateParamTr(param));
	  		}
		}
		
		$( "#serviceDetailDialog" ).dialog( "open" );
	}
	
	app.generateParamTr = function(param){
		var tr = $("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
		tr.prop("id", "tr_param_" + param.paramName);
  		tr.data("paramName", param.paramName);
  		var index = 0;
  		tr.children("td").eq(index++).text(param.paramName);
  		tr.children("td").eq(index++).text(param.paramDesc);
  		tr.children("td").eq(index++).text(param.paramGroupName);
  		tr.children("td").eq(index++).text(param.paramGroupDesc);
  		tr.children("td").eq(index++).text(param.isEnc);
  		tr.children("td").eq(index++).text(param.exampleValue);
  		if(app.admin){
  			var edit = $('<button type="button" class="btn btn-xs btn-primary">编辑</button>');
  	  		var del = $('<button type="button" class="btn btn-xs btn-danger">删除</button>');
  	  		edit.on("click", function(){
  	  			app.editParam(this);
  	  		});
  	  		del.on("click", function(){
  	  			app.delParam(this);
  	  		});
  	  		
  	  		tr.children("td").eq(index++).append(edit).append($('<span>&nbsp;&nbsp;</span>')).append(del);
  		}
  		
  		return tr;
	}
	
	app.editParam = function(button){
		button = $(button);
		
		var paramTr = button.parent().parent();
		var paramName = paramTr.data('paramName');
		var index = 1;
		var paramDesc = paramTr.children("td").eq(index++).text();
		var paramGroupName = paramTr.children("td").eq(index++).text();
		var paramGroupDesc = paramTr.children("td").eq(index++).text();
		var isEnc = paramTr.children("td").eq(index++).text();
		var exampleValue = paramTr.children("td").eq(index++).text();
		var param = {paramName:paramName, paramDesc:paramDesc, paramGroupName:paramGroupName, paramGroupDesc:paramGroupDesc, isEnc:isEnc, exampleValue:exampleValue};
		
		app.editingParamType = paramTr.parent().parent().prop("id");
		app.editingParam = param;
		app.showParamDetail();
	}
	
	app.delParam = function(button){
		if(!app.admin){
			return false;
		}
		if(!confirm("确定要删除该参数吗？")){
			return false;
		}
		
		button = $(button);
		
		var paramTr = button.parent().parent();
		paramTr.remove();
	}
	
	app.showParamDetail = function(){
		
		$("#paramName, #paramDesc, #paramGroupName, #paramGroupDesc, #exampleValue").val('');
		
		if(app.editingParam){
			//赋值
			var param = app.editingParam;
			$("#paramName").val(param.paramName);
			$("#paramDesc").val(param.paramDesc);
			$("#paramGroupName").val(param.paramGroupName);
			$("#paramGroupDesc").val(param.paramGroupDesc);
			$('input:radio[name=isEnc]').each(function(){
				if($(this).val() == param.isEnc){
					$(this).prop('checked', true);
				}else{
					$(this).prop('checked', false);
				}
			});
			$("#exampleValue").val(param.exampleValue);
		}
		
		$( "#paramDetailDialog" ).dialog( "open" );
	}
	
	app.saveService = function(button){
		if(!app.project){
			alert('先选择项目！');
			return;
		}
		if(!app.admin){
			return false;
		}
		button = $(button);
		if(button.hasClass('disabled')){
			return false;
		}
		button.addClass('disabled');
		//发请求，保存成功后刷新列表
		var oldServiceName = null;
		if(app.editingService){
			oldServiceName = app.editingService.serviceName;
		}
		var serviceName = $('#serviceName').val();
		serviceName = $.trim(serviceName);
		if(serviceName.length == 0){
			alert('名称不能为空！');
			return false;
		}
		var serviceTitle = $('#serviceTitle').val();
		var serviceDesc = $('#serviceDesc').val();
		var needLogin = $('input:radio[name=needLogin]:checked').val();
		var isLogin = $('input:radio[name=isLogin]:checked').val();
		var requestParams = app.getParams("requestParams");
		var responseParams = app.getParams("responseParams");
		var service = {serviceName:serviceName, serviceTitle:serviceTitle, serviceDesc:serviceDesc, needLogin:needLogin, isLogin:isLogin, requestParams:requestParams, responseParams:responseParams};
		service = JSON.stringify(service);
		$.post(app.base + '/saveService', {project:app.project, oldServiceName:oldServiceName, service:service}, function(response){

			response = app.parseJSON(response);
	      	if(response.length == 0){
	      		//失败
	      		alert("保存出错，请检查");
	      	}else{
	      		$( "#serviceDetailDialog" ).dialog( "close" );
	      		app.loadServiceList();
	      	}
			
	      	button.removeClass('disabled');
		});
	}
	
	app.getParams = function(tableId){
		var paramTrs = $("#"+tableId).children("tbody").children("tr");
		var params = [];
		for(var i=0; i<paramTrs.length; i++){
			var tr = paramTrs[i];
			tr = $(tr);
			var index = 0;
			var paramName = tr.children("td").eq(index++).text();
			var paramDesc = tr.children("td").eq(index++).text();
			var paramGroupName = tr.children("td").eq(index++).text();
			var paramGroupDesc = tr.children("td").eq(index++).text();
			var isEnc = tr.children("td").eq(index++).text();
			var exampleValue = tr.children("td").eq(index++).text();
			var param = {paramName:paramName, paramDesc:paramDesc, paramGroupName:paramGroupName, paramGroupDesc:paramGroupDesc, isEnc:isEnc, exampleValue:exampleValue};
			params[i] = param;
		}
		return params;
	}
	
	app.saveParam = function(button){
		if(!app.admin){
			return false;
		}
		var paramName = $('#paramName').val();
		var paramDesc = $('#paramDesc').val();
		var paramGroupName = $('#paramGroupName').val();
		var paramGroupDesc = $('#paramGroupDesc').val();
		var isEnc = $('input:radio[name=isEnc]:checked').val();
		var exampleValue = $('#exampleValue').val();
		var param = {paramName:paramName, paramDesc:paramDesc, paramGroupName:paramGroupName, paramGroupDesc:paramGroupDesc, isEnc:isEnc, exampleValue:exampleValue};
		if(app.editingParam){
			//更新
			var trId = "tr_param_" + app.editingParam.paramName;
			var tr = $("#"+app.editingParamType+" #"+trId);
			tr = $(tr);
			tr.data("paramName", param.paramName);
			var index = 0;
	  		tr.children("td").eq(index++).text(param.paramName);
	  		tr.children("td").eq(index++).text(param.paramDesc);
	  		tr.children("td").eq(index++).text(param.paramGroupName);
	  		tr.children("td").eq(index++).text(param.paramGroupDesc);
	  		tr.children("td").eq(index++).text(param.isEnc);
	  		tr.children("td").eq(index++).text(param.exampleValue);
		}else{
			//追加
			$("#"+app.editingParamType).children("tbody").append(app.generateParamTr(param));
		}
		
		$( button ).dialog( "close" );
	}

	app.loadServiceList = function(projectName, project){
		
		$('#project').text(projectName);
		if(projectName){
			app.projectName = projectName;
		}
		if(project){
			app.project = project;
		}
		if(!app.project){
			alert('先选择项目！');
			return;
		}
		if('mmlc' == app.project){
			$(".testCode").hide();
		}else{
			$(".testCode").show();
		}
		
		$("#projectName").text(app.projectName);
		$('.checkRowAll').prop('checked', false);
		$("#checkedCount").text("已勾选0个");
		
		$.post(app.base + '/apis', {project:app.project}, function(response){
	  		response = app.parseJSON(response);
	      	
	  		$("#apisCount").text(response.length + "个");
	  		//先清空
	  		$("#apis").children("tbody").html('');
	  		//生成数据行
	  		for(var i=0; i<response.length; i++){
	  			var service = response[i];
	  			var tr = $("<tr><td></td><td></td><td></td><td style='word-break:break-all;'></td><td></td><td></td><td></td></tr>");
		  		tr.data("serviceName", service.serviceName);
		  		var checkRow = $('<input type="checkbox" class="checkRow">');
		  		checkRow.on("change", function(){
					app.checkRow($(this).prop('checked'));
				});
		  		var index = 0;
		  		tr.children("td").eq(index++).append(checkRow);
		  		tr.children("td").eq(index++).text(service.serviceName);
		  		tr.children("td").eq(index++).text(service.serviceTitle);
		  		tr.children("td").eq(index++).text(service.serviceDesc);
		  		tr.children("td").eq(index++).text(service.needLogin);
		  		tr.children("td").eq(index++).text(service.isLogin);
		  		if(app.admin){
		  			var edit = $('<button type="button" class="btn btn-xs btn-primary">编辑</button>');
			  		var del = $('<button type="button" class="btn btn-xs btn-danger">删除</button>');
			  		edit.on("click", function(){
			  			app.editService(this);
			  		});
			  		del.on("click", function(){
			  			app.delService(this);
			  		});
			  		
			  		tr.children("td").eq(index++).append(edit).append($('<span>&nbsp;&nbsp;</span>')).append(del);
		  		}else{
		  			var edit = $('<button type="button" class="btn btn-xs btn-primary">查看</button>');
		  			edit.on("click", function(){
			  			app.editService(this);
			  		});
		  			
		  			tr.children("td").eq(index++).append(edit);
		  		}
		  		
		  		$("#apis").children("tbody").append(tr);
	  		}
	      });
	}
	
	app.checkRowAll = function(check){
		if(check){
			$('.checkRow').prop('checked', true);
		}else{
			$('.checkRow').prop('checked', false);
		}
		
		var checked = $('.checkRow:checked');
		$("#checkedCount").text("已勾选" + checked.length + "个");
	}

	app.checkRow = function(check){
		if(!check){
			$('.checkRowAll').prop('checked', false);
		}
		
		var checked = $('.checkRow:checked');
		var checkRow = $('.checkRow');
		if(checkRow.length == checked.length){
			$('.checkRowAll').prop('checked', true);
		}
		$("#checkedCount").text("已勾选" + checked.length + "个");
	}
	
	app.genCode = function(button){
		if(!app.project){
			alert('先选择项目！');
			return;
		}
		var checked = $('.checkRow:checked');
		if(checked.length == 0){
			alert("先选中，再生成");
			return false;
		}
		
		button = $(button);
		if(button.hasClass('disabled')){
			return false;
		}
		button.addClass('disabled');
		$("#loading").modal('show');
		
		var serviceNames = '';
		for(var i=0; i<checked.length; i++){
			var serviceName = $(checked[i]).parent().parent().data('serviceName');
			serviceNames += serviceName + ",";
		}
		serviceNames = serviceNames.slice(0, serviceNames.length - 1);
		$.post(app.base + '/genCode', {project:app.project, serviceNames:serviceNames}, function(response){
			$("#loading").modal('hide');
			if("1" == response){
//				alert("生成代码成功");
				button.removeClass('disabled');
				window.open (app.base + '/downloadCode?project='+app.project);
			}else{
				alert("生成代码出错，请检查");
			}
		});
	}
	
	app.testCode = function(button){
		if(!app.project){
			alert('先选择项目！');
			return;
		}
		button = $(button);
		if(button.hasClass('disabled')){
			return false;
		}
		button.addClass('disabled');
		$("#loading").modal('show');
		
		$.post(app.base + '/testCode', {project:app.project}, function(response){
			$("#loading").modal('hide');
			if("1" == response){
				alert("发布测试成功");
				button.removeClass('disabled');
			}else{
				alert("发布测试出错，请检查");
			}
		});
	}

	// Listen for the jQuery ready event on the document  
	$(function() {
	// The DOM is ready!
		var maxWidth = window.innerWidth*0.95;
		var maxHeight = window.innerHeight*0.95;
		var serviceButtons, paramButtons;
		if(app.admin){
			serviceButtons = [{text: "保存服务", click: function() { app.saveService(this) } }, {text: "关闭", click: function() { $(this).dialog( "close" );} }];
			paramButtons = [{text: "保存参数", click: function() { app.saveParam(this) } }, {text: "关闭", click: function() { $(this).dialog( "close" );} }];
		}else{
			serviceButtons = [{text: "关闭", click: function() { $(this).dialog( "close" );} }];
			paramButtons = [{text: "关闭", click: function() { $(this).dialog( "close" );} }];
		}
		$( "#serviceDetailDialog" ).dialog({ buttons:serviceButtons, autoOpen: false, modal:true, width:maxWidth*0.8, minWidth:maxWidth*0.6, maxWidth:maxWidth, maxHeight:maxHeight });
		$( "#paramDetailDialog" ).dialog({ buttons:paramButtons, autoOpen: false, modal:true, width:maxWidth*0.8, minWidth:maxWidth*0.6, maxWidth:maxWidth, maxHeight:maxHeight });
		
		$(".addService").on("click", function(){
			app.editingService = null;
			app.showServiceDetail();
		});
		
		$(".addRequestParam").on("click", function(){
			app.editingParamType = "requestParams";
			app.editingParam = null;
			app.showParamDetail();
		});
		$(".addResponseParam").on("click", function(){
			app.editingParamType = "responseParams";
			app.editingParam = null;
			app.showParamDetail();
		});
		
		$(".checkRowAll").on("change", function(){
			app.checkRowAll($(this).prop('checked'));
		});
		
		$(".genCode").on("click", function(){
			//发送生成代码的请求
			app.genCode(this);
		});
		
		$(".downloadCode").on("click", function(){
			//发送生成代码的请求，成功后调用下载
			app.genCode(this);
		});
		
		$(".testCode").on("click", function(){
			//报文发布测试
			app.testCode(this);
		});
		
		$("#loading").modal({backdrop:'static', keyboard:false, show:false})
		
	})
}(window.jQuery, window.app))