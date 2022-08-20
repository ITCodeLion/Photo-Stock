//
//  NetworkServiceRandom.swift
//  White&Fluffy
//
//  Created by Lev on 26.06.2022.
//

import Foundation

class NetworkServiceRandom {
    
    func requestRandom(completion: @escaping (Data?, Error?) -> Void) {
        
        let  parameters = self.prepareParameters()
        let  url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID 0WqpP9ezBKOARYkaRbDMl-9bg9sMOsKRaVxsZ1QtgAY"
        return headers
    }
    
    private func prepareParameters() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(20)
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path =  "/photos/random"
        
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
// MARK: - Parsing

extension NetworkServiceRandom {
    
    func fetchImages(completion: @escaping ([UnsplashPhoto]?) -> ()) {
        self.requestRandom() { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
//                while error.localizedDescription == "The Internet connection appears to be offline" {
//                    
//                }
                
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
