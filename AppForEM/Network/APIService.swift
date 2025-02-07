//
//  APIService.swift
//  AppForEM
//
//  Created by Bema on 5/2/25.
//

import Foundation
import UIKit

class APIService {
    static let shared = APIService()
    
    func fetchTodos(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        }
        task.resume()
    }
}
