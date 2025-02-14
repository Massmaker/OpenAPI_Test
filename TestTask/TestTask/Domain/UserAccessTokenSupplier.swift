//
//  UserAccessTokenSupplier.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

final class UserAccessTokenSupplier:AccessTokenSupplier {
    
    let session:URLSession
    
    init(session:URLSession) {
        self.session = session
    }
    
    func getAccessToken() async throws -> AccessToken {
        
        do {
            let tokenRequest = try GetRequestsBuilder.buildRequestFor(api: .getToken)
            
            do {
                let tokenResponse = try await session.data(for: tokenRequest)
                
                let decoder = JSONDecoder()
                            
                let data:Data = tokenResponse.0
                
                do {
                    let successResponse:AccessTokenResponse = try decoder.decode(AccessTokenResponse.self, from: data)
                    
                    if !successResponse.success {
                        throw URLError(.badServerResponse)
                    }
                    
                    //SUCCESS!
                    return successResponse.token
                }
                catch (let decodingError) {
                    throw decodingError // wrong response data format
                }
            }
            catch(let tokenRequestSessionError) {
                throw tokenRequestSessionError //no connection, timeout ... other errors
            }
                    
            
        }
        catch(let urlRequestObtainingError) {
            throw urlRequestObtainingError //failed to obtain URLRequest for submitting
        }
    }
}
