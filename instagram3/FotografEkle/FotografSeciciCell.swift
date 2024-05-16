//
//  FotografSeciciCell.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 13.05.2024.
//

import UIKit
class FotografSeciciCell : UICollectionViewCell {
    let imgFotograf : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .green
        return img
    }()
    override init(frame : CGRect){
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(imgFotograf)
        imgFotograf.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0    )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
