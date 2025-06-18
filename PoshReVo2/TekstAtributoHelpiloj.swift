import Foundation
import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

enum TekstAtributoHelpiloj {
	private enum Konstantoj {
		/// Kiel alte superskriptoj sidu
		static let superskriptSupreco = 2
		
		/// Kiel malalte subskriptoj sidu
		static let subskriptMalsupreco = -2
		
	}
	
	/// Kazo de tekstatributo aldonota al ĉeno
	private struct Atributo {
		let speco: TekstoAtributo
		let komenco: Int
		let fino: Int
	}

	/// Liveras ĉiujn tekstatributojn aldonendajn al la ĉeno
	private static func kreiAtributojn(por teksto: String) -> [Atributo] {
		var atributoj: [Atributo] = []
		
		let regesp = try! NSRegularExpression(pattern: TekstoAtributo.regulEsprimo)
		let trovajhoj = regesp.matches(in: teksto, range: NSRange(teksto.startIndex..., in: teksto))
		
		var enangulajSignoj = 0 // Ni ignoru signojn ene de anguloj kiam ni kalkulas atributo-lokojn
		var staplo: [(TekstoAtributo, Int)] = []
		for trovajho in trovajhoj {
			let range = trovajho.range
			let klavo = String(teksto[Range(trovajho.range(at: 1), in: teksto)!])
			let loko = range.location - enangulajSignoj
			
			if klavo.first != "/" {
				// etikedo komencas – notu ĝin
				let ecejo = trovajho.range(at: 5)
				if ecejo.location != NSNotFound {
					let valoro = String(teksto[Range(ecejo, in: teksto)!])
					if let atributo = TekstoAtributo(kodo: klavo, eco: valoro) {
						staplo.append((atributo, loko))
					}
				} else if let atributo = TekstoAtributo(kodo: klavo) {
					staplo.append((atributo, loko))
				}
			} else if let lasta = staplo.popLast() {
				// Etikedo fermiĝas. Aldonu atributon
				atributoj.append(Atributo(speco: lasta.0, komenco: lasta.1, fino: loko))
			}
			
			enangulajSignoj += range.length
		}
		
		return atributoj
	}

	/// Forigi la HTML kodojn el la teksto, por ke ĝi aperu nude
	static func forigiAngulojn(teksto: String) -> String {
		let regesp = try! NSRegularExpression(pattern: TekstoAtributo.regulEsprimo)
		return regesp.stringByReplacingMatches(
			in: teksto,
			range: NSMakeRange(0, teksto.count),
			withTemplate: ""
		)
	}
	
	/// Aldoni tekstatributojn al la ĉeno
	private static func atributaTeksto(
		por teksto: String,
		kun atributoj: [Atributo],
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) -> NSMutableAttributedString {
		
		let atributaTeksto = NSMutableAttributedString(string: forigiAngulojn(teksto: teksto))
		
		// Prepari tekst-stilojn
		// TODO: Pliklarigi kie kaj kiel tiparo estas elektita kaj metita
		let tekstGrandeco = UIFont.preferredFont(forTextStyle: .body).pointSize
		let tekstStilo = UIFont.systemFont(ofSize: tekstGrandeco)
		let grasaStilo = UIFont.boldSystemFont(ofSize: tekstGrandeco)
		let kursivaStilo = UIFont.italicSystemFont(ofSize: tekstGrandeco)
		let grasKursivaStilo = UIFont(
			descriptor: grasaStilo.fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold])!,
			size: tekstGrandeco
		)
	
		// Meti bazan tiparon kaj koloron
		atributaTeksto.addAttribute(
			.font,
			value: tekstStilo,
			range: NSMakeRange(0, atributaTeksto.length)
		)
		
		atributaTeksto.addAttribute(
			.foregroundColor,
			value: stilo.teksto,
			range: NSMakeRange(0, atributaTeksto.length)
		)
		
		for atributo in atributoj.reversed() {
			guard atributo.komenco >= 0 && atributo.fino <= atributaTeksto.length else { continue }

			let regiono = NSMakeRange(atributo.komenco, atributo.fino - atributo.komenco)
			switch atributo.speco {
			case .kursiva:
				let komencatributoj = atributaTeksto.attributes(at: regiono.location, effectiveRange: nil)
				if komencatributoj.contains(where: {
					(($0.value as? UIFont)?.fontDescriptor.symbolicTraits.contains(.traitBold) ?? false)
				}) {
					// Ĉu ĉi-kazo iam efektivas?
					atributaTeksto.addAttribute(
						.font,
						value: grasKursivaStilo,
						range: regiono
					)
				} else {
					atributaTeksto.addAttribute(
						.font,
						value: kursivaStilo,
						range: regiono
					)
				}
			case .grasa:
				let komencatributoj = atributaTeksto.attributes(at: regiono.location, effectiveRange: nil)
				if komencatributoj.contains(where: {
					(($0.value as? UIFont)?.fontDescriptor.symbolicTraits.contains(.traitItalic) ?? false)
				}) {
					atributaTeksto.addAttribute(
						.font,
						value: grasKursivaStilo,
						range: regiono
					)
				} else {
					atributaTeksto.addAttribute(
						.font,
						value: grasaStilo,
						range: regiono
					)
				}
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
				atributaTeksto.addAttribute(
					.font,
					value: kursivaStilo,
					range: regiono
				)
				atributaTeksto.addAttribute(
					.foregroundColor,
					value: stilo.ligilo,
					range: regiono
				)
			case .tradukNumero:
				atributaTeksto.addAttribute(
					.foregroundColor,
					value: stilo.ligilo,
					range: regiono
				)
			case .ligo:
				// Ligoj aldoniĝos aliloke
				break
			}
		}
		
		return atributaTeksto
	}
	
	/// Legas certajn HTML-ajn kodojn el la teksto, produktas tekst-atributojn laŭ ties instrukcio, kaj ŝarĝas la etikedon je tiuj
	static func provizi(etikedon etikedo: TTTAttributedLabel, per teksto: String) {
		let atributoj = TekstAtributoHelpiloj.kreiAtributojn(por: teksto)
		etikedo.setText(TekstAtributoHelpiloj.atributaTeksto(por: teksto, kun: atributoj))
		
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
