//
//  AnaPaylasımCelll.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 22.05.2024.
//

import UIKit
class AnaPaylasımCelll : UICollectionViewCell {
    var paylasim : Paylasim?{
        didSet{
            guard let url = paylasim?.PaylasimGoruntuURL ,
                  let goruntuUrl = URL(string: url) else {return}
            imgPaylasimFoto.sd_setImage(with: goruntuUrl,completed: nil)
            lblkUllaniciAdi.text = paylasim?.kullanici.KullaniciAdi
            guard let pUrl = paylasim?.kullanici.profilGoruntuURL,
                  let ProfilGoruntuURL = URL(string: pUrl) else {return}
            imgKullaniciProfilFoto.sd_setImage(with: ProfilGoruntuURL,completed: nil)
           attrPaylasimMesajıOlustur()
        }
    }
    fileprivate func  attrPaylasimMesajıOlustur(){
        guard let paylasim = self.paylasim else {return}
        let attrText = NSMutableAttributedString(string: paylasim.kullanici.KullaniciAdi,attributes: [
         .font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSAttributedString(string: "\(paylasim.Mesaj  ?? "Veri Yok") ",attributes: [.font : UIFont.systemFont(ofSize: 14)]))
         attrText.append(NSAttributedString(string: "\n\n",attributes: [.font : UIFont.systemFont(ofSize: 4)]))
        let paylasimZaman = paylasim.PaylasimTarihi.dateValue()
        attrText.append(NSAttributedString(string: paylasimZaman.zamanOnceHesap() ,attributes: [
             .font : UIFont.systemFont(ofSize: 14),.foregroundColor : UIColor.gray]))
        lblPaylasimMesaj.attributedText = attrText
    }
    let lblPaylasimMesaj : UILabel = {
        let lbl = UILabel()

     
        lbl.numberOfLines = 0
        
        return lbl
        
    }()
    let btnBookmark : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        return btn
    }()
    let btnBegen : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        return btn
        
    }()
    let btnYOrumYap : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "message"), for: .normal)
        return btn
        
    }()
    let btnMSesajGönder : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        return btn
    }()
    let btnSecenekler : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
        
    }()
    let lblkUllaniciAdi : UILabel = {
       let lbl = UILabel()
        lbl.text = "Kullanıcı Adı"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
        
    }()
    let imgKullaniciProfilFoto : UIImageView = {
      let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .blue
        return img
    }()
    
    let imgPaylasimFoto : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
        
    }()
    override init(frame : CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(imgKullaniciProfilFoto)
        addSubview(lblkUllaniciAdi)
        addSubview(btnSecenekler)
        addSubview(imgPaylasimFoto)
        imgKullaniciProfilFoto.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        imgKullaniciProfilFoto.layer.cornerRadius = 40/2
        lblkUllaniciAdi.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: imgKullaniciProfilFoto.trailingAnchor, trailing: btnSecenekler.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0 )
        btnSecenekler.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        imgPaylasimFoto.anchor(top: imgKullaniciProfilFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        _ = imgPaylasimFoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        etkilesimButonlariOlustur()
    }
    fileprivate func etkilesimButonlariOlustur(){
        let stackView = UIStackView(arrangedSubviews: [btnBegen,btnYOrumYap,btnMSesajGönder])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 50)
        addSubview(btnBookmark)
        btnBookmark.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
    addSubview(lblPaylasimMesaj)
        lblPaylasimMesaj.anchor(top: btnBegen.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
