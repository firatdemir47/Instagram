//
//  Uzanti+Date.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 27.05.2024.
//

import Foundation
extension Date {
    func zamanOnceHesap() -> String {
        let saniyeOnce = Int(Date().timeIntervalSince(self))
        let dakika = 60
        let saat = 60 * dakika
        let gun = 24 * saat
        let hafta = 7*gun
        let ay = 4 * hafta
        let oran : Int
        let birim : String
        if saniyeOnce<dakika {
            oran = saniyeOnce
            birim = "Saniye"
        }
        else if saniyeOnce<saat {
            oran = saniyeOnce / dakika
            birim = "Dakika"
        }
        else if saniyeOnce<gun {
            oran = saniyeOnce / saat
            birim = "Saat"
        }
        else if saniyeOnce < hafta {
            oran = saniyeOnce / gun
            birim = "Gün"
            }
        else if saniyeOnce<ay {
            oran = saniyeOnce / hafta
            birim = "Hafta"
        }
        else {
            oran = saniyeOnce / ay
            birim = "Ay"
        }
        return "\(oran)\(birim) Önce"
    }
}
