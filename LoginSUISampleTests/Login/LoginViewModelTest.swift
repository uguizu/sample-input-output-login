//
//  LoginViewModelTest.swift
//  LoginSUISampleTests
//
//  Created by Eduardo Martinez on 8/5/21.
//

import Combine
import XCTest

@testable import LoginSUISample

class LoginViewModelTest: XCTestCase {
    func testEmailValidatorSuccess() throws {
        // Given
        let mock = LoginServiceMock(shouldLoginFail: false)
        let viewModel = LoginViewModel(loginService: mock)

        // When
        viewModel.email = "valid@email.com"
        // Then
        XCTAssert(viewModel.emailValidation)

        // When
        viewModel.email = "nothing"
        // Then
        XCTAssertFalse(viewModel.emailValidation)

        // When
        viewModel.email = ""
        // Then
        XCTAssertFalse(viewModel.emailValidation)
    }

    func testEmailPasswordValidator() throws {
        // Given
        let mock = LoginServiceMock(shouldLoginFail: false)
        let viewModel = LoginViewModel(loginService: mock)

        // When
        viewModel.password = "anything"
        // Then
        XCTAssert(viewModel.emailValidation)

        // When
        viewModel.email = ""
        // Then
        XCTAssertFalse(viewModel.emailValidation)
    }

    func testButtonEnabled() throws {
        // Given
        let mock = LoginServiceMock(shouldLoginFail: false)
        let viewModel = LoginViewModel(loginService: mock)

        // When
        viewModel.email = "valid@email.com"
        viewModel.password = "anything"

        // Then
        XCTAssert(viewModel.isButtonEnabled)
    }

    func testButtonDisabled() throws {
        // Given
        let mock = LoginServiceMock(shouldLoginFail: false)
        let viewModel = LoginViewModel(loginService: mock)

        // When
        viewModel.email = "notValid"
        viewModel.password = "password"
        // Then
        XCTAssertFalse(viewModel.isButtonEnabled)

        // When
        viewModel.email = "valid@email.com"
        viewModel.password = ""
        // Then
        XCTAssertFalse(viewModel.isButtonEnabled)

        // When
        viewModel.email = ""
        viewModel.password = "password"
        // Then
        XCTAssertFalse(viewModel.isButtonEnabled)

        // When
        viewModel.email = ""
        viewModel.password = ""
        // Then
        XCTAssertFalse(viewModel.isButtonEnabled)
    }

    func testLoginSuccess() throws {
        // Given
        let mock = LoginServiceMock(shouldLoginFail: false)
        let viewModel = LoginViewModel(loginService: mock)
        let expectation = XCTestExpectation(description: "Async Sink Test")

        // When
        viewModel.email = "valid@email.com"
        viewModel.password = "anything"

        let successCancellable = viewModel.didLoginSucceed
            .sink { value in
                XCTAssert(value == ())
                expectation.fulfill()
            }
        
        let failCancellable = viewModel.didThrowError
            .sink { _ in XCTFail("Should not throw error") }

        viewModel.didTapLogin.send()

        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(successCancellable)
        XCTAssertNotNil(failCancellable)
    }
    
    func testLoginFails() throws {
        // Given
        let mock = LoginServiceMock(shouldLoginFail: true)
        let viewModel = LoginViewModel(loginService: mock)
        let expectation = XCTestExpectation(description: "Async Sink Test")

        // When
        viewModel.email = "valid@email.com"
        viewModel.password = "anything"

        let successCancellable = viewModel.didLoginSucceed
            .sink { XCTFail("Should not succeed") }
        
        let failCancellable = viewModel.didThrowError
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }

        viewModel.didTapLogin.send()

        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(successCancellable)
        XCTAssertNotNil(failCancellable)
    }
}
