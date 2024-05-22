//
//  AnaPaylasimCell.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 21.05.2024.
//

import UIKit
class AnaPaylasimCell : UICollectionViewCell {
    var paylasim : Paylasim? {
        didSet{
            guard let url = paylasim?.PaylasimGoruntuURL ,
                  let goruntuUrl = URL(string: url) else{return}
            imgPaylasimFoto.sd_setImage(with: goruntuUrl,completed: nil)
        }
    }
    let imgPaylasimFoto : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgPaylasimFoto)
        imgPaylasimFoto.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
