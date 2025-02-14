//
//  UserByIdLoader.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

protocol UserByIdLoading {
    func getUserBy(userId:UserId) async throws -> User
}

fileprivate let logger = createLogger(subsystem: "Networking", category: "UserByIdLoader")

final class UserByIdLoader:UserByIdLoading {
    
    let session:URLSession
    private lazy var decoder = JSONDecoder()
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getUserBy(userId: UserId) async throws -> User {
        let api = API.getUserBy(userId: userId)
        
        
        let requestPath = api.requestPath()
        
        guard let requestURL = URL(string: requestPath) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: requestURL)
        
        let httpMethod = api.method
        
        request.httpMethod = httpMethod
        
        do {
            
            logger.notice("Starting obtaining a user by id: \(userId)")
            
            let response = try await session.data(for: request)
            
            guard let httpResponse = response.1 as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            let responseCode = httpResponse.statusCode
            
            let data = response.0
            
            guard !data.isEmpty else {
                throw URLError(.badServerResponse)
            }
            
            if responseCode != 200 {
                
                //Handle failure
                
                logger.warning("\(#function) Bad response code: \(responseCode)")
                do {
                    let reasonableResponse = try decoder.decode(FailureResponse.self, from: data)
                    
                    if let message = reasonableResponse.message {
                        
                        logger.notice("\(#function) User by id '\(userId)' error response: \(message)")
                        throw APICallError.reasonableMessage(message, HandledErrorStatusCode(rawValue: responseCode))
                    }
                    
                    throw URLError(.badServerResponse)
                }
                catch {
                    throw URLError(.badServerResponse)
                }
            }
            
            
            //Handle success
            do {
                
                let successResponse = try decoder.decode(UserByIdResponse.self, from: data)
                
                guard successResponse.success else {
                    throw URLError(.badServerResponse)
                }
                
                logger.notice("Returning user by id: \(userId)")
                
                return successResponse.user
            }
            catch {
                //decoding error
                logger.error("\(#function) Decoding error: \(error)")
                throw error
            }
            
        }
        catch {
            // session (URLSession) error
            throw error
        }
        
    }
}
