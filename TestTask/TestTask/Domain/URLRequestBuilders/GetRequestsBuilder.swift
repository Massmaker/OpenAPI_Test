//
//  GetRequestsBuilder.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation


final class GetRequestsBuilder {
    
    static func buildRequestFor(api: API) throws -> URLRequest {
        if api.method != "GET" {
            throw NotAnError(message: "\(self) builds only \"GET\" requests")
        }
        
        return try buildGetRequest(for: api)
    }
    
    
    private static func buildGetRequest(for api: API) throws -> URLRequest {
        
        let getURLString = api.requestPath()
        
        guard getURLString.firstIndex(of: "&") == nil else {
            throw URLError(.unsupportedURL)
        }
        
        var request:URLRequest
        
        if let pathParams = api.pathParameters,
           var components = URLComponents(string: getURLString) {
            
            //using this approach for compatibility -> pre iOS 16
            let queryItems = pathParams.map({URLQueryItem(name: $0.key, value: "\($0.value)")})
            components.queryItems = queryItems
            guard let newURL = components.url else {
                throw URLError(.unsupportedURL)
            }
            
            request = URLRequest(url: newURL)
        }
        else {
            guard let url = URL(string: getURLString) else {
                throw URLError(.badURL)
            }
            request = URLRequest(url: url)
        }
        
        request.httpMethod = api.method
        
        
        return request
    }
    
    
}
