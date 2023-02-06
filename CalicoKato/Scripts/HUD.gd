extends CanvasLayer

var coins = 0
onready var key = $Key
onready var exitKey = $ExitKey
var keys := 0
var hasExitKey := false

func _ready():
	Global.hud = self
	load_hearts()
	$Coins.text = String(Global.coins + coins)
	$Keys.text = String(keys)

func _on_coin_collected():
	coins += 1
	_ready()

func load_hearts():
	$HeartsFull.rect_size.x = Global.lives*53
	$HeartsEmpty.rect_size.x = (Global.max_lives - Global.lives)*53
	$HeartsEmpty.rect_position.x = $HeartsFull.rect_position.x + $HeartsFull.rect_size.x * $HeartsFull.rect_scale.x

