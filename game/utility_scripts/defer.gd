@abstract
extends RefCounted
class_name Defer

static var defer_impl := DeferImpl.new()

static func defer() -> Signal:
	return defer_impl.defer()

class DeferImpl:
	signal called()
	var _queued: bool = false
	
	func defer() -> Signal:
		if not _queued:
			_queued = true
			_deferred.call_deferred()
		return called
	
	func _deferred() -> void:
		_queued = false
		called.emit()
