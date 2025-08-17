import UIKit

import TTTAttributedLabel

/// Ĉelo enhavanta artikolajn tekstojn ĉiuspecajn
final class TekstoChelo: UITableViewCell {
	// MARK: - Interfaceroj
	
	private lazy var etikedo: TTTAttributedLabel = {
		let etikedo = TTTAttributedLabel(frame: .zero)
		etikedo.font = Tiparo.artikolaTeksto
		etikedo.numberOfLines = 0
		return etikedo
	}()
	
	// MARK: - Valorizado
	
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
		liganto: TTTAttributedLabelDelegate,
		supraMargheno: CGFloat = 0.0,
		malsupraMargheno: CGFloat = 0.0,
		horizontalaMargheno: CGFloat,
		stilo: InterfacStilo
	) {
		etikedo.textColor = stilo.dokumentaTeksto
		etikedo.delegate = liganto
		
		TekstAtributoHelpiloj.provizi(
			etikedon: etikedo,
			per: teksto,
			tiparo: Tiparo.artikolaTeksto,
			stilo: stilo
		)
		
		etikedo.snp.remakeConstraints { make in
			make.top.equalToSuperview().inset(supraMargheno)
			make.bottom.equalToSuperview().inset(malsupraMargheno)
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
		}
	}
}
