//
//  HomeViewModelTests.swift
//  PenpeerInterviewTests
//
//  Created by Wei Chu on 2025/11/24.
//

import Testing
import Moya
@testable import PenpeerInterview

struct HomeViewModelTests {
    let pokeAPIRepository: PokeAPIRepositoryProtocol = FakePokeAPIRepository()
    
    let viewModel = HomeViewModel()
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
