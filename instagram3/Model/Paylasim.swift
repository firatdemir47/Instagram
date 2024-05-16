//
//  Paylasim.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 14.05.2024.
//

import Firebase
struct Paylasim {
    let PaylasimGoruntuURL : String?
    let GoruntuGenislik : Double?
    let GoruntuYukseklik : Double?
    let KullaniciId : String?
    let Mesaj : String?
    let PaylasimTarihi : Timestamp?
    init(sozlukVerisi : [String : Any]){
        self.PaylasimGoruntuURL = sozlukVerisi["PaylasimGoruntuURL"] as? String
        self.GoruntuGenislik = sozlukVerisi["GoruntuGenislik"] as? Double
        self.GoruntuYukseklik = sozlukVerisi["GoruntuYukseklik"] as? Double
        self.KullaniciId = sozlukVerisi["KullaniciId"] as? String
        self.Mesaj = sozlukVerisi["Mesaj"] as? String
        self.PaylasimTarihi = sozlukVerisi[" PaylasimTarihi"] as? Timestamp
        
    }
}

