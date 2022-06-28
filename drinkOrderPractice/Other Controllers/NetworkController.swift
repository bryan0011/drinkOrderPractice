//
//  NetworkController.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/20.
//

import Foundation
import UIKit

class NetworkController {
    
    static let shared = NetworkController()
    
    func fetchImage(request: URLRequest, completion: @escaping (UIImage?)->Void) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
        
    }
    
    func fetchMenu(request: URLRequest, completion: @escaping (Result<[Record],Error>)->Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(DrinkMenu.self, from: data)
                    completion(.success(searchResponse.records))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchOrderList(request: URLRequest, completion: @escaping (Result<[Type], Error>)->Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let orderList = try decoder.decode(OrderList.self, from: data)
                    completion(.success(orderList.records))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


