extends RichTextLabel


var info_queue: Array[String] = []

# 现在没有一个统一的类型来统一 Actor 和 Player，习惯强类型语言的我有点慌
func handle_killed_info(killed_team_side: Team.Side, killed_name: String, \
		killer_team_side: Team.Side, killer_name: String):
	while info_queue.size() >= 5:
		info_queue.pop_front()
	info_queue.push_back(get_color_bbcode(killer_team_side) + killer_name + "[/color] pistol kill " \
			+ get_color_bbcode(killed_team_side) + killed_name + "[/color]")
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
