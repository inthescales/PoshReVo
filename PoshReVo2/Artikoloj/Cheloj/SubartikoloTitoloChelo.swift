import UIKit

final class SubartikoloTitoloChelo: UITableViewCell {
	private enum Konstantoj {
		/// Diko de la divida streko
		static let strekDiko: CGFloat = 1.0
	}
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 22, weight: .bold).dinamika()
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	private lazy var linio: UIView = {
		let linio = UIView()
		linio.snp.makeConstraints { make in
			make.height.equalTo(Konstantoj.strekDiko)
		}
		return linio
	}()
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .clear
		
		contentView.addSubview(etikedo)
		contentView.addSubview(linio)
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
		
		linio.backgroundColor = stilo.dokumentaTeksto
		
		etikedo.snp.makeConstraints { make in
			make.left.top.bottom.equalToSuperview().inset(margheno)
			// make.top.bottom.equalToSuperview()
		}
		
		linio.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().inset(margheno)
			make.left.equalTo(etikedo.snp.right).offset(margheno)
		}
	}
}
