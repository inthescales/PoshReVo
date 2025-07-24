import UIKit

import TTTAttributedLabel

/// Sekcio ene de infomopaĝo, enhavanta du etikedojn: titolo kaj ĉefteksto
final class InformoSekcio: UIView {
	private enum Konstantoj {
		/// Spaco inter titolo kaj ĉefteksto en ĉiuj sekcio
		static let intertekstaSpaco: CGFloat = 4.0
	}
	
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
	
	init(
		titolo: String?,
		teksto: String,
		delegate: TTTAttributedLabelDelegate,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		super.init(frame: .zero)
		
		if let titolo {
			titolEtikedo.text = titolo
			titolEtikedo.font = .systemFont(ofSize: 20, weight: .bold)
			titolEtikedo.textColor = stilo.dokumentaTeksto
			
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
		
		tekstejo.textColor = stilo.dokumentaTeksto
		tekstejo.linkAttributes = [
			kCTForegroundColorAttributeName : stilo.dokumentLigilo,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		tekstejo.activeLinkAttributes = [
			kCTForegroundColorAttributeName : stilo.navigaciaFono,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		
		tekstejo.delegate = delegate
		TekstAtributoHelpiloj.provizi(etikedon: tekstejo, per: teksto)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
}
