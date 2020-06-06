//
//  REST.swift
//  Carangas
//
//  Created by Douglas Frari on 29/05/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//
import Foundation
import Alamofire

enum ErrorRequest {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}

final class REST {
    
    // URL principal + endpoint
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    // session criada automaticamente e disponivel para reusar
    private static let session = URLSession(configuration: configuration) // URLSession.shared
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {

       // URL TABELA FIPE
       let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
       guard let url = URL(string: urlFipe) else {
           onComplete(nil)
           return
       }
       // tarefa criada, mas nao processada
       AF.request(url).responseJSON { response in
           do{
               if response.data == nil{
                  onComplete(nil)
               }
               if response.error != nil{
                   onComplete(nil)
               }
               let cars = try JSONDecoder().decode([Brand].self, from: response.data!)
               onComplete(cars)
           }catch is DecodingError{
                onComplete(nil)
           }catch{
               onComplete(nil)
           }
       }
        
    }
    
    
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (ErrorRequest) -> Void) {
        
        AF.request(basePath).responseJSON { response in
            do{
                if response.data == nil{
                    onError(.noData)
                    return
                }
                if response.error != nil{
                    onError(.url)
                    return
                }
                let cars = try JSONDecoder().decode([Car].self, from: response.data!)
                onComplete(cars)
            }catch is DecodingError{
                 onError(.invalidJSON)
            }catch{
                onError(.taskError(error: error))
            }
        }
    }
    
    
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    
    
    private class func applyOperation(car: Car, operation: RESTOperation , onComplete: @escaping (Bool) -> Void ) {
    
        let urlString = basePath + "/" + (car._id ?? "")
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        var metodo = HTTPMethod(rawValue: "GET")
        switch operation {
        case .delete:
            metodo = HTTPMethod(rawValue: "DELETE")
        case .save:
            metodo = HTTPMethod(rawValue: "POST")
        case .update:
            metodo = HTTPMethod(rawValue: "PUT")
        }
        
        
        AF.request(url,
                   method: metodo,
                   parameters: car,
                   encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)
                    onComplete(true)
        }
    }

} // fim da classe
