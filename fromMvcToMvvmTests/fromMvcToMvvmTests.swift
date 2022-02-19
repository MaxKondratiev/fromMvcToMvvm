//
//  fromMvcToMvvmTests.swift
//  fromMvcToMvvmTests
//
//  Created by максим  кондратьев  on 19.02.2022.
//

import XCTest
@testable import fromMvcToMvvm

class fromMvcToMvvmTests: XCTestCase {

    private var sut: UserViewModel!
    private var userService: MockUserService!
    private var viewOutput: MockUserViewModelOutput!
    
    override func setUpWithError() throws {
        
        
        sut = UserViewModel(userService: userService)
        viewOutput = MockUserViewModelOutput()
        userService =  MockUserService()
        sut.outputDelegate = viewOutput
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        userService = nil
        try super.setUpWithError()
    }

    func testUpdateView_onApiSuccess_showImageAndEmail() throws {
        //given
        let user = User(id: 1, email: "me@gmail.com", avatar: "https://www.picsum.com/2")
        userService.fetchUserMockResult = .success(user)
        
        //when
        sut.fetchUser()
        
        //then
        //XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
       
    }
    
    func testUpdateView_onApiFailure_showsError() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
class MockUserService: UserService {
    
    var fetchUserMockResult:  Result<User, Error>?
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        if let result = fetchUserMockResult {
            completion(result)
        }
    }
}

class MockUserViewModelOutput: UserViewModelOutput {
    
    var updateViewArray: [(imageUrl: String, email: String)] = []
    func updateView(imageUrl: String, email: String) {
        updateViewArray.append((imageUrl,email))
    }
    
    
}
