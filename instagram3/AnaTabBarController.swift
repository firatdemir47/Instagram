//
//  AnaTabBarController.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 4.05.2024.
//

import Foundation
import UIKit
import Firebase
class AnaTabBarController : UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil{
            
            DispatchQueue.main.async {
                let oturumAckontroller = OturumACCOntroller()
                let navController = UINavigationController(rootViewController: oturumAckontroller)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController , animated: true ,completion: nil)
                
            }
            return
        }
  Gorunumuolustur()
}
    func Gorunumuolustur(){
        
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullaniciProfilController(collectionViewLayout: layout)
       
        let navController = UINavigationController(rootViewController: kullaniciProfilController )
       
        navController.tabBarItem.image = #imageLiteral(resourceName: "profil.png").withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profil_secili.png").withRenderingMode(.alwaysOriginal)
      
        tabBar.tintColor = .black
         viewControllers = [navController,UIViewController()]
        
    }
}
