extends Node

signal game_over

enum GameLogLevel {INFO, WARNING, ALERT}

const COLOR1 = Color("#EDBE1F")
const COLOR2 = Color("#5E20A0")
const COLOR3 = Color("#1E5B9A")


var master_volume:float = 100
var music_volume:float = 100
var sfx_volume:float = 100
var darkness:float = .90

var use_controller:=false

func _ready():
	_init_logger()	

func _init_logger():
	Logger.set_logger_level(Logger.LOG_LEVEL_INFO)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var console_appender:Appender = Logger.add_appender(ConsoleAppender.new())
	console_appender.logger_format=Logger.LOG_FORMAT_FULL
	console_appender.logger_level = Logger.LOG_LEVEL_INFO
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_DEBUG


func get_world():
	return get_node("/root/Level")
func get_player():
	return get_world().get_node("%Player")
	

