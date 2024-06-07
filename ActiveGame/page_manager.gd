extends Control
class_name PageManager


var current_page: Control


func RenderHome():
	ClearPages()
	$Home.Activate()


func RenderPage(page: Page, id):
	ClearPages()
	print("Rendering Page: ", page)
	current_page = page
	page.Activate(id)


func RenderEvent(page: EventPage, event: CalendarEvent):
	ClearPages()
	print("Rendering Event: ", page)
	current_page = page
	page.Activate(event)


func ClearPages():
	for p in get_children():
		if p.name == "Home":
			p.hide()
		else:
			p.Close()


func CompleteEvent(page: EventPage):
	page.Close()
