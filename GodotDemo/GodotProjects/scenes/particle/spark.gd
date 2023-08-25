extends Node2D


@onready var spark_particles: CPUParticles2D = $SparkParticles
@onready var delete_timer: Timer = $DeleteTimer


func _ready() -> void:
	spark_particles.restart()
	# 保证定时器的时间是粒子播放的时间
	delete_timer.start(spark_particles.lifetime)

func _on_delete_timer_timeout() -> void:
	# 居然没有粒子效果播放完的信号……
	queue_free()
