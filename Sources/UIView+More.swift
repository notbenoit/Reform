import UIKit

// MARK: - Text Field

/// A TextField struct holds data about a UITextField and its frame.
struct TextField {
	let origin: CGPoint
	let textField: UITextField
}

extension TextField {
	static func origin(lhs: TextField, rhs: TextField) -> Bool {
		switch (rhs.origin.y - lhs.origin.y) {
		case (..<0):
			return false
		case (1...):
			return true
		case 0:
			return lhs.origin.x < rhs.origin.x
		default:
			fatalError("TextField ordering impossible case")
		}
	}
}

extension TextField: Equatable {
	static func ==(lhs: TextField, rhs: TextField) -> Bool {
		return lhs.textField == rhs.textField
	}
}

extension UIView {

	public var allFields: [UITextField] {
		return allTextFields.map { $0.textField }
	}

	/// Pulls all UITextFields in subviews recursively.
	var allTextFields: [TextField] {
		var fields: [TextField] = []
		for subview in subviews {
			if let textField = subview as? UITextField, let window = textField.window {
				let frame = window.convert(textField.bounds, from: textField)
				fields += [TextField.init(origin: frame.origin, textField: textField)]
			} else {
				fields += subview.allTextFields
			}
		}
		return fields.sorted(by: TextField.origin(lhs:rhs:))
	}

	/// Returns the UITextField laid out after a given UITextField
	///
	/// - Parameter field: The UITextField we are jumping from.
	/// - Returns: A potiential next UITextField
	public func field(after field: UITextField) -> UITextField? {
		let textField = TextField(origin: .zero, textField: field)
		let allFields = allTextFields
		return allFields.index(after: textField).map { allFields[$0] }?.textField
	}

	/// Returns the UITextField laid out before a given UITextField
	///
	/// - Parameter field: The UITextField we are jumping from.
	/// - Returns: A potiential previous UITextField
	public func field(before field: UITextField) -> UITextField? {
		let textField = TextField(origin: .zero, textField: field)
		let allFields = allTextFields
		return allFields.index(before: textField).map { allFields[$0] }?.textField
	}

}

extension Collection where Self.Element == TextField, Self.Index == Int {

	private func findIndex(using: ((Self.Index) -> Self.Index), field: TextField) -> Self.Index? {
		return index(of: field)
			.map(using)
			.flatMap { $0 < endIndex && self.count > 0 && $0 >= 0 ? $0 : nil }
	}

	func index(after field: TextField) -> Self.Index? {
		return findIndex(using: { self.index(after: $0) }, field: field)
	}

	func index(before field: TextField) -> Self.Index? {
		return findIndex(using: { self.index($0, offsetBy: -1) }, field: field)
	}

}

// MARK: - Responder Chain
extension UIView {

	func superviewOfType<T: UIView>(_ type: T.Type) -> T? {
		if let t = self as? T {
			return t
		} else {
			return self.superview?.superviewOfType(type)
		}
	}

	var parentViewController: UIViewController? {
		return firstResponderOfType(UIViewController.self)
	}

	func firstResponderOfType<T>(_ type: T.Type) -> T? {
		var parentResponder: UIResponder? = self
		while let unwrappedParent = parentResponder {
			parentResponder = unwrappedParent.next
			if let responder = parentResponder as? T {
				return responder
			}
		}
		return nil
	}

}
