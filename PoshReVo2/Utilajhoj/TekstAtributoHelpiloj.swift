import Foundation
import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

/// Helpiloj por interpreti tekstetikedojn por faro de atributoj, kaj aplikado de atributoj al tekstejoj
enum TekstAtributoHelpiloj {
	private enum Konstantoj {
		/// Kiel alte superskriptoj sidu
		static let superskriptSupreco = 2
		
		/// Kiel malalte subskriptoj sidu
		static let subskriptMalsupreco = -2
		
	}
	
	/// Kazo de tekstatributo aldonota al ĉeno
	private struct TekstAtributajho {
		let speco: TekstAtributo
		let komenco: Int
		let fino: Int
	}

	/// Liveras ĉiujn tekstatributojn aldonendajn al la ĉeno
	private static func kreiAtributojn(por teksto: String) -> [TekstAtributajho] {
		var atributoj: [TekstAtributajho] = []
		
		let regesp = try! NSRegularExpression(pattern: TekstAtributo.regulEsprimo)
		let trovajhoj = regesp.matches(in: teksto, range: NSRange(teksto.startIndex..., in: teksto))
		
		var enangulajSignoj = 0 // Ni ignoru signojn ene de anguloj kiam ni kalkulas atributo-lokojn
		var staplo: [(TekstAtributo, Int)] = []
		for trovajho in trovajhoj {
			let range = trovajho.range
			let klavo = String(teksto[Range(trovajho.range(at: 1), in: teksto)!])
			let loko = range.location - enangulajSignoj
			
			if klavo.first != "/" {
				// etikedo komencas – notu ĝin
				let ecejo = trovajho.range(at: 5)
				if ecejo.location != NSNotFound {
					let valoro = String(teksto[Range(ecejo, in: teksto)!])
					if let atributo = TekstAtributo(kodo: klavo, eco: valoro) {
						staplo.append((atributo, loko))
					}
				} else if let atributo = TekstAtributo(kodo: klavo) {
					staplo.append((atributo, loko))
				}
			} else if let lasta = staplo.popLast() {
				// Etikedo fermiĝas. Aldonu atributon
				atributoj.append(TekstAtributajho(speco: lasta.0, komenco: lasta.1, fino: loko))
			}
			
			enangulajSignoj += range.length
		}
		
		return atributoj
	}

	/// Forigi la HTML kodojn el la teksto, por ke ĝi aperu nude
	static func forigiAngulojn(teksto: String) -> String {
		let regesp = try! NSRegularExpression(pattern: TekstAtributo.regulEsprimo)
		return regesp.stringByReplacingMatches(
			in: teksto,
			range: NSMakeRange(0, teksto.unicodeScalars.count),
			withTemplate: ""
		)
	}
	
