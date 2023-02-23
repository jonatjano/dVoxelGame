module map;

import raylib;
import libs.modlib : BlockType;
import std.conv: to;

struct Block {
	Vector3 pos;
	BlockType* type;
	
	this(Vector3 pos, BlockType* type) {
		this.pos = pos;
		this.type = type;
	}
	
	this(float x, float y, float z, BlockType* type) {
		this(Vector3(x, y, z), type);
	}

	Color color() {
		string text = type.texture.to!string;
		switch(text) {
			case "lightgray": return lightgray;
			case "gray": return gray;
			case "darkgray": return darkgray;
			case "yellow": return yellow;
			case "gold": return gold;
			case "orange": return orange;
			case "pink": return pink;
			case "red": return red;
			case "maroon": return maroon;
			default: return white;
		}
	}
}
