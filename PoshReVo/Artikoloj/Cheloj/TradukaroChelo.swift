import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

/// Artikolo-ĉelo montranta liston da tradukoj de unu vorto aŭ derivaĵo
final class TradukaroChelo: UITableViewCell {
	private enum Konstantoj {
		/// Kroma spaco supre kaj malsupre de la tuta ĉelo
		static let vertikalaMargheno = 12.0
		
		/// Kroma spaco supre kal malsupre de traduk-etikedoj
		static let linioBufro: CGFloat = 1.0
	}
	
	/// Kia koloro la ĉeltitola etikedo havu
	private enum TitolKoloro {
		case forta
		case malforta
	}
	
	/// Kia tekststilo la ĉeltitola etikedo havu
	private enum TitolStilo {
		case kursiva
		case grasKursiva
	}
	
	// MARK: - Agordado
	
	/// Fermo vokata kiam la uzanto premas la elekto-butono
	private var elekti: (() -> Void)?
	
	// MARK: - Valorizado
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: - Agoj
	
	@objc private func premisElekti() {
		elekti?()
	}
	
	// MARK: - Interfaco-starigado
	
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
		let montrotaj = tradukoj.filter { tradukKodoj.contains($0.lingvo.kodo) }
		
		// Ĉu la uzanto havas traduklingvojn
		let neniujLingvoj = tradukLingvoj.isEmpty
		|| (tradukLingvoj.count == 1 && tradukLingvoj.first?.kodo == Lingvo.esperantaKodo)
		
		// Forigi ĉiujn antaŭajn interfacerojn
		contentView.subviews.forEach { $0.removeFromSuperview() }
		