	/// Aldoni tekstatributojn al la ĉeno
	private static func atributaTeksto(
		por teksto: String,
		kun atributoj: [TekstAtributajho],
		tiparo bazaTiparo: UIFont,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) -> NSMutableAttributedString {
		
		let atributaTeksto = NSMutableAttributedString(string: forigiAngulojn(teksto: teksto))

		// Meti bazan tiparon kaj koloron
		atributaTeksto.addAttribute(
			.font,
			value: bazaTiparo,
			range: NSMakeRange(0, atributaTeksto.length)
		)
		
		atributaTeksto.addAttribute(
			.foregroundColor,
			value: stilo.dokumentaTeksto,
			range: NSMakeRange(0, atributaTeksto.length)
		)
		
		for atributo in atributoj.reversed() {
			guard atributo.komenco >= 0 && atributo.fino <= atributaTeksto.length else { continue }

			let regiono = NSMakeRange(atributo.komenco, atributo.fino - atributo.komenco)
			var novajTrajtoj: UIFontDescriptor.SymbolicTraits?
			
			switch atributo.speco {
			case .kursiva:
				novajTrajtoj = .traitItalic
			case .grasa:
				novajTrajtoj = .traitBold
			case .supera:
				atributaTeksto.addAttribute(
					kCTSuperscriptAttributeName as NSAttributedString.Key,
					value: Konstantoj.superskriptSupreco,
					range: regiono
				)				
			case .suba:
				atributaTeksto.addAttribute(
					kCTSuperscriptAttributeName as NSAttributedString.Key,
					value: Konstantoj.subskriptMalsupreco,
					range: regiono
				)
			case .ekzemplo:
				novajTrajtoj = .traitItalic
				atributaTeksto.addAttribute(
					.foregroundColor,
					value: stilo.dokumentEkzemplo,
					range: regiono
				)
			case .rimarko:
				atributaTeksto.addAttribute(
					.foregroundColor,
					value: stilo.dokumentRimarko,
					range: regiono
				)
			case .sencNumero:
				atributaTeksto.addAttribute(
					.foregroundColor,
					value: stilo.dokumentSencNumero,
					range: regiono
				)
				novajTrajtoj = .traitBold
			case .ligo:
				// Ligoj aldoniĝos aliloke
				break
			}
			
			// Aldoni apartajn trajtojn al tiparo, se necesas
			if let novajTrajtoj {
				// Akiri trajtojn jam aldonitajn al la nuna loko, kaj aldoni la novajn
				let lokajTrajtoj = atributaTeksto.attributes(at: regiono.location, effectiveRange: nil)
					.map { ($0.value as? UIFont)?.fontDescriptor.symbolicTraits ?? [] }
					.reduce(UIFontDescriptor.SymbolicTraits()) {
						$0.union($1)
					}
				let trajtaro = lokajTrajtoj.union(novajTrajtoj)
				
				// Krei novan tiparon havantan la ĝustajn tratojn
				if let priskribilo = bazaTiparo.fontDescriptor.withSymbolicTraits(trajtaro) {
					let novaTiparo = UIFont(descriptor: priskribilo, size: bazaTiparo.pointSize)
					atributaTeksto.addAttribute(
						.font,
						value: novaTiparo,
						range: regiono
					)
				}
			}
		}
		
		return atributaTeksto
	}
	
	// MARK: - Publikaj agoj
	
	/// Liveras atributan tekston, interpretanta etikedojn en la teksto, havanta certan tiparon
	static func atributaTeksto(el teksto: String, tiparo: UIFont) -> NSAttributedString {
		let atributoj = TekstAtributoHelpiloj.kreiAtributojn(por: teksto)
		return TekstAtributoHelpiloj.atributaTeksto(
			por: teksto,
			kun: atributoj,
			tiparo: tiparo
		)
	}
	
	/// Legas certajn HTML-ajn kodojn el la teksto, produktas tekst-atributojn laŭ ties instrukcio, kaj ŝarĝas la etikedon je tiuj
	static func provizi(
		etikedon etikedo: TTTAttributedLabel,
		per teksto: String,
		tiparo: UIFont,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		// Agordi etikedon
		etikedo.linkAttributes = [
			kCTForegroundColorAttributeName : stilo.dokumentLigilo,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		etikedo.activeLinkAttributes = [
			kCTForegroundColorAttributeName : stilo.dokumentLigiloPremita,
			kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)
		]
		
		// Prepari tekst-stilojn
		let atributoj = TekstAtributoHelpiloj.kreiAtributojn(por: teksto)
		let atributaTeksto = TekstAtributoHelpiloj.atributaTeksto(
			por: teksto,
			kun: atributoj,
			tiparo: tiparo,
			stilo: stilo
		)
		etikedo.setText(atributaTeksto)
		
		// Ŝajne ne eblas aldoni ligilojn kiel tekst-atributoj je TTTAttributedLabel.
		// Kiam mi provis, la ligiloj funkciis, tamen mi ne sukcesis meti la ĝustajn kolorojn.
		// Mi ne scias kial.
		for atributo in atributoj {
			if case let .ligo(celo) = atributo.speco {
				etikedo.addLink(
					to: URL(string: celo),
					with: NSMakeRange(atributo.komenco, atributo.fino - atributo.komenco)
				)
			}
		}
	}
}
