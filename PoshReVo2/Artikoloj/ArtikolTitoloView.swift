import UIKit

import ReVoDatumbazo

final class ArtikolTitoloView: UIView {
	private enum Konstantoj {
		static let margheno: CGFloat = 16
	}
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.text = artikolo.titolo
		etikedo.font = .systemFont(ofSize: 30, weight: .bold)
		etikedo.textColor = stilo.teksto
		return etikedo
	}()
	
	// MARK: Agordoj
	
	private let artikolo: Artikolo
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		artikolo: Artikolo,
		stilo: InterfacStilo
	) {
		self.artikolo = artikolo
		self.stilo = stilo
		super.init(frame: .zero)
		
		backgroundColor = self.stilo.senkoloraFono
		
		addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.top.bottom.left.equalToSuperview().inset(Konstantoj.margheno)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
}
