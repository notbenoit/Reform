import ReactiveSwift

public struct InputValidation {

	public struct Error: Swift.Error {

		let localizedDescription: String

		init(_ description: String) {
			localizedDescription = description
		}

		init(_ left: Error, _ right: Error) {
			localizedDescription = left.localizedDescription + " " + right.localizedDescription
		}

	}

	public static func checkNothing<Value>() -> (Value) -> ValidatingProperty<Value, Error>.Decision {
		return { _ in .valid }
	}

	public static func checkMinLength(_ minLength: Int, emptyErrorMessage: String = "Must not be empty") -> (String) -> ValidatingProperty<String, Error>.Decision {
		return { value in
			guard value.trimmingCharacters(in: CharacterSet.whitespaces).count >= minLength else {
				return .invalid(Error(minLength <= 1 ? emptyErrorMessage : "Must include a minimum of \(minLength) characters."))
			}
			return .valid
		}
	}

	public static func checkMaxLength(_ maxLength: Int) -> (String) -> ValidatingProperty<String, Error>.Decision {
		return { value in
			if value.trimmingCharacters(in: CharacterSet.whitespaces).count <= maxLength {
				return .valid
			} else {
				return .invalid(Error("Must include a maximum of \(maxLength) characters."))
			}
		}
	}

	public static func checkIsIn(possibleValues: Set<String>, error: String) -> (String) -> ValidatingProperty<String, Error>.Decision {
		return {
			guard possibleValues.contains($0) else {
				return .invalid(Error(error))
			}
			return .valid
		}
	}

	public static func checkValueIsEqual<P: PropertyProtocol>(to otherValue: P, error: String) -> (String) -> ValidatingProperty<String, Error>.Decision where P.Value == String {
		return {
			guard $0 == otherValue.value else {
				return .invalid(Error(error))
			}
			return .valid
		}
	}

}

/// Combine two Validator checks together, combining errors together if there are two.
///
/// - Parameters:
///   - lhs: A validator check
///   - rhs: Another validator check for the same entry type T.
///
/// - note: We can't handle coerced values when combining validators, because a coerced value may be
///         invalid for the other validator.
///
///
/// - Returns: A validator that combines the two given as parameters.
func && <T>(
	lhs: @escaping ((T) -> ValidatingProperty<T, InputValidation.Error>.Decision),
	rhs: @escaping ((T) -> ValidatingProperty<T, InputValidation.Error>.Decision)) -> ((T) -> ValidatingProperty<T, InputValidation.Error>.Decision) {
	return { value in
		switch (lhs(value), rhs(value)) {
		case (.valid, .valid):
			return .valid
		case let (.invalid(leftError), .invalid(rightError)):
			return .invalid(InputValidation.Error(leftError, rightError))
		case let (_, .invalid(error)):
			return .invalid(error)
		case let (.invalid(error), _):
			return .invalid(error)
		default:
			fatalError("Can't satisfy coerced values when combining validators")
		}
	}
}

/// Combine two Validator checks together, and is valid if either of the validators are valid.
///
/// - Parameters:
///   - lhs: A validator check
///   - rhs: Another validator check for the same entry type T.
///
/// - note: We can't handle coerced values when combining validators, because a coerced value may be
///         invalid for the other validator.
///
///
/// - Returns: A validator that is valid if either of the validators are valid.
func || <T>(
	lhs: @escaping ((T) -> ValidatingProperty<T, InputValidation.Error>.Decision),
	rhs: @escaping ((T) -> ValidatingProperty<T, InputValidation.Error>.Decision)) -> ((T) -> ValidatingProperty<T, InputValidation.Error>.Decision) {
	return { value in
		switch (lhs(value), rhs(value)) {
		case (.valid, _):
			return .valid
		case (_, .valid):
			return .valid
		case let (.invalid(leftError), .invalid(rightError)):
			return .invalid(InputValidation.Error(leftError, rightError))
		default:
			fatalError("Can't satisfy coerced values when combining validators")
		}
	}
}
