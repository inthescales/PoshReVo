import UIKit

final class ShovMenueroView: UIControl {
	private enum Konstantoj {
		/// Marĝeno flanke de bildo kaj titolo
		static let flankaMargheno: CGFloat = 16.0
		
		/// Marĝeno supre kaj sube de bildo kaj titolo
		static let vertikalaMargheno: CGFloat = 12.0
		
		/// Grando de la bildoj
		static let bildoGrando: CGFloat = 24.0
		
		/// Spaco inter bildo kaj teksto
		static let interspaco: CGFloat = 8.0
		
		/// Spaco inter maldekstra flanko de la patro kaj maldekstra pinto de la substreko
		static let substrekSpaco: CGFloat = 16.0
	}
	
	// MARK: - Interfaceroj
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.text = teksto
		etikedo.textColor = menuAgordoj.tekstKoloro
		etikedo.font = .systemFont(ofSize: 18) // TODO: tiparo
		return etikedo
	}()
	
	private lazy var bildejo: UIImageView = {
		let ejo = UIImageView(image: bildo)
		ejo.tintColor = menuAgordoj.tekstKoloro
		ejo.contentMode = .scaleAspectFill
		return ejo
	}()
	
	private lazy var substreko: UIView = {
		let streko = UIView()
		streko.backgroundColor = menuAgordoj.dividiloKoloro
		return streko
	}()
	
	// MARK: - Agordoj
	
	private let bildo: UIImage?
	
	private let teksto: String
	
	private let elektis: () -> Void
	
	private let uziBildojn: Bool
	
	private let menuAgordoj: ShovMenuoViewController.Agordoj
	
	init(
		bildo: UIImage?,
		teksto: String,
		elektis: @escaping () -> Void,
		lasiBildoSpacon: Bool,
		menuAgordoj: ShovMenuoViewController.Agordoj
	) {
		self.bildo = bildo?.withRenderingMode(.alwaysTemplate)
		self.teksto = teksto
		self.elektis = elektis
		self.uziBildojn = lasiBildoSpacon
		self.menuAgordoj = menuAgordoj
		
		super.init(frame: .zero)
		
		aranghiElementojn()
		registriAgojn()
		metiStilon(premita: false)
	}
	
	// MARK: - Starigado
	
	/// Aldonas kaj aranĝas interfacerojn. Voku nur unufoje
	private func aranghiElementojn() {
		if uziBildojn {
			addSubview(bildejo)
			bildejo.snp.makeConstraints { make in
				make.left.equalToSuperview().inset(Konstantoj.flankaMargheno)
				make.top.bottom.equalToSuperview().inset(Konstantoj.vertikalaMargheno)
				make.width.height.equalTo(Konstantoj.bildoGrando)
			}
		}
		
		addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(Konstantoj.vertikalaMargheno)
			make.right.equalToSuperview().inset(Konstantoj.flankaMargheno)
			
			if uziBildojn {
				make.left.equalTo(bildejo.snp.right).offset(Konstantoj.interspaco)
			} else {
				make.left.equalToSuperview().inset(Konstantoj.flankaMargheno)
			}
		}
		
		addSubview(substreko)
		substreko.snp.makeConstraints { make in
			make.bottom.equalToSuperview()
			make.left.equalToSuperview().offset(Konstantoj.substrekSpaco)
			make.right.equalToSuperview()
			make.height.equalTo(1)
		}
	}
	
	/// Registras prem- kaj malprem-agojn. Voku nur unufoje
	private func registriAgojn() {
		addTarget(self, action: #selector(ekpremis), for: .touchDown)
		addTarget(self, action: #selector(finpremis), for: .touchUpInside)
		addTarget(self, action: #selector(premAborti), for: .touchCancel)
	}
	
	private func metiStilon(premita: Bool) {
		if premita {
			backgroundColor = menuAgordoj.tekstKoloro
			etikedo.textColor = menuAgordoj.menuaKoloro
			bildejo.tintColor = menuAgordoj.menuaKoloro
		} else {
			backgroundColor = menuAgordoj.menuaKoloro
			etikedo.textColor = menuAgordoj.tekstKoloro
			bildejo.tintColor = menuAgordoj.tekstKoloro
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: - Agoj
	
	@objc private func ekpremis() {
		metiStilon(premita: true)
	}
	
	@objc private func finpremis() {
		metiStilon(premita: false)
		elektis()
	}
	
	@objc private func premAborti() {
		metiStilon(premita: false)
	}
}
