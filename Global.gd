extends Node

var max_lives := 3
var lives := 3
var has_key = false
var level: int = 1

func reset_lives():
	lives = max_lives
