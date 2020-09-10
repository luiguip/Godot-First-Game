extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()

func show_temporary_message(text):
	show_message(text)
	$MessageTimer.start()

func show_game_over():
	show_temporary_message("Game Over")
	yield($MessageTimer, "timeout")
	show_message("Dodge the \nCreeps!")
	$StartButtonTimer.start()

func start_score_label():
	$ScoreLabel.text = str(0)
	show_temporary_message("Get Ready!")
	

func update_score_label(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButtonTimer_timeout():
	$StartButton.show()
