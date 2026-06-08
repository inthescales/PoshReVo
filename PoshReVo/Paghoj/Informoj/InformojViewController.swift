import UIKit

import SnapKit
import TTTAttributedLabel

/// Prezentas informojn pri ReVo kaj PoŝReVo
final class InformojViewController: UIViewController {
	private enum Konstantoj {
		/// Spaco inter ekranbordo kaj paĝenhavoj
		static let margheno: CGFloat = 8.0
		
		/// Spaco inter ĉiuj du sekcioj
		static let intersekciaSpaco: CGFloat = 32.0
	}
		
	// MARK: - Interfaceroj
	
	/// Staplo da tekstelementoj
	private lazy var staplo: UIStackView = {
		let staplo = UIStackView()
		staplo.axis = .vertical
		staplo.spacing = Konstantoj.intersekciaSpaco
		return staplo
	}()
	
	/// Rulumejo kiu enhavos la staplon
	private lazy var rulumejo: UIScrollView = {
		let ejo = UIScrollView()
		ejo.showsHorizontalScrollIndicator = false
		ejo.addSubview(staplo)
		ejo.isScrollEnabled = true
		staplo.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(Konstantoj.margheno)
			make.width.equalToSuperview().offset(-Konstantoj.margheno * 2)
		}
		return ejo
	}()
	
	// MARK: - Agordoj
	
	private let stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(stilo: InterfacStilo = UzantDatumaro.komuna.stilo) {
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Tekstoj.priPoshReVo
		
		view.backgroundColor = stilo.dokumentaFono

		view.addEdgeMatchedSubview(rulumejo)
		
		// Konverti tekstojn en sekcio-modelojn
		for (titolo, teksto) in enhavoj {
			let novaSekcio = InformoSekcio(titolo: titolo, teksto: teksto, delegate: self)
			staplo.addArrangedSubview(novaSekcio)
		}
	}
	
	// MARK: - Enhavoj
	
	private let enhavoj: [(String?, String)] = {
		var enhavoj: [(String?, String)] = [
			(
				"Pri Reta Vortaro",
				"Reta Vortaro estas vortaro de Esperanto, legebla senpage sur la reto ĉe <a href=\"https://www.reta-vortaro.de/\">www.reta-vortaro.de</a>. Ĉi tiu apo kolektas kaj prezentas la difinojn kaj tradukojn kiujn ĝi enhavas, samkiel ili aperas tie.\n\nReta Vortaro estas redaktata de volontuloj. Se vi trovas eraron aŭ mankon, aŭ nur deziras kontribui, <a href=\"https://revuloj.github.io/temoj/redinfo.html\">fariĝu redaktanto</a>"
			),
			(
				"Pri Poŝa Reta Vortaro",
				"Poŝa Reta Vortaro estas programita de Robin Hill. Pliaj informoj troviĝas ĉe <a href=\"http://www.inthescales.com/projects/poshrevo_eo/\">ĉi tiu retpaĝo</a>.\n\nSe vi bezonas helpon, renkontis eraron, aŭ havas ajnaspecan komenton vi povas kontakti per retpoŝto je <a href=\"mailto:kontakto@inthescales.com\">tiu ĉi adreso</a>"
			),
			(
				"Kodaro",
				"La fontokodo de ĉi tiu aplikaĵo estas libere havebla kaj oni rajtas legi, kopii, ŝanĝi, redisdoni, kaj vendi ĝin ajnamaniere. Tiu kodo disponeblas <a href=\"https://github.com/inthescales/PoshReVo\">ĉi tie</a>, kaj estas eldonita sub la <a href=\"https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html\">Permesilo GPLv2</a>."
			),
			(
				nil,
				"<k>Poŝa Reta Vortaro, PoŝReVo © 2016-2026, Robin Hill</k>"
			)
		]
		
		// Versio-numero
		if let versioNumero = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			enhavoj.append((nil, "<k>Versio-numero " + versioNumero + "</k>"))
		}
		
		return enhavoj
	}()
}

extension InformojViewController: TTTAttributedLabelDelegate {
	// NOTU: Vidu noton ĉe ArtikoloViewController: TTTAttributedLabelDelegate
	func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
		if let url {
			UIApplication.shared.open(url)
		}
	}
}
