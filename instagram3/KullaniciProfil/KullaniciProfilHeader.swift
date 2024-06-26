//
//  KullaniciProfilHeader.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 7.05.2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
class KullaniciProfilHeader : UICollectionViewCell{
    var gecerliKullanici : Kullanici? {
        didSet{
            takipButonuAyarla()
            guard let url = URL(string: gecerliKullanici?.profilGoruntuURL ?? "") else {return}
            imgProfilGoruntu.sd_setImage(with: url,completed: nil)
            lblKullaniciAdi.text = gecerliKullanici?.KullaniciAdi
        }
        
    }
    fileprivate func takipButonuAyarla() {
        guard let oturumKID = Auth.auth().currentUser?.uid else {return}
        guard let gecerliKID = gecerliKullanici?.KullaniciID else {return}
        if oturumKID != gecerliKID {
            Firestore.firestore().collection("TakipEdiyor").document(oturumKID).getDocument { (snapshot, hata) in
                if let hata = hata {
                    print("Takip Verisi ALınamadı:" ,hata.localizedDescription)
                    return
                }
                guard let takipVerileri = snapshot?.data() else {return}
                if let veri = takipVerileri[gecerliKID]{
                    let takip = veri as! Int
                    print(takip)
                    if takip == 1 {
                        self.btnprofilDüzenle.setTitle("Takipten Çıkar", for: .normal)
                    } }
                    else {
                        self.btnprofilDüzenle.setTitle("Takip Et", for: .normal)
                        self.btnprofilDüzenle.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 240)
                        self.btnprofilDüzenle.setTitleColor(.white, for: .normal)
                        self.btnprofilDüzenle.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                        self.btnprofilDüzenle.layer.borderWidth = 1
                    }
                    
                }
            }
        else {
            self.btnprofilDüzenle.setTitle("Profili Düzenle", for: .normal)
        }
               
        }
        
    
   lazy var btnprofilDüzenle : UIButton = {
        let btn = UIButton(type: .system)
     
        btn.setTitleColor(.black ,for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(btnProfil_Takip_Düzenle), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnProfil_Takip_Düzenle(){
        guard let oturumuAcanKID = Auth.auth().currentUser?.uid else {return}
            guard let gecerliKID = gecerliKullanici?.KullaniciID else {return}
        
        if btnprofilDüzenle.titleLabel?.text == "Takipten Çıkar" {
            Firestore.firestore().collection("TakiEdiyor").document(oturumuAcanKID).updateData([gecerliKID: FieldValue.delete()]){(hata) in
                if let hata = hata {
                    print("Takipten Çıkarırken Hata Meydana Geldi : \(hata.localizedDescription)")
                    
                }
                print("\(self.gecerliKullanici?.KullaniciAdi ?? "") Adlı Kullanıcı Takipten Çıkarıldı ")
                self.btnprofilDüzenle.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 240)
                self.btnprofilDüzenle.setTitleColor(.white, for: .normal)
                self.btnprofilDüzenle.layer.borderWidth = 1
                self.btnprofilDüzenle.setTitle("Takip Et", for: .normal)
            }
            return
        }
        
        
        let eklenecekDeger = [gecerliKID : 1]
        
        
        Firestore.firestore().collection("TakipEdiyor").document(oturumuAcanKID).getDocument{(snapshot , hata) in
            if let hata = hata {
                print("Takip verisi alınmadı : \(hata.localizedDescription)")
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("TakipEdiyor").document(oturumuAcanKID).updateData(eklenecekDeger){
                    (hata) in
                    if let hata = hata {
                        print("Takip Verisi Güncellemesi Başarısız : \(hata.localizedDescription)")
                        return
                    }
                    print("Takip İşlemi Başarılı")
                    self.btnprofilDüzenle.setTitle("Takipten Çıkar", for: .normal)
                    self.btnprofilDüzenle.setTitleColor(.black, for: .normal)
                    self.btnprofilDüzenle.backgroundColor = .white
                    self.btnprofilDüzenle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    self.btnprofilDüzenle.layer.borderColor = UIColor.lightGray.cgColor
                    self.btnprofilDüzenle.layer.borderWidth = 1
                    self.btnprofilDüzenle.layer.cornerRadius = 5
                }
            }
            else {
                Firestore.firestore().collection("Takip Ediyor").document(oturumuAcanKID).setData(eklenecekDeger)
                { (hata) in
                    if let hata = hata {
                        print("Takip Verisi Kaydı Başarısız : \(hata.localizedDescription)")
                        return
                    }
                    print("Takip işlemi Başarılı")
                }            }
            
            }
        }
    
    let lblPaylasım : UILabel = {
        
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "10\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Paylaşım",attributes: [.foregroundColor : UIColor.darkGray,.font : UIFont.systemFont(ofSize: 14)]))
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    let lblTakipçi : UILabel = {
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "30\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Takipçi",attributes: [.foregroundColor : UIColor.darkGray,.font : UIFont.systemFont(ofSize: 14)]))
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
        
    }()
    let lblTakipEdiyor : UILabel = {
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "20\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Takip Ediyor",attributes: [.foregroundColor : UIColor.darkGray,.font : UIFont.systemFont(ofSize: 14)]))
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    let lblKullaniciAdi : UILabel = {
        let lbl = UILabel()
        lbl.text = "Kullanıcı Adı"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
        
    }()
    let btnGrid : UIButton = {
        let btn = UIButton(type: .system)
       // let symbl = UIImage(systemName: ".bounce")
        //btn.setImage(symbl, for: .normal)
        btn.setImage(#imageLiteral(resourceName: "Izgara"), for: .normal)
        return btn
        
    }()
    let btnListe : UIButton = {
        let btn = UIButton(type: .system)
    
        btn.setImage(#imageLiteral(resourceName: "Liste"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
        
    }()
    let btnYerIsareti : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "Liste2"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
        
    }()
    
  
    let imgProfilGoruntu : UIImageView = {
        
        let img = UIImageView()
        img.backgroundColor = .yellow
        return img
    }()
    override init(frame : CGRect){
        
        super.init(frame: frame)
        
        addSubview(imgProfilGoruntu)
        let goruntuBoyut : CGFloat = 90
        imgProfilGoruntu.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: goruntuBoyut, height: goruntuBoyut)
        imgProfilGoruntu.layer.cornerRadius = goruntuBoyut / 2
        imgProfilGoruntu.clipsToBounds = true
        toolbarOluştur()
    addSubview(lblKullaniciAdi)
        lblKullaniciAdi.anchor(top: imgProfilGoruntu.bottomAnchor, bottom: btnGrid.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0 , paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
    kullaniciDurumBilgisiGoster()
    addSubview(btnprofilDüzenle)
        btnprofilDüzenle.anchor(top: lblPaylasım.bottomAnchor, bottom: nil, leading: lblPaylasım.leadingAnchor, trailing: lblTakipEdiyor.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)
    }
    fileprivate func kullaniciDurumBilgisiGoster(){
        let stackView = UIStackView(arrangedSubviews: [lblPaylasım,lblTakipçi,lblTakipEdiyor])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, bottom: nil, leading: imgProfilGoruntu.trailingAnchor, trailing: trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 60)
    }
    fileprivate func  toolbarOluştur(){
        let ustAyracView = UIView()
        ustAyracView.backgroundColor = UIColor.lightGray
        let altAyracView = UIView()
        altAyracView.backgroundColor = UIColor.lightGray
        let stackView = UIStackView(arrangedSubviews: [btnGrid,btnListe,btnYerIsareti])
        addSubview(stackView)
        addSubview(ustAyracView)
        addSubview(altAyracView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        ustAyracView.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        altAyracView.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

