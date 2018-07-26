//
//  AppVerifyDemoTests.swift
//  AppVerifyDemoTests
//
//  Created by Chad Timmerman on 6/18/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import XCTest
@testable import AppVerifyDemo

class AppVerifyDemoTests: XCTestCase {
    
    var viewController: InitiateViewController!

    let countryCode = "+1"
    let selectedCountryCode = "+44"

    let phoneNumber = "(012) 345-6789"
    let sanitizedNumber = "10123456789"
    
    let requestId = "abcdefg"
    let newRequestId = "qwerty"

    let jwtToken = "asdfghjkl-qwerty"
    let verificationCode = "123456"
    
    let deeplinkURL = "telesign://verify?123456"
    
    override func setUp() {
        super.setUp()
        
        viewController = InitiateViewController()
        viewController.initiateView.phoneTextField.countryCodeTextField.text = countryCode
        viewController.initiateView.phoneTextField.textField.text = phoneNumber
        
        UIApplication.shared.keyWindow?.rootViewController = viewController

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainViewController() {
        
        let sanitizedNumber = viewController.initiateView.phoneTextField.sanitizePhoneNumber(countryCode: countryCode, phoneNumber: phoneNumber)
        XCTAssertEqual(sanitizedNumber, self.sanitizedNumber)

        viewController.didSelectCountryCode(code: selectedCountryCode)
        
        wait(for: 1)
        
        XCTAssertEqual(viewController.initiateView.phoneTextField.countryCodeTextField.text, self.selectedCountryCode)
    }
    
    func testCountryCodeTableViewController() {
        viewController.presentCountryCodeTableView()
        wait(for: 1)
        
        // Checks if CountryCodeTableViewController was successfully loaded
        let controller = viewController.presentedViewController as! UINavigationController
        let countryCodeTableViewController = controller.visibleViewController as! CountryCodeViewController
        XCTAssert(countryCodeTableViewController.isViewLoaded == true)
        
        // Makes sure the countryCodesArray is not empty
        XCTAssert(countryCodeTableViewController.countryCodesArray.isEmpty == false)
        
        // Dismisses the CountryCodeTableViewController and waits to make sure it was successfully deallocated
        countryCodeTableViewController.dismissViewController()
        wait(for: 1)
    }
    
    func testVerifyViewController() {
        viewController.presentVerifyController(requestId: requestId, phoneNumber: sanitizedNumber, timeout: 120)
        wait(for: 1)
        
        // Checks if VerifyViewController was successfully loaded
        let controller = viewController.presentedViewController as! UINavigationController
        let verifyViewController = controller.visibleViewController as! FinalizeViewController
        XCTAssertEqual(verifyViewController.requestId, requestId)
        XCTAssertEqual(verifyViewController.phoneNumber, sanitizedNumber)
        
        // Checks if updateRequestId function is working as expected
        verifyViewController.updateValues(with: newRequestId, timeout: 90)
        wait(for: 1)
        XCTAssertEqual(verifyViewController.requestId, newRequestId)
        
        // Checks that Alert is displayed if textField is empty when verify button is pressed
        verifyViewController.verifyButtonPressed()
        wait(for: 1)
        
        let alert = controller.visibleViewController as! UIAlertController
        XCTAssertTrue(alert.isViewLoaded)
        
        alert.dismiss(animated: true, completion: nil)
        wait(for: 1)
        
        // Mocks a successful verification request and displays the SuccessViewController
        verifyViewController.success()
        wait(for: 1)

        // Checks if SuccessViewController was successfully loaded
        let successViewController = controller.visibleViewController as! SuccessViewController
        XCTAssertTrue(successViewController.isViewLoaded)

        // Dismisses the SuccessViewController and waits to make sure it was successfully deallocated
        successViewController.dismissViewController()
        wait(for: 1)
    }
    
    func testDeeplink() {
        
        guard let url = URL(string: deeplinkURL) else {
            return
        }
        
        DeepLinker.handleDeepLink(url: url)
    }
 
    func testInitiate() {
        let requestBody = "jwt=\(jwtToken)&phone_number=\(phoneNumber)"
        let request = InitiateRequest(jwtToken: jwtToken, phoneNumber: phoneNumber, appendOptionalParameters: false)
        XCTAssertEqual(requestBody, request.body)
        
        let url = "https://appverify/sms"
        
        XCTAssertThrowsError(try SessionManager.shared.generateJwtToken())
        
        // Testing successful mock initiate sms request
        if let successResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil) {
            let mockSession = URLSessionMock(mockResponse: successResponse)
            Service.shared.session = mockSession
            
            Service.shared.initiate(with: jwtToken, phoneNumber: sanitizedNumber) { (successData, errorData, error) in
                XCTAssertEqual(successData?.response.code, 200)
            }
        }
        
        // Testing failed mock sms request
        if let errorResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil) {
            let mockSession = URLSessionMock(mockResponse: errorResponse)
            Service.shared.session = mockSession
            
            Service.shared.initiate(with: jwtToken, phoneNumber: sanitizedNumber) { (successData, errorData, error) in
                XCTAssertEqual(errorData?.response.code, 404)
            }
        }
    
    }
    
    func testFinalizeRequest() {
        let requestBody = "request_id=\(requestId)&verification_code=\(verificationCode)"
        let request = FinalizeRequest(requestId: requestId, verificationCode: verificationCode)
        XCTAssertEqual(requestBody, request.body)
        
        let url = "https://appverify/verify"
        
        // Testing successful mock verify request
        if let successResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil) {
            let mockSession = URLSessionMock(mockResponse: successResponse)
            Service.shared.session = mockSession
            
            Service.shared.finalize(with: requestId, verificationCode: verificationCode) { (successData, errorData, error) in
                XCTAssertEqual(successData?.response.code, 200)
            }
            
        }

        // Testing failed mock verify request
        if let errorResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil) {
            let mockSession = URLSessionMock(mockResponse: errorResponse)
            Service.shared.session = mockSession
            
            Service.shared.finalize(with: requestId, verificationCode: verificationCode) { (successData, errorData, error) in
                XCTAssertEqual(errorData?.response.code, 404)
            }
        }
    }
}

extension XCTestCase {
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}

class URLSessionMock: URLSession {
    private let mockResponse: HTTPURLResponse
    
    init(mockResponse: HTTPURLResponse) {
        self.mockResponse = mockResponse
    }

    let smsSuccessData = InitiateResponse(response: Response(receivedOnDate: "today", code: 200, message: "success"), requestId: "abcdefg", timeout: 120, maxRetries: 3)
    let verifySuccessData = FinalizeResponse(response: Response(receivedOnDate: "today", code: 200, message: "success"))
    let errorData = ErrorResponse(response: Response(receivedOnDate: "today", code: 404, message: "error"))
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        if mockResponse.statusCode == 200 {

            guard let components = URLComponents(url: mockResponse.url!, resolvingAgainstBaseURL: true) else {
                return URLSessionDataTaskMock {
                    completionHandler(nil, self.mockResponse, Error.self as? Error)
                }
            }
            
            if components.path == "/sms" {
                let data = try? JSONEncoder().encode(self.smsSuccessData)
                return URLSessionDataTaskMock {
                    completionHandler(data, self.mockResponse, nil)
                }
            } else {
                let data = try? JSONEncoder().encode(self.verifySuccessData)
                return URLSessionDataTaskMock {
                    completionHandler(data, self.mockResponse, nil)
                }
            }
            
        } else {
            let error = try? JSONEncoder().encode(self.errorData)
            return URLSessionDataTaskMock {
                completionHandler(error, self.mockResponse, nil)
            }
        }
    }

}

// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
