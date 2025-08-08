import UIKit

final class SubartikoloTitoloChelo: UITableViewCell {
	private enum Konstantoj {
		/// Diko de la divida streko
		static let strekDiko: CGFloat = 1.0
	}
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = Tiparo.subartikolaTitolo
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .clear
		
		contentView.addSubview(etikedo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(
		teksto: String,
		margheno: CGFloat,
		stilo: InterfacStilo
	) {
		etikedo.text = teksto
		etikedo.textColor = stilo.dokumentaTeksto
		
		etikedo.snp.remakeConstraints { make in
			make.edges.equalToSuperview().inset(margheno)
		}
	}
}
