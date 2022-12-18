extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileMap/Paths/AnimationPlayer.play("default")
	$CanvasLayer/MainMenu.connect("request_open_options", self, "_on_options_open")	
	$CanvasLayer/MainMenu.connect("request_close_options", self, "_on_options_close")	
	$CanvasLayer/MainMenu.connect("request_open_controls", self, "_on_controls_open")	
	$CanvasLayer/MainMenu.connect("request_close_controls", self, "_on_controls_close")	
	
	$CanvasLayer/OptionsPanel.connect("darkness_changed", self,"_on_darkness_value_changed")
	$CanvasLayer/OptionsPanel.connect("panel_closed", self,"_on_options_panel_closed")
	$CanvasLayer/ControlsPanel.connect("panel_closed", self,"_on_controls_panel_closed")
	_on_darkness_value_changed(Globals.darkness)


func _on_controls_panel_closed():
	$CanvasLayer/MainMenu.controls_open=false


func _on_options_panel_closed():
	$CanvasLayer/MainMenu.options_open=false

func _on_options_close():
	$CanvasLayer/MainMenu.options_open=false
	$CanvasLayer/OptionsPanel.visible=false
		
func _on_options_open():
	$CanvasLayer/OptionsPanel.visible=true

func _on_controls_close():
	$CanvasLayer/MainMenu.controls_open=false
	$CanvasLayer/ControlsPanel.visible=false
		
func _on_controls_open():
	$CanvasLayer/ControlsPanel.visible=true


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Demo":
		$PlatformTileMap/AnimationPlayer.play("DemoCelebration")
	elif anim_name == "DemoCelebration":
		
		$PlatformTileMap/AnimationPlayer.play("RESET")
		yield(get_tree().create_timer(1),"timeout")
		$PlatformTileMap/AnimationPlayer.play("Demo")	


func _on_darkness_value_changed(new_value:float):
	$Darkness.energy = new_value
