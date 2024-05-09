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
    let paylasımHucreID = "paylasımHucreID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
       
        kullaniciyiGetir()
        collectionView.register(KullaniciProfilHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier: paylasımHucreID)
        btnOturumKapatOlustur()
    }
    fileprivate func btnOturumKapatOlustur()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Liste3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(oturumKapat))
        
    }
    @objc fileprivate func oturumKapat(){
        let alertController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        let actionOturumKapat = UIAlertAction(title: "Oturumu Kapat", style: .destructive){ (_) in
            print("Oturum Kapatılacak Kodlar buraya yazılacal")
            guard let _ = Auth.auth().currentUser?.uid else {return}
            do{//oturum Kapatılıyor
                try Auth.auth().signOut()
                let oturumAcController = OturumACCOntroller()
                let navContoller = UINavigationController(rootViewController: oturumAcController)
                navContoller.modalPresentationStyle = .fullScreen
                self.present(navContoller , animated: true , completion: nil)
                
                
            }catch let oturumukapatmahatasi{
                
                print("Oturumu kapatırken hata oluştu :",oturumukapatmahatasi)
            }
        }
        let actionIptalEt = UIAlertAction(title: "İptal Et", style: .cancel,handler: nil)
        alertController.addAction(actionOturumKapat)
        alertController.addAction(actionIptalEt)
        present(alertController , animated: true,completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = (view.frame.width - 5) / 3
        return CGSize(width: genislik, height: genislik)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paylasımHucre = collectionView.dequeueReusableCell(withReuseIdentifier: paylasımHucreID, for: indexPath)
        paylasımHucre.backgroundColor = .blue
        return paylasımHucre
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! KullaniciProfilHeader
        header.gecerliKullanici = gecerliKullanici
     
        return header
    }
    var gecerliKullanici : Kullanici?
    fileprivate func kullaniciyiGetir(){
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("kullanicilar").document(gecerliKullaniciID).getDocument {(snapshot , hata) in
            if let hata = hata {
                print ("kullanici Bİlgileri Getirelemedi :" ,hata)
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
           //let kullaniciAdi = kullaniciVerisi["kullaniciAdi"] as? String
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            self.collectionView.reloadData()
            self.navigationItem.title = self.gecerliKullanici?.KullaniciAdi
     
        }
    }
}
extension KullaniciProfilController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
  
}
