//
//  AnaController.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 21.05.2024.
//

import UIKit
import Firebase


class AnaController : UICollectionViewController {
    let hucreID = "hucreID"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(AnaPaylasimCell.self,forCellWithReuseIdentifier: hucreID)
   butonlariOlustur()
        paylasimlariGetir()
    }
    var paylasimlar = [Paylasim]()
    fileprivate func paylasimlariGetir(){
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID).collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi ",descending: false)
            .addSnapshotListener {(QuerySnapshot , hata) in
                if let hata = hata {
                    print("Paylaşımlar getirilirken hata meydana geldi :" ,hata)
                    return
                }
                QuerySnapshot?.documentChanges.forEach({(degisiklik) in
                    if degisiklik.type == .added{
                        let paylasimVerisi = degisiklik.document.data()
                       let paylasim = Paylasim(sozlukVerisi: paylasimVerisi)
                        self.paylasimlar.append(paylasim)
                    }})
                
                self.paylasimlar.reverse()
                self.collectionView.reloadData()
            }}
    fileprivate func  butonlariOlustur(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ööö.png"))
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasimCell
        hucre.paylasim = paylasimlar[indexPath.row]
        hucre.backgroundColor = .red
        return hucre
    }
    
}
extension AnaController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 220)
    }
    
}
