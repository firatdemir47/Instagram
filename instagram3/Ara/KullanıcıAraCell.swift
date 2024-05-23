//
//  KullanıcıAraCell.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 23.05.2024.
//

import UIKit
class KullanıcıAraCell : UICollectionViewCell {
    var kullanici : Kullanici? {
        didSet{
            lblKullaniciAdi.text = kullanici?.KullaniciAdi
            if let url = URL(string: kullanici?.profilGoruntuURL ?? ""){
                imgKullaniciProfil.sd_setImage(with : url , completed : nil)
            }
        }
    }
    let lblKullaniciAdi : UILabel = {
       let lbl = UILabel()
        lbl.text = "Kullanıcı Adı"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    let imgKullaniciProfil : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .yellow
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    override init(frame : CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgKullaniciProfil)
        addSubview(lblKullaniciAdi)
        imgKullaniciProfil.layer.cornerRadius = 55 / 2
        imgKullaniciProfil.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 55, height: 55)
        imgKullaniciProfil.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lblKullaniciAdi.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgKullaniciProfil.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        
    let ayracView = UIView()
        ayracView.backgroundColor = UIColor(white: 0, alpha: 0.45)
        addSubview(ayracView)
        ayracView.anchor(top: nil, bottom: bottomAnchor, leading: lblKullaniciAdi.leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.45)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
