package org.handbones.model.vo 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetVO 
	{
		public var id : String;
		
		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}