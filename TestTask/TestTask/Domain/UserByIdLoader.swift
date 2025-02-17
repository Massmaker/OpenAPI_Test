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
        
        do {
            let getUserByIdUrlRequest = try GetRequestsBuilder.buildRequestFor(api: .getUserBy(userId: userId))
            
            do {
                let response = try await session.data(for: getUserByIdUrlRequest)
                
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
                
                
                //Handle success status code
                do {
                    
                    let successResponse = try decoder.decode(UserByIdResponse.self, from: data)
                    
                    guard successResponse.success else {
                        throw URLError(.badServerResponse)
                    }
                    
                    logger.notice("Returning user by id: \(userId)")
                    
                    return successResponse.user
                }
                catch(let decodingError) {
                    //decoding error
                    logger.error("\(#function) Decoding error: \(decodingError)")
                    throw decodingError
                }
            }
            catch (let urlSessionError) {
                // URLSession error
                throw urlSessionError
            }
        }
        catch (let urlRequestBuildingError) {
            //URLRequest building error
            throw urlRequestBuildingError
        }
        
    }
}
