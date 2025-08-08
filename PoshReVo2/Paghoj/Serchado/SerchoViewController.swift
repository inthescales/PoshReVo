import UIKit

import ReVoDatumbazo

/// Ekrano por serĉi vortojn
final class SerchoViewController: UIViewController, Ingito {
	private enum Konstantoj {
		/// Maksimuma kvanto da serĉrezultoj prezentotaj
		static let serchLimo = 32
	}
	
	// MARK: Interfaceroj
	
	private lazy var serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiVortonAuFrazon,
		iksumi: serchLingvo?.estasEsperanto ?? false,
		montriOmbron: false,
		tekstoShanghighis: { [weak self] teksto in
			self?.farisPeton(teksto: teksto, serchLingvo: self?.serchLingvo)
		}
	)
	
	/// Lingvo elektilo pendanta sub serĉilo
	private lazy var lingvoBreto: LingvoBretoViewController = {
		return LingvoBretoViewController(
			elektisLingvon: { [weak self] lingvo in
				self?.elektisLingvon(lingvo)
				self?.serchilo.iksumi = self?.serchLingvo?.estasEsperanto ?? false
				self?.farisPeton(teksto: self?.serchTeksto, serchLingvo: lingvo)
			},
			redaktisLingvojn: { [weak self] lingvoj in
				self?.farisPeton(
					teksto: self?.serchTeksto,
					serchLingvo: self?.serchLingvo
				)
			}
		)
	}()
	
	/// Tabelo montranta serĉrezultojn
	private lazy var rezultoTabelo: VortoListoViewController = {
		return VortoListoViewController<Serchlistero>(
			elektis: elektis,
			alvenasFinon: venigiPli
		)
	}()
	
	// MARK: Stato
	
	/// La nuna serĉteksto en la serĉejo
	private var serchTeksto: String? {
		serchilo.teksto
	}
	
	/// La nuna serĉlingvo
	private var serchLingvo: Lingvo? {
		lingvoBreto.elektita
	}
	
	/// Stato de la nune-prezentita serĉo
	private var serchStato: SerchStato?
	
	/// Datumoj pri la lasta serĉo, antaŭ la nuna
	private var lastaSercho: (Lingvo, String)? = nil
	
	// MARK: Agordoj
	
	/// Fermo vokota kiam la uzanto elektas serĉlingvon
	private var elektisLingvon: (Lingvo) -> Void
	
	private var kunordigilo: Kunordigilo
	
	private var stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(
		serchLingvoj: [Lingvo],
		elektisLingvon: @escaping (Lingvo) -> Void,
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.elektisLingvon = elektisLingvon
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
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(stiloShanghighis),
			name: Avizoj.stiloShanghighis,
			object: nil
		)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	// MARK: - Avizreagoj
	
	@objc private func lingvoAvizo(_ avizo: Notification) {
		guard let elektita = avizo.object as? Lingvo else { return }
		lingvoBreto.ghisdatigi(elektitan: elektita)
	}
	
	@objc private func lingvaroAvizo(_ avizo: Notification) {
		guard let lingvaro = avizo.object as? [Lingvo] else { return }
		lingvoBreto.ghisdatigi(lingvaron: lingvaro)
	}
	
	@objc private func stiloShanghighis() {
		let novaStilo = UzantDatumaro.komuna.stilo
		stilo = novaStilo
		
		view.backgroundColor = stilo.navigaciaFono
		rezultoTabelo.meti(stilon: stilo)
		serchilo.meti(stilon: stilo)
		lingvoBreto.meti(stilon: stilo)
	}
	
	// MARK: - Interagado
	
	/// Vokota kiam al uzanto elektos eron de la rezultotabelo
	private func elektis(_ listero: Serchlistero) {
		guard let prezentilo = navigationController else {
			return
		}
		
		if listero.destinoj.count == 1,
		   // Se estas pluraj destinoj, montri disigilon
		   let destino = listero.destinoj.first {
			kunordigilo.prezentiArtikoloPaghon(el: destino, prezentilo: prezentilo)
		} else if listero.destinoj.count > 1 {
			// Se estas nur unu destino, montri ĝian artikolon
			kunordigilo.prezentiDisigiloPaghon(
				por: listero.destinoj,
				prezentilo: prezentilo,
				elektis: { [weak self] destino in
					self?.kunordigilo.prezentiArtikoloPaghon(el: destino, prezentilo: prezentilo)
				}
			)
		}
	}
	
	// MARK: - Serĉado
	
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
	
	/// Nuligi serĉstaton kaj malplenigi rezultotabelon
	private func nuligiSerchon() {
		serchStato = nil
		lastaSercho = nil
		rezultoTabelo.montri(listerojn: [])
	}
	
	/// Venigi pli da serĉrezultoj, ekz. kiam uzanto rulumis malsupren
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
	
	// MARK: - Helpiloj
	
	/// Fari listerojn kiujn la tabelo montru
	private func tabeloListeroj(por stato: SerchStato) -> [Serchlistero] {
		stato.rezultoj.map { rezulto in
			Serchlistero(
				teksto: rezulto.teksto,
				subteksto: tekstoPorDestinoj(destinoj: rezulto.destinoj),
				destinoj: rezulto.destinoj
			)
		}
	}
	
	/// Teksto mentrota kiel rezult-listera subteksto
	private func tekstoPorDestinoj(destinoj: [Destino]) -> String? {
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

	// MARK: - Ingito
	
	let titolo = Tekstoj.serchi
	
	func restarigi() {
		serchilo.nuligiTekston()
		nuligiSerchon()
	}
}
