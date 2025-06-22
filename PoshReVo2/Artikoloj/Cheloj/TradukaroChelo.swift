import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

final class TradukaroChelo: UITableViewCell {
	// MARK: - Agordado
	
	private var elekti: (() -> Void)?
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(
		tradukoj: [Traduko],
		tradukLingvoj: [Lingvo],
		margheno: CGFloat,
		elekti: @escaping () -> Void,
		stilo: InterfacStilo
	) {
		self.elekti = elekti
		
		// TODO: Ŝanĝu post kiam lingvo estos denove struct
		let tradukKodoj = tradukLingvoj.map { $0.kodo }
		let montrotaj = tradukoj
			.filter { tradukKodoj.contains($0.lingvo.kodo) }
		
		contentView.subviews.forEach { $0.removeFromSuperview() }
		let neniujLingvoj = tradukLingvoj.isEmpty
			|| tradukLingvoj.count == 1 && tradukLingvoj.first?.kodo == "eo"
		
		if neniujLingvoj || montrotaj.isEmpty {
			let teksto = neniujLingvoj ? Tekstoj.neniujLingvoj : Tekstoj.neniujTradukoj
			let avizo = fariAvizon(teksto: teksto, stilo: stilo)
			contentView.addSubview(avizo)
			avizo.snp.makeConstraints { make in
				make.top.bottom.equalToSuperview()
				make.left.right.equalToSuperview().inset(margheno)
			}
		} else {
			let staplo = fariStaplon(tradukoj: montrotaj, stilo: stilo)
			contentView.addSubview(staplo)
			staplo.snp.makeConstraints { make in
				make.top.bottom.equalToSuperview()
				make.left.right.equalToSuperview().inset(margheno)
			}
		}
	}
		
	private func fariAvizon(teksto: String, stilo: InterfacStilo) -> UIView {
		let etikedo = UILabel()
		etikedo.text = teksto
		etikedo.font = .italicSystemFont(ofSize: 16) // TODO: tiparo
		etikedo.setContentHuggingPriority(.defaultLow, for: .horizontal)
		
		let butono = UIButton()
		butono.setTitle(Tekstoj.elekti, for: .normal)
		butono.setTitleColor(stilo.koloraFono, for: .normal) // TODO: Nova koloro
		butono.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		butono.addTarget(self, action: #selector(premisElekti), for: .touchUpInside)
		
		let ujo = UIView()

		ujo.addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.top.bottom.left.equalToSuperview()
		}
		
		ujo.addSubview(butono)
		butono.snp.makeConstraints { make in
			make.left.equalTo(etikedo.snp.right)
			make.top.bottom.right.equalToSuperview()
		}
		
		return ujo
	}
	
	private func fariStaplon(tradukoj: [Traduko], stilo: InterfacStilo) -> UIStackView {
		let staplo = UIStackView()
		staplo.axis = .vertical
		staplo.alignment = .fill
		
		var lingvoEtikedoj: [UILabel] = []
		
		for traduko in tradukoj {
			let lingvoEtikedo = UILabel()
			lingvoEtikedo.text = traduko.lingvo.adverbo + ":"
			lingvoEtikedo.textColor = stilo.ligilo
			lingvoEtikedo.numberOfLines = 1
			lingvoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			lingvoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
			
			let difinoEtikedo = TTTAttributedLabel(frame: .zero)
			TekstAtributoHelpiloj.provizi(etikedon: difinoEtikedo, per: traduko.teksto)
			difinoEtikedo.textColor = stilo.teksto
			difinoEtikedo.numberOfLines = 0
			difinoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			difinoEtikedo.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			difinoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
			difinoEtikedo.setContentHuggingPriority(.defaultLow, for: .horizontal)
			
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
				} else {
					plejGranda.setContentHuggingPriority(.defaultHigh, for: .horizontal)
				}
			}
		}
		
		return staplo
	}
	
	// MARK: - Agoj
	
	@objc private func premisElekti() {
		elekti?()
	}
}
