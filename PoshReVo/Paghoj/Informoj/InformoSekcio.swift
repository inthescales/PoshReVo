import UIKit

import TTTAttributedLabel

/// Sekcio ene de infomekrano, enhavanta du etikedojn: titolo kaj ĉefteksto
final class InformoSekcio: UIView {
	private enum Konstantoj {
		/// Spaco inter titolo kaj ĉefteksto en ĉiu sekcio
		static let intertekstaSpaco: CGFloat = 16.0
	}
	
	private lazy var titolEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = Tiparo.informoTitolo
		etikedo.numberOfLines = 0
		etikedo.textColor = stilo.dokumentaTeksto
		return etikedo
	}()
	
	private lazy var dividilo: UIView = {
		let dividilo = UIView()
		dividilo.translatesAutoresizingMaskIntoConstraints = false
		dividilo.backgroundColor = stilo.dokumentaDividilo
		return dividilo
	}()
	
	private lazy var chefEtikedo: TTTAttributedLabel = {
		let etikedo = TTTAttributedLabel(frame: .zero)
		etikedo.font = Tiparo.informoTeksto
		etikedo.numberOfLines = 0
		etikedo.textColor = stilo.dokumentaTeksto
		return etikedo
	}()
	
	// MARK: - Agordoj
	
	private let stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(
		titolo: String?,
		teksto: String,
		delegate: TTTAttributedLabelDelegate,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.stilo = stilo
		super.init(frame: .zero)
		
		if let titolo {
			titolEtikedo.text = titolo
			
			addSubview(titolEtikedo)
			titolEtikedo.snp.makeConstraints { make in
				make.top.left.right.equalToSuperview()
			}
			
			addSubview(dividilo)
			dividilo.snp.remakeConstraints { make in
				make.top.equalTo(titolEtikedo.snp.bottom)
				make.left.right.equalToSuperview().inset(0).priority(.low)
				make.height.equalTo(1)
			}
			
			addSubview(chefEtikedo)
			chefEtikedo.snp.makeConstraints { make in
				make.left.right.bottom.equalToSuperview()
				make.top.equalTo(dividilo.snp.bottom).offset(Konstantoj.intertekstaSpaco)
			}
		} else {
			addEdgeMatchedSubview(chefEtikedo)
		}
		
		chefEtikedo.delegate = delegate
		TekstAtributoHelpiloj.provizi(
			etikedon: chefEtikedo,
			per: teksto,
			tiparo: Tiparo.informoTeksto,
			stilo: stilo
		)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
}
