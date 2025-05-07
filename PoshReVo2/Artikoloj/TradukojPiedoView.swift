import UIKit

import ReVoDatumbazo

final class TradukojPiedoView: UICollectionReusableView {
	private lazy var butono: UIButton = {
		let butono = UIButton()
		butono.setTitleColor(stilo.koloraFono, for: .normal) // TODO: Plibonigi
		butono.layer.borderWidth = 2
		butono.layer.cornerRadius = 4
		butono.setTitle(Tekstoj.montriPliajnLingvoj, for: .normal)
		butono.addTarget(self, action: #selector(premisButonon), for: .touchUpInside)
		return butono
	}()
	
	// MARK: Agordoj
	
	private let ago: () ->()
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		ago: @escaping () -> (),
		stilo: InterfacStilo
	) {
		self.ago = ago
		self.stilo = stilo
		super.init(frame: .zero)
		
		addEdgeMatchedSubview(butono)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	@objc private func premisButonon() {
		ago()
	}
}
