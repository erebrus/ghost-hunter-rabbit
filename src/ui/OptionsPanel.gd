extends Panel
signal darkness_changed(value)
signal sfx_changed(value)
signal music_changed(value)
signal master_changed(value)

signal panel_closed()

func _ready():
	$MarginContainer/VBoxContainer/GridContainer/AlphaSlider/HSlider.value = Globals.darkness
func _on_Close_pressed():
	emit_signal("panel_closed")
	visible=false


func _on_darkness_value_changed(value):
	Globals.darkness = value
	emit_signal("darkness_changed", value)


func _on_sfx_value_changed(value):
	emit_signal("sfx_changed", value)


func _on_music_value_changed(value):
	emit_signal("music_changed", value)


func _on_master_value_changed(value):
	emit_signal("master_changed", value)
