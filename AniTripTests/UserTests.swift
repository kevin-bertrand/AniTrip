//
//  UserTests.swift
//  AniTripTests
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import XCTest
@testable import AniTrip

class UserTests: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var userManager: UserManager!
    
    override class func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        userManager = UserManager(networkManager: fakeNetworkManager)
    }
    
    // Login tests
    func testGivenUserDisconnected_WhenTryingToConnect_ThenIsSuccess() {
        // Prepare expectation
        <#expectations#>
        
        // Given
        <#Given#>
        
        // When
        <#When#>
        
        // Then
        <#Then#>
    }
}
