import UIKit

final class DerivajhTitoloChelo: UITableViewCell {
	private enum Konstantoj {
		static let supraMargheno: CGFloat = 8.0
		
		static let malsupraMargheno: CGFloat = 16.0
	}
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = Tiparo.derivajhaTitolo
		etikedo.numberOfLines = 0
		return etikedo
	}()
	
	private lazy var dividilo: UIView = {
		let dividilo = UIView()
		dividilo.translatesAutoresizingMaskIntoConstraints = false
		return dividilo
	}()
	
	// MARK: - Valorizado
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .clear
		
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
		etikedo.textColor = stilo.dokumentaTeksto
		etikedo.snp.remakeConstraints { make in
			make.top.equalToSuperview().inset(Konstantoj.supraMargheno)
			make.left.right.equalToSuperview().offset(margheno)
		}
		
		dividilo.backgroundColor = stilo.dokumentaDividilo
		dividilo.snp.remakeConstraints { make in
			make.top.equalTo(etikedo.snp.bottom)
			make.left.right.equalToSuperview().inset(margheno).priority(.low)
			make.bottom.equalToSuperview().inset(Konstantoj.malsupraMargheno)
			make.height.equalTo(1)
		}
	}
}
