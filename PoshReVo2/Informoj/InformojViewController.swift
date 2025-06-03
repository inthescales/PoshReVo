import UIKit

import SnapKit
import TTTAttributedLabel

/// Prezentas informojn pri ReVo kaj PoŝReVo
final class InformojViewController: UIViewController {
	private enum Konstantoj {
		/// Spaco inter titolo kaj ĉefteksto en ĉiuj sekcio
		static let intertekstaSpaco: CGFloat = 4.0
		
		/// Spaco inter ĉiuj du sekcioj
		static let intersekciaSpaco: CGFloat = 16.0
	}
	
	private class SekcioView: UIView {
		private lazy var titolEtikedo: UILabel = {
			let etikedo = UILabel()
			etikedo.numberOfLines = 0
			return etikedo
		}()
		
		private lazy var tekstejo: TTTAttributedLabel = {
			let etikedo = TTTAttributedLabel(frame: .zero)
			etikedo.numberOfLines = 0
			return etikedo
		}()
		
		init(titolo: String?, teksto: String, delegate: TTTAttributedLabelDelegate) {
			super.init(frame: .zero)
			
			var stilo = InterfacStilo.nuna
			if let titolo {
				titolEtikedo.text = titolo
				titolEtikedo.font = .systemFont(ofSize: 20, weight: .bold)
				titolEtikedo.textColor = stilo.teksto
				
				addSubview(titolEtikedo)
				titolEtikedo.snp.makeConstraints { make in
					make.top.left.right.equalToSuperview()
				}
				addSubview(tekstejo)
				tekstejo.snp.makeConstraints { make in
					make.left.right.bottom.equalToSuperview()
					make.top.equalTo(titolEtikedo.snp.bottom).offset(Konstantoj.intertekstaSpaco)
				}
			} else {
				addEdgeMatchedSubview(tekstejo)
			}
			
			tekstejo.textColor = stilo.teksto
			tekstejo.delegate = delegate
			TekstAtributoHelpiloj.provizi(etikedon: tekstejo, per: teksto)
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) ne realas")
		}
	}
	
	// MARK: - Interfaceroj
	
	private lazy var staplo: UIStackView = {
		let staplo = UIStackView()
		staplo.axis = .vertical
		staplo.spacing = Konstantoj.intersekciaSpaco
		return staplo
	}()
	
	// MARK: - Agordoj
	
	var stilo: InterfacStilo
	
	init(stilo: InterfacStilo = .nuna) {
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = stilo.senkoloraFono

		view.addSubview(staplo)
		staplo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		var enhavoj: [(String?, String)] = [
			(
				"Pri ReVo",
				"Reta Vortaro estas vortaro de Esperanto, legebla senpage sur la reto ĉe <a href=\"https://www.reta-vortaro.de/\">www.reta-vortaro.de</a>. Ĉi-apo kolektas kaj prezentas la difinojn kaj tradukojn kiujn ĝi enhavas, samkiel ili aperas tie.\n\nReta Vortaro estas redaktata de volontuloj. Se vi trovas eraron aŭ mankon, aŭ nur deziras kontribui, <a href=\"https://revuloj.github.io/temoj/redinfo.html\">fariĝu redaktanto</a>"
			),
			(
				"Pri PoŝReVo",
				"Poŝa Reta Vortaro estas programita de Robin Hill. Pliaj informoj troviĝas ĉe <a href=\"http://www.inthescales.com/projects/poshrevo_eo/\">ĉi tiu retpaĝo</a>.\n\nSe vi bezonas helpon, renkontis eraron, aŭ havas ajnaspecan komenton vi povas kontakti per retpoŝto je <a href=\"mailto:kontakto@inthescales.com\">tiu ĉi adreso</a>"
			),
			(
				"Kodaro",
				"La fontokodo de ĉi tiu aplikaĵo estas libere havebla kaj oni rajtas legi, kopii, ŝanĝi, redisdoni, kaj vendi ĝin ajnamaniere. Tiu kodo disponeblas <a href=\"https://github.com/inthescales/PoshReVo\">ĉi tie</a>, kaj estas eldonita sub la <a href=\"https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html\">Permesilo GPLv2</a>."
			),
			(
				nil,
				"<i>Poŝa Reta Vortaro, PoŝReVo © 2016-2025, Robin Hill</i>"
			)
		]
		
		if let versioNumero = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			enhavoj.append((nil, "<i>Versio-numero " + versioNumero + "</i>"))
		}
		
		for (titolo, teksto) in enhavoj {
			let novaSekcio = SekcioView(titolo: titolo, teksto: teksto, delegate: self)
			staplo.addArrangedSubview(novaSekcio)
		}
	}
}

extension InformojViewController: TTTAttributedLabelDelegate {
	// NOTU: Vidu noton ĉe ArtikoloViewController: TTTAttributedLabelDelegate
	func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
		if let url {
			UIApplication.shared.open(url)
		}
	}
}