		// Aldoni supran dividilon
		let supraDividilo = StrekaroView(koloro: stilo.dokumentaDividilo)
		contentView.addSubview(supraDividilo)
		supraDividilo.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Konstantoj.vertikalaMargheno)
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
			make.height.equalTo(1)
		}
		
		// Fari kaj aranĝi enhavojn
		let enhavoj = fariEnhavoj(
			montrotaj: montrotaj,
			neniujLingvoj: neniujLingvoj,
			horizontalaMargheno: horizontalaMargheno,
			stilo: stilo
		)
		
		if let komencaElemento = enhavoj.first {
			komencaElemento.snp.makeConstraints { make in
				make.top.equalTo(supraDividilo.snp.bottom).offset(Konstantoj.vertikalaMargheno)
			}
		}
		let finaElemento = enhavoj.last ?? supraDividilo
		
		// Aldoni malsupran dividilon
		let malsupraDividilo = StrekaroView(koloro: stilo.dokumentaDividilo)
		contentView.addSubview(malsupraDividilo)
		malsupraDividilo.snp.makeConstraints { make in
			make.top.equalTo(finaElemento.snp.bottom).offset(Konstantoj.vertikalaMargheno)
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
			make.height.equalTo(1)
			make.bottom.equalToSuperview().inset(Konstantoj.vertikalaMargheno)
		}
	}
	
	/// Faras kaj liveras paĝenhavoj laŭ la argumentoj
	private func fariEnhavoj(
		montrotaj: [Traduko],
		neniujLingvoj: Bool,
		horizontalaMargheno: CGFloat,
		stilo: InterfacStilo
	) -> [UIView] {
		if neniujLingvoj || montrotaj.isEmpty {
			return fariSentradukajEnhavoj(
				neniujLingvoj: neniujLingvoj,
				horizontalaMargheno: horizontalaMargheno,
				stilo: stilo
			)
		} else {
			return fariTradukaron(
				montrotaj: montrotaj,
				horizontalaMargheno: horizontalaMargheno,
				stilo:stilo
			)
		}
	}
	
	/// Faras kaj liveras tiujn ĉelenhavojn taŭgajn kiam estas neniuj montreblaj tradukoj
	private func fariSentradukajEnhavoj(
		neniujLingvoj: Bool,
		horizontalaMargheno: CGFloat,
		stilo: InterfacStilo
	) -> [UIView] {
		let teksto = neniujLingvoj ? Tekstoj.neniujLingvoj : Tekstoj.neniujTradukoj
		let avizo = fariKapon(
			teksto: teksto,
			koloro: .malforta,
			titolStilo: .kursiva,
			stilo: stilo
		)
		contentView.addSubview(avizo)
		avizo.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
		}
		return [avizo]
	}
	
	/// Faras kaj liveras ĉelenhavojn taŭgaj kiam estas tradukoj montrindaj
	private func fariTradukaron(
		montrotaj: [Traduko],
		horizontalaMargheno: CGFloat,
		stilo: InterfacStilo
	) -> [UIView] {
		let avizo = fariKapon(
			teksto: Tekstoj.enViajLingvoj,
			koloro: .forta,
			titolStilo: .grasKursiva,
			stilo: stilo
		)
		contentView.addSubview(avizo)
		avizo.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
		}
		
		let staplo = fariTradukoStaplon(tradukoj: montrotaj, stilo: stilo)
		contentView.addSubview(staplo)
		staplo.snp.makeConstraints { make in
			make.top.equalTo(avizo.snp.bottom).offset(Konstantoj.vertikalaMargheno - Tiparo.tradukaLingvo.pointSize / 4)
			make.left.right.equalToSuperview().inset(horizontalaMargheno)
		}
		return [avizo, staplo]
	}
	
	// MARK: - Interfacero-farado
	
	/// Faras kaj liveras ĉelkapon — informan etikedon kaj lingvelektan butonon
	private func fariKapon(
		teksto: String,
		koloro: TitolKoloro,
		titolStilo: TitolStilo,
		stilo: InterfacStilo
	) -> UIView {
		// Fari etikedon
		
		let etikedo = UILabel()
		etikedo.text = teksto
		etikedo.setContentHuggingPriority(.defaultLow, for: .horizontal)
		
		switch koloro {
		case .forta:
			etikedo.textColor = stilo.dokumentaTeksto
		case .malforta:
			etikedo.textColor = stilo.dokumentaMalfortaTeksto
		}
		
		switch titolStilo {
		case .kursiva:
			etikedo.font = Tiparo.tradukaroEtikedoMalforta
		case .grasKursiva:
			etikedo.font = Tiparo.tradukaroEtikedoForta
		}
		
		// Fari butonon
		
		let butono = UIButton()
		butono.setTitle(Tekstoj.elekti, for: .normal)
		butono.metiDinamikanTitolon(Tekstoj.elekti, tiparo: Tiparo.tradukaElektiButono)
		butono.setTitleColor(stilo.dokumentLigilo, for: .normal)
		butono.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		butono.addTarget(self, action: #selector(premisElekti), for: .touchUpInside)
		butono.titleEdgeInsets = .zero
		
		// Kunigi kaj liveri
		
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
	
	/// Faras kaj liveras staplon da tradukoj, kun lingvaj etikedoj
	private func fariTradukoStaplon(tradukoj: [Traduko], stilo: InterfacStilo) -> UIStackView {
		let staplo = UIStackView()
		staplo.axis = .vertical
		staplo.alignment = .fill
		
		var lingvoEtikedoj: [UILabel] = []
		
		for (i, traduko) in tradukoj.enumerated() {
			// Fari lingvoetikedon
			
			// Noto: Mi uzas TTTAttributedLabel-on ĉi tie ĉar, je grandaj tekstgrandoj, la altoj
			// de UILabel kaj TTTAttributedLabel iomete malsamas.
			let lingvoEtikedo = TTTAttributedLabel(frame: .zero)
			lingvoEtikedo.font = Tiparo.tradukaLingvo
			lingvoEtikedo.textColor = stilo.dokumentSencNumero
			lingvoEtikedo.numberOfLines = 1
			lingvoEtikedo.text = traduko.lingvo.adverbo + ":" // Faru FINE (pro TTTAttributedLabel sensencaĵo)
			lingvoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			lingvoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
			
			// Fari difinoetikedon
			
			let difinoEtikedo = TTTAttributedLabel(frame: .zero)
			TekstAtributoHelpiloj.provizi(
				etikedon: difinoEtikedo,
				per: traduko.teksto,
				tiparo: Tiparo.tradukaSignifo,
				stilo: stilo
			)
			difinoEtikedo.textColor = stilo.dokumentaTeksto
			difinoEtikedo.numberOfLines = 0
			difinoEtikedo.translatesAutoresizingMaskIntoConstraints = false
			difinoEtikedo.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			difinoEtikedo.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
			difinoEtikedo.setContentHuggingPriority(.defaultLow, for: .horizontal)
			
			// Kunigi vidojn
			
			let etikedujo = UIView()
			etikedujo.translatesAutoresizingMaskIntoConstraints = false
			etikedujo.backgroundColor = (i % 2 == 0) ? stilo.dokumentaFono : stilo.dokumentaAlternaFono
			[lingvoEtikedo, difinoEtikedo].forEach { etikedujo.addSubview($0) }
			
			lingvoEtikedo.snp.makeConstraints { make in
				make.left.equalToSuperview()
				make.top.equalToSuperview().inset(Konstantoj.linioBufro)
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
		
		// Ni deziras ke ĉiuj lingvo-etikedoj havu la saman larĝon, por ke la tradukoj
		// estu aranĝitaj laŭ linio maldekstre. Do ni trovas la plej larĝan, kaj fiksas ĉiujn aliajn
		// larĝojn laŭ tiu.
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
}
