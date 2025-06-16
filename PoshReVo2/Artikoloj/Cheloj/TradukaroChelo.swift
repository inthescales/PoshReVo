import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

final class TradukaroChelo: UITableViewCell {
	private lazy var staplo: UIStackView = {
		let staplo = UIStackView()
		staplo.axis = .vertical
		staplo.alignment = .fill
		return staplo
	}()

	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)		
		 contentView.addEdgeMatchedSubview(staplo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(
		tradukoj: [Traduko],
		liganto: TTTAttributedLabelDelegate,
		stilo: InterfacStilo
	) {
		staplo.arrangedSubviews.forEach {
			staplo.removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
		
		var lingvoEtikedoj: [UILabel] = []
		
		for traduko in tradukoj {
			let lingvoEtikedo = UILabel()
			lingvoEtikedo.text = traduko.lingvo.adverbo + ":"
			lingvoEtikedo.textColor = stilo.ligilo
			lingvoEtikedo.numberOfLines = 1
			lingvoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			lingvoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
			
			let difinoEtikedo = TTTAttributedLabel(frame: .zero)
			// difinoEtikedo.text = traduko.teksto
			TekstAtributoHelpiloj.provizi(etikedon: difinoEtikedo, per: traduko.teksto)
			difinoEtikedo.textColor = stilo.teksto
			difinoEtikedo.numberOfLines = 0
			difinoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			difinoEtikedo.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			difinoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
			
			let etikedujo = UIView()
			etikedujo.translatesAutoresizingMaskIntoConstraints = false
			[lingvoEtikedo, difinoEtikedo].forEach { etikedujo.addSubview($0) }
			
			lingvoEtikedo.snp.makeConstraints { make in
				make.top.left.equalToSuperview()
				make.bottom.lessThanOrEqualToSuperview()
			}
			
			difinoEtikedo.snp.makeConstraints { make in
				make.top.right.bottom.height.equalToSuperview()
				make.left.equalTo(lingvoEtikedo.snp.right).offset(12)
			}
			
			staplo.addArrangedSubview(etikedujo)
			lingvoEtikedoj.append(lingvoEtikedo)
		}
		
		if let plejGranda = lingvoEtikedoj.max(by: { $0.intrinsicContentSize.width < $1.intrinsicContentSize.width }) {
			for etikedo in lingvoEtikedoj {
				if etikedo != plejGranda {
					etikedo.snp.makeConstraints { make in
						make.width.equalTo(plejGranda)
					}
				}
			}
		}
	}
}
