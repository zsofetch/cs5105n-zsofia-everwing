extends Node

const SFX_DIR = "res://assets/audio/sfx/"
const MUSIC_DIR = "res://assets/audio/music/"
const EXTENSIONS = ["ogg", "mp3", "wav"]   # checked in this order
const SFX_VOICES: int = 8                  # sounds that can overlap

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var next_voice: int = 0
var cache: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS   # keep playing while the game is paused
	_ensure_bus("Music")
	_ensure_bus("SFX")

	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

	for i in range(SFX_VOICES):
		var voice := AudioStreamPlayer.new()
		voice.bus = "SFX"
		add_child(voice)
		sfx_players.append(voice)

func play_sfx(sfx_name: String, volume_db: float = 0.0, pitch_variation: float = 0.0) -> void:
	var stream := _get_stream(SFX_DIR, sfx_name)
	if stream == null:
		return
	var voice := _next_voice()
	voice.stream = stream
	voice.volume_db = volume_db
	voice.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
	voice.play()

func play_music(track_name: String) -> void:
	var stream := _get_stream(MUSIC_DIR, track_name)
	if stream == null:
		return
	if music_player.stream == stream and music_player.playing:
		return   # already playing: don't restart when the scene changes
	_enable_loop(stream)
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func _next_voice() -> AudioStreamPlayer:
	for voice in sfx_players:
		if not voice.playing:
			return voice
	var reused := sfx_players[next_voice]   # all busy: reuse the oldest
	next_voice = (next_voice + 1) % sfx_players.size()
	return reused

func _get_stream(dir: String, base: String) -> AudioStream:
	var key := dir + base
	if cache.has(key):
		return cache[key]
	for ext in EXTENSIONS:
		var path := "%s%s.%s" % [dir, base, ext]
		if ResourceLoader.exists(path):
			cache[key] = load(path)
			return cache[key]
	cache[key] = null   # file missing: remember, so we don't search on every shot
	return null

func _enable_loop(stream: AudioStream) -> void:
	if stream is AudioStreamWAV:
		var wav := stream as AudioStreamWAV
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
		wav.loop_begin = 0
		wav.loop_end = int(wav.get_length() * wav.mix_rate)
	elif stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	elif stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = true

# Safety net: creates the bus if it isn't in your layout
func _ensure_bus(bus_name: String) -> void:
	if AudioServer.get_bus_index(bus_name) != -1:
		return
	AudioServer.add_bus()
	var idx: int = AudioServer.bus_count - 1
	AudioServer.set_bus_name(idx, bus_name)
	AudioServer.set_bus_send(idx, "Master")
	AudioServer.set_bus_volume_db(idx, -10.0 if bus_name == "Music" else -4.0)
