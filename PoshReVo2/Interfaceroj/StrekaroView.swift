import UIKit

/// Speciala dividilo konsistanta el linio da streketo (dashed line)
final class StrekaroView: UIView {
	private enum Konstantoj {
		/// Kiom longa ĉiu streketu estu
		static let strekLongo: CGFloat = 2.0
		
		/// Kiom da spaco estu inter streketoj
		static let spacLongo: CGFloat = 2.0
	}
	
	// MARK: - Agordoj
	
	/// La koloro de la streketoj
	private let koloro: UIColor
	
	// MARK: - Valorizado
	
	init(koloro: UIColor, fonKoloro: UIColor = .clear) {
		self.koloro = koloro
		
		super.init(frame: .zero)
		backgroundColor = fonKoloro
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		koloro.set()
		
		let pado = UIBezierPath()
		pado.lineCapStyle = .butt
		
		let strekoj = [Konstantoj.strekLongo, Konstantoj.spacLongo]
		pado.setLineDash(strekoj, count: strekoj.count, phase: 0.0)
		
		if bounds.height > bounds.width {
			// Se la view estas pli alta ol larĝa, streku vertikale
			let p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
			pado.move(to: p0)

			let p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
			pado.addLine(to: p1)
			pado.lineWidth = bounds.width
		} else {
			// Se la view estas pli larĝa ol alta, streku horizontale
			let p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
			pado.move(to: p0)

			let p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
			pado.addLine(to: p1)
			pado.lineWidth = bounds.height
		}
		
		pado.stroke()
	}
}
