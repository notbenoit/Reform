import UIKit

public struct KeyboardAttributes {

	let capitalization: UITextAutocapitalizationType
	let correction: UITextAutocorrectionType
	let spellChecking: UITextSpellCheckingType
	let keyboardType: UIKeyboardType
	let keyboardAppearance: UIKeyboardAppearance
	let returnKey: UIReturnKeyType
	let isSecureTextEntry: Bool

	public init(
		capitalization: UITextAutocapitalizationType = .sentences,
		correction: UITextAutocorrectionType = .default,
		spellChecking: UITextSpellCheckingType = .default,
		keyboardType: UIKeyboardType = .default,
		keyboardAppearance: UIKeyboardAppearance = .dark,
		returnKey: UIReturnKeyType = .done,
		isSecureTextEntry: Bool = false) {
		self.capitalization = capitalization
		self.correction = correction
		self.spellChecking = spellChecking
		self.keyboardType = keyboardType
		self.keyboardAppearance = keyboardAppearance
		self.returnKey = returnKey
		self.isSecureTextEntry = isSecureTextEntry
	}

}

extension KeyboardAttributes {

	public static var name: KeyboardAttributes {
		return KeyboardAttributes(
			capitalization: .words,
			correction: .no,
			spellChecking: .no,
			keyboardType: .default,
			keyboardAppearance: .dark,
			returnKey: .next,
			isSecureTextEntry: false)
	}

}
