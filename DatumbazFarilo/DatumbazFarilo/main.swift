import Foundation
import CoreData
import ReVoDatumbazoOSX

print(FileManager.default.currentDirectoryPath)

var revoIndiko: String = radiko + "/fontoj/revo"
var grundIndiko: String = radiko + "/fontoj/grundo"

let konteksto = kreiDatumbazon(fontIndiko: radiko + "/fontoj", destino: radiko + "/PoshReVoDatumbazo.sqlite")

LingvoAnalizilo2.legi(el: grundIndiko + "/cfg/lingvoj.xml", en: konteksto)
FakoAnalizilo2.legi(el: grundIndiko + "/cfg/fakoj.xml", en: konteksto)
MallongigoAnalizilo2.legi(el: grundIndiko + "/cfg/mallongigoj.xml", en: konteksto)
StiloAnalizilo2.legi(el: grundIndiko + "/cfg/stiloj.xml", en: konteksto)
Oficialecoj.aldoni(al: konteksto)

print("All done :)")
