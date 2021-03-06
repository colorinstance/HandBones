package org.handbones.controller 
{
	import org.assetloader.base.AssetType;
	import org.handbones.model.PageModel;
	import org.handbones.model.SettingsModel;
	import org.handbones.model.vo.ActionVO;
	import org.handbones.model.vo.AssetVO;
	import org.handbones.model.vo.ContextMenuItemVO;
	import org.handbones.model.vo.ContextMenuVO;
	import org.handbones.model.vo.CookieVO;
	import org.handbones.model.vo.CookiesVO;
	import org.handbones.model.vo.TrackVO;
	import org.robotlegs.mvcs.Command;

	import flash.events.MouseEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class ParseSettingsXmlCommand extends Command 
	{

		[Inject]
		public var model : SettingsModel;

		[Inject]
		public var xml : XML;

		override public function execute() : void 
		{
			parseSiteNode(xml);
		}

		protected function parseSiteNode(xml : XML) : void
		{
			var pages : Array = [];
			var actions : Array = [];
			var assets : Array = [];
			
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "contextMenu":
						model.contextMenuVo = parseContextMenuNode(node);
						break;
					case "cookies":
						model.cookiesVo = parseCookiesNode(node);
						break;
					case "page" :
						pages.push(parsePageNode(node));
						break;
					case "action" :
						actions.push(parseActionNode(node));
						break;
					case "asset" :
						assets.push(parseAssetNode(node));
						break;
				}
			}
			
			model.titleBody = xml.title.@body || "";
			model.titlePrefix = xml.title.@prefix;
			model.titleSuffix = xml.title.@suffix;
			
			model.trackerUID = xml.tracker.@uid;
			model.trackerDebug = toBoolean(xml.tracker.@debug, false);
			
			model.shellDispatchContextStartupComplete = toBoolean(xml.shell.@dispatchContextStartupComplete, true);
			
			model.pages = pages;
			model.actions = actions;
			model.assets = assets;
			
			model.data = xml.data[0];
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseContextMenuNode(xml : XML) : ContextMenuVO 
		{
			var items : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "item" :
						items.push(parseContextMenuItemNode(node));
						break;
				}
			}
			
			var vo : ContextMenuVO = new ContextMenuVO();
			
			vo.hideDefault = toBoolean(xml.@hideDefault, true);
			vo.zoom = toBoolean(xml.@zoom, false);
			vo.quality = toBoolean(xml.@quality, false);
			vo.print = toBoolean(xml.@print, false);
				
			vo.items = items;
			
			return vo;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseCookiesNode(xml : XML) : CookiesVO 
		{
			var cookies : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "cookie" :
						cookies.push(parseCookieNode(node));
						break;
				}
			}
			
			var vo : CookiesVO = new CookiesVO();
			
			vo.name = xml.@name;
			vo.clear = toBoolean(xml.@clear, false);
				
			vo.cookies = cookies;
			
			return vo;
		}

		protected function parseCookieNode(xml : XML) : CookieVO 
		{
			var vo : CookieVO = new CookieVO();
			
			vo.id = xml.@id;
			vo.value = String(xml.@value) || null;
			vo.type = xml.@type || "string";
			vo.reset = toBoolean(xml.reset, false);
			
			return vo;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseContextMenuItemNode(xml : XML) : ContextMenuItemVO 
		{
			var actions : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "action" :
						actions.push(parseActionNode(node));
						break;
				}
			}
			
			var vo : ContextMenuItemVO = new ContextMenuItemVO();
			
			vo.caption = xml.@caption;
			
			vo.separator = toBoolean(xml.@separator, false);
			vo.enabled = toBoolean(xml.@enabled, true);
			vo.visible = toBoolean(xml.@visible, true);
			
			vo.actions = actions;
			
			return vo;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parsePageNode(xml : XML) : PageModel 
		{
			var actions : Array = [];
			var assets : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "action" :
						actions.push(parseActionNode(node));
						break;
					case "asset" :
						assets.push(parseAssetNode(node));
						break;
				}
			}
			
			var pageModel : PageModel = new PageModel();
			
			pageModel.id = xml.@id;
			pageModel.address = xml.@address;
			pageModel.title = xml.@title;
			pageModel.src = xml.@src;
			
			pageModel.assetGroupId = xml.@assetGroupId || null;
			pageModel.loadPriority = (xml.@loadPriority || NaN);
			
			pageModel.loadOnDemand = toBoolean(xml.@loadOnDemand, false);
			
			pageModel.actions = actions;
			pageModel.assets = assets;
			pageModel.data = xml.data[0];
			
			pageModel.autoStartup = toBoolean(xml.@autoStartup, true);
			pageModel.autoShutdown = toBoolean(xml.@autoShutdown, true);
			
			return pageModel;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseActionNode(xml : XML) : ActionVO 
		{
			var action : ActionVO = new ActionVO();
			
			var trackers : Array = [];
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "track" :
						trackers.push(parseTrackNode(node));
						break;
				}
			}
			
			action.ref = xml.@ref || "";
			
			action.event = xml.@event || MouseEvent.CLICK;
			
			action.gotoPageId = xml.@gotoPageId;
			action.invokeUrl = xml.@invokeUrl;
			action.changeAddress = xml.@changeAddress;
			
			action.urlWindow = xml.@urlWindow;
			action.keepHistory = toBoolean(xml.@keepHistory, true);
			
			action.showStatus = toBoolean(xml.@showStatus, true);
			
			action.trackers = trackers;
			
			return action;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseTrackNode(xml : XML) : TrackVO 
		{
			var track : TrackVO = new TrackVO();
			
			track.url = xml.@url;
			
			track.category = xml.@category;
			track.action = xml.@action;
			track.label = xml.@label;
			track.value = xml.@value;
			
			return track;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseAssetNode(xml : XML) : AssetVO
		{
			var asset : AssetVO = new AssetVO();
			
			asset.id = xml.@id;
			asset.src = xml.@src;
			asset.type = xml.@type || AssetType.AUTO;
			asset.retries = xml.@retries || 3;
			asset.weight = parseWeightString(xml.@weight);
			asset.priority = xml.@priority || NaN;
			asset.onDemand = toBoolean(xml.@onDemand, false);
			asset.preventCache = toBoolean(xml.@preventCache, false);
			
			return asset;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function parseWeightString(str : String) : uint
		{
			if(!str)
				return 0;
				
			str = str.replace(new RegExp(" ", "g"), "");
			
			var mbExp : RegExp = new RegExp("mb", "gi");
			if(mbExp.test(str))
				return Number(str.replace(mbExp, "")) * 1024 * 1024;
			
			var kbExp : RegExp = new RegExp("kb", "gi");
			if(kbExp.test(str))
				return Number(str.replace(kbExp, "")) * 1024;
			
			return 0;
		}
	}
}
