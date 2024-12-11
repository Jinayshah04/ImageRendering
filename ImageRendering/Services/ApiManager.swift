//
//  ApiManager.swift
//  ImageRendering
//
//  Created by mobile1 on 10/12/24.
//

import Foundation
import Alamofire

class ApiManager{
    let urlStr="https://api.thecatapi.com/v1/images/search?limit=10"
    
    func fetchAF(completionHandler:@escaping(Result<[CatModel],Error>)->Void){
        AF.request(urlStr).responseDecodable(of:[CatModel].self) { response in
            switch response.result{
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let err):
                completionHandler(.failure(err))
            }
        }
        
    }
}
