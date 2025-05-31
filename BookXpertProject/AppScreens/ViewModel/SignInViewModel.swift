//
//  SignInViewModel.swift
//  BookXpertProject

import UIKit
import FirebaseAuth
import CoreData
import GoogleSignIn

typealias MobileModelListDataReponse =  (_ success: Bool, _ response: [MobileModelListModel]?, _ error: ApiServiceError?) -> Void
typealias MobileListDataFetchReponse = (_ success: Bool, _ message: String) -> Void

class SignInViewModel: NSObject{
    let decoder = JSONDecoder()
    lazy var coreDataClass: AppCoreDataClass = {
        return AppCoreDataClass()
    }()
    var mobileModelListData: [MobileModelList] = [MobileModelList]()
    
    func getMobileModelListApi(completion: @escaping MobileModelListDataReponse) {
        APIService.instance.getAPIRequest(URLConstants.getMobileModelUrl) { response in
            if let jsonData = self.decoder.safeDecode([MobileModelListModel].self, from: response){
                self.coreDataClass.saveMobileModelsToCoreData(jsonData ?? []) { success, message, error in
                    if success{
                        print("Mobile Models Saved to CoreData")
                    }
                }
                completion(true,jsonData, nil)
            }else{
                completion(false, nil, .decodingError)
            }
        } failure: { error in
            completion(false, nil, error)
        }
    }
    
    func fetchMobileModelData(completion: @escaping MobileListDataFetchReponse){
        self.mobileModelListData = self.coreDataClass.fetchMobileModels()
        if self.mobileModelListData.isEmpty{
            completion(false,"")
        }else{
            completion(true,"")
        }
    }
    
    func sendFCMNotificationMethod(title: String, body: String, itemId: String, completion: @escaping NotificationSuccessResponse) {
        let accessToken:String = ""
        let payload: [String: Any] = [
            "message": [
                "token": UserDefault.shared.getDeviceFCMToken(),
                "notification": [
                    "title": title,
                    "body": body
                ],
                "data": [
                    "itemId": itemId
                ]
            ]
        ]
        APIService.instance.sendFCMNotificationMethod(accessToken: accessToken, payload: payload) { success in
            completion(success)
        }
    }
}
