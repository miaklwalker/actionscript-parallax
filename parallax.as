var layers = [];
var obj = {};
var count = 0
var config = {
scaleToCamera : true,
offsetToCamera: true,
offsetToOriginalPosition:false
};

function absorb(valueOne,valueTwo) {
	return valueOne - valueOne * valueTwo;
}

function toPrecision(value,digitsToRoundTo) {
	var multiplier = Math.pow(10, digitsToRoundTo);
	return Math.round(value * multiplier) / multiplier;
}

function updateLayer(name,zAxis,xOffset=0,yOffset=0,scale=true) {
	var layer = {
	_name:name,
	xAxis:xOffset,
	yAxis:yOffset,
	zAxis:zAxis,
	scale:scale
	};
	layers.push(layer);
}

function initialize():Function {

	var container:DisplayObjectContainer = this;

	var index = container.numChildren;
	var localPrecision = 5;
	var offsets = {};
	function createOffsets() {
		var cam = obj["vcam"].ele;
		return {
			offsetW:cam.width / 2,
			offsetH:cam.height / 2,
			offsetX:toPrecision(cam.x - obj.vcam.originalX,localPrecision),
			offsetY:toPrecision(cam.y - obj.vcam.originalY,localPrecision),
			xScale:toPrecision(cam.width / obj.vcam.originalW,localPrecision),
			yScale:toPrecision(cam.height / obj.vcam.originalH,localPrecision)
			};
	}

	function _updateLayer(layerName:String, layerZ:Number,xUserOffset = 0,yUserOffset = 0,scaling=true) {
		var newX,newY,newW,newH;
		var _ele = obj[layerName].ele;
		var cam = obj["vcam"].ele;
		var xScale = offsets.xScale;
		var yScale = offsets.yScale;
		
		// This tell us where the new vcam origin is 
		var scaleOffsetX = absorb(cam.x, xScale) / layerZ;
		var scaleOffsetY = absorb(cam.height, yScale) / layerZ;
		// USER OFFSETS
		var userOffsetX = xUserOffset - absorb(xUserOffset,xScale);
		var userOffsetY = yUserOffset - absorb(yUserOffset,yScale);

		// we are moving our layer by first moving it the vcamx
		// then moving the layer by the offset and finally adjusting 
		// that value by the zAxis
		var zScale = (1 + layerZ/1000);

		newX = cam.x;
		newX -= offsets.offsetW;
		newX -= (offsets.offsetX) / layerZ;
		newX += userOffsetX;
		newX += scaleOffsetX * zScale;
		
		newY =  cam.y;
		newY -= offsets.offsetH;
		newY -= (offsets.offsetY) / layerZ;
		newY += userOffsetY;
		newY += scaleOffsetY * zScale;
		
		newW = obj[layerName].originalW
		newW *= xScale;
		
		newH = obj[layerName].originalH
		newH *= yScale

		
		if (scaling && config.scaleToCamera) {			
			var resizeX = scaleOffsetX * obj[layerName].originalW / layerZ * .5;
			var resizeY = scaleOffsetY * obj[layerName].originalH / layerZ * .5;
			var xChange = newX - newX + resizeX + scaleOffsetX;
			var yChange = newY - newY + resizeY + scaleOffsetY;
			var scale = 4
			newX -= xChange *.5;
			newY -= yChange *.5 * scale;
			newW  += (resizeX + scaleOffsetX);
			newH += (resizeY + scaleOffsetY) * scale;
		}
		_ele.x = newX;
		_ele.y = newY;
		_ele.width = newW;
		_ele.height = newH;
	}


	function updatePosition(e) {
		var index = layers.length;
		offsets = createOffsets();
		var cam = obj["vcam"];
		var camOffsetX = (cam.originalX - cam.originalW / 2);
		var camOffsetY = (cam.originalY - cam.originalH / 2);
		do {
			var layer = layers[--index];
			var layerName = layer._name;
			var el = obj[layerName];
			var xOff = layer.xAxis + el.originalX;
			var yOff = layer.yAxis + el.originalY;
			if (config.offsetToCamera) {
				xOff -= camOffsetX;
				yOff -= camOffsetY;
			}
			_updateLayer(layer._name,layer.zAxis,xOff,yOff,layer.scale);
		} while (index);
	}

	function defineCoordinates() {
		do {
			var layer = container.getChildAt(--index);
			var _name = layer.name;
			var isVcam = getQualifiedClassName(layer).toString().indexOf("vcam") != -1;
			if (_name == "undefined" || isVcam) {
				_name = "vcam";
			}
			obj[_name] = {
			originalX:layer.x,
			originalY:layer.y,
			originalW:layer.width,
			originalH:layer.height,
			ele:layer
			}
			   ;
		} while (index);
	}

	defineCoordinates();
	addEventListener(Event.ENTER_FRAME,updatePosition);

	function cleanup() {
		removeEventListener(Event.ENTER_FRAME,updatePosition);
		for (var l = 0; l < layers.length; l++) {
			var layer = layers[l];
			var layerName = layer._name;
			var MC = obj[layerName];
			var ele = MC.ele;
			ele.x = MC.originalX;
			ele.y = MC.originalY;
			ele.width = MC.originalW;
			ele.height = MC.originalH
		}
	}
	return cleanup;
}
var cleanup = initialize();




