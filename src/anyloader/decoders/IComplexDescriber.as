package anyloader.decoders {
	import flash.utils.IDataInput;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public interface IComplexDescriber extends IDescriber {
		function get core(): IDescriber;
		function match(bytes: IDataInput): void;
	}
	
}