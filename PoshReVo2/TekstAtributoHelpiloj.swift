import Foundation
import UIKit

import TTTAttributedLabel

enum TekstAtributoHelpiloj {
	private enum Klavoj {
		static let ligo = "ligo"
		static let kursiva = "kursiva"
		static let grasa = "grasa"
		static let grasKursiva = "grasKursiva"
		static let supera = "super"
		static let suba = "sub"
	}
	
	enum AtributSpeco: Equatable {
		case ligo(celo: String)
		case kursiva
		case grasa
		case grasKursiva
		case supera
		case suba
	}
	
	struct Atributo {
		let speco: AtributSpeco
		let komenco: Int
		let fino: Int
	}

	/// Legi la tekston kaj trovi markojn en formo de HTML-kodoj.
	/// Troviĝos:
	///	<i>...</i> por kursivaj tekstoj
	///	<b>...</b> por grasaj tekstoj
	///	<a href="...">...</a> por ligoj
	///
	/// Liveras aron da listoj de trovajhoj, en la form de (komenca loko, fina loko, ligo-teksto)
	static func troviMarkojn(teksto: String) -> [String : [(Int, Int, String)]] {
		
		var rez = [String : [(Int, Int, String)]]()
		rez[Klavoj.kursiva] = [(Int, Int, String)]()
		rez[Klavoj.grasa] = [(Int, Int, String)]()
		rez[Klavoj.grasKursiva] = [(Int, Int, String)]()
		rez[Klavoj.ligo] = [(Int, Int, String)]()
		rez[Klavoj.supera] = [(Int, Int, String)]()
		rez[Klavoj.suba] = [(Int, Int, String)]()
		
		let regesp = try! NSRegularExpression(pattern: "<(/?([ikbga]|sup|sub|frm))( (href|am)=\"(.*?)\")?>")
		let trovajhoj = regesp.matches(in: teksto, range: NSRange(teksto.startIndex..., in: teksto))
		
		var enangulajSignoj = 0 // Ni ignoru signojn ene de anguloj kiam ni kalkulas atributo-lokojn
		var staplo: [(AtributSpeco, Int)] = []
		for trovajho in trovajhoj {
			let range = trovajho.range
			let klavo = String(teksto[Range(trovajho.range(at: 1), in: teksto)!])
			let loko = range.location - enangulajSignoj
			
			if klavo.first != "/" {
				// etikedo komencas
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
				// etikedo finiĝas
				switch klavo {
				case "/i", "/k":
					if staplo.contains(where: { $0.0 == .grasa }) {
						rez[Klavoj.grasKursiva]?.append((lasta.1, loko, ""))
					} else {
						rez[Klavoj.kursiva]?.append((lasta.1, loko, ""))
					}
				case "/b", "/g":
					if staplo.contains(where: { $0.0 == .kursiva }) {
						rez[Klavoj.grasKursiva]?.append((lasta.1, loko, ""))
					} else {
						rez[Klavoj.grasa]?.append((lasta.1, loko, ""))
					}
				case "/sup":
					rez[Klavoj.supera]?.append((lasta.1, loko, ""))
				case "/sub":
					rez[Klavoj.suba]?.append((lasta.1, loko, ""))
				case "/a":
					if case let .ligo(celo) = lasta.0 {
						rez[Klavoj.ligo]?.append((lasta.1, loko, celo))
					}
				default:
					break
				}
			}
			
			enangulajSignoj += range.length
		}
		
		return rez
	}

