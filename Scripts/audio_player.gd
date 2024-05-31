extends AudioStreamPlayer

# preload audio files
const menu_music = preload("res://audio/menu_music.mp3")
const level_music = preload("res://audio/level_music.mp3")

# set initial volume levels
var music_volume: float = linear_to_db(0.5)
var fx_volume: float = linear_to_db(0.5)

func _play_music(music: AudioStream):
	# don't play the same music twice
	if stream == music:
		return

	# play the new music
	stream = music # set new music
	volume_db = self.music_volume # set music volume
	play() # play music

func play_music_menu():
	_play_music(menu_music)

func play_music_level():
	_play_music(level_music)

func play_FX(fx_stream: AudioStream):
	# Create and play FX
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = fx_stream # sound effect
	fx_player.name = "FX_PLAYER" # for debugging
	fx_player.volume_db = self.fx_volume # set FX volume
	add_child(fx_player) # add FX to tree
	fx_player.play() # play FX

	await fx_player.finished # wait for FX to finish

	fx_player.queue_free() # remove FX from tree
