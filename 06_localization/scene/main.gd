extends Control

func _ready() -> void:
	TranslationServer.set_locale("zh")
	print("$RichTextLabel.text: pre: " + str($RichTextLabel.text))
	$RichTextLabel.text = handle_rich_text($RichTextLabel.text)
	print("$RichTextLabel.text: post: " + str($RichTextLabel.text))
	pass

# 工具方法
func handle_rich_text(rich_text : String) -> String:
	var translated_text = ""
	var current_index = 0
	while current_index < rich_text.length():
		var tag_start = rich_text.find("[", current_index)
		if tag_start == -1:
			translated_text += tr(rich_text.substr(current_index))
			break
		translated_text += tr(rich_text.substr(current_index, tag_start - current_index))
		var tag_end = rich_text.find("]", tag_start)
		if tag_end == -1:
			translated_text += rich_text.substr(tag_start)
			break
		translated_text += rich_text.substr(tag_start, tag_end - tag_start + 1)
		current_index = tag_end + 1
	return translated_text
