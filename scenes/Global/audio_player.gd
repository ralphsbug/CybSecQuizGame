extends AudioStreamPlayer

const level_music = preload("res://assets/sounds/lofi_pop_slow.mp3")

func _play_music(music:  AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume - 10
	play()
	
func play_music_level():
	_play_music(level_music)
