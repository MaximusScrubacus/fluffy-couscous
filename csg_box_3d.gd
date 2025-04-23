extends CSGBox3D
@onready var torch: Node3D = $"../Torch"


func interact():
		torch.get_group("lightFlame")
		if torch.is_in_group("lightFlame"):
				torch.hide()
