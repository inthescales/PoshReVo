import UIKit

final class MallongigoListoChelo: UITableViewCell {
	private enum Konstantoj {
		static let margheno: CGFloat = 8.0
	}
	
	private lazy var mallongigoEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 20, weight: .bold).dinamika() // TODO: Tiparo
		return etikedo
	}()

	private lazy var signifoEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 18).dinamika() // TODO: Tiparo
		return etikedo
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubview(mallongigoEtikedo)
		mallongigoEtikedo.snp.makeConstraints { make in
			make.left.top.bottom.equalToSuperview().inset(Konstantoj.margheno)
		}
		
		addSubview(signifoEtikedo)
		signifoEtikedo.snp.makeConstraints { make in
			make.right.top.bottom.equalToSuperview().inset(Konstantoj.margheno)
			make.left.equalTo(mallongigoEtikedo.snp.right)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	func agordi(mallongigo: String, signifo: String, stilo: InterfacStilo) {
		mallongigoEtikedo.text = mallongigo
		mallongigoEtikedo.textColor = stilo.dokumentaTeksto
		
		signifoEtikedo.text = signifo
		signifoEtikedo.textColor = stilo.dokumentaTeksto
		
		backgroundColor = stilo.dokumentaFono
	}
}
