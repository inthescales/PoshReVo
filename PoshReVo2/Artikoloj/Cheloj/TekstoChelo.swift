import UIKit

import TTTAttributedLabel

final class TekstoChelo: UITableViewCell {
	private lazy var etikedo: TTTAttributedLabel = {
		let etikedo = TTTAttributedLabel(frame: .zero)
		etikedo.font = Tiparo.artikolaTeksto
		etikedo.numberOfLines = 0
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
		liganto: TTTAttributedLabelDelegate,
		margheno: CGFloat,
		stilo: InterfacStilo
	) {
		etikedo.textColor = stilo.dokumentaTeksto
		etikedo.delegate = liganto
		
		etikedo.linkAttributes = [
			kCTForegroundColorAttributeName : stilo.dokumentLigilo,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		etikedo.activeLinkAttributes = [
			kCTForegroundColorAttributeName : stilo.dokumentLigiloPremita,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		
		TekstAtributoHelpiloj.provizi(etikedon: etikedo, per: teksto, tiparo: Tiparo.artikolaTeksto)
		
		etikedo.snp.remakeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.left.right.equalToSuperview().inset(margheno)
		}
	}
}
