extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func _on_MobTimer_timeout():
	var mob = Mob.instance()
	var direction = set_direction()
	set_mob_attributes(mob, direction)

func set_mob_attributes(mob, direction):
	add_child(mob)
	set_mob_random_spawn_location(mob)
	set_mob_direction(mob, direction)
	set_mob_velocity(mob, direction)

func set_mob_random_spawn_location(mob):
	$MobPath/MobSpawnLocation.offset = randi()
	mob.position = $MobPath/MobSpawnLocation.position

func set_direction():
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	return direction

func set_mob_direction(mob, direction):
	mob.rotation = direction

func set_mob_velocity(mob, direction):
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

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
