//
//  UserRegistrator.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

typealias AccessToken = String

protocol UserRegistration {
    func registerNew(user:UserRegistrationRequestInfo) async throws -> (userId:UserId, message:String)
}

protocol AccessTokenSupplier {
    func getAccessToken() async throws -> AccessToken
}

fileprivate let logger = createLogger(subsystem: "Networking", category: "UserRegistrator")

final class UserRegistrator:UserRegistration {
    
    let tokenSupplier: any AccessTokenSupplier
    let session:URLSession
    
    private lazy var decoder:JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(tokenSupplier: some AccessTokenSupplier, session:URLSession) {
        self.tokenSupplier = tokenSupplier
        self.session = session
    }
    
    func registerNew(user: UserRegistrationRequestInfo) async throws -> (userId:UserId, message:String) {
        
        do {
            // 1 - start obtaining access token for the POST request
            let accessToken = try await tokenSupplier.getAccessToken()
            logger.info("Obtained access token: \(accessToken)")
            
           //throws immediately in case of error and re-throws the error to the caller
            let urlRequest = try MultipartFormDataRequestBuilder.buildRequest(for: user, withToken: accessToken)
            logger.notice("Regustrationrequest Header fields: \(urlRequest.allHTTPHeaderFields ?? [:])")
           
            do {
                let response = try await session.data(for: urlRequest)
                
                guard let httpResponse = response.1 as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                let statusCode = httpResponse.statusCode
                
                let data = response.0
                guard !data.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                
                guard statusCode == 201 else {
                    // handle server response errors
                    logger.warning("\(#function) Bad response code: \(statusCode)")
                    do {
                        let reasonableResponse = try decoder.decode(FailureResponse.self, from: data)
                        
                        if let details = reasonableResponse.fails, !details.isEmpty {
                            logger.notice("\(#function) Register User error. Message: \(reasonableResponse.message ?? "") Details : \(details)")
                            throw APICallError.detailedError(reasonableResponse, HandledErrorStatusCode(rawValue: statusCode))
                        }
                        
                        if let message = reasonableResponse.message {
                            
                            logger.notice("\(#function) Register User error. Message: \(message)")
                            throw APICallError.reasonableMessage(message, HandledErrorStatusCode(rawValue: statusCode))
                        }
                        
                        throw URLError(.badServerResponse)
                    }
                    catch {
                        throw URLError(.badServerResponse)
                    }
                }
                
                // Decode for user Id
                do {
                    let registrationResponse:UserRegistrationResponse = try decoder.decode(UserRegistrationResponse.self, from: data)
                    
                    guard registrationResponse.success else {
                        throw APICallError.reasonableMessage("Registration Failed", nil)
                    }
                    
                    let userId = registrationResponse.userId
                    
                    if let message = registrationResponse.message {
                        return (userId:userId, message:message)
                    }
                    else {
                        return (userId:userId, message:"")
                    }
                }
                catch(let responseDecodingError) {
                    throw responseDecodingError
                }
                
                
            }
            catch(let sessionError) {
                // session request error
                throw sessionError
            }
            
        }
        catch (let accessTokenObtainingError) {
            //no Access Token error
            throw accessTokenObtainingError
        }
    }
}
