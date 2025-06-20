import UIKit

final class DerivajhTitoloChelo: UITableViewCell {
	private enum Konstantoj {
		static let subaSpaco: CGFloat = 8.0
	}
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 24, weight: .bold) // TODO: Tiparo
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	private lazy var dividilo: UIView = {
		let dividilo = UIView()
		dividilo.translatesAutoresizingMaskIntoConstraints = false
		return dividilo
	}()
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(etikedo)
		contentView.addSubview(dividilo)
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
		etikedo.textColor = stilo.teksto
		etikedo.snp.remakeConstraints { make in
			make.top.equalToSuperview()
			make.left.equalToSuperview().offset(margheno)
		}
		
		dividilo.backgroundColor = stilo.tekstDividilo
		dividilo.snp.remakeConstraints { make in
			make.top.equalTo(etikedo.snp.bottom)
			make.left.right.equalToSuperview().inset(margheno).priority(.low)
			make.bottom.equalToSuperview().inset(Konstantoj.subaSpaco)
			make.height.equalTo(1)
		}
	}
}
