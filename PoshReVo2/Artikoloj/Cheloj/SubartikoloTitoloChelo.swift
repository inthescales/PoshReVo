import UIKit

final class SubartikoloTitoloChelo: UITableViewCell {
	private enum Konstantoj {
		static let linioDikeco: CGFloat = 1.0
		static let linioFlankoSpaco: CGFloat = 4.0
	}
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 20, weight: .bold)
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	private lazy var linio: UIView = {
		let linio = UIView()
		linio.snp.makeConstraints { make in
			make.height.equalTo(Konstantoj.linioDikeco)
		}
		return linio
	}()
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.left.top.bottom.equalToSuperview()
		}
		
		contentView.addSubview(linio)
		linio.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().offset(-Konstantoj.linioFlankoSpaco)
			make.left.equalTo(etikedo.snp.right).offset(Konstantoj.linioFlankoSpaco)
		}
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
		
		linio.backgroundColor = stilo.teksto
	}
}
