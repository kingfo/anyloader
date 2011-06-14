package com.xintend.net.uploader {
	import com.xintend.events.RichEvent;
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class Uploader extends EventDispatcher implements IUploader {
		
		public static const UPLOAD_LIST_COMPLETE: String = "uploadListComplete";
		public static const UPLOAD_LOCK: String = "uploadLock";
		public static const UPLOAD_UNLOCK: String = "uploadUnlock";
		public static const UPLOAD_CLEAR: String = "uploadClear";
		
		/*兼容 YUI */
		public static const CONTENT_READY: String = "contentReady";
		public static const FILE_SELECT: String = "fileSelect";
		public static const UPLOAD_START: String = "uploadStart";
		public static const UPLOAD_PROGRESS: String = "uploadProgress";
		public static const BROWSE_CANCEL: String = "browseCancel";
		public static const UPLOAD_COMPLETE: String = "uploadComplete";
		public static const UPLOAD_COMPLETE_DATA: String = "uploadCompleteData";
		public static const UPLOAD_ERROR: String = "uploadError";
		
		
		
		
		public function get isLocked(): Boolean { return _isLocked; }
		
		public function get isMulit(): Boolean { return _isMulit; }
		/**
		 * 指定是否支持多文件选择
		 * @param	allowMultipleFiles			
		 */
		public function setAllowMultipleFiles(value:Boolean):void {
			_isMulit = value;
		}
		/**
		 * 配置文件过滤器
		 * @param	fileFilters					制定文件的类型
		 */
		public function setFileFilters (fileFilters: Array): void {
			this.fileFilters = fileFilters;
		}
		
		public function get length(): int { return pendingLength; }
		
		public static const ID_PREFIX: String = "ID";
		
		public function Uploader() {
			FILE_ID = new Date().getTime();
		}
		
		
		public function init(serverURL:String,serverParameters:Object): void {
			this.serverURL = serverURL;
			this.serverParameters = serverParameters;
			dispatchEvent(new RichEvent(CONTENT_READY));
		}
		
		/**
		 * 显示一个文件浏览对话框，让用户选择要上载的文件。 该对话框对于用户的操作系统来说是本机的。
		 * @param	mulit				启用多文件选择
		 * @param	fileFilters			实例数组，用于过滤在对话框中显示的文件。如果省略此参数，则显示所有文件。
		 * @return	如果参数有效并且打开了文件浏览对话框，则返回 true。 在以下情况下，browse 方法返回 false：未打开对话框；正在进行另一个浏览器会话；使用 typelist 参数，但未能在数组的任一元素中提供描述或扩展名字符串。 
		 */
		public function browse(mulit: * = null, fileFilters: Array = null): Boolean {
			var filters: Array;
			var i: int;
			var n: int;
			var fileter: Object;
			var ext:*;
			var desc:*;
			var mac:*;
			
			if (_isLocked) {
				dispatchEvent(new RichEvent(UPLOAD_LOCK));
				return false;
			}
			
			_isMulit = mulit || isMulit;
			
			fileFilters = fileFilters || this.fileFilters;
			
			if (fileFilters) {
				// 提取文件过滤配置
				filters = [];
				n = (fileFilters||[]).length;
				for (i = 0; i < n;  i++) {
					fileter = fileFilters[i];
					ext = fileter["ext"] || fileter["extension"];
					mac = fileter["mac"] || fileter["macType"];
					if (ext) {
						desc = fileter["desc"] || fileter["description"] || "Files"
						filters[i] = new FileFilter(desc,ext,mac);
					}
				}
			}
			
			try {
				// 多文件上传验证
				if (isMulit) {
					if (!fileReferenceList) {
						fileReferenceList = new FileReferenceList();
						configureListeners(fileReferenceList);
					}
					return fileReferenceList.browse(filters);
				}else {
					fileReference = new FileReference();
					configureListeners(fileReference);
					return fileReference.browse(filters);
				}
			}catch (e: Error) {
				dispatchEvent(new RichEvent(ErrorEvent.ERROR, false, true, e.message));
			}
			
			
			_isLocked = true;
			
			return true;
		}
		/**
		 * 开始上传文件
		 * @param	fileid						指上传文件名
		 * @param	serverURL					指上传文件服务器地址。
		 * @param	method						指上传文件服务器的方式  GET or POST
		 * @param	serverURLParameter			至上传的URL参数
		 * @param	uploadDataFieldName			POST操作数据属性。默认是Filedata不需要更改，请务必保持此指不为空或空字符串。
		 * @return
		 */
		public function upload(fileID: String,
								serverURL: String = null, 
								method: String = "POST", 
								serverURLParameter: Object = null,
								uploadDataFieldName: String = "Filedata") : Boolean {
			var request: URLRequest;
			var fileReference: FileReference;
			this.serverURL = serverURL || this.serverURL;
			this.serverParameters = serverParameters || this.serverParameters;
			
			if (!this.serverURL) return false;
			
			request = getURLRequest(this.serverURL, method, serverURLParameter);
			
			try {
				fileReference = pendingFiles[fileID];
				if (!fileReference) dispatchEvent(new RichEvent(ErrorEvent.ERROR, false, true, "no file"));
				addNetListeners(fileReference);
				fileReference.upload(request, uploadDataFieldName);
			}catch (e: Error) {
				dispatchEvent(new RichEvent(ErrorEvent.ERROR, false, true, e.message));
			}
			
			listComplete = false;
			
			return true;
		}
		
		/**
		 * 开始上传文件队列
		 * @param	serverURL					指上传文件服务器地址。
		 * @param	method						指上传文件服务器的方式  GET or POST
		 * @param	serverURLParameter			至上传的URL参数
		 * @param	uploadDataFieldName			POST操作数据属性。默认是Filedata不需要更改，请务必保持此指不为空或空字符串。
		 * @return
		 */
		public function uploadAll(serverURL: String = null, 
								method: String = "POST", 
								serverURLParameter: Object = null,
								uploadDataFieldName:String = "Filedata") : Boolean {
			var request: URLRequest;
			var fileReference: FileReference;
			this.serverURL = serverURL || this.serverURL;
			this.serverParameters = serverParameters || this.serverParameters;
			if (!this.serverURL) return false;
			request = getURLRequest(this.serverURL, method, serverURLParameter);
			try {
				for each(fileReference in pendingFiles) {
					addNetListeners(fileReference);
					fileReference.upload(request, uploadDataFieldName);
				}
			}catch (e: Error) {
				dispatchEvent(new RichEvent(ErrorEvent.ERROR, false, true, e.message));
			}
			listComplete = false;
			return true;
		}
		
		
		/**
		 * 终止指定上传过程中的文件
		 * @param	fid			
		 * @return
		 */
		public function cancel(fid: String = null): * {
			trace("cancel");
			
			var fileReference: FileReference;
			var res:*;
			try {
				if (fid == null) {
					res = [];
					for each(fileReference in pendingFiles) {
						res.push(fileReference);
						
							fileReference.cancel();
					}
				} else {
					res = fileReference = pendingFiles[fid];
					if (fileReference) {
							fileReference.cancel();
						
					}
				}
			}catch (e: Error) { trace(e) }
			
			return res;
		}
		/**
		 * 通过 文件序列号获取文件
		 * @param	fid
		 * @return
		 */
		public function getFile(fid: String): Object {
			return convertFileReferenceToObject(pendingFiles[fid]);
		}
		/**
		 * 通过 文件序列号删除文件
		 * @param	fid
		 * @return
		 */
		public function removeFile(fid: String): Object {
			trace("removeFile");
			var fileReference: FileReference = pendingFiles[fid] as FileReference;
			var o: Object = convertFileReferenceToObject(fileReference);
			cancel(fid);
			removePendingFile(fileReference);
			return o;
		}
		/**
		 * 锁定上传功能
		 */
		public function lock(): void {
			if (_isLocked) return;
			_isLocked = true;
			dispatchEvent(new RichEvent(UPLOAD_LOCK));
		}
		/**
		 * 解锁上传功能
		 */
		public function unlock(): void {
			if (!_isLocked) return;
			_isLocked = false;
			dispatchEvent(new RichEvent(UPLOAD_UNLOCK));
		}
		/**
		 * 清除所有文件
		 */
		public function clear(): void {
			var fileReference: FileReference;
			trace("clear");
			cancel();
			for each( fileReference in pendingFiles) {
				removePendingFile(fileReference);
			}
			pendingLength = 0;
			dispatchEvent(new RichEvent(UPLOAD_CLEAR));
		}
		
		
		public function convertFileReferenceToObject(fileReference: * ): Object {
			var o: Object;
			if (!fileReference || !(fileReference is FileReference)) return null;
			trace("convertFileReferenceToObject",fileReference.name);
			try {
				o = { };
				o.cDate = fileReference.creationDate;
				o.mDate = fileReference.modificationDate;
				o.name = fileReference.name;
				o.size = fileReference.size;
				o.type = fileReference.type;
				o.id = pendingIds[fileReference] || null;
			}catch (e: Error) {
				
			}
			
			return o;
		}
		
		
		protected function getURLRequest(url:String, method:String = "POST", variables:Object = null) : URLRequest {
            var k:String = null;
            var req:URLRequest = new URLRequest();
            req.url= url;
            req.method = method;
			if (variables != null) {
				 req.data = new URLVariables();
				for (k in variables){
					req.data[k] = variables[k];
				}
			}
            return req;
        }
		
		protected function configureListeners(dispatcher: IEventDispatcher): void {
			dispatcher.addEventListener(Event.CANCEL, eventHandler);
			dispatcher.addEventListener(Event.SELECT, eventHandler);
        }
		
		
		protected function netEventHandler(e: Event): void {
			var event: RichEvent;
			var fileID: String;
			var file: Object;
			file = convertFileReferenceToObject(e.target);
			fileID = pendingFiles[e.target];
			trace("netEventHandler",e.type,file.id);
			switch(e.type) {
				case ProgressEvent.PROGRESS:
					event = new RichEvent(UPLOAD_PROGRESS, false, true, {bytesLoaded:e["bytesLoaded"],bytesTotal:e["bytesTotal"]} );
				break;
				case Event.COMPLETE:
					e.target.removeEventListener(Event.COMPLETE, netEventHandler);
					removePendingFile(e.target as FileReference);
					event = new RichEvent(UPLOAD_COMPLETE );
					checkLength();
				break;
				case DataEvent.UPLOAD_COMPLETE_DATA:
					e.target.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, netEventHandler);
					removePendingFile(e.target as FileReference);
					event = new RichEvent(UPLOAD_COMPLETE_DATA, false, true,  {data:e["data"]});
					checkLength();
				break;
				case Event.OPEN:
					event = new RichEvent(UPLOAD_START );
				break;
			}
			event.file = file;
			dispatchEvent(event);
		}
		
		
		
		protected function errorEventHandler(e: Event): void {
			var event: RichEvent;
			var fileID: String;
			var file: Object;
			file = convertFileReferenceToObject(e.target);
			fileID = pendingFiles[e.target];
			event = new RichEvent(UPLOAD_ERROR);
			 switch(e.type) {
				case HTTPStatusEvent.HTTP_STATUS:
					event.status = e["status"];
				break;
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
					event.message = e["text"];
				break;
			}
			event.file = file;
			event.originType = e.type;
			dispatchEvent(event);
		}
		
		protected function eventHandler(e: Event): void {
			var event: RichEvent;
			var fileList: Array;
			switch(e.type) {
				case Event.SELECT:
					fileList = addPendingFile(e.target);
					event = new RichEvent(FILE_SELECT,false,true, {fileList:fileList});
				break;
				case Event.CANCEL:
					event = new RichEvent(BROWSE_CANCEL);
				break;
			}
			dispatchEvent(event);
		}
		protected function checkLength(): void {
			if (pendingLength == 0 && !listComplete) {
				clear();
				dispatchEvent(new RichEvent(UPLOAD_LIST_COMPLETE));
				listComplete = true;
			}
		}
		/**
		 * 添加待处理文件至未决列表中。
		 * @param	file
		 * @return					是转化为纯粹 Object 的数组
		 */
		protected function addPendingFile(file: Object): Array {
			var i: int;
			var n: int;
			var fileReference: FileReference;
			var fileID: String;
			var fileList: Array = [];
			var fileReferenceList: FileReferenceList;
			if (file is FileReferenceList) {
				fileReferenceList = file as FileReferenceList;
				n = fileReferenceList.fileList.length;
				for (i = 0; i < n; i++ ) {
					fileReference = fileReferenceList.fileList[i];
					fileID = saveFile(fileReference);
					pendingLength++;
					fileList.push(convertFileReferenceToObject(fileReference));
				}
				
			}else if (file is FileReference) {
				fileReference = file as FileReference;
				saveFile(fileReference);
				fileList = [convertFileReferenceToObject(fileReference)];
				pendingLength++;
			}
			return fileList;
		}
		
		
		protected function addNetListeners(dispatcher: FileReference): void {
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, errorEventHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEventHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
			
			dispatcher.addEventListener(Event.OPEN, netEventHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, netEventHandler);
			
			dispatcher.addEventListener(Event.COMPLETE, netEventHandler);
			dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, netEventHandler);
        }
		
		protected function removeNetListeners(dispatcher: IEventDispatcher): void {
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, errorEventHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEventHandler);
			
			dispatcher.removeEventListener(Event.OPEN, netEventHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, netEventHandler);
			
			//dispatcher.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataEventHandler);
			//
			//dispatcher.removeEventListener(Event.COMPLETE, netEventHandler);
        }
		/**
		 * 保存指定的文件引用
		 * @param	fileReference
		 * @return
		 */
		protected function saveFile(fileReference: FileReference): String {
			var fid: String;
			fid = ID_PREFIX + Number(FILE_ID++).toString(16).toUpperCase();
			pendingFiles[fid] = fileReference;
			pendingIds[fileReference] = fid;
			return fid;
		}
		/**
		 * 从未决堆中移除指定的文件引用
		 * @param	file
		 */
		protected function removePendingFile(file: FileReference): void {
			if (!file) return;
			var key: String = pendingIds[file]; // 从堆中取
			if (!key) return;
			var fileReference: FileReference = pendingFiles[key]; // 堆中存在的 FR
			if (!fileReference) return;
			trace("removePendingFile");
			removeNetListeners(fileReference);
			pendingFiles[key] = null;
			pendingIds[fileReference] = null;
			delete pendingFiles[key];
			delete pendingIds[fileReference];
			pendingLength--;
		}

		
		private var pendingFiles: Dictionary = new Dictionary(true);
		private var pendingIds: Object = new Dictionary(false);
		private var pendingLength: int = 0;
		
		private var serverURL: String;
		private var serverParameters: Object;
		private var _isMulit: Boolean = true;
		private var _isLocked: Boolean = false;
		private var fileFilters: Array;
		private var fileReferenceList: FileReferenceList;
		private var fileReference: FileReference;
		
		private var listComplete: Boolean = false;
		
		private var FILE_ID: int;
		
		
		
		
	}

}