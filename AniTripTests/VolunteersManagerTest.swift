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
        volunteersManager.getList(byUser: getDefaultUser())
        
        // Then
        XCTAssertFalse(volunteersManager.volunteersList.isEmpty)
    }
    
    /// Get error
    func testGivenGettingVolunteerList_WhenGettingError_ThenVolunteerListShouldBeEmpty() {
        // Given
        configureManager(correctData: .volunteerList, response: .status200, status: .error)
        
        // When
        volunteersManager.getList(byUser: getDefaultUser())
        
        // Then
        XCTAssertTrue(volunteersManager.volunteersList.isEmpty)
    }
    
    // MARK: Desactivate volunteer account
    /// Get success
    func testGivenDesactivateAccount_WhenGettingSuccess_ThenSuccessNotificationShouldPop() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .desactivateAccount, response: .status200, status: .correctData)
        
        // When
        volunteersManager.desactivate(account: getDefaultVolunteer(), byUser: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertNotEqual(volunteers[1].isActive, volunteersUpdated[1].isActive)
    }
    
    /// Get failed
    func testGivenDesactivateAccount_WhenGettingFailed_ThenErrorNotificationShouldPop() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .desactivateAccount, response: .status200, status: .error)
        
        // When
        volunteersManager.desactivate(account: getDefaultVolunteer(), byUser: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertEqual(volunteers[1].isActive, volunteersUpdated[1].isActive)
    }
    
    // MARK: Activate volunteer account
    /// Get success
    func testGivenActivateAccount_WhenGettingSuccess_ThenSuccessNotificationShouldPop() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .activationAccount, response: .status200, status: .correctData)
        
        // When
        volunteersManager.activate(account: VolunteerToActivate(email: ""), byUser: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertNotEqual(volunteers[0].isActive, volunteersUpdated[0].isActive)
    }
    
    /// Get failed
    func testGivenActivateAccount_WhenGettingFailed_ThenErrorNotificationShouldPop() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .activationAccount, response: .status200, status: .error)
        
        // When
        volunteersManager.activate(account: VolunteerToActivate(email: ""), byUser: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertEqual(volunteers[0].isActive, volunteersUpdated[0].isActive)
    }
    
    // MARK: Update position tests
    /// Get success
    func testGivenUserNotConnected_WhenTryingToChangeStatus_ThenGetError() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .updatePosition, response: .status200, status: .correctData)
        
        // When
        volunteersManager.changePosition(of: VolunteerToUpdatePosition(email: "", position: .user), by: nil)
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertEqual(volunteers[0].position, volunteersUpdated[0].position)
    }
    
    /// Get success
    func testGivenUserIsAdmin_WhenChangingStatus_ThenGetSuccess() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .updatePosition, response: .status200, status: .correctData)
        
        // When
        volunteersManager.changePosition(of: VolunteerToUpdatePosition(email: "", position: .user), by: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertNotEqual(volunteers[0].position, volunteersUpdated[0].position)
    }
    
    /// Get failed
    func testGivenUpdateStatus_WhenGetting404_ThenSendUnknownErrorNotification() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .updatePosition, response: .status404, status: .correctData)
        
        // When
        volunteersManager.changePosition(of: VolunteerToUpdatePosition(email: "", position: .user), by: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertEqual(volunteers[0].position, volunteersUpdated[0].position)
    }
    
    /// Get unknown status
    func testGivenUpdateStatus_WhenGettingUnknownStatus_ThenSendUnknownErrorNotification() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .updatePosition, response: .status0, status: .correctData)
        
        // When
        volunteersManager.changePosition(of: VolunteerToUpdatePosition(email: "", position: .user), by: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertEqual(volunteers[0].position, volunteersUpdated[0].position)
    }
    
    /// Get incorrect response
    func testGivenUpdateStatus_WhenGettingError_ThenSendUnknownErrorNotification() {
        // Given
        let volunteers = getVolunteerList()
        configureManager(correctData: .updatePosition, response: .status200, status: .error)
        
        // When
        volunteersManager.changePosition(of: VolunteerToUpdatePosition(email: "", position: .user), by: getDefaultUser())
        let volunteersUpdated = volunteersManager.volunteersList
        
        // Then
        XCTAssertEqual(volunteers[0].position, volunteersUpdated[0].position)
    }
    
    // MARK: Download Profile picture
    /// Success
    func testGivenGettingVolunteerProfilePicture_WhenGettingSuccess_ThenImageShouldBeDownloaded() {
        // Prepare expectation
        let expectation = XCTestExpectation(description: "Getting volunteer profile picture")
        
        // Given
        let defaultVolunteer = Volunteer(imagePath: "/", id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: .user, missions: [], address: nil, isActive: true)
        
        // When
        configureManager(correctData: .image, response: .status200, status: .correctData, and: .image)
        volunteersManager.downlaodProfilePicture(of: defaultVolunteer) { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// Error
    func testGivenGettingVolunteerProfilePicture_WhenGettingError_ThenImageShouldBeDownloaded() {
        // Prepare expectation
        let expectation = XCTestExpectation(description: "Getting volunteer profile picture")
        
        // Given
        configureManager(correctData: .volunteerList, response: .status200, status: .correctData)
        volunteersManager.getList(byUser: getDefaultUser())
        configureManager(correctData: .volunteerList, response: .status200, status: .error)
        
        // When
        volunteersManager.downlaodProfilePicture(of: volunteersManager.volunteersList.first!) { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// Invalid data
    func testGivenGettingVolunteerProfilePicture_WhenGettingInvalidData_ThenImageShouldBeDownloaded() {
        // Prepare expectation
        let expectation = XCTestExpectation(description: "Getting volunteer profile picture")
        
        // Given
        let defaultVolunteer = Volunteer(imagePath: "/", id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: .user, missions: [], address: nil, isActive: true)
        
        // When
        configureManager(correctData: .image, response: .status200, status: .incorrectData, and: .image)
        volunteersManager.downlaodProfilePicture(of: defaultVolunteer) { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: Disconnect
    func testGivenDisconnectFinished_WhenDisconnectUser_ThenAllPropertiesShouldBeEmpty() {
        // Given
        
        // When
        volunteersManager.disconnect()
        
        // Then
        XCTAssertEqual(volunteersManager.volunteersList.count, 0)
    }
    
    // MARK: Private
    /// Configure the fake network manager
    private func configureManager(correctData: FakeResponseData.DataFiles?, response: FakeResponseData.Response, status: FakeResponseData.SessionStatus, and correctDataExtension: FakeResponseData.DataExtension = .json) {
        fakeNetworkManager.correctData = correctData
        fakeNetworkManager.status = status
        fakeNetworkManager.response = response
        fakeNetworkManager.correctDataExtension = correctDataExtension
    }
    
    /// Getting default user
    private func getDefaultUser() -> User {
        return User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .admin, missions: [], isActive: true, token: "")
    }
    
    /// Getting default volunteer
    private func getDefaultVolunteer() -> Volunteer {
        return Volunteer(imagePath: "", image: nil, id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: .admin, missions: [], address: nil, isActive: false)
    }
    
    /// Donwload volunteer list
    private func getVolunteerList(with correctData: FakeResponseData.DataFiles = .volunteerList) -> [Volunteer] {
        configureManager(correctData: correctData, response: .status200, status: .correctData)
        volunteersManager.getList(byUser: getDefaultUser())
        return volunteersManager.volunteersList
    }
}
