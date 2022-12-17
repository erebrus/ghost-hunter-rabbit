extends Control

const SELECTED_FONT= preload("res://assets/resources/menu_item_selected_font.tres")
const NOT_SELECTED_FONT= preload("res://assets/resources/menu_item_not_selected_font.tres")

enum MenuOption {START,START_RANDOM, MUSIC, QUIT}

onready var menu_items = [$HBoxContainer/VBoxContainer/Standard, $HBoxContainer/VBoxContainer/Random, $HBoxContainer/VBoxContainer/Music, $HBoxContainer/VBoxContainer/Quit]
onready var select_button_sfx = $ButtonSelectAudio
onready var title = $HBoxContainer/Title
var selected_option = 0 
onready var title_pos_ori:Vector2 = title.rect_position
func _ready():
	pass


func _process(delta: float) -> void:
#	title.rect_position = title_pos_ori + Vector2(0,1)*sin(OS.get_ticks_msec()/100)*6
	menu_items[MenuOption.MUSIC].text = "MUSIC: ON" if Globals.music else "MUSIC: OFF"

func update_option(new_option):
	selected_option = clamp(new_option,0, menu_items.size())
	for i in range(menu_items.size()):
		if selected_option==i:
			menu_items[i].set("custom_fonts/font", SELECTED_FONT)	
		else:
			menu_items[i].set("custom_fonts/font", NOT_SELECTED_FONT)	
	select_button_sfx.play()
	
func on_selected_option():
	match selected_option:
		MenuOption.START:
			get_tree().change_scene("res://src/level/Level.tscn")
		MenuOption.START_RANDOM:
			get_tree().change_scene("res://src/level/RandomLevel.tscn")
		MenuOption.MUSIC:
			Globals.toggle_music()
		MenuOption.QUIT:
			get_tree().quit()
			
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_down"):
		update_option(selected_option+1)
	elif Input.is_action_just_pressed("ui_up"):
		update_option(selected_option-1)
	elif Input.is_action_just_pressed("ui_accept"):
		on_selected_option()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		for i in  range(menu_items.size()):
			var item:Control = menu_items[i] as Control
			var bounds = Rect2(item.rect_global_position, item.rect_size)
			if bounds.has_point(event.position) and selected_option != i:
				update_option(i)
				get_tree().get_root().set_input_as_handled()
		return		
	if event is InputEventMouseButton:# and event.button_index == BUTTON_LEFT:
		if event.is_pressed():	
			for i in  range(menu_items.size()):
				var item:Control = menu_items[i] as Control
				var bounds = Rect2(item.rect_global_position, item.rect_size)
				if bounds.has_point(event.position):
					selected_option = i
					on_selected_option()

	

