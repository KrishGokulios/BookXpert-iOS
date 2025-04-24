//
//  APIService.swift
//  BookXpertProject


import Foundation
import UIKit
import Alamofire

typealias NotificationSuccessResponse = (_ success: Bool) -> Void

class APIService {
    
    typealias SuccessfullyCompleted = (_ response: Data) -> Void
    typealias Failure = (_ error: String) -> Void
    
    
    private static let instance = APIService()
        
        
//    var sessionManager: SessionManager {
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 60
//        return manager
//    }
    
    private var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        return Session(configuration: configuration)
    }()
    
    //MARK:- Get API (GET)
    func getAPIRequest(_ url: String, parameters: [String: Any]? = nil, success: @escaping SuccessfullyCompleted, failure: @escaping Failure) -> Void {
        print(url)
        
//        session.request(url, method: .get, parameters: (parameters ?? [:]) as Parameters, encoding: URLEncoding.default).responseJSON { (response) in
//            print("--> getAPI Response:", response)
//            if response.response?.statusCode == 401{
//                print("Authentication failed")
//                failure("Authentication failed")
//            }else if (response.error != nil) {
//                failure("Something Went Wrong")
//            } else {
//                let responsedata = response.data ?? Data()
//                success(responsedata);
//            }
//        }
        
        session.request(url,
                        method: .get,
                        parameters: parameters,
                        encoding: URLEncoding.default)
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                print("--> Success:", response)
                success(data)
            case .failure(let error):
                print("--> Failure:", error.localizedDescription)
                if response.response?.statusCode == 401 {
                    failure("Authentication failed")
                } else {
                    failure(error.localizedDescription)
                }
            }
        }

    }
    
    func getFCMNotificationHeaderValue(accessToken: String) -> HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }

    func sendFCMNotificationMethod(accessToken: String, payload:[String: Any], completion: @escaping NotificationSuccessResponse) {
        let projectID = "your-project-id" // replace with actual Firebase project ID
        let url = "https://fcm.googleapis.com/v1/projects/\(projectID)/messages:send"
        session.request(url, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: getFCMNotificationHeaderValue(accessToken: accessToken))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("FCM Sent:", value)
                    completion(true)
                case .failure(let error):
                    print("FCM Error:", error.localizedDescription)
                    completion(false)
                }
            }
    }
    
}


