﻿<%@page language="java" import="java.util.Date"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<html lang="zh">
	<head>
		<base href=" <%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="renderer" content="webkit|ie-comp|ie-stand">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0" />
		<meta http-equiv="Cache-Control" content="no-transform" />
		<!--[if lt IE 9]>
		<script type="text/javascript" src="js/html5shiv.min.js"></script>
		<![endif]-->
		<link rel="stylesheet" type="text/css" href="css/common.css" />
		<link rel="stylesheet" type="text/css" href="lib/Hui-iconfont/1.0.8/iconfont.css" />
		<link rel="stylesheet" type="text/css" href="lib/treetable/css/jquery.treetable.css" />
		<link rel="stylesheet" type="text/css" href="lib/treetable/css/jquery.treetable.theme.default.css" />
		<style type="text/css">
			#menuTable th, #menuTable td {
				font-size: 14px;
				padding: 8px;
			}
			</style>
		<title>菜单管理</title>
	</head>

	<body>
		<nav class="breadcrumb"><i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span> 系统管理 <span class="c-gray en">&gt;</span> 菜单列表
		</nav>
		<div class="page-container">
			<div class="cl pd-5 bg-1 bk-gray mt-20"> <span class="l"><a class="btn btn-primary radius" data-title="添加目录" _href="article-add.html" onclick="Hui_admin_tab(this)" href="javascript:;"><i class="Hui-iconfont">&#xe600;</i> 添加目录</a></span></div>
			<div class="mt-20">
				<table id="menuTable" >
					<thead>
						<tr >
							<th width="120">更新时间</th>
							<th width="75">浏览次数</th>
							<th width="60">发布状态</th>
							<th width="120">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${list}" var="menu">
					<tr data-tt-id='${menu.menuId}'<c:if test="${menu.type ne 0}"> data-tt-parent-id='${menu.parentId}'</c:if>>  
            		<td>${menu.name}</td>
            		<td>${menu.icon}</td>
                	<td>${menu.url}</td>
                	<td>${menu.orderNum}</td>
			        </tr>
			        </c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<script type="text/javascript" src="js/jquery.min.js"></script>
		<script type="text/javascript" src="lib/layer/layer.js"></script>
		<script type="text/javascript" src="lib/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="lib/treetable/jquery.treetable.js"></script>
		<script type="text/javascript">
			$(function(){
				var option1 = {
	                    theme: 'vsStyle', //显示样式
	                    expandLevel: 1, //展开三级分类
	                };
	                $('#menuTable').treetable(option1).treetable({ expandable: true});
			});
			/*资讯-添加*/
			function article_add(title, url, w, h) {
				var index = layer.open({
					type: 2,
					title: title,
					content: url
				});
				layer.full(index);
			}
			/*资讯-编辑*/
			function article_edit(title, url, id, w, h) {
				var index = layer.open({
					type: 2,
					title: title,
					content: url
				});
				layer.full(index);
			}
			/*资讯-删除*/
			function article_del(obj, id) {
				layer.confirm('确认要删除吗？', function(index) {
					$(obj).parents("tr").remove();
					layer.msg('已删除!', {
						icon: 1,
						time: 1000
					});
				});
			}
			/*资讯-审核*/
			function article_shenhe(obj, id) {
				layer.confirm('审核文章？', {
						btn: ['通过', '不通过', '取消'],
						shade: false,
						closeBtn: 0
					},
					function() {
						$(obj).parents("tr").find(".td-manage").prepend('<a class="c-primary" onClick="article_start(this,id)" href="javascript:;" title="申请上线">申请上线</a>');
						$(obj).parents("tr").find(".td-status").html('<span class="label label-success radius">已发布</span>');
						$(obj).remove();
						layer.msg('已发布', {
							icon: 6,
							time: 1000
						});
					},
					function() {
						$(obj).parents("tr").find(".td-manage").prepend('<a class="c-primary" onClick="article_shenqing(this,id)" href="javascript:;" title="申请上线">申请上线</a>');
						$(obj).parents("tr").find(".td-status").html('<span class="label label-danger radius">未通过</span>');
						$(obj).remove();
						layer.msg('未通过', {
							icon: 5,
							time: 1000
						});
					});
			}
			/*资讯-下架*/
			function article_stop(obj, id) {
				layer.confirm('确认要下架吗？', function(index) {
					$(obj).parents("tr").find(".td-manage").prepend('<a style="text-decoration:none" onClick="article_start(this,id)" href="javascript:;" title="发布"><i class="Hui-iconfont">&#xe603;</i></a>');
					$(obj).parents("tr").find(".td-status").html('<span class="label label-defaunt radius">已下架</span>');
					$(obj).remove();
					layer.msg('已下架!', {
						icon: 5,
						time: 1000
					});
				});
			}

			/*资讯-发布*/
			function article_start(obj, id) {
				layer.confirm('确认要发布吗？', function(index) {
					$(obj).parents("tr").find(".td-manage").prepend('<a style="text-decoration:none" onClick="article_stop(this,id)" href="javascript:;" title="下架"><i class="Hui-iconfont">&#xe6de;</i></a>');
					$(obj).parents("tr").find(".td-status").html('<span class="label label-success radius">已发布</span>');
					$(obj).remove();
					layer.msg('已发布!', {
						icon: 6,
						time: 1000
					});
				});
			}
			/*资讯-申请上线*/
			function article_shenqing(obj, id) {
				$(obj).parents("tr").find(".td-status").html('<span class="label label-default radius">待审核</span>');
				$(obj).parents("tr").find(".td-manage").html("");
				layer.msg('已提交申请，耐心等待审核!', {
					icon: 1,
					time: 2000
				});
			}
		</script>
	</body>

</html>