import UIKit

/// A base implementation for a very standard accessoryView.
/// This UIToolBar subclass has three button, Prev, Next, and Done.
public class BaseAccessoryView: UIToolbar {

	public override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		self.items = [
			UIBarButtonItem(title: "Prev", style: .plain, target: self, action: #selector(prev(_:))),
			UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:))),
			UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done(_:))),
		]
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func next(_ button: UIBarButtonItem) {
		guard
			let formView = firstResponderOfType(FormView.self),
			let editingField = formView.allTextFields.first(where: { $0.textField.isFirstResponder }) else {
				return
		}
		formView.field(after: editingField.textField)?.becomeFirstResponder()
	}

	@objc func prev(_ button: UIBarButtonItem) {
		guard
			let formView = firstResponderOfType(FormView.self),
			let editingField = formView.allTextFields.first(where: { $0.textField.isFirstResponder }) else {
				return
		}
		formView.field(before: editingField.textField)?.becomeFirstResponder()
	}

	@objc func done(_ button: UIBarButtonItem) {
		guard
			let formView = firstResponderOfType(FormView.self) else {
				return
		}
		formView.endEditing(true)
	}

	private var editingField: UITextField? {
		return firstResponderOfType(FormView.self)?.allTextFields.first(where: { $0.textField.isFirstResponder })?.textField
	}

}
