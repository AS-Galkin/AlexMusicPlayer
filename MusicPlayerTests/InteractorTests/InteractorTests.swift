//
//  InteractorTests.swift
//  MusicPlayerTests
//
//  Created by Александр Галкин on 11.10.2021.
//

import XCTest
@testable import MusicPlayer

class InteractorTests: XCTestCase {
    
    var searchVC: SearchViewController!
    
    override func setUpWithError() throws {
        searchVC = SearchViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInteractorIsNotNill() {
        searchVC.setup()
        let interactor = searchVC.interactor
        XCTAssertNotNil(interactor)
    }
}
