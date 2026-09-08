//
//  HomeFactory.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 08/09/26.
//
struct HomeFactory {

    static func makeHomeView(
        networkClient: NetworkClient
    ) -> HomeView {

        // Data layer
        let api = HomeAPI(
            client: networkClient
        )

        let repository = HomeRepoImpl(
            api: api
        )

        // Domain layer
        let useCase = HomeUsecase(
            repository: repository
        )

        // Presentation layer
        let viewModel = HomeViewModel(
            useCase: useCase
        )

        return HomeView(
            viewModel: viewModel
        )
    }
}
