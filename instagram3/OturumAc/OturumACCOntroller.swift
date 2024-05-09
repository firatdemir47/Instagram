//
//  OturumACCOntroller.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 8.05.2024.
//

import UIKit
import Firebase
import JGProgressHUD
class OturumACCOntroller : UIViewController {
    let txtEmail : UITextField = {
        let txt = UITextField()
      
        txt.placeholder = "Email adresini giriniz...."
        txt.backgroundColor = UIColor(white: 0, alpha: 0.5)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
        
    }()
    let txtParola : UITextField = {
       let txt =  UITextField()
        txt.placeholder = "Parolanız..."
        txt.isSecureTextEntry = true
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
        
    }()
    let btnGirisYap : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giriş Yap", for: .normal)
        btn.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnGirisYapPressed) , for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnGirisYapPressed(){
        guard let eMailAdresi = txtEmail.text , let parola = txtParola.text else {return}
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Oturum Açılıyor..."
        hud.show(in: self.view)
        
        Auth.auth().signIn(withEmail: eMailAdresi, password: parola) { (sonuc , hata) in
            if let hata = hata {
                
                print ("Oturum açılırken hata meydana geldi :" , hata)
                hud.dismiss(animated: true)
                let hatalihud = JGProgressHUD(style: .light)
                hatalihud.textLabel.text = "Hata Meydana Geldi : \(hata.localizedDescription)"
                hatalihud.show(in: self.view)
                hatalihud.dismiss(afterDelay: 2)
                return
            }
            print("Kullanıcı Başarılı bir Şekilde Oturum Açtı",sonuc?.user.uid)
            
            let keywindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            guard let anaTabBarController = keywindow?.rootViewController as? AnaTabBarController else {return}
            anaTabBarController.Gorunumuolustur() //kullanıcı profil contollera gideriz
            self.dismiss(animated: true , completion: nil) //oturum açma ekranı kapanacak . kapatmazsanız profil sayfasına gidemezsiniz
            
            hud.dismiss(animated: true)
            let basariliHud = JGProgressHUD(style: .light)
            basariliHud.textLabel.text = "Başarılı"
            basariliHud.show(in: self.view)
            basariliHud.dismiss(afterDelay: 1)
            
             
        }
        
    }    
    let logoView : UIView = {
        let view = UIView()
        let imageLogo = UIImageView(image: #imageLiteral(resourceName: "ööö.png"))
        

       imageLogo.contentMode = .scaleAspectFill

        view.addSubview(imageLogo)
        imageLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       // view.backgroundColor = UIColor.rgbDonustur(red: 0, green: 120, blue: 175)
        view.backgroundColor = .white
    return view
    }()
    let btnKayitOl : UIButton = {
        let btn = UIButton(type: .system)
        let attrBaslik = NSMutableAttributedString(string: "Henüz bir hesabınız yok mu?", attributes: [
            .font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray])
        attrBaslik.append(NSAttributedString(string: " Kayıt Ol",attributes: [
            .font : UIFont.boldSystemFont(ofSize: 16),.foregroundColor : UIColor.rgbDonustur(red: 20, green: 155, blue: 235)]))
        btn.setAttributedTitle(attrBaslik, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnKayitolPressed), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func veriDegisimi(){
        
        let formGecerliMi = (txtEmail.text?.count ?? 0) > 0 && (txtParola.text?.count ?? 0) > 0
        if formGecerliMi{
            btnGirisYap.isEnabled = true
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
        }
        else {
            btnGirisYap.isEnabled = false
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        }
    }
    @objc fileprivate func btnKayitolPressed(){
    let kayitOlCOntroller = KayitOlController()
        navigationController?.pushViewController(kayitOlCOntroller, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoView)
        logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        view.backgroundColor = .white
        
        view.addSubview(btnKayitOl)
        btnKayitOl.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
    girisGorunumOlustur()
    }
    fileprivate func  girisGorunumOlustur(){
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtParola,btnGirisYap])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
    }
}
