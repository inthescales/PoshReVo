import UIKit

final class SerchoViewController: UIViewController {
	lazy var serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiVortonAuFrazon,
		iksumi: true, // TODO: Nur se neesperanta lingvo uziĝas
		tekstoShanghighis: { teksto in }
	)
	lazy var rezultoj = UITableView()
}
