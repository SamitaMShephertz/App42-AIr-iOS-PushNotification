package{
	
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class CustomButton extends Sprite {
	private var wsize:uint = 135;
	private var hsize:uint = 40;
	private var overColor:uint = 0xBBBBBB;
	private var downColor:uint = 0x00CCFF;
	private var buttons:TextField;	
	public var xFormat1:TextFormat = new TextFormat("Arial", 18);
	public function CustomButton(str:String="Button") {
		
		
		this.mouseChildren=false;		
		draw(wsize, hsize, overColor);
		buttons=new TextField();
		
		buttons.defaultTextFormat = xFormat1;
		buttons.text=str;	
		buttons.autoSize = TextFieldAutoSize.CENTER; 
		this.addChild(buttons);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
	}
	
	public function draw(w:uint, h:uint, bgColor:uint):void {
		graphics.clear();
		graphics.beginFill(bgColor);
		graphics.drawRoundRect(0,0,w,h,50,40);
		graphics.endFill();
	}	
	
	public function mouseDownHandler(event:MouseEvent):void {		
		draw(wsize, hsize, downColor);	
	}
	
	public function mouseUpHandler(event:MouseEvent):void {	
		draw(wsize, hsize, overColor);
	}
}
}
