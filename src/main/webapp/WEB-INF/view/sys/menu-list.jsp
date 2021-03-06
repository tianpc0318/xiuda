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
			#menuTable th {
				font-size: 14px;
				padding: 6px;
			}
			#menuTable td {
				font-size: 14px;
				padding: 5px 0px 5px 10px;
			}
			</style>
		<title>菜单管理</title>
	</head>

	<body>
		<nav class="breadcrumb"><i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span> 系统管理 <span class="c-gray en">&gt;</span> 菜单列表
		</nav>
		<div class="page-container">
			<div class="cl pd-5 bg-1 bk-gray">
				<span class="l"><a class="btn btn-primary radius" data-title="添加目录" onclick="catalog_add('添加目录', 'sys/menu/menu-edit', '80%', '100%')" href="javascript:;"><i class="Hui-iconfont">&#xe600;</i> 添加目录</a></span>
			</div>
			<div class="mt-10">
				<table id="menuTable" >
					<thead>
						<tr >
							<th width="20%">菜单名称</th>
							<th width="8%">菜单图标</th>
							<th width="20%">菜单URL</th>
							<th width="15%">授权标识</th>
							<th width="10%">排序号</th>
							<th width="7%">状态</th>
							<th width="20%">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list}" var="menu">
							<tr data-tt-id='${menu.menuId}'<c:if test="${menu.type ne 0}"> data-tt-parent-id='${menu.parentId}'</c:if>>  
			            		<td>${menu.name}</td>
			            		<td><c:if test="${menu.icon != null}"><i class="Hui-iconfont"><c:if test="${not empty menu.icon}">&${menu.icon}</c:if></i></c:if></td>
			                	<td>${menu.url}</td>
			                	<td>${menu.perms}</td>
			                	<td>${menu.orderNum}</td>
			                	<td>${menu.available eq 1 ? "正常" : "禁用"}</td>
			                	<td class="text-c">
<%-- 			                		<shiro:hasPermission name="menu:create"> --%>
			                        <c:if test="${menu.type ne 2}">
			                        	<a style="text-decoration:none" class="mr-5" onClick="child_add(this, '添加子节点', 'sys/menu/menu-edit', '80%', '100%')" href="javascript:;"><i class="Hui-iconfont">&#xe600;</i></a>
			                        </c:if>
<%-- 				                    </shiro:hasPermission> --%>
<%-- 			                		<shiro:hasPermission name="menu:update"> --%>
									<a style="text-decoration:none" class="mr-5" onClick="menu_edit(this, '菜单编辑','sys/menu/menu-edit', '80%', '100%')" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a>
<%-- 									</shiro:hasPermission> --%>
<%-- 									<shiro:hasPermission name="menu:delete"> --%>
									<a style="text-decoration:none" onClick="menu_del(this)" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>
<%-- 									</shiro:hasPermission> --%>
								</td>
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
				var option = {
	                    theme: 'vsStyle', //显示样式
	                    expandLevel: 1, //展开三级分类
	                };
	            $('#menuTable').treetable(option);
			});
			/*目录-添加*/
			function catalog_add(title, url, w, h) {
				layer.open({
					type: 2,
					title: title,
					content: url,
					area: [w, h]
				});
			}
			/*子节点-添加*/
			function child_add(obj, title, url, w, h) {
				layer.open({
					type: 2,
					title: title,
					content: url + '?parentId=' + $(obj).parents("tr").attr("data-tt-id"),
					area: [w, h]
				});
			}
			/*菜单-编辑*/
			function menu_edit(obj, title, url, w, h) {
				layer.open({
					type: 2,
					title: title,
					content: url + '?menuId=' + $(obj).parents("tr").attr("data-tt-id"),
					area: [w, h]
				});
			}
			/*菜单-删除*/
			function menu_del(obj) {
				layer.confirm('确认要删除吗？', function(index) {
					$.ajax({
			            type: "POST",
			            url: "sys/menu/delete",
			            dataType: "json",
			            data: {menuId: $(obj).parents("tr").attr("data-tt-id")},
			            success: function(data){
			            	if(data.code == '10000'){//操作成功
			            		layer.msg('删除成功', {
									icon: 6,
									time: 1000
								});
			            		window.location.href ='sys/menu/list';
							}else{
								layer.msg(data.msg, {
									icon: 5,
									time: 1000
								});
							}
			            }
			         });
				});
			}
		</script>
	</body>

</html>