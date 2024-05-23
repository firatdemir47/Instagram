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
        self.delegate = self
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
        /* let anaController = UIViewController()
         let anaNavController = UINavigationController(rootViewController: anaController)
         
         let tabBarItem = UITabBarItem(title: "Ana Sayfa", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
         
         
         anaNavController.tabBarItem = tabBarItem
         
         let araController = UIViewController()
         let araNavController = UINavigationController(rootViewController: araController)
         let tabBarItem3 = UITabBarItem(title: "Arama", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
         araNavController.tabBarItem = tabBarItem3
         
         let ekleController = UIViewController()
         let ekleNavContoroller = UINavigationController(rootViewController: ekleController)
         let tabBarItem4 = UITabBarItem(title: "Ekle", image: UIImage(systemName: "plus.app"), selectedImage: UIImage(systemName: "plus.app.fill"))
         ekleNavContoroller.tabBarItem = tabBarItem4
         
         let begeniController = UIViewController()
         let begeniNavContoroller = UINavigationController(rootViewController: begeniController)
         let tabBarItem5 = UITabBarItem(title: "Like", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
         begeniNavContoroller.tabBarItem = tabBarItem5
         
         let layout = UICollectionViewFlowLayout()
         let kullaniciProfilController = KullaniciProfilController(collectionViewLayout: layout)
         let navController = UINavigationController(rootViewController: kullaniciProfilController )
         let tabBarItem2 = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
         
         navController.tabBarItem = tabBarItem2
         
         tabBar.tintColor = .black
         
         viewControllers = [anaNavController,araNavController,ekleNavContoroller,begeniNavContoroller,navController]
         */
        let anaNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(systemName: "house")!, seciliIkon: UIImage(systemName: "house.fill")! ,rootViewController: AnaControllerr(collectionViewLayout: UICollectionViewFlowLayout()))
        let araNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(systemName: "magnifyingglass.circle")!, seciliIkon: UIImage(systemName:  "magnifyingglass.circle.fill")!, rootViewController: KullanıcıAraController(collectionViewLayout: UICollectionViewFlowLayout()))
       
        let ekleNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(systemName: "plus.app")!, seciliIkon: UIImage(systemName: "plus.app.fill")! )
        
        let begenNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(systemName: "heart")!, seciliIkon: UIImage(systemName: "heart.fill")! )
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullaniciProfilController(collectionViewLayout: layout)
        let kullaniciProfilNavController = UINavigationController(rootViewController: kullaniciProfilController )
        let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        kullaniciProfilNavController.tabBarItem = tabBarItem2
        tabBar.tintColor = .black
        viewControllers=[anaNavController,araNavController,ekleNavController,begenNavController,kullaniciProfilNavController]
        guard let itemler = tabBar.items else {return}
        for item in itemler {
            
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
    }
    fileprivate func navControllerOlustur(seciliOlmayanIkon :UIImage,seciliIkon : UIImage,rootViewController : UIViewController = UIViewController())-> UINavigationController{
        let rootContorller = rootViewController
        let navController = UINavigationController(rootViewController: rootContorller)
        navController.tabBarItem.image = seciliOlmayanIkon
        navController.tabBarItem.selectedImage = seciliIkon
        return navController
        
    }
}
extension AnaTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else {return true}
    
        if index == 2{
            let layout = UICollectionViewFlowLayout()
            let fotografSeciciController = FotografSeciciController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: fotografSeciciController)
            navController.modalPresentationStyle = .fullScreen
            present(navController , animated: true , completion: nil)
            return false
        }
        return true
        
    }
   
    
}
