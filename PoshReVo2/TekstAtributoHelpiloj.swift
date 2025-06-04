import Foundation
import UIKit

import TTTAttributedLabel

enum TekstAtributoHelpiloj {
	/// Specoj de tekstatribuoj, aldoneblaj al ĉenoj
	private enum AtributSpeco: Equatable {
		case ligo(celo: String)
		case kursiva
		case grasa
		case grasKursiva
		case supera
		case suba
	}
	
	/// Kazo de tekstatributo aldonota al ĉeno
	private struct Atributo {
		let speco: AtributSpeco
		let komenco: Int
		let fino: Int
	}

	/// Liveras ĉiujn tekstatributojn aldonendajn al la ĉeno
	private static func kreiAtributojn(por teksto: String) -> [Atributo] {
		var atributoj: [Atributo] = []
		
		let regesp = try! NSRegularExpression(pattern: "<(/?([ikbga]|sup|sub|frm))( (href|am)=\"(.*?)\")?>")
		let trovajhoj = regesp.matches(in: teksto, range: NSRange(teksto.startIndex..., in: teksto))
		
		var enangulajSignoj = 0 // Ni ignoru signojn ene de anguloj kiam ni kalkulas atributo-lokojn
		var staplo: [(AtributSpeco, Int)] = []
		for trovajho in trovajhoj {
			let range = trovajho.range
			let klavo = String(teksto[Range(trovajho.range(at: 1), in: teksto)!])
			let loko = range.location - enangulajSignoj
			
			if klavo.first != "/" {
				// etikedo komencas – notu ĝin
				switch klavo {
				case "i", "k":
					staplo.append((.kursiva, loko))
				case "b", "g":
					staplo.append((.grasa, loko))
				case "sup":
					staplo.append((.supera, loko))
				case "sub":
					staplo.append((.suba, loko))
				case "a":
					let ligLoko = trovajho.range(at: 5)
					if ligLoko.location != NSNotFound {
						let ligCelo = String(teksto[Range(ligLoko, in: teksto)!])
						staplo.append((.ligo(celo: ligCelo), loko))
					}
				default:
					break
				}
			} else if let lasta = staplo.popLast() {
				// etikedo finiĝas – marki ĉi atributo-regionon
				if ["/i", "/k"].contains(klavo)
					&& staplo.contains(where: { $0.0 == .grasa }) {
					
					atributoj.append(Atributo(speco: .grasKursiva, komenco: lasta.1, fino: loko))
				} else if ["/b", "/g"].contains(klavo)
					&& staplo.contains(where: { $0.0 == .grasa }) {
					
					atributoj.append(Atributo(speco: .grasKursiva, komenco: lasta.1, fino: loko))
				} else {
					atributoj.append(Atributo(speco: lasta.0, komenco: lasta.1, fino: loko))
				}
			}
			
			enangulajSignoj += range.length
		}
		
		return atributoj
	}

	/// Forigi la HTML kodojn el la teksto, por ke ĝi aperu nude
	static func forigiAngulojn(teksto: String) -> String {
		let regesp = try! NSRegularExpression(
			pattern: "<(/?([ikbga]|sup|sub|frm))( (href|am)=\"(.*?)\")?>"
		)
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
		
		// TODO: Injekcii stilon
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
				atributaTeksto.addAttribute(
					.font,
					value: kursivaStilo,
					range: regiono
				)
				
			case .grasa:
				atributaTeksto.addAttribute(
					.font,
					value: grasaStilo,
					range: regiono
				)
				
			case .grasKursiva:
				atributaTeksto.addAttribute(
					.font,
					value: grasKursivaStilo,
					range: regiono
				)
				
			case .supera:
				atributaTeksto.addAttribute(
					kCTSuperscriptAttributeName as NSAttributedString.Key,
					value: 2, // TODO: Kial "2"?
					range: regiono
				)
				
			case .suba:
				atributaTeksto.addAttribute(
					kCTSuperscriptAttributeName as NSAttributedString.Key,
					value: -2, // TODO: Kial "-2"?
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
