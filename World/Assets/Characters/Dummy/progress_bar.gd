extends ProgressBar
@onready var progress_bar: ProgressBar = $"."
@onready var dummy: CharacterBody3D = $"../../.."

func health():
	min_value = 0
	max_value = 100
