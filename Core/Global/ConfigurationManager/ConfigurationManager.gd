extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
## TODO
enum OperativeSystem {
	## TODO
	UNKNOWN,
	## TODO
	WINDOWS,
	## TODO
	MAC_OS,
	## TODO
	LINUX,
	## TODO
	ANDROID,
	## TODO
	IOS,
	## TODO
	WEB,
}
#endregion Enums

#region Constants
## TODO
const DEFAULT_GAMEPLAY_LAYER : int = 1
## TODO
const CURSOR_LAYER           : int = 2
## TODO
const VFX_LAYER              : int = 3

## TODO
const CURSOR_ICON_SIZE : int = 20
#endregion Constants

#region Exports Variables
## TODO
@export var cursor_texture : Texture2D
## TODO
@export var simulated_cursor : bool = true
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _empty_texture : Texture2D = get_transparent_texture(CURSOR_ICON_SIZE, CURSOR_ICON_SIZE)
#endregion Private Variables

#region On Ready Variables
@onready var _cursor_layer : CanvasLayer = %CursorLayer
@onready var _cursor       : Sprite2D    = %Cursor
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("VFXLayer"):
		assert(node is CanvasLayer)
		if get_operative_system() != OperativeSystem.WEB:
			node.layer = VFX_LAYER
		else:
			node.queue_free()
	
	if simulated_cursor and get_operative_system() != OperativeSystem.WEB:
		_cursor.texture = get_resized_texture(cursor_texture, CURSOR_ICON_SIZE, CURSOR_ICON_SIZE)
		_cursor_layer.layer = CURSOR_LAYER
		Input.set_custom_mouse_cursor(_empty_texture, Input.CURSOR_ARROW)
		process_mode = ProcessMode.PROCESS_MODE_INHERIT
	else:
		_cursor_layer.queue_free()
		process_mode = ProcessMode.PROCESS_MODE_DISABLED

func _process(_delta : float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	_cursor.global_position = mouse_position + Vector2.ONE * CURSOR_ICON_SIZE * 0.5
#endregion Built-in Virtual Methods

#region Public Methods
## Returns the current operative system
func get_operative_system() -> OperativeSystem:
	match OS.get_name():
		"Windows":
			return OperativeSystem.WINDOWS
		"macOS":
			return OperativeSystem.MAC_OS
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			return OperativeSystem.LINUX
		"Android":
			return OperativeSystem.ANDROID
		"iOS":
			return OperativeSystem.IOS
		"Web":
			return OperativeSystem.WEB
		_:
			return OperativeSystem.UNKNOWN

## Returns a [Texture2D] with the same content as the given texture, but different
## dimensions.
func get_resized_texture(original_texture : Texture2D, width : int, height : int) -> Texture2D:
	var image : Image = original_texture.get_image()
	image.resize(width, height, Image.INTERPOLATE_BILINEAR)
	
	return ImageTexture.create_from_image(image)

## Returns a transparent [Texture2D].
func get_transparent_texture(width : int, height : int) -> Texture2D:
	var image : Image = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	return ImageTexture.create_from_image(image)
#endregion Public Methods

#region Private Methods
#endregion Private Methods
