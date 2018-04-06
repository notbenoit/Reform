import Foundation
import Reform

final class ViewModel {

	let formItems: [AnyStackViewRowItem] = [
		SpacingItem(44.0).any,
		SideBySideInput(left: TextFieldInput.firstName.any, right: TextFieldInput.lastName.any).any,
		TextFieldInput().any,
		TextFieldInput().any,
		TextFieldInput().any,
		SpacingItem(20.0).any,
		]

}
