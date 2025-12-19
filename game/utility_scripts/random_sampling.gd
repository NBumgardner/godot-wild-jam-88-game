@abstract
extends RefCounted
class_name RandomSampling

static var NO_RESULT = Object.new()

## Efraimidis, Pavlos S.; Spirakis, Paul G. (2006-03-16).
## "Weighted random sampling with a reservoir".
## Information Processing Letters. 97 (5): 181–185. doi:10.1016/j.ipl.2005.11.003.
static func weighted_pick_random(collection: Variant, get_weight: Callable) -> Variant:
	var result = NO_RESULT
	var result_roll: float = 0.0
	var jump: float = 0.0
	
	for element in collection:
		var element_weight: float = get_weight.call(element)
		jump -= element_weight
		if jump <= 0.0:
			result = element
			var t := 0.0 if element_weight == 0.0 else (result_roll ** element_weight)
			result_roll = randf_range(t, 1.0) ** (1.0 / element_weight)
			jump = log(randf()) / log(result_roll)
	
	if result == NO_RESULT:
		push_error("Unable to pick random value! (Is collection empty?)")
		return null
	
	return result
