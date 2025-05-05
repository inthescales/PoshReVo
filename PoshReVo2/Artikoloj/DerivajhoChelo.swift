import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

final class DerivajhoChelo: UITableViewCell {
	private lazy var titoloEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 20, weight: .bold)
		etikedo.numberOfLines = 1
		return etikedo
	}()
	
	private lazy var difinoEtikedo: TTTAttributedLabel = {
		let etikedo = TTTAttributedLabel(frame: .zero)
		etikedo.numberOfLines = 0
		
		return etikedo
	}()
	
	// MARK: Agordoj
	
	var stilo: InterfacStilo?
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(titoloEtikedo)
		titoloEtikedo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		contentView.addSubview(difinoEtikedo)
		difinoEtikedo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(titoloEtikedo.snp.bottom)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: Agoj
	
	func agordi(
		vorto: Vorto,
		liganto: TTTAttributedLabelDelegate,
		stilo: InterfacStilo
	) {
		self.stilo = stilo
		
		titoloEtikedo.text = vorto.titolo
		titoloEtikedo.textColor = self.stilo?.teksto
		
		difinoEtikedo.textColor = self.stilo?.teksto
		difinoEtikedo.delegate = liganto
		
		//difinoTekstejo.delegate = liganto
		
		if let koloro = self.stilo?.ligilo,
		   let aktivaKoloro = self.stilo?.koloraFono {
			difinoEtikedo.linkAttributes = [
				kCTForegroundColorAttributeName : koloro,
				kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
			]
			difinoEtikedo.activeLinkAttributes = [
				kCTForegroundColorAttributeName : aktivaKoloro,
				kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
			]
		}
		
		prepari(teksto: vorto.teksto) // TODO: Renomi
	}
	
	// MARK: Helpiloj
	
	func prepari(teksto: String) {
		let markoj = LigiloHelpiloj.troviMarkojn(teksto: teksto)
		difinoEtikedo.setText(LigiloHelpiloj.pretigiTekston(teksto, kunMarkoj: markoj))
		
		let markoLigoKlavo = "ligo" // TODO: Faru alimaniere
		for ligMarko in markoj[markoLigoKlavo]! {
			difinoEtikedo.addLink(
				to: URL(string: ligMarko.2),
				with: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0)
			)
		}
	}
}
