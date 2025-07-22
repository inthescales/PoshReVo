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
		iksumi: serchLingvo?.estasEsperanto ?? false,
		tekstoShanghighis: { [weak self] teksto in
			self?.farisPeton(teksto: teksto, serchLingvo: self?.serchLingvo)
		}
	)
	
	private lazy var lingvoBreto: LingvoBretoViewController = {
		kunordigilo.fariLingvoBreton(
			elektisLingvon: { [weak self] lingvo in
				self?.serchilo.iksumi = self?.serchLingvo?.estasEsperanto ?? false
				self?.farisPeton(teksto: self?.serchTeksto, serchLingvo: lingvo)
			},
			redaktisLingvojn: { [weak self] lingvoj in
				self?.farisPeton(
					teksto: self?.serchTeksto,
					serchLingvo: self?.serchLingvo
				)
				// TODO: Enfokusigi serĉilonb
			}
		)
	}()
	
	private lazy var rezultoTabelo: VortoListoViewController = {
		return VortoListoViewController<Serchlistero>(
			elektis: elektis,
			alvenasFinon: venigiPli
		)
	}()
	
	// MARK: Stato
	
	private var serchTeksto: String? {
		serchilo.teksto
	}
	
	private var serchLingvo: Lingvo? {
		lingvoBreto.elektita
	}
	
	/// Stato de la nune-prezentita serĉo
	private var serchStato: SerchStato?
	
	/// Datumoj pri la lasta serĉo antaŭ la nuna
	private var lastaSercho: (Lingvo, String)? = nil
	
	/// Ĉu la paĝo jam aperis al la uzanto
	private var jamAperis = false
	
	// MARK: Agordoj
	
	/// Ĉu ĉi-paĝo komencis serĉfadenon
	let radika: Bool
	
	private var kunordigilo: Kunordigilo
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		serchLingvoj: [Lingvo],
		radika: Bool = false,
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.radika = radika
		self.kunordigilo = kunordigilo
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
		view.backgroundColor = stilo.navigaciaFono
		
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
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(lingvoAvizo(_:)),
			name: Avizoj.elektitaLingvoShanghighis,
			object: nil
		)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(lingvaroAvizo(_:)),
			name: Avizoj.uzantajLingvojShanghighis,
			object: nil
		)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if !jamAperis {
			jamAperis = true
			serchilo.enfokusighi()
		}
	}
	
	@objc func lingvoAvizo(_ avizo: Notification) {
		guard let elektita = avizo.object as? Lingvo else { return }
		lingvoBreto.ghisdatigi(elektitan: elektita)
	}
	
	@objc func lingvaroAvizo(_ avizo: Notification) {
		guard let lingvaro = avizo.object as? [Lingvo] else { return }
		lingvoBreto.ghisdatigi(lingvaron: lingvaro)
	}
	
	// MARK: Interagado
	
	private func elektis(_ listero: Serchlistero) {
		guard let prezentilo = navigationController else {
			return
		}
		
		if listero.destinoj.count == 1,
		   let destino = listero.destinoj.first {
			kunordigilo.prezentiArtikoloPaghon(el: destino, prezentilo: prezentilo)
		} else if listero.destinoj.count > 1 {
			kunordigilo.prezentiDisigiloPaghon(
				por: listero.destinoj,
				prezentilo: prezentilo,
				elektis: { [weak self] destino in
					self?.kunordigilo.prezentiArtikoloPaghon(el: destino, prezentilo: prezentilo)
				}
			)
		}
	}
	
	// MARK: Serĉado
	
	/// Uzanto metis serĉ-parametrojn, tiel ke ni eble volas ekserĉi
	private func farisPeton(teksto: String?, serchLingvo: Lingvo?) {
		if let teksto,
		   !teksto.isEmpty,
		   let lingvo = serchLingvo {
			fariSerchon(teksto: teksto, serchLingvo: lingvo)
		} else {
			nuligiSerchon()
		}
	}
	
	/// Fari serĉon laŭ la parametroj
	private func fariSerchon(teksto: String, serchLingvo: Lingvo) {
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
	
	/// Nuligi serĉstaton
	private func nuligiSerchon() {
		serchStato = nil
		lastaSercho = nil
		rezultoTabelo.montri(listerojn: [])
	}
	
	/// Venigi pli da serĉrezultoj, ekz kiam uzanto rulumis malsupren
	private func venigiPli() {
		if let stato = serchStato, !stato.atingisFinon {
			let novaStato = VortaroDatumbazo.komuna.daurigiSerchon(
				stato: stato,
				limo: Konstantoj.serchLimo
			)
			
			serchStato = novaStato
			DispatchQueue.main.async { [weak self] in
				guard let self else { return }
				
				rezultoTabelo.montri(listerojn: tabeloListeroj(por: novaStato))
			}
		}
	}
	
	// MARK: Helpiloj
	
	/// Fari listerojn kiujn la tabelo montru
	func tabeloListeroj(por stato: SerchStato) -> [Serchlistero] {
		stato.rezultoj.map { rezulto in
			Serchlistero(
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
