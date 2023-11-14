class_name MySimSQL


class IdGenerator:
	var id: int = 0
	
	
	func next() -> int:
		id += 1
		return id


class DataObj:
	var id: int


class EnumDO extends DataObj:
	# 类型枚举键名
	var enum_name: String
	# 类型枚举值
	var enum_val: int
	# 视图层名字
	var view_name: String


class Table:
	var id_gen := IdGenerator.new()
	var id_index : Dictionary = {}
	var indexes: Array[Index] = []
	var elem_type: Variant
	
	
	func create_index(index: Index) -> void:
		indexes.append(index)
	
	
	func insert(d: DataObj) -> void:
		if not is_instance_of(d, elem_type):
			printerr("Table inserting wrong type elem")
			return
		d.id = id_gen.next()
		id_index[d.id] = d
		for index in indexes:
			index.add(d)
	
	
	func delete_by_id(id: int) -> void:
		if not id_index.has(id):
			return
		var d: DataObj = id_index[id]
		id_index.erase(id)
		for index in indexes:
			index.remove(d)
	
	
	func query_by_id(id: int) -> DataObj:
		return id_index.get(id)


class EnumTable extends Table:
	var enum_name_index := MySimSQL.Index.new("enum_name", MySimSQL.Index.Type.UNIQUE)
	var enum_val_index := MySimSQL.Index.new("enum_val", MySimSQL.Index.Type.UNIQUE)
	
	
	func _init() -> void:
		create_index(enum_name_index)
		create_index(enum_val_index)
	
	
	func init_insert(d: DataObj) -> void:
		super.insert(d)
	
	
	func insert(d: DataObj) -> void:
		printerr("this is a enum table, can't insert")
	
	
	func delete_by_id(id: int) -> void:
		printerr("this is a enum table, can't delete")


class Index:
	enum Type {
		UNIQUE, # 唯一
		NORMAL, # 普通
	}
	
	var dict: Dictionary = {}
	var name: String
	var type: Type
	
	
	func _init(name: String, type: Type) -> void:
		self.name = name
		self.type = type
	
	
	func add(elem: DataObj) -> void:
		var col = elem.get(name)
		match type:
			Type.NORMAL:
				if not dict.has(col):
					dict[col] = []
				dict[col].append(elem)
			Type.UNIQUE:
				if dict.has(col):
					printerr("MySimSQL | unique index: ", name, " found a collision")
					return
				dict[col] = elem
	
	
	func remove(elem: DataObj) -> void:
		var col = elem.get(name)
		match type:
			Type.NORMAL:
				if dict.has(col):
					dict[col].erase(elem)
					if dict[col].is_empty():
						dict.erase(col)
			Type.UNIQUE:
				if dict.has(col):
					dict.erase(col)
	
	
	func get_do(col: Variant) -> DataObj:
		return dict.get(col)
