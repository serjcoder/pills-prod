//
//  NetworkService.swift
//  pills-prod
//
//  Created by Sergei Ivchenko on 07.02.2022.
//

import Foundation

class NetworkService {
    
    public static let shared = NetworkService()
    private init() {}
    
    private func request (urlString: String, completion: @escaping (Result<Data,Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response,error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
    
    func fetchTraks(urlString: String, responce: @escaping (Pills?) -> Void) {
        request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(Pills.self, from:data)
                    responce(data)
                } catch let jsonError {
                    print("Fail to decode: \(jsonError)")
                    responce(nil)
                }
            case .failure(let error):
                print("recived data error \(error.localizedDescription)")
                responce(nil)
            }
        }
    }
}
