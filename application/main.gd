extends Application


const FIRST_LEVEL_EXP = 50
const MAX_LEVEL = 10
const LEVEL_EXP_INCREASE = 20
const START_HEALTH = 10


const CARDS_NEW_SKILLS_PATH_TEMPLATE = "res://assets/cards/new_skills/card"
const CARDS_UPGRADES_PATH_TEMPLATE = "res://assets/cards/upgrades/card"
const CARDS_BUFFS_PATH_TEMPLATE = "res://assets/cards/buffs/card"


const CARDS_NEW_SKILLS_ALL = [
	"1",
	"2",
	"3",
	"4",
]

const CARDS_UPGRADES_ALL = {
	"1": ["5", "6"],
	"2": ["7", "8"],
}

const CARDS_BUFFS_ALL = [
	"9",
	"10",
]
	

var cardsNewSkills = [
	"1",
	"2",
	"3",
	"4",
]

var cardsUsedNewSkills = []

var cardsUpgrades = []



var health = START_HEALTH

var level = 1
var experience = 0
var maxExperience = FIRST_LEVEL_EXP + (level-1)*LEVEL_EXP_INCREASE

var card1 = null
var card2 = null
var card3 = null

var random = RandomNumberGenerator.new()

func _ready() -> void:	
	random.randomize()
	
	set_visible_start()
	
	api('connect_to_hud_app', {
		'target_node' : self,
		'on_message' : 'on_message',
		'on_error' : 'on_error',
		'on_connected' : 'on_connected',
		'on_disconnected' : 'on_disconnected',
	})
	
	api('connect_to_input', {
		'target_node' : self,
		'on_input' : 'on_input'
	})

func on_message(message):
	if message["type"] == "exp":
		experience = int(message["value"])
		if experience >= maxExperience:
			level += 1
			if level == MAX_LEVEL:
				set_visible_win()
			else:
				experience = 0
				maxExperience = FIRST_LEVEL_EXP + (level-1)*LEVEL_EXP_INCREASE
				show_cards()
		else:
			$progress_exp.value = experience
	elif message["type"] == "health":
		health = int(message["value"])
		if health==0:
			game_over_listener()
		else:
			$text_health.text = "Health: " + str(health)	
	


func on_connected():
	pass
#	$messages.text += '[Event]: sent message to hud!\n'
#	api('send_to_hud_app', {
#		'type' : 'text',
#		'text' : 'Hello from Exception402!'
#	})


func on_disconnected():
	pass


func on_error(error_text:String):
	pass


func on_input(type, state):
	pass
#	api('send_to_hud_app', {
#		'type' : 'input',
#		'input_type' : type,
#		'state' : state
#	})
	
func show_cards():
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'pause'
	})
	set_visible_cards()

	
func game_over_listener():
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'stop'
	})
	set_visible_game_over()








func set_visible_main():
	card1 = null
	card2 = null
	card3 = null
	
	$button_start.visible = false
	
	$text_game_over.visible = false
	$button_play_again.visible = false
	
	$texture_card1.visible = false
	$texture_card2.visible = false
	$texture_card3.visible = false
	
	$progress_exp.visible = true
	$text_health.visible = true
	
	$text_win.visible = false
	$button_win_play_again.visible = false
	
func set_visible_cards():
	$button_start.visible = false
	
	$text_game_over.visible = false
	$button_play_again.visible = false
	
	$texture_card1.visible = true
	$texture_card2.visible = true
	$texture_card3.visible = true
	
	$progress_exp.visible = false
	$text_health.visible = false
	
	$text_win.visible = false
	$button_win_play_again.visible = false
	
	var cards = get_cards_bundle()
	card1 = cards[0]
	card2 = cards[1]
	card3 = cards[2]
	
	$texture_card1/text_card_name1.text = card1["name"]
	$texture_card1/text_card_description1.text = card1["name"]
	$texture_card1/texture_card_icon1.texture = load_card_icon(card1["id"])
	
	$texture_card2/text_card_name2.text = card2["name"]
	$texture_card2/text_card_description2.text = card2["name"]
	$texture_card2/texture_card_icon2.texture = load_card_icon(card2["id"])
	
	$texture_card3/text_card_name3.text = card3["name"]
	$texture_card3/text_card_description3.text = card3["name"]
	$texture_card3/texture_card_icon3.texture = load_card_icon(card3["id"])
	
	
func set_visible_game_over():
	$button_start.visible = false
	
	$text_game_over.visible = true
	$button_play_again.visible = true
	
	$texture_card1.visible = false
	$texture_card2.visible = false
	$texture_card3.visible = false
	
	$progress_exp.visible = false
	$text_health.visible = false
	
	$text_win.visible = false
	$button_win_play_again.visible = false
	
func set_visible_start():
	$button_start.visible = true
	
	$text_game_over.visible = false
	$button_play_again.visible = false
	
	$texture_card1.visible = false
	$texture_card2.visible = false
	$texture_card3.visible = false
	
	$progress_exp.visible = false
	$text_health.visible = false
	
	$text_win.visible = false
	$button_win_play_again.visible = false
	
