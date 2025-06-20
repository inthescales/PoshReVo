import UIKit

import TTTAttributedLabel

final class TekstoChelo: UITableViewCell {
	private lazy var etikedo: TTTAttributedLabel = {
		let etikedo = TTTAttributedLabel(frame: .zero)
		etikedo.font = UIFont.preferredFont(forTextStyle: .body) // TODO: Tekstgrandeco
		etikedo.numberOfLines = 0
		return etikedo
	}()
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
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
		etikedo.textColor = stilo.teksto
		etikedo.delegate = liganto
		
		etikedo.linkAttributes = [
			kCTForegroundColorAttributeName : stilo.ligilo,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		etikedo.activeLinkAttributes = [
			kCTForegroundColorAttributeName : stilo.koloraFono,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		
		TekstAtributoHelpiloj.provizi(etikedon: etikedo, per: teksto)
		
		etikedo.snp.remakeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.left.right.equalToSuperview().inset(margheno)
		}
	}
}
