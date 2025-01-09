import Foundation

let radiko = FileManager.default.currentDirectoryPath
var revoIndiko: String = radiko + "/fontoj/revo"
var grundIndiko: String = radiko + "/fontoj/grundo"

let lingvoAnalizilo = LingvoAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/lingvoj.xml", delegate: lingvoAnalizilo)
let lingvoj = lingvoAnalizilo.lingvoj

let fakoAnalizilo = FakoAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/fakoj.xml", delegate: fakoAnalizilo)
let fakoj = fakoAnalizilo.fakoj

let mallongigoAnalizilo = MallongigoAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/mallongigoj.xml", delegate: mallongigoAnalizilo)
let mallongigoj = mallongigoAnalizilo.mallongigoj

let stiloAnalizilo = StiloAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/stiloj.xml", delegate: stiloAnalizilo)
let stiloj = stiloAnalizilo.stiloj

let literoAnalizilo = LiteroAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/literoj.xml", delegate: literoAnalizilo)
let literoj = literoAnalizilo.literoj

for (key, val) in stiloj {
	print(key + ": " + val)
}

print("All done :)")