func set_visible_win():
	$button_start.visible = false
	
	$text_game_over.visible = false
	$button_play_again.visible = false
	
	$texture_card1.visible = false
	$texture_card2.visible = false
	$texture_card3.visible = false
	
	$progress_exp.visible = false
	$text_health.visible = false
	
	$text_win.visible = true
	$button_win_play_again.visible = true
	
func init_main_vars():
	cardsNewSkills = [
		"1",
		"2",
		"3",
		"4",
	]

	cardsUsedNewSkills = []

	cardsUpgrades = []
	
	health = START_HEALTH
	level = 1
	experience = 0
	maxExperience = FIRST_LEVEL_EXP + (level-1)*LEVEL_EXP_INCREASE
	$progress_exp.max_value = maxExperience
	$text_health.text = "Health: " + str(START_HEALTH)

func get_cards_bundle():
	var idCard1 = CARDS_BUFFS_ALL[random.randi() % CARDS_BUFFS_ALL.size()]
	var card1 = load_card(idCard1, "buff")
	
	var card2 = null
	if cardsNewSkills.size()>0:
		var idCard2 = cardsNewSkills[random.randi() % cardsNewSkills.size()]
		card2 = load_card(idCard2, "new_skill")
	elif cardsUpgrades.size()>0:
		var idCard2 = cardsUpgrades[random.randi() % cardsUpgrades.size()]
		card2 = load_card(idCard2, "upgrade")
	else:
		var idCard2 = CARDS_BUFFS_ALL[random.randi() % CARDS_BUFFS_ALL.size()]
		card2 = load_card(idCard2, "buff")
		
	var card3 = null
	if cardsNewSkills.size()>0:
		var idCard3 = cardsNewSkills[random.randi() % cardsNewSkills.size()]
		card3 = load_card(idCard3, "new_skill")
	elif cardsUpgrades.size()>0:
		var idCard3 = cardsUpgrades[random.randi() % cardsUpgrades.size()]
		card2 = load_card(idCard3, "upgrade")
	else:
		var idCard3 = CARDS_BUFFS_ALL[random.randi() % CARDS_BUFFS_ALL.size()]
		card2 = load_card(idCard3, "buff")
	
	return [card1, card2, card3]
	
	
	
func load_card(id, cardType):
	var path = null
	if cardType == "buff":
		path = CARDS_BUFFS_PATH_TEMPLATE + id + ".json"
	elif cardType == "new_skill":
		path = CARDS_NEW_SKILLS_PATH_TEMPLATE + id + ".json"
	elif cardType == "upgrade":
		path = CARDS_UPGRADES_PATH_TEMPLATE + id + ".json"
	
	var file = File.new()
	if file.open(path, File.READ) == OK:
		var jsonStr = file.get_as_text()
		file.close()
		
		var jsonData = JSON.parse(jsonStr)
		# q_data = jsonData
		if jsonData != null:
			print(jsonData)
			return jsonData
		else:
			print("Failed to parse JSON data.")
			return null
	else:
		print("Failed to open file for reading.")
		return null
		
func load_card_icon(cardId):
	var texture = ImageTexture.new()
	var image = Image.new()
	var imagePath = "res://assets/cards/icons/cardIcon" + str(cardId) + ".png"
	image.load(imagePath)
	texture.create_from_image(image)
	return texture
	
func removeCardFromLists(card):
	var cardId = card["id"]
	if card["type"]=="new_skill":
		cardsNewSkills.remove(cardsNewSkills.find(cardId))
		cardsUsedNewSkills.push_back(card)
		cardsUpgrades.append_array(CARDS_UPGRADES_ALL[cardId])
	elif card["type"]=="upgrade":
		cardsUpgrades.remove(cardsUpgrades.find(cardId))
	else:
		pass

	
func _on_button_play_again_pressed():
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'start'
	})
	set_visible_main()

func _on_button_card1_pressed():
	var cardId = card1["id"]
	api('send_to_hud_app', {
		'type' : 'card_info',
		'id' : cardId,
	})
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'resume',
	})
	removeCardFromLists(card1)
	set_visible_main()
	


func _on_button_card2_pressed():
	var cardId = card2["id"]
	api('send_to_hud_app', {
		'type' : 'card_info',
		'id' : cardId,
	})
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'resume',
	})
	removeCardFromLists(card2)
	set_visible_main()


func _on_button_card3_pressed():
	var cardId = card3["id"]
	api('send_to_hud_app', {
		'type' : 'card_info',
		'id' : cardId,
	})
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'resume',
	})
	removeCardFromLists(card3)
	set_visible_main()


func _on_button_start_pressed():
	api('send_to_hud_app', {
		'type' : 'state',
		'value' : 'start'
	})
	set_visible_main()
	init_main_vars()
	pass # Replace with function body.


func _on_button_win_play_again_pressed():
	set_visible_main()
