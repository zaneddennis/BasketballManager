extends Object
class_name ColorsUtil


const PALLETTE = {
	"blue": [
		Color("b3b3d3"), Color("6767a1"), Color("343477"), Color("11114d"), Color("030322")
	],
	"green": [
		Color("030322"), Color("bad87c"), Color("7d9f35"), Color("486609"), Color("1f2e00")
	],
	"red": [
		Color("ffd2d1"), Color("e78785"), Color("aa3c39"), Color("6d0c0a"), Color("310100")
	],
	"gold": [
		Color("fff3d1"), Color("e7ce85"), Color("aa8e39"), Color("6d540a"), Color("312500")
	],
	"purple": [
		Color("9c79b5"), Color("806099"), Color("663e82"), Color("4f3263"), Color("3b254a")
	],
	"grey": [
		Color("cccccc"), Color("a8a8a8"), Color("757575"), Color("595959"), Color("404040"), Color("2e2e2e"), Color("1f1f1f")
	]
}


const ATTRIBUTE_BAD = PALLETTE["red"][2]
const ATTRIBUTE_MEH = PALLETTE["grey"][2]
const ATTRIBUTE_AVG = Color.WHITE
const ATTRIBUTE_GOOD = PALLETTE["gold"][2]
const ATTRIBUTE_ELITE = PALLETTE["green"][2]
