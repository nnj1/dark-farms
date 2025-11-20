extends AudioStreamPlayer

var song_titles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	song_titles = GlobalVars.dir_contents('res://assets/music/Infinity Crystal_ Awakening/Infinity Crystal_ Awakening/')
	self.stream = load('res://assets/music/Infinity Crystal_ Awakening/Infinity Crystal_ Awakening/' + song_titles.pick_random())
	self.play()
	
func play_path(given_music_path: String) -> void:
	self.stream = load(given_music_path)
	self.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_finished() -> void:
	self.stream = load('res://assets/music/Infinity Crystal_ Awakening/Infinity Crystal_ Awakening/' + song_titles.pick_random())
	self.play()
