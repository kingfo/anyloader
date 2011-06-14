package com.xintend.ajbridge.local.store {
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class LocalStorage extends EventDispatcher implements ILocalStorage{
		
		public static const DEFAULT_NAME_PREFIX: String = "DataStore_";
		
		public static const MINIMUM_ADEQUATE_WIDTH: Number = 215;
		public static const MINIMUM_ADEQUATE_HEIGHT: Number = 138;
		
		
		
		public function LocalStorage(useCompression: Boolean = true, browser: String = null,secure:Boolean = false) {
			_useCompression = useCompression;
			_browser = browser || "";
			
			checkout(DEFAULT_NAME_PREFIX + _browser,null,secure);
		}
		
		
		
		/**
		 * 切换存储文件
		 * @param	name							具体本地存储名
		 * @param	path							具体本地路径
		 * @param	secure							
		 */
		public function checkout(name: String, path: String = null, secure: Boolean = false): void {
			var oldName: String = storageName;
			
			storageName = name;
			storagePath = path;
			storageSecure = secure;
			
			trace("checkout")
			
			dispatchEvent(new StorageEvent(StorageEvent.CHECKOUT, null,"storageName",oldName,storageName));
		}
		
		/**
		 * 获取本地存储成对 key/value 的个数
		 * @return
		 */
		public function getLength(): uint {
			trace("getLength");
			return readArchive().hash.length;
		}
		/**
		 * 获得存储的数据对象
		 * @param	key								键
		 * @return
		 */
		public function getItem(key: String):*{
			trace("getItem:", key);
			var  archive: Object = readArchive();
			if (archive.storage.hasOwnProperty(key)) {
				return archive.storage[key];
			}
			return null;
		}
		/**
		 * 存储数据对象
		 * @param	key								键
		 * @param	data							任意数据
		 */
		public function setItem(key:String,data:*): void {
			var oldValue:* ;
	    	var info: String;
			var archive: Object = readArchive();
			var result: Boolean;
			trace("setItem:", key, String(data));
			if (archive.storage.hasOwnProperty(key)) {
				if (archive.storage[key] == data) {
					return ;
				}else {
					oldValue = getItem(key);
					info = "update";
				}
			}else {
				info = "add";
				archive.hash.push(key);
			}
			if (key == "" || key == null) return;
			archive.storage[key] = data;
			
			
			result = save(archive);
			if (result) dispatchEvent(new StorageEvent(StorageEvent.STORAGE, info,key,  oldValue, data));
		}
		/**
		 * 按索引取得键
		 * 通常通过 length 和 key 的配合来查找已存在的 键
		 * @param	index
		 * @return
		 */
		public function key(index: *): String {
			////	统一为 null  避免 undefined
			trace("key:", index);
			if (isNaN(index) || !isFinite(index)) return null;
			return readArchive().hash[index] || null;
		}
		/**
		 * 移除已存在的数据
		 * @param	key
		 */
		public function removeItem(key: String): void {
			trace("removeItem:", key);
			var archive: Object = readArchive();
			var index: int;
			var oldValue: * ;
			var info: String;
			var result: Boolean;
			if (key == "" || key == null) return;
			index =  archive.hash.indexOf(key);
			if (index < 0) return;
			oldValue = archive.storage[key];
			delete archive.storage[key];
			archive.hash.splice(index, 1);
			
			info = "delete";
			
			
			result = save(archive);
			if (result) dispatchEvent(new StorageEvent(StorageEvent.STORAGE,info, key, oldValue));
		}
		/**
		 * 清空数据缓存
		 * 原始操作相当于销毁实际文件
		 * 而此操作后又创建了新的档案并再次存入修改信息
		 */
		public function clear(): void {
			var so: SharedObject = getSharedObject();
			so.clear();
			save(createEmptyArchive());
			dispatchEvent(new StorageEvent(StorageEvent.CLEAR));
			trace('clear');
		}
		/**
		 * 销毁本地存储
		 */
		public function destroy(): void {
			var so: SharedObject = getSharedObject();
			so.clear();
			save();
			dispatchEvent(new StorageEvent(StorageEvent.DESTROY));
			trace('destroy');
		}
		
		/**
		 * 获得已存字节大小  单位 B
		 * @return
		 */
		public function getSize(): uint {
			var so: SharedObject = getSharedObject();
			var size: uint = so.size;
			return size;
		}
		/**
		 * 分配磁盘空间
		 * @param	value
		 * @return
		 */
		public function setSize(value: int): String {
			var status: String;
			var so: SharedObject = getSharedObject();
			status = so.flush(value);
			return status;
		}
		/**
		 * 获得是否是压缩方式处理数据
		 * @return
		 */
		public function getUseCompression(): Boolean {
			return _useCompression;
		}
		/**
		 * 设置压缩方式
		 * 配置是否为压缩方式请在传参的时候配置
		 * 一般不公开
		 * @param	value
		 */
		public function setUseCompression(value:Boolean): void {
			_useCompression = value;
		}
		/**
		 * 获取最后修改时间
		 * @return
		 */
		public function getModificationDate(): Date {
			var so:SharedObject = getSharedObject();
			var lastDate: Date =  new Date(so.data.modificationDate);
			return lastDate;
		}
		/**
		 * 重新获取本地共享对象
		 * @return
		 */
		protected function getSharedObject(): SharedObject {
			var so:SharedObject = SharedObject.getLocal(storageName,storagePath,storageSecure);
			so.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			dispatchEvent(new StorageEvent(StorageEvent.OPEN,so.hasOwnProperty("data")?"success":"failed"));
			return so;
		}
		/**
		 * SharedObject 存储状态
		 * @param	event
		 */
		protected function onNetStatus(event: NetStatusEvent): void {
			if (event.info.level === "error") {
				dispatchEvent(new StorageEvent(StorageEvent.STATUS,"failed"));
			}else {
				dispatchEvent(new StorageEvent(StorageEvent.STATUS,"success"));
			}
		}
		/**
		 * 设置修改时间
		 * @param	so
		 */
		protected function setModificationDate(so:SharedObject): void {
			so.data.modificationDate = new Date().getTime();
		}
		/**
		 * 保存即时数据
		 * @param	archive
		 * @return
		 */
		protected function save(archive:Object = null): Boolean {
			var so: SharedObject = getSharedObject();
			var bytes: ByteArray = new ByteArray();
			var result: String;
			var key: String;
			////	与YUI SWFStore不同
			////	每次操作保存都当作一次修改作为记录
			////	而非有新值才变动
			
			if (archive) {
				if (_useCompression) {
					bytes.writeObject(archive);   
					bytes.compress();    
					so.data.archive = bytes;
				}else {
					so.data.archive = archive;
				}
				setModificationDate(so);
			}
			
			try{
				result = so.flush();
				dispatchEvent(new StorageEvent(StorageEvent.CLOSE,result)); 
	    	}catch(e:Error){
				dispatchEvent(new StorageEvent(StorageEvent.ERROR,"SharedObject flush error"));
			}
			
			switch(result) {
				case SharedObjectFlushStatus.FLUSHED:
					return true;
				break;
				case SharedObjectFlushStatus.PENDING:
					if (archive) {
						key = archive.hash[archive.hash.length - 1];
					}
					dispatchEvent(new StorageEvent(StorageEvent.PENDING,null,key));
					return false;
				break;
				default:
					dispatchEvent(new StorageEvent(StorageEvent.ERROR, "Flash Player Could not write SharedObject to disk."));
					return false;
			}
			
		}
		/**
		 * 即时读取存档
		 * @return
		 */
		protected function readArchive(): Object {
			var so: SharedObject = getSharedObject();
			var tempBytes: ByteArray;
			var bytes: ByteArray;
			var archive: Object;
			if (!so.data.hasOwnProperty("archive")) {
   				archive = createEmptyArchive();
				dispatchEvent(new StorageEvent(StorageEvent.CREATE));
 			}else {
				////	判断是否字节流
				////	是则是经过压缩的数据
				if (so.data.archive is ByteArray) {
					tempBytes = so.data.archive as ByteArray;
					bytes = new ByteArray();
					////	可能位置不正确，所以尝试复位
					tempBytes.position = 0;
 					tempBytes.readBytes(bytes, 0, tempBytes.length);
					try	{
 						bytes.uncompress();
 					}catch(error:Error)	{
 						dispatchEvent(new StorageEvent(StorageEvent.ERROR,"ByteArray uncompress error"));
 					}
					archive = bytes.readObject();
				}else {
					archive = so.data.archive;
				}
			}
			return archive;
		}
		/**
		 * 创建空文档
		 * @return
		 */
		protected function createEmptyArchive(): Object {
			return { storage: { }, hash: [] };
		}
		
		
		
		private var _length: uint;
		private var _useCompression: Boolean;
		private var _browser: String;
		
		
		private var storageName: String;
		private var storagePath: String;
		private var storageSecure: Boolean;
	}

}