//
//  ApiControl.swift
//  JosephCodingBrandi
//
//  Created by Joseph_iMac on 2020/12/30.
//

import UIKit
import Foundation
import Alamofire

class ApiControl {
    static let shared = ApiControl()
    
    func apiRequest(url:String, complateHandle:@escaping (AFDataResponse<Any>)->())
    {
        AF.request(url, method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": ApiManager.KEY.REST_API]).responseJSON { response in
            print("Requesturl : \(url)")
            switch response.result {
                case .success( _):
//                    print("👌🏻Response : \(response)")
                    complateHandle(response)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
