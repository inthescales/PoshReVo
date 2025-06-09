import UIKit

final class DerivajhTitoloChelo: UITableViewCell {
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 20, weight: .bold)
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addEdgeMatchedSubview(etikedo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(
		teksto: String,
		stilo: InterfacStilo
	) {
		etikedo.text = teksto
		etikedo.textColor = stilo.teksto
	}
}
