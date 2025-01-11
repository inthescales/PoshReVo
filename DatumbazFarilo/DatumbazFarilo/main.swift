import Foundation
import CoreData
import ReVoDatumbazoOSX

print(FileManager.default.currentDirectoryPath)
let radiko = "/Users/robin/Desktop"
var revoIndiko: String = radiko + "/fontoj/revo"
var grundIndiko: String = radiko + "/fontoj/grundo"

let konteksto = kreiDatumbazon(fontIndiko: radiko + "/fontoj", destino: radiko + "/PoshReVoDatumbazo.sqlite")

// Legi grundaĵojn
LingvoAnalizilo2.legi(el: grundIndiko + "/cfg/lingvoj.xml", en: konteksto)
FakoAnalizilo2.legi(el: grundIndiko + "/cfg/fakoj.xml", en: konteksto)
MallongigoAnalizilo2.legi(el: grundIndiko + "/cfg/mallongigoj.xml", en: konteksto)
StiloAnalizilo2.legi(el: grundIndiko + "/cfg/stiloj.xml", en: konteksto)
Oficialecoj.aldoni(al: konteksto)
let literoj = LiteroAnalizilo.legi(el: grundIndiko + "/cfg/literoj.xml")

// Legi artikolojn
ArtikolAnalizilo.legi(el: revoIndiko + "/revo/abak.xml", en: konteksto, literoj: literoj)

print("All done :)")
