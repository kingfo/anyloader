package com.xintend.ajbridge.local.store {
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public interface ILocalStorage {
		/**
		 * 获取本地存储成对 key/value 的个数
		 * @return
		 */
		function getLength(): uint;
		/**
		 * 获取指定 key 对应值。 不存在返回 null
		 * @param	key
		 * @return
		 */
		function getItem(key: String):*;
		/**
		 * 写入指定 key 及对应值
		 * @param	key
		 * @param	data
		 */
		function setItem(key: String, data:*): void;
		/**
		 * 返回指定堆中第 n 个 key 的名称。 不存在返回 null
		 * @param	n
		 * @return
		 */
		function key(n: *): String;
		/**
		 * 删除指定 key 及对应值
		 * @param	key
		 */
		function removeItem(key: String): void;
		/**
		 * 清空所有记录
		 */
		function clear(): void
	}
	
}