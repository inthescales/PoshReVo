import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

/// Artikolo-ĉelo montranta liston da tradukoj de unu vorto aŭ derivaĵo
final class TradukaroChelo: UITableViewCell {
	private enum Konstantoj {
		/// Kroma spaco supre kaj malsupre de la tuta ĉelo
		static let vertikalaMargheno = 12.0
		
		static let tekstGrandeco: CGFloat = 18.0
		
		/// Kroma spaco supre kal malsupre de traduk-etikedoj
		static let linioBufro: CGFloat = 1.0
	}
	
	private enum TitolStilo {
		case kursiva
		case grasKursiva
	}
	
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
		margheno horizontalaMargheno: CGFloat,
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
		
		let supraDividilo = StrekoView(koloro: stilo.dokumentaDividilo)
		contentView.addSubview(supraDividilo)
		supraDividilo.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Konstantoj.vertikalaMargheno)
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
			make.height.equalTo(1)
		}
		
		let finaElemento: UIView
		if neniujLingvoj || montrotaj.isEmpty {
			let teksto = neniujLingvoj ? Tekstoj.neniujLingvoj : Tekstoj.neniujTradukoj
			let avizo = fariAvizon(teksto: teksto, titolStilo: .kursiva, stilo: stilo)
			contentView.addSubview(avizo)
			avizo.snp.makeConstraints { make in
				make.top.equalTo(supraDividilo.snp.bottom).offset(Konstantoj.vertikalaMargheno)
				make.left.right.equalToSuperview().inset(horizontalaMargheno)
			}
			
			finaElemento = avizo
		} else {
			let avizo = fariAvizon(teksto: Tekstoj.enViajLingvoj, titolStilo: .grasKursiva, stilo: stilo)
			contentView.addSubview(avizo)
			avizo.snp.makeConstraints { make in
				make.top.equalTo(supraDividilo.snp.bottom).offset(Konstantoj.vertikalaMargheno)
				make.left.right.equalToSuperview().inset(horizontalaMargheno)
			}
			
			let staplo = fariStaplon(tradukoj: montrotaj, stilo: stilo)
			contentView.addSubview(staplo)
			staplo.snp.makeConstraints { make in
				make.top.equalTo(avizo.snp.bottom).offset(Konstantoj.vertikalaMargheno - Konstantoj.tekstGrandeco / 4)
				make.left.right.equalToSuperview().inset(horizontalaMargheno)
			}
			
			finaElemento = staplo
		}
		
		let malsupraDividilo = StrekoView(koloro: stilo.dokumentaDividilo)
		contentView.addSubview(malsupraDividilo)
		malsupraDividilo.snp.makeConstraints { make in
			make.top.equalTo(finaElemento.snp.bottom).offset(Konstantoj.vertikalaMargheno)
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
			make.height.equalTo(1)
			make.bottom.equalToSuperview().inset(Konstantoj.vertikalaMargheno)
		}
	}
		
	private func fariAvizon(teksto: String, titolStilo: TitolStilo, stilo: InterfacStilo) -> UIView {
		let etikedo = UILabel()
		etikedo.text = teksto
		switch titolStilo {
		case .kursiva:
			etikedo.font = .italicSystemFont(ofSize: Konstantoj.tekstGrandeco).dinamika() // TODO: tiparo
		case .grasKursiva:
			let priskribilo = UIFont.systemFont(ofSize: Konstantoj.tekstGrandeco).dinamika() // TODO: tiparo
				.fontDescriptor
				.withSymbolicTraits([.traitItalic, .traitBold])
			etikedo.font = UIFont(descriptor: priskribilo!, size: Konstantoj.tekstGrandeco).dinamika() // TODO: tiparo
		}
		etikedo.setContentHuggingPriority(.defaultLow, for: .horizontal)
		
		let butono = UIButton()
		butono.setTitle(Tekstoj.elekti, for: .normal)
		butono.metiDinamikanTitolon(Tekstoj.elekti, tiparo: .systemFont(ofSize: Konstantoj.tekstGrandeco))
		butono.setTitleColor(stilo.navigaciaFono, for: .normal) // TODO: Nova koloro
		butono.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		butono.addTarget(self, action: #selector(premisElekti), for: .touchUpInside)
		butono.titleEdgeInsets = .zero
		
		let ujo = UIView()

		ujo.addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.centerY.left.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
		
		ujo.addSubview(butono)
		butono.snp.makeConstraints { make in
			make.left.equalTo(etikedo.snp.right)
			make.centerY.right.equalToSuperview()
		}
		
		return ujo
	}
	
	private func fariStaplon(tradukoj: [Traduko], stilo: InterfacStilo) -> UIStackView {
		let staplo = UIStackView()
		staplo.axis = .vertical
		staplo.alignment = .fill
		
		var lingvoEtikedoj: [UILabel] = []
		
		for (i, traduko) in tradukoj.enumerated() {
			// Noto: Mi uzas TTTAttributedLabel-on ĉi tie ĉar, je grandaj tekstgrandoj, la altoj
			// de UILabel kaj TTTAttributedLabel iomete malsamas.
			let lingvoEtikedo = TTTAttributedLabel(frame: .zero)
			//TekstAtributoHelpiloj.provizi(etikedon: lingvoEtikedo, per: traduko.lingvo.adverbo + ":", tekstGrando: 18.0) // TODO: Tiparo
			lingvoEtikedo.font = .systemFont(ofSize: 18.0) // TODO: Tiparo
			lingvoEtikedo.textColor = stilo.dokumentLigilo
			lingvoEtikedo.numberOfLines = 1
			lingvoEtikedo.text = traduko.lingvo.adverbo + ":" // Faru FINE (pro TTTAttributedLabel sensencaĵo)
			lingvoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			lingvoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
			
			let difinoEtikedo = TTTAttributedLabel(frame: .zero)
			TekstAtributoHelpiloj.provizi(etikedon: difinoEtikedo, per: traduko.teksto, tekstGrando: 18.0) // TODO: Tiparo
			difinoEtikedo.textColor = stilo.dokumentaTeksto
			difinoEtikedo.numberOfLines = 0
			difinoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			difinoEtikedo.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			difinoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
			difinoEtikedo.setContentHuggingPriority(.defaultLow, for: .horizontal)
			
			let etikedujo = UIView()
			etikedujo.translatesAutoresizingMaskIntoConstraints = false
			etikedujo.backgroundColor = (i % 2 == 0) ? stilo.dokumentaFono : stilo.dokumentaAlternaFono
			[lingvoEtikedo, difinoEtikedo].forEach { etikedujo.addSubview($0) }
			
			lingvoEtikedo.snp.makeConstraints { make in
				make.top.left.equalToSuperview()
				make.bottom.lessThanOrEqualToSuperview().inset(Konstantoj.linioBufro)
			}
			
			difinoEtikedo.snp.makeConstraints { make in
				make.right.equalToSuperview()
				make.height.equalToSuperview().offset(-Konstantoj.linioBufro * 2)
				make.top.bottom.equalToSuperview().inset(Konstantoj.linioBufro)
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
