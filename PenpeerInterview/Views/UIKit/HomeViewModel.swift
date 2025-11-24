//
//  HomeViewModel.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

struct HomeViewModel {
    let repository: PokeAPIRepositoryProtocol
    
    init(repository: PokeAPIRepositoryProtocol = PokeAPIRepository()) {
        self.repository = repository
    }
    
    func getPokemon() async {
        do {
            let result = try await repository.getTypeList(limit: 0, offset: 0)
            print(result)
        }
        catch {
            print(error)
        }
    }
}
