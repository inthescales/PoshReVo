import UIKit

extension UIView {
	/// Aldonas sub-vidon kaj ligas ĝiajn bordojn al tiuj de ĉi tiu vido
	func addEdgeMatchedSubview(_ view: UIView) {
		addSubview(view)
		view.snp.makeConstraints { make in
			make.edges.equalTo(self)
		}
	}
}
