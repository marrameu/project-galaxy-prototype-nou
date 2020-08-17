extends "res://src/Camera/CameraShake.gd"

onready var occlusion_ray : RayCast = get_node("../OcclusionRay")
onready var cam_base : Spatial = get_parent()

var min_distance: = 0.2
var max_distance: float

var distance: float

var smooth: = 10.0 # Sense outline quedaria millor amb 5.0

var dolly_dir: = Vector3()

var col_enabled: = true


func _ready() -> void:
	occlusion_ray.cast_to = translation
	occlusion_ray.add_exception(get_parent().get_node(get_parent().target))
	
	max_distance = to_global(translation).distance_to(to_global(get_parent().translation))
	dolly_dir = translation.normalized()


func _process(delta : float) -> void:
	col_enabled = true if cam_base.current_state == cam_base.States.PLAYER else false
	
	if col_enabled:
		if occlusion_ray.is_colliding():
			distance = clamp(global_transform.origin.distance_to(occlusion_ray.get_collision_point()) * 0.9, min_distance, max_distance) # Si falla, probar amb 0
		else:
			distance = max_distance
		
		# Com la distància és multiplicada per 0.9, a vegades embla que vagi més de pressa
		# Degut a les 'contact shadows', els fps baixen quan la càmera s'apropa
		translation = lerp(translation, dolly_dir * distance, delta * smooth)
