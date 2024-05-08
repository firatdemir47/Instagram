//
//  ViewController.swift
//  instagram3
//
//  Created by FIRAT DEMİR on 30.04.2024.
//
import UIKit
import Firebase
import FirebaseStorage
import JGProgressHUD

class KayitOlController: UIViewController {
    let btnfotografekle : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "fotografeklesimgesi").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget( self , action: #selector(btnFotografEklePressed), for: .touchUpInside)
   
        return btn
        
    }()
    @objc fileprivate func btnFotografEklePressed(){
        
        let imgPickController = UIImagePickerController()
        imgPickController.delegate = self
        present(imgPickController,animated: true,completion: nil)
    }
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder="Email adresinizi giriniz..."
        
       
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
        
    }()
    @objc fileprivate func veriDegisimi(){
        let formGecerlimi = (txtEmail.text?.count ?? 0 )>0 &&
        (txtKullaniciadi.text?.count ?? 0)>0 && (txtParola.text?.count ?? 0)>0
        
        if formGecerlimi{
            btnKayitol.isEnabled = true
            btnKayitol.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
            
        }else {
            btnKayitol.isEnabled=false 
            
            btnKayitol.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        }
    }
    let txtKullaniciadi : UITextField = {
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder="Kullanıcı adınız...."
       
       
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
        
    }()
    let txtParola : UITextField = {
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder="Parolanız..."
        txt.isSecureTextEntry = true
       
       
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
        
    }()
    let btnKayitol : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Kayıt Ol", for: .normal)
        //btn.backgroundColor = UIColor(red: 150/255, green: 205/255, blue: 245/255, alpha: 1)
        btn.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(btnKayitolPressed), for: .touchUpInside)
        btn.isEnabled=false
        return btn
    }()
    @objc fileprivate func btnKayitolPressed(){
        
        guard let emailAdresi = txtEmail.text else {return}
        guard let kullaniciAdi = txtKullaniciadi.text else {return}
        guard let parola = txtParola.text else {return}
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text="Kaydınız Gerçekleşiyor"
        hud.show(in: self.view)
        Auth.auth().createUser(withEmail: emailAdresi, password: parola){(sonuc, hata) in if let hata = hata {
            print("Kullanıcı kayıt oluken hata meydana geldi :",hata)
            hud.dismiss(animated: true)
            return
        }
            
            guard let kaydolanKullaniciID = sonuc?.user.uid else {return}
            let goruntuAdi = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/ProfilFotograflari/\(goruntuAdi)")
            let goruntuData = self.btnfotografekle.imageView?.image?.jpegData(compressionQuality: 0.8) ?? Data()
    
            ref.putData(goruntuData, metadata: nil) { (_,hata) in
                if let hata = hata {
                    print("Fotoğraf kaydedilmedi : ",hata)
                    return
                    
                }
            print("Görüntüü Başarıyla upload edildi")
           
                ref.downloadURL{(url, hata) in
                    if let hata = hata {
                        print("Görüntünün URL Adresi ALınamadı : ",hata)
                        return
                    }
                    print ("Upload edilen Görüntünün Url ADresi : \(url?.absoluteString ?? "Lİnk yok")")
                    let eklenecekveri = ["kullaniciAdi": kullaniciAdi ,
                                         "KullaniciID" : kaydolanKullaniciID,
                                         "profilGOruntuUrl": url?.absoluteString ?? ""]
                    Firestore.firestore().collection("kullanicilar").document(kaydolanKullaniciID).setData(eklenecekveri){(hata) in
                        if let hata = hata {
                            print("kullanici verileri firestore kaydedilmedi :" ,hata)
                            return
                            
                        }
                        print ("kullanici verileri başarıyla kaydedildi")
                       
                        hud.dismiss(animated: true)
                        self.gorunumuDuzelt()
                        
                        
                    }}
            }
            
            print("kullanıcı kaydı başarıyla gerçekleşti : ",sonuc?.user.uid)
           
        }
    }
   fileprivate func gorunumuDuzelt(){
       self.btnfotografekle.setImage(#imageLiteral(resourceName: "fotografeklesimgesi").withRenderingMode(.alwaysOriginal), for: .normal)
    
        self.btnfotografekle.layer.borderColor = UIColor.clear.cgColor
        self.btnfotografekle.layer.borderWidth = 0
        self.txtEmail.text = ""
        self.txtKullaniciadi.text = ""
        self.txtParola.text = ""
        let basarilihud = JGProgressHUD(style: .light)
        basarilihud.textLabel.text = "Kayıt işlemi Başarılı..."
        basarilihud.show(in: self.view)
        basarilihud.dismiss(afterDelay:2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(btnfotografekle)
        
        btnfotografekle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnfotografekle.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 150)
        
   girisAlanlariniOlustur()
    
        
        
    }
    fileprivate func girisAlanlariniOlustur (){
       
        
     
        
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtKullaniciadi,txtParola,btnKayitol])
      
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
     
        stackView.anchor(top: btnfotografekle.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 45, paddingRight: -45,width: 0,height: 230)
    }


}

extension UIView {

  func anchor(top: NSLayoutYAxisAnchor?,
              bottom: NSLayoutYAxisAnchor?, // 'bottom' tipini değiştirin
              leading: NSLayoutXAxisAnchor?,
              trailing: NSLayoutXAxisAnchor?,
              paddingTop: CGFloat,
              paddingBottom: CGFloat,
              paddingLeft: CGFloat,
              paddingRight: CGFloat,
              width :CGFloat,
              height : CGFloat) {
      translatesAutoresizingMaskIntoConstraints=false
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    if let bottom = bottom {  // Now 'bottom' can only be NSLayoutYAxisAnchor
      self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
    }

    if let leading = leading {
      self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
    }
    if let trailing = trailing {
      self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
    }
      if width != 0 {
          widthAnchor.constraint(equalToConstant: width).isActive=true
          
      }
      if height != 0{
          
          heightAnchor.constraint(equalToConstant: height).isActive=true
      }
  }
}
extension KayitOlController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgSecilen = info[.originalImage] as? UIImage
        self.btnfotografekle.setImage(imgSecilen?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnfotografekle.layer.cornerRadius=btnfotografekle.frame.width/2
        btnfotografekle.layer.masksToBounds=true
        btnfotografekle.layer.borderColor=UIColor.darkGray.cgColor
        btnfotografekle.layer.borderWidth=3
        dismiss(animated: true,completion: nil)
        
        
    }
}
