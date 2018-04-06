import Foundation

public class InputFormatter {

	let format: (String) -> String

	init(_ format: @escaping (String) -> String) {
		self.format = format
	}

}

extension InputFormatter {

	public static var uppercase: InputFormatter {
		return InputFormatter { $0.uppercased() }
	}

	public static var none: InputFormatter {
		return InputFormatter { $0 }
	}

}

func +(lhs: InputFormatter, rhs: InputFormatter) -> InputFormatter {
	return InputFormatter { input in
		rhs.format(lhs.format(input))
	}
}
