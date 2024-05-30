extends AudioStreamPlayer

const menu_music = preload("res://audio/menu_music.mp3")
const level_music = preload("res://audio/level_music.mp3")

var music_volume: float = -10.0
var fx_volume: float = -10.0

func _play_music(music: AudioStream):
	if stream == music:
		return

	stream = music
	volume_db = self.music_volume
	play()

func play_music_menu():
	_play_music(menu_music)

func play_music_level():
	_play_music(level_music)

func play_FX(fx_stream: AudioStream):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = fx_stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = self.fx_volume
	add_child(fx_player)
	fx_player.play()

	await fx_player.finished

	fx_player.queue_free()
