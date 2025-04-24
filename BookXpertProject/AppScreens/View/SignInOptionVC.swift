//
//  SignInOptionVC.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

import UIKit

class SignInOptionVC: UIViewController {
    
    @IBOutlet weak var appLogoImgOL: UIImageView!
    @IBOutlet weak var screenTitleLblOL: UILabel!
    @IBOutlet weak var googleSigninViewOL: UIControl!
    @IBOutlet weak var googleDesImgOL: UIImageView!
    @IBOutlet weak var googleDesLblOL: UILabel!
    
    lazy var googleSignInClass: GoogleSignInClass = {
        return GoogleSignInClass()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSetup()
    }
    
    @IBAction func didTapGoogleSignIn(_ sender: UIControl) {
        self.googleSignInClass.signInWithGoogle(presentingVC: self) { success, message, error in
            if success{
                print("Google Sigin completed and updated in coredata")
                UserDefault.shared.setUserSignedIn(isSignedIn: true)
                self.navigateToHomePage()
            }else{
                print("Google Sigin failed and failed updating in coredata")
            }
        }
    }
    
    func uiSetup(){
        if let appLogoImg = UIImage(named: "bookExpertLog"){
            self.appLogoImgOL.image = appLogoImg
        }
        self.screenTitleLblOL.text = "Sign In"
        self.googleDesLblOL.text = "Sign in with Google"
        if let appImg = UIImage(named: "googleG_LogIcon"){
            self.googleDesImgOL.image = appImg
        }
        self.googleSigninViewOL.layer.cornerRadius = (self.googleSigninViewOL.frame.height / 2)
        self.googleSigninViewOL.layer.borderColor = UIColor(hexCode: ColorHelper.instance.blackColorCode).cgColor
        self.googleSigninViewOL.layer.borderWidth = 1
        
        
        if ColorHelper.instance.checkMoileIsDarkAppearance(){
            self.googleSigninViewOL.layer.borderColor = UIColor(hexCode: ColorHelper.instance.whiteColorCode).cgColor
        }else{
            self.googleSigninViewOL.layer.borderColor = UIColor(hexCode: ColorHelper.instance.blackColorCode).cgColor
            self.googleSigninViewOL.layer.borderColor = ColorHelper.instance.getBlackColor().cgColor//UIColor(hexCode: ColorHelper.instance.blackColorCode).cgColor
        }
    }
    
    func navigateToHomePage(){
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let rootVC = mainStroyboard.instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}
