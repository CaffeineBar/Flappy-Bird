extends Area2D

signal hit
signal dapat_skor

func _on_body_entered(body: Node2D) -> void:
	hit.emit()

func _on_cetak_skor_body_entered(body: Node2D) -> void:
	dapat_skor.emit()
	$Poin.play()
