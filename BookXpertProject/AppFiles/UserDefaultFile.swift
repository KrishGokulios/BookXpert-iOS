//
//  UserDefaultFile.swift
//  BookXpertProject


import UIKit
import Security
enum UserDefaultKeys: String {
    //MARK: Sign In Check
    case userSignedIn
    case deviceFCMToken
    case permissionForNotification
    
}

class UserDefault{
    static let shared = UserDefault()
    
    func resetUserDefault() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    func setUserSignedIn(isSignedIn: Bool?) {
        UserDefaults.standard.set(isSignedIn, forKey: UserDefaultKeys.userSignedIn.rawValue)
    }
    
    func getUserSignedIn() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultKeys.userSignedIn.rawValue) ?? false
    }
    
    func setAllowNotificationService(permission: Bool) {
        UserDefaults.standard.set(permission, forKey: UserDefaultKeys.permissionForNotification.rawValue)
    }
    
    func getAllowNotificationService() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultKeys.permissionForNotification.rawValue) ?? false
    }
    
    func setDeviceFCMToken(fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: UserDefaultKeys.deviceFCMToken.rawValue)
    }
    
    func getDeviceFCMToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.deviceFCMToken.rawValue) ?? ""
    }
}

