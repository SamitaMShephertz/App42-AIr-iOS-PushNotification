import com.shephertz.app42.paas.sdk.as3.App42CallBack;
import com.shephertz.app42.paas.sdk.as3.App42Exception;
import com.shephertz.app42.paas.sdk.as3.push.PushNotification;
import com.shephertz.app42.paas.sdk.as3.push.PushNotificationService;

import flash.text.TextField;
var pushNotificationService:PushNotificationService;
var outputBtn:TextField = new TextField();
var headingTextField:String="";
class app42StorePushCallBack implements App42CallBack {
	public function onSuccess(response:Object):void
	{
		outputBtn.appendText("\n PushNotification");	
		var pushNotification:PushNotification = PushNotification(response);
		outputBtn.appendText("\n PushNotification success is : "+pushNotification)	
		outputBtn.appendText("\n User Name  : "+pushNotification.getUserName());
		outputBtn.appendText("\n DeviceToken :"+pushNotification.getDeviceToken());
		outputBtn.appendText("\n Device Type : "+pushNotification  .getType());		}
	public function onException(exception:App42Exception):void
	{
		outputBtn.appendText ( "\n Exception is : " + exception);
	}
}
class app42PushCallBack implements App42CallBack  
{     
	headingTextField="";
	public function onSuccess(response:Object):void  
	{     
		outputBtn.appendText("\n PushNotification");	
		var pushNotification:PushNotification = PushNotification(response);  
		outputBtn.appendText("\n PushNotification success is : "+pushNotification)	
		outputBtn.appendText("\n User Name  : "+pushNotification.getUserName());  
		outputBtn.appendText("\n Expiry is " + pushNotification.getExpiry());      
		outputBtn.appendText("\n Message is " + pushNotification.getMessage());      
	}  
	public function onException(exception:App42Exception):void  
	{  
		outputBtn.appendText ( "\n Exception is : " + exception);
	}  
}  
package
{
	import com.shephertz.app42.paas.sdk.as3.App42API;
	import com.shephertz.app42.paas.sdk.as3.push.DeviceType;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifier;
	import flash.notifications.RemoteNotifierSubscribeOptions;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	[SWF(width="1280", height="752", frameRate="60")]
	public class PushSample extends Sprite
	{
		private var notificationStyles:Vector.<String> = new Vector.<String>;	
		private var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions();
		private var preferredStyles:Vector.<String> = new Vector.<String>();
		private var remoteNotifierObject:RemoteNotifier = new RemoteNotifier();	
		
		private var deviceTokenbtn:CustomButton = new CustomButton("      Store Token");	
		public var xFormat1:TextFormat = new TextFormat("Arial", 20);
		public var xFormat:TextFormat = new TextFormat("Arial", 50);
		private var pushMessagebtn:CustomButton = new CustomButton("      Send Message");			
		private var clearbtn:CustomButton = new CustomButton("      Clear Console");		
		private var deviceToken:String="";
		private var GREY:uint = 0x999999;
		private var BLACK:uint = 0x000000;
		private var WHITE:uint = 0xFFFFFF;
		private var RED:uint = 0xDF0101;
		private var unsubscribeBtn:TextField = new TextField();		
		
		private var messageTextField:TextField = new TextField(); 
		private var messagelbl:TextField = new TextField();	
		public function PushSample()
		{
			super();
			
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			App42API.initialize(Constant.apiKey,Constant.secretKey);
			pushNotificationService  = App42API.buildPushNotificationService();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			outputBtn.x = 20;	
			outputBtn.y = 50 ;
			outputBtn.selectable = false;
			outputBtn.width = 600;			
			outputBtn.defaultTextFormat = xFormat1;
			outputBtn.wordWrap= true;
			outputBtn.height = 500;			
			outputBtn.border= true;
			outputBtn.borderColor = BLACK;		
			outputBtn.background = true;
			outputBtn.backgroundColor = GREY;
			outputBtn.textColor = WHITE;
			outputBtn.text= "OUTPUT";		
			stage.addChild(outputBtn);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			messagelbl.x = 25;	
			messagelbl.y = 600 ;
			messagelbl.selectable = false;
			messagelbl.width = 150;			
			messagelbl.defaultTextFormat = xFormat1;
			messagelbl.wordWrap= true;
			messagelbl.height = 50;			
			messagelbl.border= true;
			messagelbl.borderColor = BLACK;		
			messagelbl.background = true;
			messagelbl.backgroundColor = GREY;
			messagelbl.textColor = WHITE;
			messagelbl.text= "Enter the Message :";	
			stage.addChild(messagelbl);
				
			messageTextField.x = 145;
			messageTextField.y = 600;
			messageTextField.height = 50;
			messageTextField.width = 470;
			messageTextField.defaultTextFormat = xFormat;
			messageTextField.background = true;			
			messageTextField.backgroundColor = GREY;
			messageTextField.textColor = WHITE;
			messageTextField.border = true;
			messageTextField.maxChars = 40;
			messageTextField.wordWrap = true;
			messageTextField.type = TextFieldType.INPUT;
			messageTextField.addEventListener(Event.CHANGE, messageHandler);
			stage.addChild(messageTextField);	
			
			deviceTokenbtn.x = 100;
			deviceTokenbtn.y=700;
			deviceTokenbtn.addEventListener(MouseEvent.CLICK,storeDeviceToken_click);
			stage.addChild(deviceTokenbtn);	
			
			pushMessagebtn.x = 250;
			pushMessagebtn.y=700;
			pushMessagebtn.addEventListener(MouseEvent.CLICK,sendMessage_click);
			stage.addChild(pushMessagebtn);	
			
		
			clearbtn.x = 400;
			clearbtn.y=700;
			clearbtn.addEventListener(MouseEvent.CLICK,clear_click);
			stage.addChild(clearbtn);	
			
			preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND );			
			subscribeOptions.notificationStyles= preferredStyles;
			remoteNotifierObject.subscribe(subscribeOptions);
			remoteNotifierObject.addEventListener(RemoteNotificationEvent.TOKEN,deviceToken_click);
			
		}		
		
		public function notificationHandler(e:RemoteNotificationEvent):void{
			headingTextField="";
			outputBtn.text = "";			
			for (var x:String in e.data) {
				outputBtn.appendText( "\n Messages, Sounds , badges : "+ x + ":  " + e.data[x]);
			}				
		}
		
		
		public function storeDeviceToken_click(e:MouseEvent):void
		{		
			outputBtn.text = "";
			pushNotificationService.storeDeviceToken(Constant.userName, deviceToken, DeviceType.iOS , new app42StorePushCallBack());
		}
		public function sendMessage_click(e:MouseEvent):void
		{
			outputBtn.text = "";	
			pushNotificationService.sendPushMessageToUser(Constant.userName,  headingTextField , new app42PushCallBack());
		}
		
		
		public function deviceToken_click(e:RemoteNotificationEvent):void
		{
			outputBtn.text = "";
			outputBtn.appendText("\n Subscribe to device");
			deviceToken = e.tokenId;
			remoteNotifierObject.addEventListener(RemoteNotificationEvent.NOTIFICATION,notificationHandler);			
		}
		
		private function clear_click(e:MouseEvent):void
		{
			outputBtn.text = "";
			messageTextField.text="";
		}
		
		private function messageHandler(e:Event):void {
			headingTextField= messageTextField.text;
		}
		
	}
}