import UIKit

/// Vido kiu montras gradienton fadante ekde koloro al travideblo
final class FadGradientoView: UIView {
	/// Direkto en kiu la vido fadas
	enum FadDirekto {
		case dekstren
		case maldekstren
		case supren
		case malsupren
	}
	
	// MARK: - Interfaceroj
	
	/// Tavolo metanta gradienton
	private lazy var gradientTavolo: CAGradientLayer = {
		let tavolo = CAGradientLayer()
		tavolo.colors = [koloro.withAlphaComponent(0.0).cgColor, koloro.cgColor]
		tavolo.locations = [0.0, NSNumber(value: fadRegiono)]
		
		switch orientigho {
		case .dekstren:
			tavolo.startPoint = CGPoint(x: 0, y: 0)
			tavolo.endPoint   = CGPoint(x: 1, y: 0)
		case .maldekstren:
			tavolo.startPoint = CGPoint(x: 1, y: 0)
			tavolo.endPoint   = CGPoint(x: 0, y: 0)
		case .supren:
			tavolo.startPoint = CGPoint(x: 0, y: 1)
			tavolo.endPoint   = CGPoint(x: 0, y: 0)
		case .malsupren:
			tavolo.startPoint = CGPoint(x: 0, y: 0)
			tavolo.endPoint   = CGPoint(x: 0, y: 1)
		}
		
		return tavolo
	}()
	
	// MARK: - Agordoj
	
	/// Orientiĝo uzota
	private let orientigho: FadDirekto
	
	/// Koloro de la opaka flanko de la gradiento
	private var koloro: UIColor
	
	/// Porcio de la vido tra kiu fado efektiviĝas, kaj kiu estu videbla
	private let fadRegiono: CGFloat
	
	// MARK: - Valorizado
	
	init(orientigho: FadDirekto, koloro: UIColor, fadRegiono: CGFloat = 1.0) {
		self.koloro = koloro
		self.orientigho = orientigho
		self.fadRegiono = fadRegiono
		super.init(frame: .zero)
		
		layer.addSublayer(gradientTavolo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		gradientTavolo.frame = bounds
	}
	
	func meti(koloron koloro: UIColor) {
		self.koloro = koloro
		gradientTavolo.colors = [koloro.withAlphaComponent(0.0).cgColor, koloro.cgColor]
		setNeedsLayout()
	}
	
	// MARK: - Sistemreagoj
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
		   return
		}
		
		meti(koloron: koloro)
	}
}
