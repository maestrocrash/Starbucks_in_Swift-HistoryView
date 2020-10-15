//
//  HistoryService.swift
//  HTTPSpike
//
//  Created by MICHAIL SHAKHVOROSTOV on 13.10.2020.
//

import Foundation

enum SeviceError: Error {
    case server
    case parsing
        
}

struct HistoryService {
    static let shared = HistoryService()
    
    func fetchTransaction(completion: @escaping ((Result<[Transaction], Error>) -> Void)) {
        
        let url = URL(string: "https://uwyg0quc7d.execute-api.us-west-2.amazonaws.com/prod/history")
        
        let task = URLSession.shared.dataTask(with: url!) {data, responce, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            guard let httpResponce = responce as? HTTPURLResponse,
                  (200...299).contains(httpResponce.statusCode) else {
                completion(Result.failure(SeviceError.server))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let result = try decoder.decode(History.self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(result.transactions)) //Update UI
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(SeviceError.parsing))
                }
            }
            
        }
        task.resume()
        
 
    }
}
