class_name MySimSQL


class IdGenerator extends RefCounted:
	var id: int = 0
	
	
	func next() -> int:
		id += 1
		return id
	
	
	func reset() -> void:
		id = 0


class DataObj extends RefCounted:
	var id: int


class EnumDO extends DataObj:
	# 类型枚举键名
	var enum_name: String
	# 类型枚举值
	var enum_val: int
	# 视图层名字
	var view_name: String


class Table extends RefCounted:
	var id_gen := IdGenerator.new()
	var id_index : Dictionary = {}
	var indexes: Dictionary = {}
	var elem_type: Variant
	
	
	func create_index(index: Index) -> void:
		indexes[index.name] = index
	
	
	func insert(d: DataObj) -> void:
		if not is_instance_of(d, elem_type):
			printerr("Table inserting wrong type elem")
			return
		d.id = id_gen.next()
		id_index[d.id] = d
		for index in indexes.values():
			index.add(d)
	
	
	func delete_by_id(id: int) -> void:
		if not id_index.has(id):
			return
		var d: DataObj = id_index[id]
		id_index.erase(id)
		for index in indexes.values():
			index.remove(d)
	
	
	func truncate() -> void:
		id_gen.reset()
		id_index.clear()
		for index in indexes.values():
			index.clear()
	
	
	func update_by_id(d: DataObj) -> void:
		# TODO: 目前是全量重写，没办法做到细分到字段的更新
		var pre: DataObj = query_by_id(d.id)
		for index in indexes.values():
			index.remove(pre)
		id_index[d.id] = d
		for index in indexes.values():
			index.add(d)
	
	
	func update_field_by_id(id: int, field: String, val: Variant) -> void:
		var do: DataObj = query_by_id(id)
		if indexes.has(field):
			var index: Index = indexes[field]
			index.remove(do)
		do.set(field, val)
		if indexes.has(field):
			var index: Index = indexes[field]
			index.add(do)
	
	
	func query_by_id(id: int) -> DataObj:
		return id_index.get(id)
	
	
	func query_all() -> Array:
		return id_index.values()
	
	
	func select_arr(qw: QueryWrapper = null) -> Array:
		if qw == null:
			return query_all()
		var result: Array
		if qw.where_arr.is_empty():
			result = query_all()
		else:
			# 目前 where 里只有 eq 条件（=）
			for w in qw.where_arr:
				if indexes.has(w.field):
					result = indexes[w.field].get_do(w.val)
					break
			if result == null:
				result = query_all()
			# TODO: 效率可能会很低，所以目前需要注意把可以快速缩小范围的索引字段的 eq 放前面
			for w in qw.where_arr:
				result = result.filter(func(e): return e.get(w.field) == w.val)
		
		if not qw.order_arr.is_empty():
			# 相等的排序不稳定
			result.sort_custom(
				func(a, b):
					for o in qw.order_arr:
						if (o.desc and a.get(o.field) > b.get(o.field)) \
								or (not o.desc and a.get(o.field) < b.get(o.field)):
							return true
					return false)
		return result


class EnumTable extends Table:
	var enum_name_index := MySimSQL.Index.new("enum_name", MySimSQL.Index.Type.UNIQUE)
	var enum_val_index := MySimSQL.Index.new("enum_val", MySimSQL.Index.Type.UNIQUE)
	
	
	func _init() -> void:
		create_index(enum_name_index)
		create_index(enum_val_index)
	
	
	static func id_to_enum_val(id: int) -> int:
		return id - 1
	
	
	static func enum_val_to_id(enum_val: int) -> int:
		return enum_val + 1
	
	
	func init_insert(d: EnumDO) -> void:
		super.insert(d)
	
	
	func insert(d: DataObj) -> void:
		printerr("this is a enum table, can't insert")
		return
	
	
	func delete_by_id(id: int) -> void:
		printerr("this is a enum table, can't delete")
	
	
	func truncate() -> void:
		printerr("this is a enum table, can't truncate")
	
	
	func update_by_id(d: DataObj) -> void:
		printerr("this is a enum table, can't update")
	
	
	func update_field_by_id(id: int, field: String, val: Variant) -> void:
		printerr("this is a enum table, can't update")
	
	
	func query_by_enum_name(enum_name: String) -> EnumDO:
		return enum_name_index.get_do(enum_name)[0] as EnumDO
	
	
	func query_by_enum_val(enum_val: int) -> EnumDO:
		return enum_val_index.get_do(enum_val)[0] as EnumDO


class Index extends RefCounted:
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
					printerr("MySimSQL | unique index: ", name, " found a collision ", col)
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
	
	
	func clear() -> void:
		dict.clear()
	
	
	func get_do(col: Variant) -> Array:
		if type == Type.NORMAL:
			return dict.get(col, [])
		else:
			return [dict.get(col)]


class QueryWrapper extends RefCounted:
	var where_arr: Array[Where] = []
	var order_arr: Array[Order] = []
	
	
	func eq(field: String, val: Variant) -> QueryWrapper:
		where_arr.append(Where.new(field, "=", val))
		return self
	
	
	func order_by_asc(field: String) -> QueryWrapper:
		order_arr.append(Order.new(field, false))
		return self
	
	
	func order_by_desc(field: String) -> QueryWrapper:
		order_arr.append(Order.new(field, true))
		return self


class Where extends RefCounted:
	# 字段名
	var field: String
	# 操作符
	var op: String
	# 条件入参
	var val: Variant
	
	
	func _init(field: String, op: String, val: Variant) -> void:
		self.field = field
		self.op = op
		self.val = val


class Order extends RefCounted:
	# 字段名
	var field: String
	# 是否降序
	var desc: bool
	
	
	func _init(field: String, desc: bool) -> void:
		self.field = field
		self.desc = desc

