package
{
	import mx.collections.ArrayCollection;
	
	public dynamic class User extends Object
	{
		public function User()
		{
			phoneNos = new ArrayCollection;
		}
		
		public var name:String;
		
		public var sex:String;
		
		public var email:String;
		
		public var password:String;
		
		public var birthday:Date;
		
		public var mainPhoneNo:String;
		
		public var phoneNos:ArrayCollection;
		
		public var team:String;
		
		public var favouriteColor:String;
		
	}
}