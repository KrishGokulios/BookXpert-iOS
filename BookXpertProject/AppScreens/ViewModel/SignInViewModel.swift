//
//  SignInViewModel.swift
//  BookXpertProject

import UIKit
import FirebaseAuth
import CoreData
import GoogleSignIn

typealias MobileModelListDataReponse = (_ success: Bool, _ response: [MobileModelListModel]?, _ error: NSError?) -> Void
typealias MobileListDataFetchReponse = (_ success: Bool, _ message: String) -> Void


class SignInViewModel: NSObject{
    var serviceClass: APIService
    let decoder = JSONDecoder()
    init( apiService: APIService = APIService()) {
        self.serviceClass = apiService
    }
    lazy var coreDataClass: AppCoreDataClass = {
        return AppCoreDataClass()
    }()
    
    var mobileModelListData: [MobileModelList] = [MobileModelList]()
//    var mobileModelListData: [MobileModelListModel] = [MobileModelListModel]()
    
    //MARK: Get- Care Management Dashboard Api Call
    func getMobileModelListApi(completion: @escaping MobileModelListDataReponse) {
        self.serviceClass.getAPIRequest(URLConstants.getMobileModelUrl) { response in
            do {
                let jsonData = try? self.decoder.decode([MobileModelListModel].self, from: response)
//                self.mobileModelListData = jsonData ?? []
                self.coreDataClass.saveMobileModelsToCoreData(jsonData ?? []) { success, message, error in
                    if success{
                        print("Mobile Models Saved to CoreData")
                    }
                }
                completion(true,jsonData, nil)
            } catch{
                completion(false, nil, error as NSError)
            }
        } failure: { error in
            print("Error->\(error)")
            completion(false, nil, nil)
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
        serviceClass.sendFCMNotificationMethod(accessToken: accessToken, payload: payload) { success in
            completion(success)
        }
    }
}
