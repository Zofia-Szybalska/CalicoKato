extends Control

func _ready():
	var count = "%s /%s"
	$CatnipCountLapel.text = count % [Global.coins, Global.max_coins]
	if Global.coins >= Global.max_coins:
		$CatnipCommentLabel.text = "Wow! That's all of them!"
	elif Global.coins == 0:
		$CatnipCommentLabel.text = "You haven't find any? You can always try again, good luck!"
	elif Global.coins < Global.max_coins/2:
		$CatnipCommentLabel.text = "You haven't even found half of them, there is a lot more to look for!"
	elif Global.coins > Global.max_coins/2:
		$CatnipCommentLabel.text = "You collected more than half, can you find them all next time?"
	else:
		$CatnipCommentLabel.text = "You found half of them, not that bad, but will you look for other half?"
