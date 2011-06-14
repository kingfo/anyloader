package com.xintend.ajbridge.net.uploader {
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public interface IUploader {
		/**
		 * 配置文件过滤器
		 * @param	fileFilters					制定文件的类型
		 */
		function setFileFilters (fileFilters: Array): void;
		/**
		 * 指定是否支持多文件选择
		 * @param	allowMultipleFiles			
		 */
		function setAllowMultipleFiles (allowMultipleFiles: Boolean): void ;
		/**
		 * 开始上传文件
		 * @param	fileid						指上传文件名
		 * @param	serverURL					指上传文件服务器地址。
		 * @param	method						指上传文件服务器的方式  GET or POST
		 * @param	serverURLParameter			至上传的URL参数
		 * @param	uploadDataFieldName			POST操作数据属性。默认是Filedata不需要更改，请务必保持此指不为空或空字符串。
		 * @return
		 */
		function upload(fileID: String,
						serverURL: String = null, 
						method: String = "POST", 
						serverURLParameter: Object = null,
						uploadDataFieldName: String = "Filedata") : Boolean;
		/**
		 * 开始上传文件队列
		 * @param	serverURL					指上传文件服务器地址。
		 * @param	method						指上传文件服务器的方式  GET or POST
		 * @param	serverURLParameter			至上传的URL参数
		 * @param	uploadDataFieldName			POST操作数据属性。默认是Filedata不需要更改，请务必保持此指不为空或空字符串。
		 * @return
		 */
		function uploadAll (serverURL: String = null, 
						method: String = "POST", 
						serverURLParameter: Object = null,
						uploadDataFieldName:String = "Filedata") : Boolean;
		/**
		 * 取消指定文件上传
		 * @param	fileID							指browse行为中发生选择的文件的文件内部id。该名称由事件形式抛出。
		 * @return
		 */
		function cancel(fileID: String=null): *;
		/**
		 * 获得 上传文件实例
		 * @param	fileID							指browse行为中发生选择的文件的文件内部id。该名称由事件形式抛出。
		 * @return
		 */
		function getFile(fileID: String): Object;
		/**
		 * 删除指定文件
		 * @param	fileID							指browse行为中发生选择的文件的文件内部id。该名称由事件形式抛出。
		 * @return
		 */
		function removeFile(fileID: String): Object;
		/**
		 * 不允许继续添加文件
		 */
		function lock(): void;
		/**
		 * 可以继续添加文件
		 */
		function unlock(): void;
		/**
		 * 清除所有文件
		 */
		function clear(): void;
		
		
		/**
		 * 弹出文件选择框,让用户选择文件.
		 * 注意,此方法必需在 flash 点击触发. 
		 * 外部 js 调用仅仅是改变其配制. 当且仅当 flash 被点击时应用其参数配置.
		 * @param	mulit						支持多文件选择标记. 
		 * @param	fileFilters					文件过滤器. 
		 * @return
		 */
		function browse(mulit: * = null, fileFilters: Array = null): Boolean;
		
		function convertFileReferenceToObject(fileReference:*): Object;
	}
	
}