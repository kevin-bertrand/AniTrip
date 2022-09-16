//
//  TripManagerTests.swift
//  AniTripTests
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import XCTest
@testable import AniTrip

final class TripManagerTests: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var tripManager: TripManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        tripManager = TripManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Getting trip list
    /// Getting list when not connected
    func testGivenUserNotConnected_WhenGettingTripList_ThenGettingError() {
        // Given
        configureManager(correctData: .tripList, response: .status200, status: .correctData)
        
        // When
        tripManager.getList(byUser: nil, of: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Getting list for connected user
    func testGivenGettingTripListForUser_WhenGettingList_ThenGettingTripList() {
        // Given
        configureManager(correctData: .tripList, response: .status200, status: .correctData)
        
        // When
        tripManager.getList(byUser: getConnectedUser(), of: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertFalse(tripManager.trips.isEmpty)
    }
    
    /// Getting list success with incorrect data
    func testGivenGettingTripListForUser_WhenGettingListWithIncorrectData_ThenGettingTripList() {
        // Given
        configureManager(correctData: .tripList, response: .status200, status: .incorrectData)
        
        // When
        tripManager.getList(byUser: getConnectedUser(), of: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Getting list for a volunteer
    func testGivenGettingTripListForVolunteer_WhenGettingList_ThenGettingTripList() {
        // Given
        configureManager(correctData: .tripList, response: .status200, status: .correctData)
        
        // When
        tripManager.getList(byUser: getConnectedUser(), of: .init(imagePath: "", image: nil, id: "\(UUID())", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: .admin, missions: [], address: nil, isActive: true))
        
        // Then
        XCTAssertFalse(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
        
    /// Getting list error
    func testGivenGettingTripListForUser_WhenGettingError_ThenTripListShouldBeEmpty() {
        // Given
        configureManager(correctData: .tripList, response: .status404, status: .correctData)
        
        // When
        tripManager.getList(byUser: getConnectedUser(), of: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Unknown status code
    func testGivenGettingTripListForUser_WhenGettingUnknownStatus_ThenTripListShouldBeEmpty() {
        // Given
        configureManager(correctData: .tripList, response: .status0, status: .correctData)
        
        // When
        tripManager.getList(byUser: getConnectedUser(), of: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Error during getting list
    func testGivenGettingTripListForUser_WhenGettingProcessError_ThenTripListShouldBeEmpty() {
        // Given
        configureManager(correctData: .tripList, response: .status0, status: .error)
        
        // When
        tripManager.getList(byUser: getConnectedUser(), of: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    // MARK: Adding trip list
    /// User not connected
    func testGivenAddingTrip_WhenUserNotConnected_ThenTripListIsNotUpdated() {
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        tripManager.add(trip: UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Success adding
    func testGivenAddingTrip_WhenIsSuccess_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status200, status: .correctData)
        
        // When
        tripManager.add(trip: UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertFalse(tripManager.trips.isEmpty)
    }
    
    /// Not authorized
    func testGivenAddingTrip_WhenUserIsNotAuthorized_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status401, status: .correctData)
        
        // When
        tripManager.add(trip: UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Unknown status
    func testGivenAddingTrip_WhenGettingUnknownStatus_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status0, status: .correctData)
        
        // When
        tripManager.add(trip: UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Process error
    func testGivenAddingTrip_WhenGettingProcessError_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status0, status: .error)
        
        // When
        tripManager.add(trip: UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    // MARK: Update trip list
    /// User not connected
    func testGivenUpdatingTrip_WhenUserNotConnected_ThenTripListIsNotUpdated() {
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        tripManager.update(trip: UpdateTrip(id: UUID(), date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: nil)
        
        // Then
        XCTAssertTrue(tripManager.volunteerTrips.isEmpty)
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Success adding
    func testGivenUpdatingTrip_WhenIsSuccess_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status200, status: .correctData)
        
        // When
        tripManager.update(trip: UpdateTrip(id: UUID(), date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertFalse(tripManager.trips.isEmpty)
    }
    
    /// Not authorized
    func testGivenUpdatingTrip_WhenUserIsNotAuthorized_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status401, status: .correctData)
        
        // When
        tripManager.update(trip: UpdateTrip(id: UUID(), date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Unknown status
    func testGivenUpdatingTrip_WhenGettingUnknownStatus_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status0, status: .correctData)
        
        // When
        tripManager.update(trip: UpdateTrip(id: UUID(), date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    /// Process error
    func testGivenUpdatingTrip_WhenGettingProcessError_ThenTripListIsUpdated() {
        // Given
        configureManager(correctData: .tripList, response: .status0, status: .error)
        
        // When
        tripManager.update(trip: UpdateTrip(id: UUID(), date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.trips.isEmpty)
    }
    
    // MARK: Download trip list to export
    /// Success
    func testGivenGettingTripsToExport_WhenIsSuccess_ThenTripExportShouldBeUpdated() {
        // Given
        configureManager(correctData: .export, response: .status200, status: .correctData)
        
        // When
        tripManager.downloadPDF(with: TripFilterToExport(userID: UUID(), language: "", startDate: "", endDate: ""), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.pdfData != Data())
    }
    
    /// Process error
    func testGivenGettingTripsToExport_WhenGettingError_ThenTripExportShouldBeUpdated() {
        // Given
        configureManager(correctData: .export, response: .status200, status: .error)
        
        // When
        tripManager.downloadPDF(with: TripFilterToExport(userID: UUID(), language: "", startDate: "", endDate: ""), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.pdfData == Data())
    }
    
    /// Unknown status
    func testGivenGettingTripsToExport_WhenIsUnknownStatus_ThenTripExportShouldBeUpdated() {
        // Given
        configureManager(correctData: .export, response: .status0, status: .correctData)
        
        // When
        tripManager.downloadPDF(with: TripFilterToExport(userID: UUID(), language: "", startDate: "", endDate: ""), by: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.pdfData == Data())
    }
    
    // MARK: Download 3 latest trips
    /// User not connected
    func testGivenGettingLatestTrips_WhenUserNotConnected_ThenLatestTripShouldBeEmpty() {
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        tripManager.threeLatestTrips(byUser: getConnectedUser(), filter: .month)
        
        // Then
        XCTAssertTrue(tripManager.threeLatestTrips.isEmpty)
    }
    
    /// Success
    func testGivenGettingLatestTrips_WhenGettingSuccess_ThenLatestTripShouldBeFilled() {
        // Given
        configureManager(correctData: .threeLatestTrip, response: .status200, status: .correctData)
        
        // When
        tripManager.threeLatestTrips(byUser: getConnectedUser(), filter: .month)
        
        // Then
        XCTAssertFalse(tripManager.threeLatestTrips.isEmpty)
    }
    
    /// Success
    func testGivenGettingLatestTrips_WhenGettingSuccessWithIncorrectData_ThenLatestTripShouldBeEmpty() {
        // Given
        configureManager(correctData: .threeLatestTrip, response: .status200, status: .incorrectData)
        
        // When
        tripManager.threeLatestTrips(byUser: getConnectedUser(), filter: .month)
        
        // Then
        XCTAssertTrue(tripManager.threeLatestTrips.isEmpty)
    }
    
    /// Getting error
    func testGivenGettingLatestTrips_WhenGettingError_ThenLatestTripShouldBeEmpty() {
        // Given
        configureManager(correctData: .threeLatestTrip, response: .status404, status: .correctData)
        
        // When
        tripManager.threeLatestTrips(byUser: getConnectedUser(), filter: .month)
        
        // Then
        XCTAssertTrue(tripManager.threeLatestTrips.isEmpty)
    }
    
    /// Unknown status
    func testGivenGettingLatestTrips_WhenGettingUnknownStatus_ThenLatestTripShouldBeEmpty() {
        // Given
        configureManager(correctData: .threeLatestTrip, response: .status0, status: .correctData)
        
        // When
        tripManager.threeLatestTrips(byUser: getConnectedUser(), filter: .month)
        
        // Then
        XCTAssertTrue(tripManager.threeLatestTrips.isEmpty)
    }
    
    /// Process error
    func testGivenGettingLatestTrips_WhenGettingProcessError_ThenLatestTripShouldBeEmpty() {
        // Given
        configureManager(correctData: .threeLatestTrip, response: .status404, status: .error)
        
        // When
        tripManager.threeLatestTrips(byUser: getConnectedUser(), filter: .month)
        
        // Then
        XCTAssertTrue(tripManager.threeLatestTrips.isEmpty)
    }
    
    // MARK: Download chart points
    /// User not connected
    func testGivenGettingChartPoint_WhenUserNotConnected_ThenChartPointShouldBeEmpty() {
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        tripManager.downloadChartPoint(forUser: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        XCTAssertTrue(tripManager.tripsChartPoints.isEmpty)
    }
    
    /// Success
    func testGivenGettingChartPoint_WhenGettingSuccess_ThenChartPointShouldBeFilled() {
        // Given
        configureManager(correctData: .chartPoints, response: .status200, status: .correctData)
        
        // When
        tripManager.downloadChartPoint(forUser: getConnectedUser())
        
        // Then
        XCTAssertFalse(tripManager.tripsChartPoints.isEmpty)
    }
    
    /// Getting error
    func testGivenGettingChartPoint_WhenGettingError_ThenChartPointShouldBeEmpty() {
        // Given
        configureManager(correctData: .chartPoints, response: .status404, status: .correctData)
        
        // When
        tripManager.downloadChartPoint(forUser: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.tripsChartPoints.isEmpty)
    }
    
    /// Unknown status
    func testGivenGettingChartPoint_WhenGettingUnknownStatus_ThenChartPointShouldBeEmpty() {
        // Given
        configureManager(correctData: .chartPoints, response: .status0, status: .correctData)
        
        // When
        tripManager.downloadChartPoint(forUser: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.tripsChartPoints.isEmpty)
    }
    
    /// Process error
    func testGivenGettingChartPoint_WhenGettingProcessError_ThenChartPointShouldBeEmpty() {
        // Given
        configureManager(correctData: .chartPoints, response: .status404, status: .error)
        
        // When
        tripManager.downloadChartPoint(forUser: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.tripsChartPoints.isEmpty)
    }
    
    // MARK: Download news
    /// User not connected
    func testGivenNews_WhenUserNotConnected_ThenNewsShouldBeEmpty() {
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        tripManager.downloadNews(for: User(image: nil, id: nil, firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: ""))
        
        // Then
        XCTAssertTrue(tripManager.news.distanceThisWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisWeek == 0)
        XCTAssertTrue(tripManager.news.distanceThisYear == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisYear == 0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastWeek == 0.0)
    }
    
    /// Success
    func testGivenNews_WhenGettingSuccess_ThenNewsShouldBeFilled() {
        // Given
        configureManager(correctData: .news, response: .status200, status: .correctData)
        
        // When
        tripManager.downloadNews(for: getConnectedUser())
        
        // Then
        XCTAssertFalse(tripManager.news.distanceThisWeek == 0.0)
        XCTAssertFalse(tripManager.news.numberOfTripThisWeek == 0)
        XCTAssertFalse(tripManager.news.distanceThisYear == 0.0)
        XCTAssertFalse(tripManager.news.numberOfTripThisYear == 0)
        XCTAssertFalse(tripManager.news.distancePercentSinceLastYear == 0.0)
        XCTAssertFalse(tripManager.news.distancePercentSinceLastWeek == 0.0)
        XCTAssertFalse(tripManager.news.numberTripPercentSinceLastYear == 0.0)
        XCTAssertFalse(tripManager.news.numberTripPercentSinceLastWeek == 0.0)
    }
    
    /// Getting error
    func testGivenNews_WhenGettingError_ThenNewsShouldBeEmpty() {
        // Given
        configureManager(correctData: .news, response: .status404, status: .correctData)
        
        // When
        tripManager.downloadNews(for: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.news.distanceThisWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisWeek == 0)
        XCTAssertTrue(tripManager.news.distanceThisYear == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisYear == 0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastWeek == 0.0)
    }
    
    /// Unknown status
    func testGivenNews_WhenGettingUnknownStatus_ThenNewsShouldBeEmpty() {
        // Given
        configureManager(correctData: .news, response: .status0, status: .correctData)
        
        // When
        tripManager.downloadNews(for: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.news.distanceThisWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisWeek == 0)
        XCTAssertTrue(tripManager.news.distanceThisYear == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisYear == 0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastWeek == 0.0)
    }
    
    /// Process error
    func testGivenNews_WhenGettingProcessError_ThenNewsShouldBeEmpty() {
        // Given
        configureManager(correctData: .news, response: .status404, status: .error)
        
        // When
        tripManager.downloadNews(for: getConnectedUser())
        
        // Then
        XCTAssertTrue(tripManager.news.distanceThisWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisWeek == 0)
        XCTAssertTrue(tripManager.news.distanceThisYear == 0.0)
        XCTAssertTrue(tripManager.news.numberOfTripThisYear == 0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.distancePercentSinceLastWeek == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastYear == 0.0)
        XCTAssertTrue(tripManager.news.numberTripPercentSinceLastWeek == 0.0)
    }
    
    
    // MARK: Disconnect user
    func testGivenDisconnectFinished_WhenDisconnectUser_ThenAllPropertiesShouldBeEmpty() {
        // Given
        
        // When
        tripManager.disconnect()
        
        // Then
        XCTAssertEqual(tripManager.trips.count, 0)
        XCTAssertEqual(tripManager.volunteerTrips.count, 0)
        XCTAssertEqual(tripManager.threeLatestTrips.count, 0)
        XCTAssertEqual(tripManager.tripsChartPoints.count, 0)
    }
    
    // MARK: Private
    /// Configure the fake network manager
    private func configureManager(correctData: FakeResponseData.DataFiles?, response: FakeResponseData.Response, status: FakeResponseData.SessionStatus) {
        fakeNetworkManager.correctData = correctData
        fakeNetworkManager.status = status
        fakeNetworkManager.response = response
    }
    
    /// Getting connected user
    private func getConnectedUser() -> User {
        User(image: nil, id: UUID(), firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: true, token: "")
    }
}
