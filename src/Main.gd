extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	set_mob()

func set_mob():
	var mob = Mob.instance()
	add_child(mob)
	mob.position = $MobPath/MobSpawnLocation.position
	mob.rotation = set_mob_direction()
	mob.linear_velocity = set_mob_velocity(mob.min_speed, mob.max_speed, mob.rotation)

func set_mob_direction():
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	return direction

func set_mob_velocity(min_speed, max_speed, rotation):
	var linear_velocity = Vector2(rand_range(min_speed, max_speed), 0)
	return linear_velocity.rotated(rotation)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score_label(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_Player_hit():
	game_over()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_game_over()

func _on_HUD_start_game():
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.start_score_label()
