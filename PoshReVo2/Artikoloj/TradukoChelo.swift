import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

final class TradukoChelo: UITableViewCell {
	private lazy var titoloEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 20, weight: .bold)
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	private lazy var difinoEtikedo: TTTAttributedLabel = {
		let etikedo = TTTAttributedLabel(frame: .zero)
		etikedo.numberOfLines = 0
		
		return etikedo
	}()
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(titoloEtikedo)
		titoloEtikedo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		contentView.addSubview(difinoEtikedo)
		difinoEtikedo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(titoloEtikedo.snp.bottom)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(
		traduko: Traduko,
		liganto: TTTAttributedLabelDelegate,
		stilo: InterfacStilo
	) {
		titoloEtikedo.text = traduko.lingvo.nomo
		titoloEtikedo.textColor = stilo.teksto
		
		difinoEtikedo.textColor = stilo.teksto
		difinoEtikedo.delegate = liganto
		
		difinoEtikedo.linkAttributes = [
			kCTForegroundColorAttributeName : stilo.teksto,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		difinoEtikedo.activeLinkAttributes = [
			kCTForegroundColorAttributeName : stilo.koloraFono,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		
		TekstAtributoHelpiloj.provizi(etikedon: difinoEtikedo, per: traduko.teksto)
	}
}
