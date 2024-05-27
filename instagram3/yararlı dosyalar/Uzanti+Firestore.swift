//
//  Uzanti+Firestore.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 27.05.2024.
//

import Firebase
extension Firestore {
    static func kullaniciOlustur(kullaniciID : String = "" , completion : @escaping(Kullanici)-> ()){
        var KID = ""
        if kullaniciID == "" {
            guard let gecerliKullaniciId = Auth.auth().currentUser?.uid else {return}
            KID = gecerliKullaniciId }
        else {
            KID = kullaniciID
        }
        Firestore.firestore().collection("kullanicilar").document(KID).getDocument{(snapshot , hata) in
            if let hata = hata {
                print("Kullanici Bilgileri Getirilemedi :" ,hata.localizedDescription)
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
            let kullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            completion(kullanici)
        }
        }
        
    }
    

