//
//  KullaniciProfilController.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 4.05.2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
class KullaniciProfilController : UICollectionViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "Kullanıcı Profili"
        kullaniciyiGetir()
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
        header.backgroundColor = .green
        return header
    }
    fileprivate func kullaniciyiGetir(){
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("kullanicilar").document(gecerliKullaniciID).getDocument {(snapshot , hata) in
            if let hata = hata {
                print ("kullanici Bİlgileri Getirelemedi :" ,hata)
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
            let kullaniciAdi = kullaniciVerisi["kullaniciAdi"] as? String
            self.navigationItem.title = kullaniciAdi
            print ("KullanıcıID:",gecerliKullaniciID)
            print ("KullanıcıAdı :" ,kullaniciAdi ?? "")
        }
    }
}
extension KullaniciProfilController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
  
}
