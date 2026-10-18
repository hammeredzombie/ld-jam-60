extends Node2D

@export_enum("Desktop", "Laptop") var workstation_type: int = 0:
	set(value):
		workstation_type = value
		set_workstation_type(workstation_type)

@export var has_usb: bool = true

@onready var _Desktop: Sprite2D = $Desktop
@onready var _Monitor: Sprite2D = $Monitor
@onready var _MonitorGlow: Sprite2D = $MonitorGlow
@onready var _UsbDesktop: Node2D = $UsbDesktop
@onready var _Laptop: Sprite2D = $Laptop
@onready var _LaptopGlow: Sprite2D = $LaptopGlow
@onready var _UsbLaptop: Node2D = $UsbLaptop


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_workstation_type(workstation_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_workstation_type(type: int) -> void:
	match type:
		0: # Desktop
			_Desktop.show()
			_Monitor.show()
			_MonitorGlow.show()
			_UsbDesktop.show()
			_Laptop.hide()
			_LaptopGlow.hide()
			_UsbLaptop.hide()
		1: # Laptop
			_Desktop.hide()
			_Monitor.hide()
			_MonitorGlow.hide()
			_UsbDesktop.hide()
			_Laptop.show()
			_LaptopGlow.show()
			_UsbLaptop.show()
		_:
			push_error("Invalid workstation type: %s" % type)
