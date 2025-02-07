//
//  ImageCache.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation
import UIKit





actor ImageCache {

    static var shared = ImageCache()
    private init() {}
    
    enum ImageLoadingState {
        case inProgress(Task<Data?, Never>)
        case completed(Data)
    }
    
    private var cache:[UserPhotoLink:ImageLoadingState] = [:]
    
    func readData(forLink link:UserPhotoLink) async -> Data? {
        
        if case let .inProgress(task) = cache[link] {
            return await task.value
        }
        
        if case let .completed(data) = cache[link] {
            return data
        }
        
        let loadingTask = Task<Data?, Never> {
            guard let data = try? await loadData(for: link) else {
                return nil
            }
            
            return data
        }
        
        cache[link] = .inProgress(loadingTask)
        
        guard let taskResultData = await loadingTask.value else {
            return nil
        }
        
        cache[link] = .completed(taskResultData)
        
        return taskResultData
    }
    
    private func loadData(for link:UserPhotoLink) async throws -> Data {
        guard let imageURL = URL(string: link) else {
            throw URLError(URLError.Code.badURL)
        }
        
        do {
            let taskResponse = try await URLSession.shared.data(from: imageURL)
            let data = taskResponse.0
            guard !data.isEmpty else {
                throw URLError(.badServerResponse)
            }
            return data
        }
        catch {
            throw error
        }
    }
}
