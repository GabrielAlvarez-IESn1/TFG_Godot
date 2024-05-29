extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE = "save.json"
const SECURITY_KEY = "!@#$%^&*()"

var player_logged_in = false
var player_data = PlayerData.new()

func _ready():
    GlobalSignals.end_zone_reached.connect(self._on_end_zone_reached)
    verify_save_dir(SAVE_DIR)
    # Check if the player is already logged in
    self.load()
    if player_data.name != null:
        player_logged_in = true

func _on_end_zone_reached():
    self.save()

func verify_save_dir(path : String):
    DirAccess.make_dir_absolute(path)

func save():
    _save_data(SAVE_DIR + SAVE_FILE)

func load():
    _load_data(SAVE_DIR + SAVE_FILE)

func log_player_in(player_name : String):
    player_data.name = player_name
    player_logged_in = true

func _save_data(path : String):
    var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
    if file == null:
        print(FileAccess.get_open_error())
        return

    var data = {
        "player_data":{
            "name": player_data.name,
            "score": player_data.score,
        }
    }

    var json_string = JSON.stringify(data, "\t")
    file.store_string(json_string)
    file.close()

func _load_data(path : String):
    if FileAccess.file_exists(path):
        var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
        if file == null:
            print(FileAccess.get_open_error())
            return

        var content = file.get_as_text()
        file.close()

        var data = JSON.parse_string(content)
        if data == null:
            printerr("Cannot parse %s as json_string: (%s)" % [path, content])
            return

        player_data = PlayerData.new()
        player_data.name = data.player_data.name
        player_data.score = data.player_data.score

    else:
        printerr("Cannot open non-existing file at %s!" % path)
