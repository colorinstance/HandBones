package org.handbones.base 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class TrackAction 
	{

		public var url : String;

		public var category : String;

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}