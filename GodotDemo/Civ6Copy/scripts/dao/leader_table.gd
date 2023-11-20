class_name LeaderTable
extends MySimSQL.EnumTable


enum Enum {
	ABRAHAM_LINCOLN, # 亚伯拉罕·林肯
	ALEXANDER, # 亚历山大
	AMANITORE, # 阿曼尼托尔
	AMBIORIX, # 安比奥里克斯
	BARBAROSSA, # 弗雷德里克·巴巴罗萨
	BASIL, # 巴兹尔二世
	CATHERINE_DE_MERCI, # 凯瑟琳·德·美第奇（黑皇后）
	CATHERINE_DE_MERCI_ALT, # 凯瑟琳·德·美第奇（寻欢作乐）
	CLEOPATRA, # 克利欧佩特拉（埃及）
	CLEOPATRA_ALT, # 克利欧佩特拉（托勒密）
	CYRUS, # 居鲁士
	ELIZABETH, # 伊丽莎白一世
	GANDHI, # 甘地
	GILGAMESH, # 吉尔伽美什
	GITARJA, # 特丽布瓦娜
	GORGO, # 戈尔戈
	HAMMURABI, # 汉谟拉比
	HARALD_ALT, # 哈拉尔德·哈德拉达（瓦良格）
	HARDRADA, # 哈拉尔德·哈德拉达(北境王)
	HOJO, # 北条时宗
	JADWIGA, # 雅德维加
	JAYAVARMAN, # 阇耶跋摩七世
	JOAO_III, # 若昂三世
	JOHN_CURTIN, # 约翰·科廷
	KUBLAI_KHAN_CHINA, # 忽必烈（中国）
	LADY_SIX_SKY, # 六日夫人
	LADY_TRIEU, # 赵夫人
	LUDWIG, # 路德维希二世
	MENELIK, # 孟尼利克二世
	MONTEZUMA, # 蒙特祖马
	MVEMBA, # 姆本巴·恩津加
	NADER_SHAH, # 纳迪尔沙阿
	NZINGA_MBANDE, # 恩津加·姆班德
	PEDRO, # 佩德罗二世
	PERICLES, # 伯里克利
	PETER_GREAT, # 彼得
	PHILIP_II, # 菲利普二世
	QIN_ALT, # 秦始皇（大一统）
	QIN, # 秦始皇（天命者）
	RAMSES, # 拉美西斯二世
	SALADIN_ALT, # 萨拉丁（苏丹）
	SALADIN, # 萨拉丁（维齐尔）
	SIMON_BOLIVAR, # 西蒙·玻利瓦尔
	T_ROOSEVELT, # 泰迪·罗斯福（进步党）
	T_ROOSEVELT_ROUGHRIDER, # 泰迪·罗斯福（莽骑兵）
	THEODORA, # 狄奥多拉
	TOKUGAWA, # 德川家康
	TOMYRIS, # 托米丽司
	TRAJAN, # 图拉真
	VICTORIA, # 维多利亚（帝国时代）
	VICTORIA_ALT, # 维多利亚（蒸汽时代）
	WU_ZETIAN, # 武则天
	YONGLE, # 永乐皇帝
	YULIUS_CAESAR, # 尤利乌斯·凯撒
}


