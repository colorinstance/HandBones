package org.handbones.model.vo 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class TrackVO 
	{

		public var url : String;

		public var category : String;

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}