extends TextureRect

const ARROW_TEXTURE_HEIGHT = 3
onready var arrowTexture = $Texture
var length
var angle

func setParams(pos1, pos2):
	var diff = pos2 - pos1
	self.length = diff.length()/self.ARROW_TEXTURE_HEIGHT
	var down = Vector2(0, 1)
	var cosAB = diff.dot(down)/(diff.length())
	self.angle = rad2deg(acos(cosAB))
	if pos1.x < pos2.x:
		self.angle *= -1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_size.y = self.length - 24
	self.rect_rotation = self.angle
	
	
	
