extends Control

func _ready() :
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	$Click.play()
	get_tree().change_scene_to_file("res://world.tscn")


func _on_options_button_pressed() -> void:
	$Click.play()
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	$Click.play()
	get_tree().quit()


func _on_start_button_mouse_entered() -> void:
	$Hover.play()
	pass # Replace with function body.


func _on_options_button_mouse_entered() -> void:
	$Hover.play()
	pass # Replace with function body.


func _on_exit_button_mouse_entered() -> void:
	$Hover.play()
	pass # Replace with function body.
