//
//  KullaniciPaylasimFotoCell.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 14.05.2024.
//

import UIKit
class KullaniciPaylasimFotoCell : UICollectionViewCell {
    var paylasim : Paylasim?{
        didSet{print ("Hücre Oluşturuldu")
            if let url = URL(string: paylasim?.PaylasimGoruntuURL ?? ""){
                imgFotoPaylasim.sd_setImage(with: url,completed: nil)
            }
        }
    }
    
    let imgFotoPaylasim : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgFotoPaylasim)
        imgFotoPaylasim.anchor(top: topAnchor , bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
