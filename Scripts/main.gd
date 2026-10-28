extends Sprite2D

@export var scene_pipa: PackedScene

var game_berjalan: bool
var game_berakhir: bool
var scrol
var skor
const KECEPATAN_SCROL: int = 4
var ukuran_layar: Vector2i
var tinggi_tanah: int
var banyak_pipa: Array
const DELAY_PIPA: int = 100
const JARAK_PIPA: int = 200

func _ready() -> void:
	ukuran_layar = get_window().size
	tinggi_tanah = $Tanah.get_node("Sprite2D").texture.get_height()
	game_baru()

func game_baru() -> void:
	game_berjalan = false
	game_berakhir = false
	skor = 0
	scrol = 0
	$LabelSkor.text = "SKOR: " + str(skor)
	$GameOver.hide()
	get_tree().call_group("banyak_pipa", "queue_free")
	banyak_pipa.clear()
	generate_pipa()
	$Burung.reset()

func _input(event: InputEvent) -> void:
	if game_berakhir == false:
		if Input.is_action_pressed("ui_accept"):
			if game_berjalan == false:
				mulai_game()
			else:
				if $Burung.terbang:
					$Burung.flap()
					cek_atas()

func mulai_game() -> void:
	game_berjalan = true
	$Burung.terbang = true
	$Burung.flap()
	$WaktuPipa.start()

func _process(delta: float) -> void:
	if game_berjalan:
		scrol += KECEPATAN_SCROL
		if scrol >= ukuran_layar.x:
			scrol = 0
		$Tanah.position.x = -scrol
		
		for pipa in banyak_pipa:
			pipa.position.x -= KECEPATAN_SCROL

func _on_waktu_pipa_timeout() -> void:
	generate_pipa()

func generate_pipa() -> void:
	var pipa = scene_pipa.instantiate()
	pipa.position.x = ukuran_layar.x + DELAY_PIPA
	pipa.position.y = (ukuran_layar.y - tinggi_tanah) / 2 + randi_range(-JARAK_PIPA, JARAK_PIPA)
	pipa.hit.connect(hit_burung)
	pipa.dapat_skor.connect(dapat_skor)
	add_child(pipa)
	banyak_pipa.append(pipa)

func dapat_skor() -> void:
	skor += 1
	$LabelSkor.text = "SKOR: " + str(skor)

func cek_atas() -> void:
	if $Burung.position.y < 0:
		$Burung.jatuh = true
		stop_game()

func stop_game() -> void:
	if game_berakhir:
		return
	
	game_berjalan = false
	game_berakhir = true
	
	$WaktuPipa.stop()
	$Kalah.play()
	$GameOver.show()
	$Burung.terbang = false

func hit_burung() -> void:
	$Burung.jatuh = true
	stop_game()

func _on_tanah_hit() -> void:
	$Burung.jatuh = true
	stop_game()

func _on_game_over_restart() -> void:
	game_baru()
