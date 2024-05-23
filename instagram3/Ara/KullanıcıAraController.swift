//
//  KullanıcıAraController.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 23.05.2024.
//

import UIKit
import Firebase
class KullanıcıAraController : UICollectionViewController ,UISearchBarDelegate{
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Kullanıcı Adını Giriniz..."
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbDonustur(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
        
    }()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filtrelenmisKullanicilar = kullaniclar
        }
        else {
            self.filtrelenmisKullanicilar = self.kullaniclar.filter({(kullanici) -> Bool in
                return kullanici.KullaniciAdi.contains(searchText)
            })}
        self.collectionView.reloadData()
    }
    let hucreId = "hucreID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor , leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        collectionView.register(KullanıcıAraCell.self,forCellWithReuseIdentifier: hucreId)
        collectionView.alwaysBounceVertical = true
        kullanicilariGetir()
    }
    var filtrelenmisKullanicilar = [Kullanici]()
    var kullaniclar = [Kullanici]()
    
    fileprivate func kullanicilariGetir(){
        Firestore.firestore().collection("kullanicilar").getDocuments{(querySnapshot , hata) in
            if let hata = hata {
                print("Kullanicilar Getirilirken Hata Meydana Geldi :\(hata.localizedDescription) ")
                
            }
            querySnapshot?.documentChanges.forEach({(degisiklik) in
                if degisiklik.type == .added {
                    let kullanici = Kullanici(kullaniciVerisi: degisiklik.document.data())
                    self.kullaniclar.append(kullanici)
                }})
            self.kullaniclar.sort { (k1, k2 ) -> Bool in
                return k1.KullaniciAdi.compare(k2.KullaniciAdi) == .orderedAscending
            }
            self.filtrelenmisKullanicilar = self.kullaniclar
            self.collectionView.reloadData()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtrelenmisKullanicilar.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hucreId, for: indexPath) as! KullanıcıAraCell
       
        cell.kullanici = filtrelenmisKullanicilar[indexPath.row]
        return cell
    }
}
extension KullanıcıAraController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
}
