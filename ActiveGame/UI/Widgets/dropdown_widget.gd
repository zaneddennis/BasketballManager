extends OptionButton


var options: Array
var metas: Array


func Activate(options: Array, metas: Array = []):
	if metas:
		assert(len(options) == len(metas))
	
	self.options = options
	if metas:
		self.metas = metas
	
	clear()
	for i in range(len(options)):
		add_item(options[i])
		if metas:
			set_item_metadata(i, metas[i])


func SelectOption(option: String):
	var ix = options.find(option)
	assert(ix != -1)
	select(ix)

func SelectOptionByMeta(meta):
	var ix = metas.find(meta)
	assert(ix != -1)
	select(ix)


func GetSelectedOption():
	var ix = get_selected_id()
	return get_item_text(ix)
