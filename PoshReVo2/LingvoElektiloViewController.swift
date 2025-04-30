import UIKit

final class LingvoElektiloViewController: UIViewController {
	let serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiLingvon,
		iksumi: true,
		tekstoShanghighis: { teksto in }
	)
	
	override func viewDidLoad() {
		view.addSubview(serchilo)
		serchilo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
	}
}
