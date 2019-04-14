package com.event
{
	import flash.events.Event;
	
	import mxml.item.ColorItem;

	public class ColorEvent extends Event
	{ 
		public static const CLICKS:String = "clicks";
		
		//当前选择的ColorItem
		public var colorItem:ColorItem;
		
		public function ColorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}