import UIKit
import ReactiveSwift

public struct SpacingItem: StackViewRowItem {

	let height: CGFloat

	public init(_ height: CGFloat) {
		self.height = height
	}

	public var viewFactory: () -> SpacingView = { return SpacingView() }
}

public class SpacingView: UIView, StackViewRow {

	private var height: CGFloat = 0

	public func set(item: SpacingItem) {
		self.height = item.height
		layoutIfNeeded()
	}

	public override var intrinsicContentSize: CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: height)
	}

}
