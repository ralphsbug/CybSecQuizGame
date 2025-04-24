extends Control

@onready var QuestionItems = $VBoxContainer/QuestionTexts
@onready var AnswersList = $AnswersList
@onready var QuestionImage = $ImageRect
@onready var RestartButton = $RestartButton
@onready var RestartButtonAlways = $RestartButtonAlways
@onready var WrongNumber = $WrongNumber
@onready var ScoreNumber = $ScoreNumber
@onready var CorrectAnswer = $CorrectAnswer
@onready var OKButton = $OK
@onready var Congratulation = $Correct
@onready var StartMenu = $VBoxContainer2
@onready var QuestionBox = $VBoxContainer

var items: Array
var item: Dictionary
var index_item: int = 0
var wrong: int = 0
var correct: float = 0
var updatedCorrectAnswerIndex: int

func _ready():
	AudioPlayer.play_music_level()
	items = read_json_file("res://assets/texts/questions.json")
	items.shuffle()
	show_beginning()
	#show_questions()
	#displayScore()

func show_beginning():
	QuestionBox.hide()
	CorrectAnswer.hide()
	OKButton.hide()
	Congratulation.hide()
	AnswersList.hide()
	QuestionImage.hide()
	ScoreNumber.hide()
	RestartButton.hide()
	RestartButtonAlways.hide()
	AnswersList.clear()
	WrongNumber.hide()

func displayScore():
	WrongNumber.text = "Wrong: " + str(wrong)
	ScoreNumber.text = "Score: " + str(int(correct))+"/"+str(items.size())

func show_questions():
	StartMenu.hide()
	QuestionBox.show()
	CorrectAnswer.hide()
	OKButton.hide()
	Congratulation.hide()
	AnswersList.show()
	QuestionImage.show()
	ScoreNumber.show()
	RestartButton.hide()
	RestartButtonAlways.show()
	AnswersList.clear()
	WrongNumber.show()
	item = items[index_item]
	QuestionItems.text = item.question
	QuestionImage.texture = load(item.imagePath)
	var options = item.options
	var correctAnswer = item.options[item.correctOptionIndex]
	options.shuffle()
	for option in options:
		if option == correctAnswer:
			updatedCorrectAnswerIndex = options.find(option,0)
	print(options)
	for option in options:
		AnswersList.add_item(option)

func show_result():
	displayScore()
	AnswersList.hide()
	Congratulation.hide()
	QuestionImage.hide()
	CorrectAnswer.hide()
	OKButton.hide()
	RestartButton.show()
	RestartButtonAlways.hide()
	WrongNumber.show()
	ScoreNumber.show()
	
	var percentage = round(correct/items.size()*100)
	var greet
	if percentage >= 80:
		greet = "Great! You got"
	elif percentage >= 60:
		greet = "Not bad! You got"
	else:
		greet = "Too bad! You only got"
	QuestionItems.text = "{greet} {percentage}% correct.".format({"greet": greet, "percentage": percentage})

func refresh_scene():
	if index_item >= items.size():
		show_result()
	else:
		show_questions()
		displayScore()

func read_json_file(filename):
	var json_as_text = FileAccess.get_file_as_string(filename)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict

func show_correct_answer():
	AnswersList.hide()
	ScoreNumber.show()
	RestartButton.hide()
	QuestionImage.show()
	CorrectAnswer.show()
	OKButton.show()
	Congratulation.hide()
	WrongNumber.show()
	item = items[index_item]
	CorrectAnswer.text = "Wrong! Correct answer:\n" + item.options[updatedCorrectAnswerIndex]
	$WrongSound.play()
	
func show_congratulations():
	AnswersList.hide()
	ScoreNumber.show()
	RestartButton.hide()
	QuestionImage.show()
	CorrectAnswer.show()
	OKButton.hide()
	Congratulation.show()
	WrongNumber.show()
	item = items[index_item]
	CorrectAnswer.text = "Right! Correct answer:\n" + item.options[updatedCorrectAnswerIndex]
	$CorrectSound.play()

func _on_ok_pressed():
	index_item +=1
	refresh_scene()

func _on_correct_pressed():
	index_item +=1
	refresh_scene()

func _on_answers_list_item_selected(index):
	if index == updatedCorrectAnswerIndex:
		correct +=1
		show_congratulations()
	else:
		wrong +=1
		show_correct_answer()
		
func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_play_button_pressed() -> void:
	#items = read_json_file("res://assets/texts/questions.json")
	#items.shuffle()
	#show_beginning()
	show_questions()
	displayScore()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_help_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Help.tscn")
