extends Node2D

@export_enum("Desktop", "Laptop") var workstation_type: int = 0

@onready var _Desktop: Sprite2D = $Desktop
@onready var _Monitor: Sprite2D = $Monitor
@onready var _MonitorGlow: Sprite2D = $MonitorGlow
@onready var _UsbDesktop: Usb = $UsbDesktop
@onready var _Laptop: Sprite2D = $Laptop
@onready var _LaptopGlow: Sprite2D = $LaptopGlow
@onready var _UsbLaptop: Usb = $UsbLaptop


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if workstation_type == 0:
		$Desktop.show()
		_Monitor.show()
		_MonitorGlow.show()
		_UsbDesktop.show()
		$Laptop.hide()
		_LaptopGlow.hide()
		_UsbLaptop.hide()
	elif workstation_type == 1:
		$Desktop.hide()
		_Monitor.hide()
		_MonitorGlow.hide()
		_UsbDesktop.hide()
		$Laptop.show()
		_LaptopGlow.show()
		_UsbLaptop.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
