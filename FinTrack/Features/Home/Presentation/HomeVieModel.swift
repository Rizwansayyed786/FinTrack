//
//  HomeVieModel.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 08/09/26.
//
import Foundation

@Observable
final class HomeViewModel {
    var state = HomeState()
    
    private let useCase: HomeUsecase
    
    init(useCase: HomeUsecase) {
        self.useCase = useCase
    }
    
    func fetchData() async {
        state.isLoading = true
        state.error = nil
        
        do{
            let response = try await useCase.execute()
            state.dashboard = response
        }catch{
            state.error = error.localizedDescription
        }
        state.isLoading = false
    }
}
