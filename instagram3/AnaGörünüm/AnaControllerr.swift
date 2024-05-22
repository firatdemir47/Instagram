//
//  AnaControllerr.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 22.05.2024.
//

import UIKit
import Firebase
class AnaControllerr : UICollectionViewController {
    let hucreID = "hucreID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(AnaPaylasımCelll.self,forCellWithReuseIdentifier: hucreID)
        butonlariOlustur()
        paylasimlariGetir()
    }
    var paylasimlar = [Paylasim]()
    fileprivate func paylasimlariGetir(){
        paylasimlar.removeAll()
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID)
            .collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi " ,descending: false)
            .addSnapshotListener{(querySnapshot , hata) in
                if let hata = hata {
                    print("Paylaşimlar Getirilirken Hata Meydana Geldi",hata.localizedDescription)
                  return
                }
                querySnapshot?.documentChanges.forEach({(degisiklik) in
                    if degisiklik.type == .added {
                        let paylasimVerisi = degisiklik.document.data()
                        let paylasim = Paylasim(sozlukVerisi: paylasimVerisi)
                        self.paylasimlar.append(paylasim)
                        
                    }
                    
                })
                self.paylasimlar.reverse()
                self.collectionView.reloadData()
            }}
    fileprivate func butonlariOlustur(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ööö.png"))
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasımCelll
        hucre.paylasim = paylasimlar[indexPath.row]
      
        return hucre
    }
}
extension AnaControllerr : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var yükseklik : CGFloat = 55
        yükseklik += view.frame.width
        yükseklik += 50
        yükseklik += 70
        return CGSize(width: view.frame.width, height: yükseklik)
    }
}
