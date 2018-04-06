import UIKit
import Reform
import ReactiveSwift

class ViewController: UIViewController {

	@IBOutlet var formView: FormView!

	let viewModel = ViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		formView.formItems.value = viewModel.formItems
	}

}

struct TextFieldInput: FormItem {

	let viewFactory: () -> TextFieldInputView = { return TextFieldInputView() }
	let keyboardAttributes: KeyboardAttributes
	let text: ValidatingProperty<String, InputValidation.Error>
	let placeholder: String?
	let formatter: InputFormatter?
	var inputView: UIView?
	let accessoryView: UIView? = BaseAccessoryView()

	init(
		initial: String = "",
		placeholder: String? = nil,
		keyboardAttributes: KeyboardAttributes = KeyboardAttributes(),
		formatter: InputFormatter? = nil,
		validate: @escaping (String) -> ValidatingProperty<String, InputValidation.Error>.Decision = InputValidation.checkNothing()) {
		self.keyboardAttributes = KeyboardAttributes()
		self.text = ValidatingProperty(initial, validate)
		self.formatter = formatter
		self.placeholder = placeholder
	}
}

extension TextFieldInput {

	static var firstName: TextFieldInput {
		return TextFieldInput(
			initial: "",
			placeholder: "First Name",
			keyboardAttributes: KeyboardAttributes.name,
			validate: InputValidation.checkMinLength(1))
	}

	static var lastName: TextFieldInput {
		return TextFieldInput(
			initial: "Jean",
			placeholder: "Last Name",
			keyboardAttributes: KeyboardAttributes.name,
			formatter: InputFormatter.uppercase,
			validate: InputValidation.checkMinLength(1))
	}
}

final class TextFieldInputView: UIView, FormItemView {

	typealias Item = TextFieldInput

	private let model = MutableProperty<TextFieldInput?>(nil)
	private lazy var readOnlyModel = Property(model)
	private lazy var underline: UIView = {
		$0.backgroundColor = .lightGray
		self.addSubview($0)
		return $0
	}(UIView())
	let textField = UITextField()

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(textField)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		textField.frame = bounds.insetBy(dx: 20.0, dy: 2.0)
		underline.frame = CGRect(x: 20.0, y: bounds.maxY - 1, width: bounds.maxX - 40, height: 1.0)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: 44.0)
	}
	
}

// MARK: - SideBySide
struct SideBySideInput: StackViewRowItem {
	
	let viewFactory: () -> SideBySideInputView = { return SideBySideInputView() }
	let left: AnyStackViewRowItem
	let right: AnyStackViewRowItem
}

final class SideBySideInputView: UIView, StackViewRow {

	lazy var stackView: UIStackView = {
		let ret = UIStackView()
		ret.translatesAutoresizingMaskIntoConstraints = false
		ret.distribution = .fillEqually
		ret.alignment = .fill
		ret.axis = .horizontal
		ret.spacing = 0
		addSubview(ret)
		ret.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		ret.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		ret.topAnchor.constraint(equalTo: topAnchor).isActive = true
		ret.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		return ret
	}()

	func set(item: SideBySideInput) {
		stackView.subviews.forEach { $0.removeFromSuperview() }
		stackView.addArrangedSubview(item.left.configuredView())
		stackView.addArrangedSubview(item.right.configuredView())
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: 44.0)
	}

}
