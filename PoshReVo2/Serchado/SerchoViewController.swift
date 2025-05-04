import UIKit

import ReVoDatumbazo

final class SerchoViewController: UIViewController {
	private enum Konstantoj {
		/// Maksimuma kvanto da serĉrezultoj prezentotaj
		static let serchLimo = 32
	}
	
	// MARK: Interfaceroj
	
	private lazy var serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiVortonAuFrazon,
		iksumi: true, // TODO: Nur se neesperanta lingvo uziĝas
		tekstoShanghighis: { [weak self] teksto in
			self?.tajpis(tekston: teksto)
		}
	)
	
	private lazy var lingvoBreto: LingvoBretoViewController = {
		LingvoBretoViewController(
			lingvoj: [],
			elektisLingvon: { lingvo in },
			redaktisLingvojn: { lingvoj in }
		)
	}()
	
	private lazy var rezultoTabelo: VortoListoViewController = {
		return VortoListoViewController(elektis: elektis)
	}()
	
	// MARK: Stato
	
	/// Stato de la nune-prezentita serĉo
	private var serchStato: SerchStato?
	
	/// Datumoj pri la lasta serĉo antaŭ la nuna
	private var lastaSercho: (Lingvo, String)? = nil
	
	// MARK: Agordoj
	
	private var kunordigilo: Kunordigilo
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		serchLingvoj: [Lingvo],
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = .nuna
	) {
		self.kunordigilo = kunordigilo
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
		
		lingvoBreto.ghisdatigi(lingvojn: serchLingvoj)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.backgroundColor = stilo.koloraFono
		
		view.addSubview(serchilo)
		serchilo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		addChild(lingvoBreto)
		view.addSubview(lingvoBreto.view)
		lingvoBreto.view.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(serchilo.snp.bottom)
		}
		
		addChild(rezultoTabelo)
		view.addSubview(rezultoTabelo.view)
		rezultoTabelo.view.snp.makeConstraints { make in
			make.top.equalTo(lingvoBreto.view.snp.bottom)
			make.left.right.bottom.equalToSuperview()
		}
	}
	
	// MARK: Interagado
	
	private func tajpis(tekston teksto: String) {
		if !teksto.isEmpty {
			fariSerchon(teksto: teksto)
		} else {
			serchStato = nil
			lastaSercho = nil
			rezultoTabelo.montri(listerojn: [])
		}
	}
	
	private func elektis(_ listero: VortoListoViewController.Listero) {
		if listero.destinoj.count == 1,
		   let destino = listero.destinoj.first {
			let pagho = kunordigilo.fariArtikoloPaghon(el: destino)
			navigationController?.pushViewController(pagho, animated: true)
		} else if listero.destinoj.count > 1 {
			let disigilo = kunordigilo.fariDisigiloPaghon(
				por: listero.destinoj,
				elektis: { [weak self] destino in
					guard let self else { return }
					
					let pagho = kunordigilo.fariArtikoloPaghon(el: destino)
					navigationController?.pushViewController(pagho, animated: true)
				}
			)
			navigationController?.pushViewController(disigilo, animated: true)
		}
	}
	
	// MARK: Serĉado
	
	private func fariSerchon(teksto: String) {
		guard let serchLingvo = lingvoBreto.elektita else {
			return
		}
		
		let novaSercho = serchLingvo != lastaSercho?.0 || teksto != lastaSercho?.1
		if novaSercho {
			let novaStato = VortaroDatumbazo.komuna.komenciSerchon(
				lingvo: serchLingvo,
				teksto: teksto,
				komenco: 0,
				limo: Konstantoj.serchLimo
			)
			
			serchStato = novaStato
			lastaSercho = (serchLingvo, teksto)
			rezultoTabelo.montri(listerojn: tabeloListeroj(por: novaStato))
		}
	}
	
	private func venigiPli() {
		if let stato = serchStato, !stato.atingisFinon {
			let novaStato = VortaroDatumbazo.komuna.daurigiSerchon(
				stato: stato,
				limo: Konstantoj.serchLimo
			)
			
			serchStato = novaStato
			DispatchQueue.main.async { [weak self] in
				guard let self else {
					return
				}
				
				rezultoTabelo.montri(listerojn: tabeloListeroj(por: novaStato))
			}
		}
	}
	
	// MARK: Helpiloj
	
	func tabeloListeroj(por stato: SerchStato) -> [VortoListoViewController.Listero] {
		stato.rezultoj.map { rezulto in
			VortoListoViewController.Listero(
				teksto: rezulto.teksto,
				subteksto: tekstoPorDestinoj(destinoj: rezulto.destinoj),
				destinoj: rezulto.destinoj
			)
		}
	}
	
	/// Teksto mentrota kiel rezult-listera subteksto
	func tekstoPorDestinoj(destinoj: [Destino]) -> String? {
		if destinoj.count == 1,
		   let destino = destinoj.first {
			var teksto = destino.subteksto?.components(separatedBy: ", ").first ?? ""
			
			if let senco = destino.senco,
			   senco != "0",
			   let indico = TekstHelpiloj.indico(por: senco) {
				teksto += indico
			}
			
			return teksto
		} else if destinoj.count > 1 {
			return String(destinoj.count) + " rezultoj"
		}
		
		return nil
	}
}
