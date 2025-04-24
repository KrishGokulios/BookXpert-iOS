//
//  GoogleSignInClass.swift
//  BookXpertProject

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn


typealias GoogleSignInDataResponse = (_ success: Bool, _ message:User?, _ error: NSError?) -> Void
typealias GoogleSignOutDataResponse = (_ success: Bool, _ message:String, _ error: NSError?) -> Void

class GoogleSignInClass: NSObject{
    lazy var coreDataClass: AppCoreDataClass = {
        return AppCoreDataClass()
    }()
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping GoogleSignInDataResponse) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                completion(false,nil, error as NSError)
                return
            }
            
            guard
                let user = signInResult?.user,
                let idToken = user.idToken?.tokenString
            else {
                completion(false,nil, NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing token"]))
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(false,nil, error as NSError)
                } else if let user = authResult?.user {
                    self.coreDataClass.updateUserInfoToCoreData(user: user) { success, message, error in
                        if success{
                            UserDefault.shared.setUserSignedIn(isSignedIn: true)
                        }
                        completion(success,user, error)
                    }
                }
            }
        }
    }
    
    func signOutFromGoogle(completion: @escaping GoogleSignOutDataResponse){
        do {
            try Auth.auth().signOut()
            print("Signed out successfully")
            self.coreDataClass.removeUserInfoFromCoreData { success, message, error in
                completion(success,message, error)
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
            completion(false,"Remove Successfully", signOutError)
        }
    }
    
}
