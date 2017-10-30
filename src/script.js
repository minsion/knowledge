(function($) {
	//课程列表的接口
	var GETCLASSES="http:imoocnote.calfnote.com/inter/getClasses.php";
	//课程笔记的接口
	var GETCLASSCHAPTER="http://imoocnote.calfnote.com/inter/getClassChapter.php";
	$.ajaxSetup({
		error:function(){
			alert('ajax系统异常！');
			return false;
		}
	})
	//handlebars模板重复的渲染 代码重构
	function renderTemplate(templateSelector,data,htmlSelector){
		var t=$(templateSelector).html();
		var f =Handlebars.compile(t);
		var h =f(data);
		$(htmlSelector).html(h);
	}
	//刷新页面的 代码重构
	function refreshClasses(curPage){
		$.getJSON(GETCLASSES,{curPage:curPage},function(data){
			renderTemplate("#class-template",data.data,"#classes");
			renderTemplate("#pag-template",formatPag(data),"#pag");
		})
	}
	//是否显示笔记本
	$('.overlap').on('click',function(){
		showNote(false);
	})
	function showNote(show){
		if (show) {
			$('.overlap').css('display','block');
			$('.notedetail').css('display','block');
		}else{
			$('.overlap').css('display','none');
			$('.notedetail').css('display','none');
		}
	}
	function bindClassEvent(){
		$('#classes').delegate('li','click',function(){
			var me = $(this);
			var cid = me.data('id');
			$.getJSON(GETCLASSCHAPTER,{cid:cid},function(data){
				console.log(data);
				renderTemplate("#chapter-template",data,"#chapterdiv");
				showNote(true);
			})
		})
	}
	bindClassEvent()
	//事件委托
	function bindPagEvent(){
		$('#pag').delegate('.clickable','click',function(){
			var me = $(this);
			refreshClasses(me.data('id'))
		})
	}
	bindPagEvent()
	$.getJSON(GETCLASSES,{curPage:1},function(data){
		console.log(data)
		renderTemplate("#class-template",data.data,"#classes");
		renderTemplate("#pag-template",formatPag(data),"#pag");
	})
	Handlebars.registerHelper('equal',function(v1,v2,options){
		if (v1 == v2) {
			return options.fn(this);
		}else{
			return options.inverse(this);
		}
	})
	Handlebars.registerHelper('long',function(v,options){
		if (v.indexOf('小时')!=-1) {
			return options.fn(this);
		}else{
			return options.inverse(this);
		}
	})
	//定义index+1
	Handlebars.registerHelper('addone',function(value){
		return value+1
	})
	//分页组件
	function formatPag(pagData){
		var arr =[];
		var total = parseInt(pagData.totalCount);
		var cur = parseInt(pagData.curPage);
		//处理到首页的逻辑
		var toLeft ={}
		toLeft.index = 1;
		toLeft.text = "&laquo;";
		if (cur !=1) {
			toLeft.clickable = true;
		}
		arr.push(toLeft);
		//处理到上一页的逻辑
		var pre ={};
		pre.index =cur - 1;
		pre.text = "&lsaquo;"
		if (cur != 1) {
			pre.clickable = true;
		}
		arr.push(pre);
		//处理到cur页前逻辑
		if (cur <= 5) {
			for (var i =1; i <cur; i++) {
				var pag = {};
				pag.text = i;
				pag.index = i;
				pag.clickable = true;
				arr.push(pag);
			}
		}else{
			//如果cur>5,那么cur前的页要显示...
			var pag = {};
			pag.text = 1;
			pag.index = 1;
			pag.clickable = true;
			arr.push(pag);
			var pag = {};
			pag.text = "...";
			arr.push(pag)
			for (var i =cur - 2; i <cur; i++) {
				var pag = {};
				pag.text = i;
				pag.index = i;
				pag.clickable = true;
				arr.push(pag);
			}
		}
		//处理cur页的逻辑
		var pag = {};
		pag.text = cur;
		pag.index = cur;
		pag.cur = true;
		arr.push(pag);
		//处理cur页后的逻辑
		if (cur >= total -4) {
			for (var i =cur+1; i <total; i++) {
				var pag = {};
				pag.text = i;
				pag.index = i;
				pag.clickable = true;
				arr.push(pag);
			}
		}else{
			//如果cur<total-4，那么cur后的页 要显示...
			for (var i =cur + 1; i <cur + 2; i++) {
				var pag = {};
				pag.text = i;
				pag.index = i;
				pag.clickable = true;
				arr.push(pag);
			}
			var pag = {}
			pag.text = "..."
			arr.push(pag);
			var pag = {};
			pag.text = total;
			pag.index = total;
			pag.clickable = true;
			arr.push(pag);
		}
		//处理下一页的逻辑
		var next = {}
		next.index = cur + 1;
		next.text = "&rsaquo;";
		if (cur != total) {
			next.clickable = true;
		}
		arr.push(next);
		//处理到尾页的逻辑
		var toRight = {}
		toRight.index = total;
		toRight.text = "&raquo;";
		if (cur != total) {
			toRight.clickable =true;
		}
		arr.push(toRight);
		return arr;
	}
})(jQuery)