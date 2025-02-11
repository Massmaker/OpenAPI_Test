//
//  UserPositionsLoader.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation

protocol UserPositionsLoading {
    func getUserPositions() async throws -> [UserPosition]
}


final class UserPositionsLoader:UserPositionsLoading {
    
    let session:URLSession
    private lazy var decoder = JSONDecoder()
    
    init() {
        self.session = URLSession(configuration: .ephemeral)
    }
    
    func getUserPositions() async throws -> [UserPosition] {
        
        let getPositionsAPI = API.getPositions
        
        let getURLString = getPositionsAPI.requestURL()
        
        guard let url = URL(string: getURLString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = getPositionsAPI.method
        
        do {
            let response = try await session.data(for: request)
            
            guard let httpResponse = response.1 as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            let statusCode = httpResponse.statusCode
            let responseData:Data = response.0
            
            guard !responseData.isEmpty else {
                //just don't mess with the empty response
                throw URLError(.badServerResponse)
            }
            
            guard case 200 = statusCode else {
                
                //try to obtain server error message
                if let decodableFailure = try? decoder.decode(UserPositionsFailureResponse.self, from: responseData),
                   let errorMessage = decodableFailure.message {
                    throw APICallError.reasonableMessage(errorMessage)
                }
                else {
                    throw URLError(.badServerResponse)
                }
            }
            
            
            do {
                let decodedSuccess = try decoder.decode(UserPositionsResponse.self, from: responseData)
                
                return decodedSuccess.positions //success!
            }
            catch (let decodingError) {
                throw decodingError
            }
            
        }
        catch {
            // URLSession error
            throw error
        }
    }
}
