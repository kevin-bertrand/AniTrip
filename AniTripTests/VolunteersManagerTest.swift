//
//  VolunteersManagerTest.swift
//  AniTripTests
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import XCTest
@testable import AniTrip

final class VolunteersManagerTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var volunteersManager: VolunteersManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        volunteersManager = VolunteersManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Get Volunteer list
    /// Trying to getting list without be connected
    func testGivenGettingVolunteerListWithoutConnectedUser_WhenGettingError_ThenVolunteerListShouldBeEmpty() {
        // Given
        configureManager(correctData: .volunteerList, response: .status200, status: .correctData)
        
        // When
        volunteersManager.getList(byUser: nil)
        
        // Then
        XCTAssertTrue(volunteersManager.volunteersList.isEmpty)
    }
    
    /// Get correct data
    func testGivenGettingVolunteerList_WhenGettingCorrectData_ThenVolunteerListShouldBeFilled() {
        // Given
        configureManager(correctData: .volunteerList, response: .status200, status: .correctData)
        
        // When
        volunteersManager.getList(byUser: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        XCTAssertFalse(volunteersManager.volunteersList.isEmpty)
    }
    
    /// Get error
    func testGivenGettingVolunteerList_WhenGettingError_ThenVolunteerListShouldBeEmpty() {
        // Given
        configureManager(correctData: .volunteerList, response: .status200, status: .error)
        
        // When
        volunteersManager.getList(byUser: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        XCTAssertTrue(volunteersManager.volunteersList.isEmpty)
    }
    
    // MARK: Desactivate volunteer account
    /// Get success
    func testGivenDesactivateAccount_WhenGettingSuccess_ThenSuccessNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.desactivationSuccess.notificationName, object: volunteersManager, handler: nil)
        
        // Given
        configureManager(correctData: .volunteerList, response: .status202, status: .correctData)
        
        // When
        volunteersManager.desactivate(account: Volunteer(image: nil, id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: nil, isActive: false), byUser: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Get failed
    func testGivenDesactivateAccount_WhenGettingFailed_ThenErrorNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.unknownError.notificationName, object: volunteersManager, handler: nil)
        
        // Given
        configureManager(correctData: .volunteerList, response: .status202, status: .error)
        
        // When
        volunteersManager.desactivate(account: Volunteer(image: nil, id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: nil, isActive: false), byUser: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // MARK: Activate volunteer account
    /// Get success
    func testGivenActivateAccount_WhenGettingSuccess_ThenSuccessNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.activationSuccess.notificationName, object: volunteersManager, handler: nil)
        
        // Given
        configureManager(correctData: .volunteerList, response: .status202, status: .correctData)
        
        // When
        volunteersManager.activate(account: .init(email: ""), byUser: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Get failed
    func testGivenActivateAccount_WhenGettingFailed_ThenErrorNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.AniTrip.unknownError.notificationName, object: volunteersManager, handler: nil)
        
        // Given
        configureManager(correctData: .volunteerList, response: .status202, status: .error)
        
        // When
        volunteersManager.activate(account: .init(email: ""), byUser: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // MARK: Private
    /// Configure the fake network manager
    private func configureManager(correctData: FakeResponseData.DataFiles?, response: FakeResponseData.Response, status: FakeResponseData.SessionStatus) {
        fakeNetworkManager.correctData = correctData
        fakeNetworkManager.status = status
        fakeNetworkManager.response = response
    }
}
