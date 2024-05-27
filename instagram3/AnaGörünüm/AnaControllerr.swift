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
        
        NotificationCenter.default.addObserver(self, selector: #selector(paylasimlarYenile), name: FotografPaylasController.guncelleNotification, object: nil)
        collectionView.backgroundColor = .white
        collectionView.register(AnaPaylasımCelll.self,forCellWithReuseIdentifier: hucreID)
        butonlariOlustur()
        //kullaniciyiGetir()//burası sonra aktifleştirilecektir
        
       takipEdilenKIDDegerleriGetir()
      let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(paylasimlarYenile), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    @objc fileprivate func paylasimlarYenile(){
        print("Paylaşımlar Yenileniyor")
        paylasimlar.removeAll()
        collectionView.reloadData()
        takipEdilenKIDDegerleriGetir()
        kullaniciyiGetir()
    }
    fileprivate func takipEdilenKIDDegerleriGetir(){
        guard let kID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("TakipEdiyor").document(kID).addSnapshotListener { (documentSnapshot,hata)  in
            if let hata = hata {
                print("Paylaşımlar Getirilirken Hata Oluştu : " ,hata.localizedDescription)
                return
            }
            guard let paylasimSozlukVerisi = documentSnapshot?.data() else {return}
            paylasimSozlukVerisi.forEach{(key,value) in
                Firestore.kullaniciOlustur(kullaniciID: key){ (kullanici) in
                    self.paylasimlariGetir(kullanici: kullanici)
                }
            }
        }
    }
    var paylasimlar = [Paylasim]()
    fileprivate func paylasimlariGetir(kullanici : Kullanici){
        
        
        Firestore.firestore().collection("Paylasimlar").document(kullanici.KullaniciID)
            .collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi " ,descending: false)
            .addSnapshotListener{(querySnapshot , hata) in
                self.collectionView.refreshControl?.endRefreshing()
                if let hata = hata {
                    print("Paylaşimlar Getirilirken Hata Meydana Geldi",hata.localizedDescription)
                  return
                }
                querySnapshot?.documentChanges.forEach({(degisiklik) in
                    if degisiklik.type == .added {
                        let paylasimVerisi = degisiklik.document.data()
                        let paylasim = Paylasim(kullanici : kullanici ,sozlukVerisi: paylasimVerisi)
                        self.paylasimlar.append(paylasim)
                        
                    }
                    
                })
                self.paylasimlar.reverse()
                self.paylasimlar.sort{(p1 , p2)-> Bool in
                    return p1.PaylasimTarihi.dateValue().compare(p2.PaylasimTarihi.dateValue()) == .orderedDescending
                }
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
    var gecerliKullanici : Kullanici?
    fileprivate func kullaniciyiGetir(kullaniciID : String = ""){
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        let KID = kullaniciID == "" ? gecerliKullaniciID : kullaniciID
        Firestore.firestore().collection("kullanicilar").document(KID).getDocument{(snapshot,hata) in
            if let hata = hata {
                print("Kullanıcı Bİlgileri Getirilemedi :" ,hata)
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            guard let kullanici = self.gecerliKullanici else {return}
            self.paylasimlariGetir(kullanici: kullanici)
        }
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
