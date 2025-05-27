//
//  APIService.swift
//  BookXpertProject


import Foundation
import UIKit
import Alamofire

typealias NotificationSuccessResponse = (_ success: Bool) -> Void
typealias SuccessfullyCompleted = (_ response: Data) -> Void
typealias Failure = (_ error: ApiServiceError) -> Void

class APIService {
    
    static let instance = APIService()
    private var session: Session!
    private init(){
        let configuration = URLSessionConfiguration.ephemeral
        session = Session(configuration: configuration)
    }
    func getHeaderValue() -> HTTPHeaders {
        let headers : HTTPHeaders = ["Authorization": "Bearer \(URLConstants.accessToken)",
                                     "Content-Type": "application/json"]
        return headers
    }
    
    //MARK:- Get API (GET)
    func getAPIRequest(_ url: String, parameters: [String: Any]? = nil, success: @escaping SuccessfullyCompleted, failure: @escaping Failure) -> Void {
        session.request(url,
                        method: .get,
                        parameters: parameters ?? [:],
                        encoding: URLEncoding.default,
                        headers: getHeaderValue()).responseJSON { (response) in
            
            guard response.error == nil else{
                failure(.customError(message: (response.error?.localizedDescription ?? "Error Occurred")))
                return
            }
            guard response.response?.statusCode != 401 else{
                failure(.sessionExpired)
                return
            }
            
            success(response.data ?? Data())
        }
    }
    
    //MARK: Insert API (POST)
    func insertAPIRequest(_ url: String,parameters: [String: Any]? = nil, success: @escaping SuccessfullyCompleted, failure: @escaping Failure) -> Void {
        session.request(url,
                        method: .post,
                        parameters: parameters ?? [:],
                        encoding: JSONEncoding.default,
                        headers:  getHeaderValue()).responseJSON { response in
            
            guard response.error == nil else{
                failure(.customError(message: (response.error?.localizedDescription ?? "Error Occurred")))
                return
            }
            guard response.response?.statusCode != 401 else{
                failure(.sessionExpired)
                return
            }
            
            success(response.data ?? Data())
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
        session.request(url,
                        method: .post,
                        parameters: payload,
                        encoding: JSONEncoding.default,
                        headers: getFCMNotificationHeaderValue(accessToken: accessToken))
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

enum ApiServiceError:Error{
    case sessionExpired
    case decodingError
    case customError(message:String)
}

extension JSONDecoder {
    func safeDecode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        return try? decode(T.self, from: data)
    }
}





