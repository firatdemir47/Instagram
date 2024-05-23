//
//  Paylasim.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 14.05.2024.
//

import Firebase
struct Paylasim {
    let kullanici : Kullanici
    let PaylasimGoruntuURL : String?
    let GoruntuGenislik : Double?
    let GoruntuYukseklik : Double?
    let KullaniciId : String?
    let Mesaj : String?
    let PaylasimTarihi : Timestamp?
    init(kullanici : Kullanici,sozlukVerisi : [String : Any]){
        self.kullanici = kullanici
        self.PaylasimGoruntuURL = sozlukVerisi["PaylasimGoruntuURL"] as? String
        self.GoruntuGenislik = sozlukVerisi["GoruntuGenislik"] as? Double
        self.GoruntuYukseklik = sozlukVerisi["GoruntuYukseklik"] as? Double
        self.KullaniciId = sozlukVerisi["KullaniciId"] as? String
        self.Mesaj = sozlukVerisi["Mesaj "] as? String
        self.PaylasimTarihi = sozlukVerisi[" PaylasimTarihi"] as? Timestamp
        
    }
}

