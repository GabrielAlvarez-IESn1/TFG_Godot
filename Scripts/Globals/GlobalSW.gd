extends Node

func _ready():
    # SilentWolf initialization
    SilentWolf.configure({
        "api_key": "ePZRnSAxOH75Fn59HgKld8PWoN9ntTRP2wEoyyoy",
        "game_id": "RUN_RUBY",
        "log_level": 1
    })

    # SilentWolf configure scores on close scene
    SilentWolf.configure_scores({
        "open_scene_on_close": GlobalScenes.scenes["main"]
    })
