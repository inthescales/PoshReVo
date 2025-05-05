import Foundation
import UIKit

enum LigiloHelpiloj {
	private enum Klavoj {
		static let ligo = "ligo"
		static let akcento = "akcento"
		static let forta = "forto"
		static let supera = "super"
		static let suba = "sub"
	}
	
	enum TekstStilo {
		case ligo
		case akcento
		case forta
		case supera
		case suba
	}
	
	struct StiloMarko {
		let komencIndekso: Int
		let finIndekso: Int
		let ligoTeksto: String?
	}

	/// Legi la tekston kaj trovi markojn en formo de HTML-kodoj.
	/// Troviĝos:
	///	<i>...</i> por akcentaj tekstoj
	///	<b>...</b> por fortaj tekstoj
	///	<a href="...">...</a> por ligoj
	///
	/// Liveras aron da listoj de trovajhoj, en la form de (komenca loko, fina loko, ligo-teksto)
	static func troviMarkojn(teksto: String) -> [String : [(Int, Int, String)]] {
		
		var rez = [String : [(Int, Int, String)]]()
		rez[Klavoj.akcento] = [(Int, Int, String)]()
		rez[Klavoj.forta] = [(Int, Int, String)]()
		rez[Klavoj.ligo] = [(Int, Int, String)]()
		rez[Klavoj.supera] = [(Int, Int, String)]()
		rez[Klavoj.suba] = [(Int, Int, String)]()
		
		let regesp = try! NSRegularExpression(pattern: "<(/?([ikbga]|sup|sub|frm))( (href|am)=\"(.*?)\")?>")
		let matches = regesp.matches(in: teksto, range: NSRange(teksto.startIndex..., in: teksto))
		
		var rubo = 0
		var ligoStako = [(Int, String)]()
		var akcentoStako = [Int]()
		var fortoStako = [Int]()
		var superStako = [Int]()
		var subStako = [Int]()
		
		for match in matches {
			
			let range = match.range
			let klavo = String(teksto[Range(match.range(at: 1), in: teksto)!])
			let loko = range.location - rubo
			
			if klavo == "i" || klavo == "k" {
				akcentoStako.append(loko)
			}
			else if klavo == "/i" || klavo == "/k" {
				if let nombro = akcentoStako.popLast() {
					rez[Klavoj.akcento]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "b" || klavo == "g" {
				fortoStako.append(loko)
			}
			else if klavo == "/b" || klavo == "/g" {
				if let nombro = fortoStako.popLast() {
					rez[Klavoj.forta]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "sup" {
				superStako.append(loko)
			}
			else if klavo == "/sup" {
				if let nombro = superStako.popLast() {
					rez[Klavoj.supera]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "sub" {
				subStako.append(loko)
			}
			else if klavo == "/sub" {
				if let nombro = subStako.popLast() {
					rez[Klavoj.suba]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "/a" {
				if let ligo = ligoStako.popLast() {
					let nombro = ligo.0, celo = ligo.1
					rez[Klavoj.ligo]?.append((nombro, loko, celo))
				}
			}
			else if klavo == "a" && match.numberOfRanges >= 4 {
				let ligLoko = match.range(at: 5)
				if ligLoko.location != NSNotFound {
					let ligCelo = String(teksto[Range(ligLoko, in: teksto)!])
					ligoStako.append((loko, ligCelo))
				}
			} else {

			}
				
			rubo += range.length
		}
		
		return rez
	}

	// Forigi la HTML kodojn el la teksto, por ke ghi povu montriĝi nude
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
	static func pretigiTekston(_ teksto: String, kunMarkoj markoj: [String : [(Int, Int, String)]] ) -> NSMutableAttributedString {
		
		let mutaciaTeksto: NSMutableAttributedString = NSMutableAttributedString(string: forigiAngulojn(teksto: teksto))
		let tekstGrandeco = UIFont.preferredFont(forTextStyle: .body).pointSize
		let tekstStilo = UIFont.systemFont(ofSize: tekstGrandeco)
		let fortaTeksto = UIFont.boldSystemFont(ofSize: tekstGrandeco)
		let akcentaTeksto = UIFont.italicSystemFont(ofSize: tekstGrandeco)

		let fortaAkcentaDescriptor = fortaTeksto.fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold])!
		let fortaAkcentaTeksto = UIFont(descriptor: fortaAkcentaDescriptor, size: tekstGrandeco)
	
		mutaciaTeksto.addAttribute(.font, value: tekstStilo, range: NSMakeRange(0, mutaciaTeksto.length))
		mutaciaTeksto.addAttribute(.foregroundColor, value: InterfacStilo.nuna.teksto, range: NSMakeRange(0, mutaciaTeksto.length)) // TODO: Injekcii stilon
		
		for akcentMarko in markoj[Klavoj.akcento]! {
			guard akcentMarko.0 >= 0 && akcentMarko.1 <= mutaciaTeksto.length else { continue }
			
			mutaciaTeksto.addAttribute(.font, value: akcentaTeksto, range: NSMakeRange(akcentMarko.0, akcentMarko.1 - akcentMarko.0))
		}
		
		for fortMarko in markoj[Klavoj.forta]! {
			guard fortMarko.0 >= 0 && fortMarko.1 <= mutaciaTeksto.length else { continue }
			
			var fortaRange = NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0)
			let attributes = mutaciaTeksto.attributes(at: fortMarko.0, effectiveRange: &fortaRange)
			if attributes[.font] as! UIFont == akcentaTeksto {
				mutaciaTeksto.addAttribute(.font, value: fortaAkcentaTeksto, range: NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0))
			} else {
				mutaciaTeksto.addAttribute(.font, value: fortaTeksto, range: NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0))
			}
		}
		
		for superMarko in markoj[Klavoj.supera]! {
			guard superMarko.0 >= 0 && superMarko.1 <= mutaciaTeksto.length else { continue }
			
			mutaciaTeksto.addAttribute(kCTSuperscriptAttributeName as NSAttributedString.Key, value: 2, range: NSMakeRange(superMarko.0, superMarko.1 - superMarko.0))
		}

		for subMarko in markoj[Klavoj.suba]! {
			guard subMarko.0 >= 0 && subMarko.1 <= mutaciaTeksto.length else { continue }
			
			mutaciaTeksto.addAttribute(kCTSuperscriptAttributeName as NSAttributedString.Key, value: -2, range: NSMakeRange(subMarko.0, subMarko.1 - subMarko.0))
		}
		
		return mutaciaTeksto
	}
}
