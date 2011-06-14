package com.xintend.ajbridge.core {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public interface IAJBridge{
		
		function getCoreVersion(): String;
		
		function get hasDeploy(): Boolean;
		
		/**
		 * 配置部署 AJBridge
		 * @param	flashvars
		 */
		function deploy(flashvars: Object): void;
		/**
		 * 添加回调
		 * @param	...args
		 */
		function addCallback(...args): void;
		/**
		 * 向外部发送自定义事件
		 * @param	event
		 */
		function sendEvent(event: Object): void ;
		/**
		 * 
		 * 也可用于静态发布 swf 方式的激活
		 * @param	config
		 */
		function activate(config:Object = null): void;
		
		function getReady(): String;
		
	}

}