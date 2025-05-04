import UIKit

import ReVoDatumbazo

final class ArtikolTekstoChelo: UITableViewCell {
	private lazy var tekstoEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.numberOfLines = 0
		return etikedo
	}()
	
	// MARK: Agordoj
	
	var stilo: InterfacStilo?
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addEdgeMatchedSubview(tekstoEtikedo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(teksto: String, stilo: InterfacStilo) {
		self.stilo = stilo
		
		tekstoEtikedo.text = teksto
		tekstoEtikedo.textColor = self.stilo?.teksto
	}
}
