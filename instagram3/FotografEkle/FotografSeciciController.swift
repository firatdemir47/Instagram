//
//  FotografSeciciController.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 11.05.2024.
//

import UIKit
import Photos
class FotografSeciciController : UICollectionViewController{
    let hucreID = "hucreID"
    let headerID = "headerID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        butonEkle()
        collectionView.register(FotografSeciciCell.self, forCellWithReuseIdentifier: hucreID)
        collectionView.register(FotografSeciciHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        fotograflarıgetir()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        secilenFotograf = fotograflar[indexPath.row]
        collectionView.reloadData()
    
        let indexUst = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexUst, at: .bottom, animated: true)
        
    }
    var assetler = [PHAsset]()
    var secilenFotograf : UIImage?
    var fotograflar = [UIImage]()
    fileprivate func FotogtafGetirmeSEcenekOlustur()-> PHFetchOptions{
        let getirmeSecenekleri = PHFetchOptions()
        getirmeSecenekleri.fetchLimit = 35
        let SiralamaAyari = NSSortDescriptor(key: "creationDate", ascending: false)
        getirmeSecenekleri.sortDescriptors = [SiralamaAyari]
        return getirmeSecenekleri
    }
    fileprivate func  fotograflarıgetir() {
      
        let fotograflar = PHAsset.fetchAssets(with: .image, options: FotogtafGetirmeSEcenekOlustur())
        DispatchQueue.global(qos: .background).async {
            fotograflar.enumerateObjects{(asset,sayi,durmaNoktasi) in
                print("\(sayi).Fotograf Getirildi")
                
                let imageManager = PHImageManager.default()
                let goruntuBoyutu = CGSize(width: 200,  height: 200)
                let secenekler = PHImageRequestOptions()
                secenekler.isSynchronous = true
                imageManager.requestImage(for: asset,targetSize: goruntuBoyutu,contentMode: .aspectFit,options: secenekler){
                    (goruntu,goruntuBilgileri) in
                    if let fotograf = goruntu{
                        self.assetler.append(asset)
                        self.fotograflar.append(fotograf)
                        if self.secilenFotograf == nil{
                            self.secilenFotograf = goruntu
                        }
                     
                    }
                    if sayi == fotograflar.count - 1 {
                        DispatchQueue.main.async{
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let genislik = view.frame.width
        return CGSize(width: genislik, height: genislik)
    }
    var header : FotografSeciciHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! FotografSeciciHeader
        self.header = header
        header.imgHeader.image = secilenFotograf
        if let secilenFotograf = secilenFotograf{
            if let index = self.fotograflar.firstIndex(of: secilenFotograf){
                let secilenAsset = self.assetler[index]
                let fotoManager = PHImageManager.default()
                let boyut = CGSize(width: 600, height: 600)
                fotoManager.requestImage(for: secilenAsset, targetSize: boyut, contentMode: .default, options: nil){
                    (foto , bilgi) in
                    header.imgHeader.image = foto
                }            }
        }
   
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fotograflar.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! FotografSeciciCell
        hucre.imgFotograf.image = fotograflar[indexPath.row]
        return hucre
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    fileprivate func butonEkle(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "İptal Et" ,style : .plain , target : self , action :#selector(btnIPtalPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sonraki", style: .plain, target: self, action: #selector(BtnSonrakiPressed))
    }
    @objc func BtnSonrakiPressed(){
    let fotoPaylasController = FotografPaylasController()
        fotoPaylasController.secilenFotograf = header?.imgHeader.image
        navigationController?.pushViewController(fotoPaylasController, animated: true)
    }
    @objc func btnIPtalPressed (){
        dismiss(animated: true , completion: nil)
    }
}
extension UINavigationController{
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
extension FotografSeciciController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = (view.frame.width - 3) / 4
        return CGSize(width: genislik, height: genislik)
    }
}
