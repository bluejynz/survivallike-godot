extends Node2D

var value: int = 0

func _ready():
	%DamageDigitLabel.text = str(value)
