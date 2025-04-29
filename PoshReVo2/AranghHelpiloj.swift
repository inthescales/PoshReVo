import UIKit

extension UIView {
	func addEdgeMatchedSubview(_ view: UIView) {
		addSubview(view)
		view.snp.makeConstraints { make in
			make.edges.equalTo(self)
		}
	}
}
