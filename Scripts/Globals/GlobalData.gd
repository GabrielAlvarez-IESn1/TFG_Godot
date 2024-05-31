extends Node

const SAVE_DIR = "user://saves/"    # File path
const SAVE_FILE = "save.json"       # File name
const SECURITY_KEY = "!@#$%^&*()"   # Security key for encrypting and decrypting data

var player_logged_in = false
var player_data = PlayerData.new()

func _ready():
    # Connect signals
    GlobalSignals.end_zone_reached.connect(self._on_end_zone_reached)

    # Check if save directory exists
    verify_save_dir(SAVE_DIR)

    # Check if the player is already logged in
    self.load()
    if player_data.name != null:
        player_logged_in = true

func _on_end_zone_reached():
    # Save player data
    self.save()

func verify_save_dir(path : String):
    # Create save directory if it doesn't exist
    DirAccess.make_dir_absolute(path)

func save():
    # Save player data
    _save_data(SAVE_DIR + SAVE_FILE)

func load():
    # Load player data
    _load_data(SAVE_DIR + SAVE_FILE)

func log_player_in(player_name : String):
    # Log player in
    player_data.name = player_name
    player_logged_in = true

func _save_data(path : String):
    # Open save file with encryption
    var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)

    # Print error if file can't be opened
    if file == null:
        print(FileAccess.get_open_error())
        return

    # Data to be saved
    var data = {
        "player_data":{
            "name": player_data.name,
            "score": player_data.score,
        }
    }

    # Save data
    var json_string = JSON.stringify(data, "\t")
    file.store_string(json_string)
    file.close()

func _load_data(path : String):
    if FileAccess.file_exists(path): # File exists
        # Open save file with encryption
        var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)

        # Print error if file can't be opened
        if file == null:
            print(FileAccess.get_open_error())
            return

        # Load data
        var content = file.get_as_text()
        file.close()

        # Parse data
        var data = JSON.parse_string(content)
        # Check if data is valid
        if data == null:
            printerr("Cannot parse %s as json_string: (%s)" % [path, content])
            return

        # Set player data
        player_data = PlayerData.new()
        player_data.name = data.player_data.name
        player_data.score = data.player_data.score

    else: # File doesn't exist
        printerr("Cannot open non-existing file at %s!" % path)
