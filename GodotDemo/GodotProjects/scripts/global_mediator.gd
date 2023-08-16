extends Node

# Godot 没有类似 Spring 的依赖倒置框架，勉强用全局变量来方便获取核心组件
var capturable_base_manager: CapturableBaseManager
var camera_manager: CameraManager
var gui: GUI
