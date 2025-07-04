extends Panel


var TableRow = preload("res://ActiveGame/UI/Widgets/Table/table_row.tscn")
var TableCell = preload("res://ActiveGame/UI/Widgets/Table/table_cell.tscn")


signal cell_clicked(meta)
signal row_hovered(row_id: int)


var data: DataFrame


func Render(formatting: Dictionary = {}):
	for n in $Scroll/Rows.get_children():
		n.queue_free()
	
	if data:
		var row_count = data.Size()
		var col_count = data.NumColumns()
		
		var header = TableRow.instantiate()
		for c in data.GetColumns():
			var cell = TableCell.instantiate()
			cell.get_node("RichTextLabel").text = c
			header.add_child(cell)
		$Scroll/Rows.add_child(header)
		
		$Scroll/Rows.add_child(HSeparator.new())
		
		for r in row_count:
			var row = TableRow.instantiate()
			$Scroll/Rows.add_child(row)
			
			for c in range(col_count):
				var col_name = data.GetColumns()[c]
				
				var value = data.GetRow(r)[c]
				var cell = TableCell.instantiate()
				
				if col_name in formatting:
					var col_name_meta = "_tablemeta_" + col_name
					var metastr = ""
					if col_name_meta in data.columns:
						metastr = "=%s" % data.GetColumn(col_name_meta)[r]
						
					var prefix = "[%s%s]" % [formatting[col_name], metastr]
					var suffix = "[/%s]" % formatting[col_name]
					cell.get_node("RichTextLabel").text = prefix + str(value) + suffix
				else:
					cell.get_node("RichTextLabel").text = str(value)
				
				row.add_child(cell)
				cell.get_node("RichTextLabel").meta_clicked.connect(_on_url_cell_clicked)
			
			row.mouse_entered.connect(_on_hover_row.bind(r))


func _on_url_cell_clicked(meta):
	cell_clicked.emit(meta)


func _on_hover_row(row_id: int):
	row_hovered.emit(row_id)
