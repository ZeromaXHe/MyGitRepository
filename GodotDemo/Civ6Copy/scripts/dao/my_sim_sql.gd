class_name MySimSQL


class IdGenerator:
	var id: int = 0
	
	
	func next() -> int:
		id += 1
		return id


class DataObj:
	var id: int


class Table:
	var id_gen := IdGenerator.new()
	var id_index : Dictionary = {}
	var indexes: Array[Index] = []
	
	
	func create_index(index: Index) -> void:
		indexes.append(index)
	
	
	func insert(d: DataObj) -> void:
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


class Index:
	enum Type {
		UNIQUE, # 唯一
		NORMAL, # 普通
	}
	
	var dict: Dictionary = {}
	var name: String
	var type: Type
	var col_getter: Callable
	
	
	func _init(name: String, type: Type, col_getter: Callable) -> void:
		self.type = type
		self.col_getter = col_getter
	
	
	func add(elem: DataObj) -> void:
		var col = col_getter.call(elem)
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
		var col = col_getter.call(elem)
		match type:
			Type.NORMAL:
				if dict.has(col):
					dict[col].erase(elem)
					if dict[col].is_empty():
						dict.erase(col)
			Type.UNIQUE:
				if dict.has(col):
					dict.erase(col)
