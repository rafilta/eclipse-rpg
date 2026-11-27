extends PanelContainer

var player: Player
var status: Label
var objective: Label
var hint: Label
var last_level := 0
var celebration := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	offset_left = -245
	offset_right = 245
	offset_top = 8
	offset_bottom = 98
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#14222cde")
	style.border_color = Color("#9d8358")
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	add_theme_stylebox_override("panel", style)
	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(box)
	status = _make_label(box, 18, Color("#f4d8a5"))
	objective = _make_label(box, 15, Color("#ecf3ed"))
	hint = _make_label(box, 13, Color("#b9cbd1"))
	hint.text = "1 Corte (12) | 2 Raio (20) | 3 Ciclone (28 energia)"
	last_level = player.stats.level

func _make_label(box: VBoxContainer, font_size: int, tint: Color) -> Label:
	var label := Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", tint)
	box.add_child(label)
	return label

func _process(delta: float) -> void:
	if not is_instance_valid(player) or not is_instance_valid(player.stats):
		return
	var s := player.stats
	if s.level > last_level:
		celebration = 4.0
	last_level = s.level
	celebration = maxf(0.0,celebration-delta)
	status.text = "ECLIPSE  |  Nv. %d  |  Vida %d/%d  |  Energia %d/%d" % [s.level,s.hp,s.hp_max,s.energy,s.energy_max]
	if celebration > 0:
		objective.text = "NÍVEL ALCANÇADO! Vida e energia recuperadas."
	elif s.level < 2:
		objective.text = "Caçada inicial: alcance o nível 2 · Raio arcano"
	elif s.level < 3:
		objective.text = "Alcance o nível 3 · desbloqueie Ciclone"
	else:
		objective.text = "Caçada livre · busque armas e armaduras raras"
	hint.text = "XP %d/%d · 1 Corte | 2 Raio (Nv2) | 3 Ciclone (Nv3)" % [s.experience,s.experience_needed]
