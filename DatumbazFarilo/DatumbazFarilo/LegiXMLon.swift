import Foundation

func legiXMLon(el indikilo: String, delegate: XMLParserDelegate) {
	let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
	let legilo = XMLParser(data: datumoj)
	legilo.delegate = delegate
	legilo.parse()
}
