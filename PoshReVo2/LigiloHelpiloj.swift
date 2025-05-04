import Foundation
import UIKit

enum LigiloHelpiloj {
	static let markoLigoKlavo = "ligo"
	static let markoAkcentoKlavo = "akcento"
	static let markoFortoKlavo = "forto"
	static let markoSuperKlavo = "super"
	static let markoSubKlavo = "sub"
	
	/*
		Legi la tekston kaj trovi markojn reprezentata de HTML kodoj.
		Tiu trovos:
			<i>...</i> por akcentaj tekstoj
			<b>...</b> por fortaj tekstoj
			<a href="...">...</a> por ligoj
	
		La rezulto estas aro de listo de trovajhoj, en la form do (komenca loko, fina loko, ligo-teksto)
	*/
	static func troviMarkojn(teksto: String) -> [String : [(Int, Int, String)]] {
		
		var rez = [String : [(Int, Int, String)]]()
		rez[markoAkcentoKlavo] = [(Int, Int, String)]()
		rez[markoFortoKlavo] = [(Int, Int, String)]()
		rez[markoLigoKlavo] = [(Int, Int, String)]()
		rez[markoSuperKlavo] = [(Int, Int, String)]()
		rez[markoSubKlavo] = [(Int, Int, String)]()
		
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
					rez[markoAkcentoKlavo]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "b" || klavo == "g" {
				fortoStako.append(loko)
			}
			else if klavo == "/b" || klavo == "/g" {
				if let nombro = fortoStako.popLast() {
					rez[markoFortoKlavo]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "sup" {
				superStako.append(loko)
			}
			else if klavo == "/sup" {
				if let nombro = superStako.popLast() {
					rez[markoSuperKlavo]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "sub" {
				subStako.append(loko)
			}
			else if klavo == "/sub" {
				if let nombro = subStako.popLast() {
					rez[markoSubKlavo]?.append((nombro, loko, ""))
				}
			}
			else if klavo == "/a" {
				if let ligo = ligoStako.popLast() {
					let nombro = ligo.0, celo = ligo.1
					rez[markoLigoKlavo]?.append((nombro, loko, celo))
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
		
		for akcentMarko in markoj[markoAkcentoKlavo]! {
			guard akcentMarko.0 >= 0 && akcentMarko.1 <= mutaciaTeksto.length else { continue }
			
			mutaciaTeksto.addAttribute(.font, value: akcentaTeksto, range: NSMakeRange(akcentMarko.0, akcentMarko.1 - akcentMarko.0))
		}
		
		for fortMarko in markoj[markoFortoKlavo]! {
			guard fortMarko.0 >= 0 && fortMarko.1 <= mutaciaTeksto.length else { continue }
			
			var fortaRange = NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0)
			let attributes = mutaciaTeksto.attributes(at: fortMarko.0, effectiveRange: &fortaRange)
			if attributes[.font] as! UIFont == akcentaTeksto {
				mutaciaTeksto.addAttribute(.font, value: fortaAkcentaTeksto, range: NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0))
			} else {
				mutaciaTeksto.addAttribute(.font, value: fortaTeksto, range: NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0))
			}
		}
		
		for superMarko in markoj[markoSuperKlavo]! {
			guard superMarko.0 >= 0 && superMarko.1 <= mutaciaTeksto.length else { continue }
			
			mutaciaTeksto.addAttribute(kCTSuperscriptAttributeName as NSAttributedString.Key, value: 2, range: NSMakeRange(superMarko.0, superMarko.1 - superMarko.0))
		}

		for subMarko in markoj[markoSubKlavo]! {
			guard subMarko.0 >= 0 && subMarko.1 <= mutaciaTeksto.length else { continue }
			
			mutaciaTeksto.addAttribute(kCTSuperscriptAttributeName as NSAttributedString.Key, value: -2, range: NSMakeRange(subMarko.0, subMarko.1 - subMarko.0))
		}
		
		return mutaciaTeksto
		
	}
}
