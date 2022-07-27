//
//  UserManagerTests.swift
//  AniTripTests
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import XCTest
@testable import AniTrip

final class UserManagerTests: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var userManager: UserManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        userManager = UserManager(networkManager: fakeNetworkManager)
    }

    // MARK: Login tests
    /// Success login
    func testGivenUserWillConnect_WhenConnectWithGoodCredentials_ThenGettingSuccess() {
        // Given
        
        // When
        connectUser()
        
        // Then
        XCTAssertNotNil(userManager.connectedUser)
    }
    
    /// Wrong credentials
    func testGivenUserWillConnect_WhenGettingIncorrectCredentialsStatus_ThenGettingError() {
        // Given
        configureManager(correctData: .userLogin, response: .status401, status: .incorrectData)
        
        // When
        userManager.login(user: UserToLogin(email: "", password: "", deviceToken: ""))
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    ///Account not activate yet
    func testGivenUserWillConnect_WhenGettingNotActivateAccountStatus_ThenGettingError() {
        // Given
        configureManager(correctData: .userLogin, response: .status460, status: .incorrectData)
        
        // When
        userManager.login(user: UserToLogin(email: "", password: "", deviceToken: ""))
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    ///Invalid data
    func testGivenUserWillConnect_WhenGettingIncorrectData_ThenGettingError() {
        // Given
        configureManager(correctData: .userLogin, response: .status200, status: .incorrectData)
        
        // When
        userManager.login(user: UserToLogin(email: "", password: "", deviceToken: ""))
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    /// Unknow status code
    func testGivenUserWillConnect_WhenGettingUnknownStatus_ThenGettingError() {
        // Given
        configureManager(correctData: .userLogin, response: .status0, status: .correctData)
        
        // When
        userManager.login(user: UserToLogin(email: "", password: "", deviceToken: ""))
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    /// Getting error during login
    func testGivenUserWillConnect_WhenGettingProcessError_ThenGettingError() {
        // Given
        configureManager(correctData: .userLogin, response: .status200, status: .error)
        
        // When
        userManager.login(user: UserToLogin(email: "", password: "", deviceToken: ""))
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    // MARK: Disconnect test
    func testGivenUserWantToDisconnect_WhenIsDisconnected_ThenConnectedUserShouldBeNull() {
        // Given
        connectUser()
        XCTAssertNotNil(userManager.connectedUser)
        
        // When
        userManager.disconnectUser()
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    // MARK: Create account test
    /// Success creation
    func testGivenCreateAnAccount_WhenGettingSuccess_ThenSuccessShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.accountCreationSuccess.notificationName, object: userManager, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status201, status: .correctData)
        
        // When
        userManager.createAccount(for: UserToCreate(email: "", password: "", passwordVerification: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Password error
    func testGivenCreateAnAccount_WhenGettingPasswordError_ThenErrorShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.accountCreationPasswordError.notificationName, object: userManager, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status406, status: .correctData)
        
        // When
        userManager.createAccount(for: UserToCreate(email: "", password: "", passwordVerification: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Informations error
    func testGivenCreateAnAccount_WhenGettingInformationsError_ThenErrorShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.accountCreationInformationsError.notificationName, object: userManager, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status500, status: .correctData)
        
        // When
        userManager.createAccount(for: UserToCreate(email: "", password: "", passwordVerification: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Unknown status
    func testGivenCreateAnAccount_WhenGettingUnknownStatus_ThenErrorShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.unknownError.notificationName, object: userManager, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        userManager.createAccount(for: UserToCreate(email: "", password: "", passwordVerification: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Getting error
    func testGivenCreateAnAccount_WhenGettingError_ThenErrorShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.unknownError.notificationName, object: userManager, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        userManager.createAccount(for: UserToCreate(email: "", password: "", passwordVerification: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // MARK: Update user
    /// User is not connected
    func testGivenUserIsNotConnected_WhenTryingToUpdateProfile_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.unknownError.notificationName, object: userManager, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        updateUser()
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Update is a success
    func testGivenUpdateUser_WhenGettingSuccess_ThenProfileShouldBeUpdated() {
        // Given
        connectUser()
        let connectedUser = userManager.connectedUser
        configureManager(correctData: .updateUser, response: .status202, status: .correctData)
        
        // When
        updateUser()

        // Then
        XCTAssertNotEqual(connectedUser?.firstname, userManager.connectedUser?.firstname)
    }
    
    /// Status 202 but incorrect data
    func testGivenUpdateUser_WhenGettingSuccessWithIncorrectData_ThenProfileShouldNotBeUpdated() {
        // Given
        connectUser()
        let connectedUser = userManager.connectedUser
        configureManager(correctData: .updateUser, response: .status202, status: .incorrectData)
        
        // When
        updateUser()

        // Then
        XCTAssertEqual(connectedUser?.firstname, userManager.connectedUser?.firstname)
    }
    
    /// Not authorized
    func testGivenUpdateUser_WhenGettingNotAuthorizedStatus_ThenProfileShouldNotBeUpdated() {
        // Given
        connectUser()
        let connectedUser = userManager.connectedUser
        configureManager(correctData: .updateUser, response: .status401, status: .incorrectData)
        
        // When
        updateUser()

        // Then
        XCTAssertEqual(connectedUser?.firstname, userManager.connectedUser?.firstname)
    }
    
    /// Account Not found
    func testGivenUpdateUser_WhenGettingAccountNotFound_ThenProfileShouldNotBeUpdated() {
        // Given
        connectUser()
        let connectedUser = userManager.connectedUser
        configureManager(correctData: .updateUser, response: .status406, status: .incorrectData)
        
        // When
        updateUser()

        // Then
        XCTAssertEqual(connectedUser?.firstname, userManager.connectedUser?.firstname)
    }
    
    /// Account not activate
    func testGivenUpdateUser_WhenGettingAccountNotActivate_ThenProfileShouldNotBeUpdated() {
        // Given
        connectUser()
        let connectedUser = userManager.connectedUser
        configureManager(correctData: .updateUser, response: .status460, status: .incorrectData)
        
        // When
        updateUser()

        // Then
        XCTAssertEqual(connectedUser?.firstname, userManager.connectedUser?.firstname)
    }
    
    /// Unknwown status code
    func testGivenUpdateUser_WhenGettingUnknownStatusCode_ThenProfileShouldNotBeUpdated() {
        // Given
        connectUser()
        let connectedUser = userManager.connectedUser
        configureManager(correctData: .updateUser, response: .status0, status: .incorrectData)
        
        // When
        updateUser()

        // Then
        XCTAssertEqual(connectedUser?.firstname, userManager.connectedUser?.firstname)
    }
    
    /// Unknwown status code
    func testGivenUpdateUser_WhenGettingError_ThenProfileShouldNotBeUpdated() {
        // Given
        connectUser()
        let connectedUser = userManager.connectedUser
        configureManager(correctData: .updateUser, response: .status0, status: .error)
        
        // When
        updateUser()

        // Then
        XCTAssertEqual(connectedUser?.firstname, userManager.connectedUser?.firstname)
    }
    
    // MARK: Private
    /// Configure the fake network manager
    private func configureManager(correctData: FakeResponseData.DataFiles?, response: FakeResponseData.Response, status: FakeResponseData.SessionStatus) {
        fakeNetworkManager.correctData = correctData
        fakeNetworkManager.status = status
        fakeNetworkManager.response = response
    }
    
    /// Connect the user
    private func connectUser() {
        configureManager(correctData: .userLogin, response: .status200, status: .correctData)
        userManager.login(user: UserToLogin(email: "", password: "", deviceToken: ""))
    }
    
    /// Update user
    private func updateUser() {
        userManager.updateUser(UserToUpdate(firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], address: LocationController.emptyAddress, password: "", passwordVerification: ""))
    }
}
