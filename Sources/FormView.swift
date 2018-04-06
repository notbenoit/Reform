import UIKit
import ReactiveSwift

public final class FormView: UIScrollView {

	public let formItems = MutableProperty<[AnyStackViewRowItem]>([])

	fileprivate let stack: UIStackView = {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.axis = .vertical
		$0.alignment = .fill
		return $0
	}(UIStackView())

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		addSubview(stack)
		stack.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
		bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
		formItems.producer.startWithValues { [weak self] in self?.set(items: $0) }
	}

}

private extension FormView {

	func set(items: [AnyStackViewRowItem]) {
		stack.subviews.forEach { $0.removeFromSuperview() }
		items.forEach { stack.addArrangedSubview($0.configuredView()) }
	}

}
