import UIKit
import ReactiveSwift

public protocol FormItem: StackViewRowItem {

	var keyboardAttributes: KeyboardAttributes { get }
	var text: ValidatingProperty<String, InputValidation.Error> { get }
	var placeholder: String? { get }
	var formatter: InputFormatter? { get }
	var inputView: UIView? { get }
	var accessoryView: UIView? { get }

}

public protocol FormItemView: StackViewRow where Self.Item: FormItem {

	var textField: UITextField { get }

}

extension FormItemView {

	public func set(item: Self.Item) {
		Self.setup(field: self.textField, using: item)
	}

	public static func setup(field textField: UITextField, using item: Self.Item) {
		textField.placeholder = item.placeholder ?? ""
		textField.text = (item.formatter ?? InputFormatter.none).format(item.text.result.value.valueAnyway)

		// Format and assign
		textField.reactive
			.controlEvents(UIControlEvents.editingChanged)
			.map { $0.text ?? "" }
			.combinePrevious("")
			.observeValues { [weak textField] (old, new) in
				guard let textField = textField else { return }
				let newFormatted = (item.formatter ?? InputFormatter.none).format(new)
				let oldFormatted = (item.formatter ?? InputFormatter.none).format(old)
				item.text.value = newFormatted
				// Compute new cursor position
				let position = cursorPosition(old: oldFormatted, new: newFormatted, textField: textField)
				textField.text = newFormatted
				// Restore cursor position
				textField.selectedTextRange = textField.textRange(from: position, to: position)
		}
		configureKeyboard(for: textField, using: item)
	}

	public static func configureKeyboard(for textField: UITextField, using item: Self.Item) {
		let keyboardAttributes = item.keyboardAttributes
		textField.autocapitalizationType = keyboardAttributes.capitalization
		textField.autocorrectionType = keyboardAttributes.correction
		textField.spellCheckingType = keyboardAttributes.spellChecking
		textField.keyboardType = keyboardAttributes.keyboardType
		textField.returnKeyType = keyboardAttributes.returnKey
		textField.isSecureTextEntry = keyboardAttributes.isSecureTextEntry
		textField.inputAccessoryView = item.accessoryView
	}

}

func cursorPosition(old original: String, new: String, textField: UITextField) -> UITextPosition {
	return textField.selectedTextRange?.end ?? textField.endOfDocument
}
