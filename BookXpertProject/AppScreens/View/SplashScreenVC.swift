//
//  SplashScreenVC.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    @IBOutlet weak var welcomeLblOL: UILabel!
    @IBOutlet weak var appImgOL: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSetup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.configureIntialAppFlow()
        }
    }
    
    func uiSetup(){
        self.welcomeLblOL.text = "Welcome to BOOKXPERT"
        if let appImg = UIImage(named: "bookExpertLog"){
            self.appImgOL.image = appImg
        }
    }
    
    func signedInCondition() -> Bool{
        if UserDefault.shared.getUserSignedIn(){
            return true
        }
        return false
    }
    
    func configureIntialAppFlow(){
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        var rootPageVC:UIViewController? = mainStroyboard.instantiateViewController(withIdentifier: "SignInOptionVC") as? SignInOptionVC
        if UserDefault.shared.getUserSignedIn(){
            rootPageVC = mainStroyboard.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC
        }
        guard let rootVC = rootPageVC else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    

}
