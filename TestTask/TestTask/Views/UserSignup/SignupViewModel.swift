//
//  SignupViewModel.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation

@MainActor
final class SignupViewModel<PositionsLoader:UserPositionsLoading>: ObservableObject {
    
    @Published var selectedPosition:UserPosition?
    @Published private(set) var availablePositions:[UserPosition] = []
    @Published var positionLoadingIsError:Bool = false
    @Published private(set) var isLoadingUserPositions:Bool = false
    
    private let userPositionsLoader:PositionsLoader
    
    init(selectedPosition: UserPosition? = nil, availablePositions: [UserPosition] = [], userPositionsLoader: PositionsLoader) {
        self.selectedPosition = selectedPosition
        self.availablePositions = availablePositions
        self.userPositionsLoader = userPositionsLoader
    }
    
    private func loadUserPositions() {
        print("Loading User Positions")
        
        self.isLoadingUserPositions = true
        
        Task {[weak self] in
            guard let self else {
                return
            }
            
            do {
                let sortedPositions = try await self.userPositionsLoader.getUserPositions()
                self.availablePositions = sortedPositions
            }
            catch {
                self.positionLoadingIsError = true
            }
            print("Loading User Positions finished")
            self.isLoadingUserPositions = false
            
        }
    }
    
    //MARK: - UI Actions
    func onViewAppear() {
        if !isLoadingUserPositions, availablePositions.isEmpty {
            loadUserPositions()
        }
    }
    
    func selectPosition(_ position:UserPosition) {
        self.selectedPosition = position
    }
    
    func retryLoadingUserPositions() {
        if isLoadingUserPositions {
            return
        }
        
        loadUserPositions()
    }
}
