extends Node2D

export var off = false

func _ready():
	if(!off):
		$AnimationPlayer.play("strobe")

func activate():
	$AnimationPlayer.play("strobe")