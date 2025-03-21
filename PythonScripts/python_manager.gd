extends RefCounted
class_name PythonManager


# this will need to be tinkered with for export
# https://docs.godotengine.org/en/stable/classes/class_projectsettings.html#class-projectsettings-method-globalize-path
static var interpreter_path = ProjectSettings.globalize_path("res://PythonScripts/myvenv/Scripts/python")


static func CallScript(script: String, args: Array=[]):
	var script_path = ProjectSettings.globalize_path("res://PythonScripts/" + script)
	
	var output = []
	var r = OS.execute(interpreter_path, [script_path] + args, output, true, false)
	
	for o in output:
		print(o)
		print("\n")
