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
        
        viewOutput = MockUserViewModelOutput()
        userService =  MockUserService()
        
        sut = UserViewModel(userService: userService)
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
        XCTAssertEqual(viewOutput.updateViewArray.count, 1)
        XCTAssertEqual(viewOutput.updateViewArray[0].email, "me@gmail.com")
        XCTAssertEqual(viewOutput.updateViewArray[0].imageUrl, "https://www.picsum.com/2")
       
    }
    
    func testUpdateView_onApiFailure_showsError() throws {
        
        //given
        userService.fetchUserMockResult = .failure(NSError())
        
        //when
        sut.fetchUser()
        //then
        XCTAssertEqual(viewOutput.updateViewArray.count, 1)
        XCTAssertEqual(viewOutput.updateViewArray[0].email, "no user found ")
        XCTAssertEqual(viewOutput.updateViewArray[0].imageUrl, "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png")
        
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
