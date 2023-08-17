extends Node

# Godot 没有类似 Spring 的依赖倒置框架，勉强用全局变量来方便获取核心组件
var capturable_base_manager: CapturableBaseManager
var camera_manager: CameraManager
var gui: GUI


# 游戏设置
var night_battle: bool = false
var friendly_fire_damage: bool = false
var player_invincible: bool = false
var ai_dont_shoot: bool = false
var navigation_debug: bool = false
