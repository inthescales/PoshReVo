import UIKit

import ReVoDatumbazo

final class DerivajhoChelo: UITableViewCell {
	private lazy var titoloEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 20, weight: .bold)
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	private lazy var difinoEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.numberOfLines = 0
		return etikedo
	}()
	
	// MARK: Agordoj
	
	var stilo: InterfacStilo?
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubview(titoloEtikedo)
		titoloEtikedo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		addSubview(difinoEtikedo)
		difinoEtikedo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(titoloEtikedo.snp.bottom)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(vorto: Vorto, stilo: InterfacStilo) {
		self.stilo = stilo
		
		titoloEtikedo.text = vorto.titolo
		titoloEtikedo.textColor = self.stilo?.teksto
		
		difinoEtikedo.text = vorto.teksto
		difinoEtikedo.textColor = self.stilo?.teksto
	}
}
