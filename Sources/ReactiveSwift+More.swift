import ReactiveSwift

extension ValidatingProperty.Result {

	/// Return the embedded value, regardless of the validation result.
	public var valueAnyway: Value {
		switch self {
		case let .valid(value):
			return value
		case let .coerced(replacement, _, _):
			return replacement
		case let .invalid(value, _):
			return value
		}
	}

}