	/// Forigi la HTML kodojn el la teksto, por ke ĝi aperu nude
	static func forigiAngulojn(teksto: String) -> String {
		var rez: String = ""
		var en: Bool = false
		var enhavoj: String = ""
		for literoScalar in teksto.unicodeScalars {
			
			let litero = String(literoScalar)
			
			if litero == "<" {
				en = true
				enhavoj.append(litero)
			} else if litero == ">" {
				en = false
				enhavoj.append(litero)

				do {
					let regesp = try NSRegularExpression(pattern: "(<a href=\"(.*?)\">)|(<frm am=\".*?\">)", options: NSRegularExpression.Options())
					let trovoj = regesp.matches(in: enhavoj, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, enhavoj.count))
					if trovoj.count > 0 {
						// Fari nenion
					} else if enhavoj == "<i>"    ||
							  enhavoj == "</i>"   ||
							  enhavoj == "<k>"    ||
							  enhavoj == "</k>"   ||
							  enhavoj == "<b>"    ||
							  enhavoj == "</b>"   ||
							  enhavoj == "<g>"    ||
							  enhavoj == "</g>"   ||
							  enhavoj == "<sup>"  ||
							  enhavoj == "</sup>" ||
							  enhavoj == "<sub>"  ||
							  enhavoj == "</sub>" ||
							  enhavoj == "</a>" ||
							  enhavoj == "<frm>" ||
							  enhavoj == "</frm>" {
								// Fari nenion
					} else {
						rez += enhavoj
					}
					
					enhavoj = ""
				} catch { }
			} else if en {
				enhavoj.append(litero)
			} else {
				rez.append(litero)
			}
		}
		
		return rez
	}
	
	// Pretigi NSAttributedString kun la akcentoj, fortaj regionoj, kaj ligoj kiujn uzas artikoloj ktp.
	// Chi tiu funkciono uzas la rezultojn de la troviMarkojn funkcio
	static func atributaTeksto(por teksto: String, kun markoj: [String : [(Int, Int, String)]] ) -> NSMutableAttributedString {
		
		let atributaTeksto = NSMutableAttributedString(string: forigiAngulojn(teksto: teksto))
		
		// Prepari tekst-stilojn
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
			value: InterfacStilo.nuna.teksto,
			range: NSMakeRange(0, atributaTeksto.length)
		)
		
		for kursivaMarko in markoj[Klavoj.kursiva]! {
			guard kursivaMarko.0 >= 0 && kursivaMarko.1 <= atributaTeksto.length else { continue }
			
			atributaTeksto.addAttribute(
				.font,
				value: kursivaStilo,
				range: NSMakeRange(kursivaMarko.0, kursivaMarko.1 - kursivaMarko.0)
			)
		}
		
		for grasaMarko in markoj[Klavoj.grasa]! {
			guard grasaMarko.0 >= 0 && grasaMarko.1 <= atributaTeksto.length else { continue }
			
			atributaTeksto.addAttribute(
				.font,
				value: grasaStilo,
				range: NSMakeRange(grasaMarko.0, grasaMarko.1 - grasaMarko.0)
			)
		}
		
		for grasKursivaMarko in markoj[Klavoj.grasKursiva]! {
			guard grasKursivaMarko.0 >= 0 && grasKursivaMarko.1 <= atributaTeksto.length else { continue }
			
			atributaTeksto.addAttribute(
				.font,
				value: grasKursivaStilo,
				range: NSMakeRange(grasKursivaMarko.0, grasKursivaMarko.1 - grasKursivaMarko.0)
			)
		}
		
		for superMarko in markoj[Klavoj.supera]! {
			guard superMarko.0 >= 0 && superMarko.1 <= atributaTeksto.length else { continue }
			
			atributaTeksto.addAttribute(
				kCTSuperscriptAttributeName as NSAttributedString.Key,
				value: 2,
				range: NSMakeRange(superMarko.0, superMarko.1 - superMarko.0)
			)
		}

		for subMarko in markoj[Klavoj.suba]! {
			guard subMarko.0 >= 0 && subMarko.1 <= atributaTeksto.length else { continue }
			
			atributaTeksto.addAttribute(
				kCTSuperscriptAttributeName as NSAttributedString.Key,
				value: -2,
				range: NSMakeRange(subMarko.0, subMarko.1 - subMarko.0)
			)
		}
		
		return atributaTeksto
	}
	
	/// Legas certajn HTML-ajn kodojn el la teksto, produktas tekst-atributojn laŭ ties instrukcio, kaj ŝarĝas la etikedon je tiuj
	static func provizi(etikedon etikedo: TTTAttributedLabel, per teksto: String) {
		let markoj = TekstAtributoHelpiloj.troviMarkojn(teksto: teksto)
		etikedo.setText(TekstAtributoHelpiloj.atributaTeksto(por: teksto, kun: markoj))
		
		markoj[Klavoj.ligo]?.forEach { ligMarko in
			etikedo.addLink(
				to: URL(string: ligMarko.2),
				with: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0)
			)
		}
	}
}
