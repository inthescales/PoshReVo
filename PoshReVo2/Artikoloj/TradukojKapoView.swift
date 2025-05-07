import UIKit

final class TradukojKapoView: UICollectionReusableView {
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.textAlignment = .center
		etikedo.font = .systemFont(ofSize: 30, weight: .bold)
		etikedo.text = "Tradukoj"
		return etikedo
	}()
	
	init() {
		super.init(frame: .zero)
		
		addEdgeMatchedSubview(etikedo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
}
