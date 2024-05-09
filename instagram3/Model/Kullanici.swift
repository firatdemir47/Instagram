//
//  Kullanici.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 7.05.2024.
//

import Foundation
struct Kullanici{
    let KullaniciAdi : String
    let KullaniciID : String
    let profilGoruntuURL : String
    init(kullaniciVerisi :[String : Any]) {
        self.KullaniciAdi = kullaniciVerisi["kullaniciAdi"] as? String ?? ""
        self.KullaniciID = kullaniciVerisi["KullaniciID"] as? String ??  ""
        self.profilGoruntuURL = kullaniciVerisi["profilGOruntuUrl"] as? String ?? ""
    }
    
}
