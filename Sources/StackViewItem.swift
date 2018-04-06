import UIKit
import ReactiveSwift
import ReactiveCocoa

/// A StackViewRow is a UIView subclass, ready to receive an associated Item
public protocol StackViewRow: AnyObject {
	associatedtype Item: StackViewRowItem
	func set(item: Item)
}

/// A StackViewRowItem knows how to build its associated StackViewRow, and gets
/// tied to it.
public protocol StackViewRowItem {
	associatedtype View: StackViewRow where View: UIView, View.Item == Self	
	var viewFactory: () -> View { get }
}

extension StackViewRowItem {

	/// Free implementation building the StackViewRow, and associating the Item.
	///
	/// - Returns: A StackViewRow, which has been assigned its Item.
	func configuredView() -> UIView {
		let view = viewFactory()
		view.set(item: self)
		return view as UIView
	}

}

/// A type erased StackViewRowItem
public struct AnyStackViewRowItem {

	/// View factory
	public let configuredView: () -> UIView

	public init<Item: StackViewRowItem>(_ item: Item) {
		configuredView = item.configuredView
	}
}

public extension StackViewRowItem {

	var any: AnyStackViewRowItem { return AnyStackViewRowItem(self) }

}
