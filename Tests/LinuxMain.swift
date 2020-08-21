import XCTest

import scryptoTests

var tests = [XCTestCaseEntry]()
tests += scryptoTests.allTests()
XCTMain(tests)