var civ_index := MySimSQL.Index.new("civ", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	super._init()
	elem_type = LeaderDO
	create_index(civ_index)
	
	for k in Enum.keys():
		var do = LeaderDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.ABRAHAM_LINCOLN:
				do.view_name = "亚伯拉罕·林肯"
				do.civ = CivTable.Enum.AMERICA
				do.quotation = "人之所以存在，其责任不仅在于改善自身状况，而且要帮助改善人类；我支持为多数人带来最大益处的方法。"
			Enum.ALEXANDER:
				do.view_name = "亚历山大"
				do.civ = CivTable.Enum.MACEDON
				do.quotation = "绵羊领导的狮群不足为惧，真正让人恐惧的是狮子领导的羊群。"
			Enum.AMANITORE:
				do.view_name = "阿曼尼托尔"
				do.civ = CivTable.Enum.NUBIA
				do.quotation = "提供土地上不产出的东西，人民便会对你感恩戴德。"
			Enum.AMBIORIX:
				do.view_name = "安比奥里克斯"
				do.civ = CivTable.Enum.GAUL
				do.quotation = "来吧，我的敌人，派出你的使者。因为我有个使我们双方受益的提议。"
			Enum.BARBAROSSA:
				do.view_name = "弗雷德里克·巴巴罗萨"
				do.civ = CivTable.Enum.GERMANY
				do.quotation = "德国的威力会永远持续下去。"
			Enum.BASIL:
				do.view_name = "巴兹尔二世"
				do.civ = CivTable.Enum.BYZANTIUM
				do.quotation = "我是保加利亚杀手巴兹尔。"
			Enum.CATHERINE_DE_MERCI:
				do.view_name = "凯瑟琳·德·美第奇（黑皇后）"
				do.civ = CivTable.Enum.FRANCE
				do.quotation = "丰收后，你必须马上播种。"
			Enum.CATHERINE_DE_MERCI:
				do.view_name = "凯瑟琳·德·美第奇（寻欢作乐）"
				do.civ = CivTable.Enum.FRANCE
				do.quotation = "我们的文化有着独特的生活之美。它的魅力无可抗拒。"
			Enum.CLEOPATRA:
				do.view_name = "克利欧佩特拉（埃及）"
				do.civ = CivTable.Enum.EGYPT
				do.quotation = "永恒存在于眼睛和嘴唇。"
			Enum.CLEOPATRA_ALT:
				do.view_name = "克利欧佩特拉（托勒密）"
				do.civ = CivTable.Enum.EGYPT
				do.quotation = "我们欢迎那些诡异而恐怖的场面，但鄙视安逸。"
			Enum.CYRUS:
				do.view_name = "居鲁士"
				do.civ = CivTable.Enum.PERSIA
				do.quotation = "不要因为敌人的诋毁而心烦意乱，也不要因为盟友的称赞而蒙蔽双眼。除了自己，谁也无法信任。"
			Enum.ELIZABETH:
				do.view_name = "伊丽莎白一世"
				do.civ = CivTable.Enum.ENGLAND
				do.quotation = "在这举世瞩目的舞台上，我们统治天下。"
			Enum.GANDHI:
				do.view_name = "甘地"
				do.civ = CivTable.Enum.INDIA
				do.quotation = "活着，像你明天即将死去一样；学习，像你永不遭遇死亡一样。"
			Enum.GILGAMESH:
				do.view_name = "吉尔伽美什"
				do.civ = CivTable.Enum.SUMERIA
				do.quotation = "说话文艺便可呤诗诵词；说话刻薄便会招来麻烦；说话动听便会芳香环绕。"
			Enum.GITARJA:
				do.view_name = "特丽布瓦娜"
				do.civ = CivTable.Enum.INDONESIA
				do.quotation = "土地不足时便扬帆远航。海洋将带来更多土地。"
			Enum.GORGO:
				do.view_name = "戈尔戈"
				do.civ = CivTable.Enum.GREECE
				do.quotation = "防守森严的城市用男人而不是用砖头做城墙。"
			Enum.HAMMURABI:
				do.view_name = "汉谟拉比"
				do.civ = CivTable.Enum.BABYLON
				do.quotation = "为了在这片土地上实现正义的统治，安努和柏尔为我起名汉谟拉比，意为尊贵而虔诚的王子。"
			Enum.HARALD_ALT:
				do.view_name = "哈拉尔德·哈德拉达（瓦良格）"
				do.civ = CivTable.Enum.NORWAY
				do.quotation = "高举旗帜之人必将取得胜利。"
			Enum.HARDRADA:
				do.view_name = "哈拉尔德·哈德拉达(北境王)"
				do.civ = CivTable.Enum.NORWAY
				do.quotation = "在国家分裂前，他必须取得胜利。"
			Enum.HOJO:
				do.view_name = "北条时宗"
				do.civ = CivTable.Enum.JAPAN
				do.quotation = "战士活着的唯一目的是战斗，而战斗的唯一目的是获胜。"
			Enum.JADWIGA:
				do.view_name = "雅德维加"
				do.civ = CivTable.Enum.POLAND
				do.quotation = "侍奉上帝的人会拥有一个好的领导者。"
			Enum.JAYAVARMAN:
				do.view_name = "阇耶跋摩七世"
				do.civ = CivTable.Enum.KHMER
				do.quotation = "身为国王就必须为人民带来福祉，碌碌无为则不可取。"
			Enum.JOAO_III:
				do.view_name = "若昂三世"
				do.civ = CivTable.Enum.PORTUGAL
				do.quotation = "我是多姆·若昂，蒙主恩典的葡萄牙和阿尔加维国王，以及海外诸地、非洲几内亚的领主。我是征服与探索之王，与埃塞俄比亚、阿拉伯、波斯和印度亦有贸易往来。"
			Enum.JOHN_CURTIN:
				do.view_name = "约翰·科廷"
				do.civ = CivTable.Enum.AUSTRALIA
				do.quotation = "我认为现在澳大利亚人民非常热爱祖国。在我国之前的历史中，没有任何一个时期有如此高的爱国热情。"
			Enum.KUBLAI_KHAN_CHINA:
				do.view_name = "忽必烈（中国）"
				do.civ = CivTable.Enum.CHINA
				do.quotation = "冀自今以往，通问结好，以相亲睦。且圣人以四海为家，不相通好，岂一家之理哉。"
			Enum.LADY_SIX_SKY:
				do.view_name = "六日夫人"
				do.civ = CivTable.Enum.MAYA
				do.quotation = "我是战无不胜的六日夫人。敌人将悉数跪在我脚下。"
			Enum.LADY_TRIEU:
				do.view_name = "赵夫人"
				do.civ = CivTable.Enum.VIETNAM
				do.quotation = "我欲乘劲风踏恶浪，斩杀东海巨蛟，光复河山，拯救人民于水火之中。"
			Enum.LUDWIG:
				do.view_name = "路德维希二世"
				do.civ = CivTable.Enum.GERMANY
				do.quotation = "我希望成为自己和他人的永恒之谜。"
			Enum.MENELIK:
				do.view_name = "孟尼利克二世"
				do.civ = CivTable.Enum.ETHIOPIA
				do.quotation = "如果远方的列强想来瓜分非洲，我绝不会袖手旁观。"
			Enum.MONTEZUMA:
				do.view_name = "蒙特祖马"
				do.civ = CivTable.Enum.AZTEC
				do.quotation = "初生的太阳并不热；只有当它按照轨迹向前行进一段时间后，它才会变热。"
			Enum.MVEMBA:
				do.view_name = "姆本巴·恩津加"
				do.civ = CivTable.Enum.KONGO
				do.quotation = "善行是好屏障"
			Enum.NADER_SHAH:
				do.view_name = "纳迪尔沙阿"
				do.civ = CivTable.Enum.PERSIA
				do.quotation = "如果天堂里没有战争，那怎么可能有快乐呢？"
			Enum.NZINGA_MBANDE:
				do.view_name = "恩津加·姆班德"
				do.civ = CivTable.Enum.KONGO
				do.quotation = "碰碰运气，看命运会将你带往何方。"
			Enum.PEDRO:
				do.view_name = "佩德罗二世"
				do.civ = CivTable.Enum.BRAZIL
				do.quotation = "就我所知，没有任何一项任务比塑造青年思想、打造未来栋梁之才更高尚。"
			Enum.PERICLES:
				do.view_name = "伯里克利"
				do.civ = CivTable.Enum.GREECE
				do.quotation = "你对政治不感兴趣并不意味着政治对你不感兴趣。"
			Enum.PETER_GREAT:
				do.view_name = "彼得"
				do.civ = CivTable.Enum.RUSSIA
				do.quotation = "请记住要让你的臣民吃饱。承诺和希望无法填饱士兵的肚子。"
			Enum.PHILIP_II:
				do.view_name = "菲利普二世"
				do.civ = CivTable.Enum.SPAIN
				do.quotation = "终有一天，我能看到世界地图，但它将不再成为世界的地图。它会是西班牙的地图。"
			Enum.QIN_ALT:
				do.view_name = "秦始皇（大一统）"
				do.civ = CivTable.Enum.CHINA
				do.quotation = "寡人尽收天下之书，其不重于用者，皆焚之。"
			Enum.QIN:
				do.view_name = "秦始皇（天命者）"
				do.civ = CivTable.Enum.CHINA
				do.quotation = "天下汹汹之大乱，皆由于封建。寡人其将一之。"
			Enum.RAMSES:
				do.view_name = "拉美西斯二世"
				do.civ = CivTable.Enum.EGYPT
				do.quotation = "我被赐予的麦粒堪比沙海，建筑直达天国，谷堆也堆积如山。"
			Enum.SALADIN_ALT:
				do.view_name = "萨拉丁（苏丹）"
				do.civ = CivTable.Enum.ARABIA
				do.quotation = "真主决定之事必将完成。"
			Enum.SALADIN:
				do.view_name = "萨拉丁（维齐尔）"
				do.civ = CivTable.Enum.ARABIA
				do.quotation = "战争决定于预先准备、人数和真主的意愿。"
			Enum.SIMON_BOLIVAR:
				do.view_name = "西蒙·玻利瓦尔"
				do.civ = CivTable.Enum.GRAN_COLOMBIA
				do.quotation = "胸怀天下之人总是心系人民，并帮助他们努力争取造物主和大自然所赋予的权利。"
			Enum.T_ROOSEVELT:
				do.view_name = "泰迪·罗斯福（进步党）"
				do.civ = CivTable.Enum.AMERICA
				do.quotation = "我们要为子孙后代留下更美好的未来。"
			Enum.T_ROOSEVELT_ROUGHRIDER:
				do.view_name = "泰迪·罗斯福（莽骑兵）"
				do.civ = CivTable.Enum.AMERICA
				do.quotation = "美国精神指的是勇气、荣誉、公正、真理、真诚、乐观这样的美德——所有这些造就了美国。"
			Enum.THEODORA:
				do.view_name = "狄奥多拉"
				do.civ = CivTable.Enum.BYZANTIUM
				do.quotation = "宝座是荣耀的坟墓。"
			Enum.TOKUGAWA:
				do.view_name = "德川家康"
				do.civ = CivTable.Enum.JAPAN
				do.quotation = "我认为我可以比现在更强大，但长久的毅力成就了今天的我。如果后代想成为我这样的人，那就必须学会忍耐。"
			Enum.TOMYRIS:
				do.view_name = "托米丽司"
				do.civ = CivTable.Enum.SCYTHIA
				do.quotation = "斯基泰斗篷为我衣，粗糙脚底为我鞋，大地为我床，饥饿让我的食物更加鲜美。"
			Enum.TRAJAN:
				do.view_name = "图拉真"
				do.civ = CivTable.Enum.ROME
				do.quotation = "分而治之；各个击破！"
			Enum.VICTORIA:
				do.view_name = "维多利亚（帝国时代）"
				do.civ = CivTable.Enum.ENGLAND
				do.quotation = "不要让别人发现你短暂不快的情绪（非常自然和常见的情绪）和不安。"
			Enum.VICTORIA_ALT:
				do.view_name = "维多利亚（蒸汽时代）"
				do.civ = CivTable.Enum.ENGLAND
				do.quotation = "面对重大事件我安静镇定，只有鸡毛蒜皮才让人心烦。"
			Enum.WU_ZETIAN:
				do.view_name = "武则天"
				do.civ = CivTable.Enum.CHINA
				do.quotation = "死者不可复生，此天命也。 然存者犹继之而行，唯此为重。"
			Enum.YONGLE:
				do.view_name = "永乐皇帝"
				do.civ = CivTable.Enum.CHINA
				do.quotation = "诸国多以人君不恤民事，而毁之也。"
			Enum.YULIUS_CAESAR:
				do.view_name = "尤利乌斯·凯撒"
				do.civ = CivTable.Enum.ROME
				do.quotation = "我来，我见，我征服。"
		super.init_insert(do)


func query_by_civ(civ: CivTable.Enum) -> LeaderDO:
	return civ_index.get_do(civ)[0] as LeaderDO
