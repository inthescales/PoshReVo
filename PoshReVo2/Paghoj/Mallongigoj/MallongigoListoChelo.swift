import UIKit

/// Ĉelo por montri mallongigon kaj ĝian signifon
final class MallongigoListoChelo: UITableViewCell {
	private enum Konstantoj {
		/// Flankaj marĝenoj ĉirkaŭ tekstoj
		static let margheno: CGFloat = 8.0
		
		/// Minimuma spaco inter mallongiga kaj signifa etikedoj
		static let interspaco: CGFloat = 16.0
	}
	
	/// Etikedo kiu montros mallongigon
	private lazy var mallongigoEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = Tiparo.mallongigo
		etikedo.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		return etikedo
	}()

	/// Etikedo kiu montros la signifon de mallongigo
	private lazy var signifoEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = Tiparo.mallongigoDifino
		etikedo.numberOfLines = 0
		etikedo.textAlignment = .right
		etikedo.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		return etikedo
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubview(mallongigoEtikedo)
		mallongigoEtikedo.snp.makeConstraints { make in
			make.left.top.equalToSuperview().inset(Konstantoj.margheno)
			make.bottom.lessThanOrEqualToSuperview().inset(Konstantoj.margheno)
		}
		
		addSubview(signifoEtikedo)
		signifoEtikedo.snp.makeConstraints { make in
			make.right.top.bottom.equalToSuperview().inset(Konstantoj.margheno)
			make.left.equalTo(mallongigoEtikedo.snp.right).offset(Konstantoj.interspaco)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	func agordi(mallongigo: String, signifo: String, stilo: InterfacStilo) {
		mallongigoEtikedo.text = mallongigo
		mallongigoEtikedo.textColor = stilo.dokumentaTeksto
		
		let atributaTeksto = TekstAtributoHelpiloj.atributaTeksto(
			el: signifo,
			tiparo: Tiparo.mallongigoDifino
		)
		signifoEtikedo.attributedText = atributaTeksto
		signifoEtikedo.textColor = stilo.dokumentaTeksto
		
		backgroundColor = stilo.dokumentaFono
	}
}
