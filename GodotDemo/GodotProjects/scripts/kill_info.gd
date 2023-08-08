extends RichTextLabel


var info_queue: Array[String] = []

func handle_actor_killed(killed: Actor, killer: Actor):
	while info_queue.size() >= 5:
		info_queue.pop_front()
	info_queue.push_back(get_color_bbcode(killer.team.side) + killer.name + "[/color] pistol kill " \
			+ get_color_bbcode(killed.team.side) + killed.name + "[/color]")
	# 刷新显示内容
	text = ""
	for s in info_queue:
		if text != "":
			text += "\n"
		text += s


func get_color_bbcode(side: Team.Side) -> String:
	match (side):
		Team.Side.ENEMY:
			return "[color=red]"
		Team.Side.PLAYER:
			return "[color=green]"
		_:
			return "[color=grey]"
