//
//  UsuarioItemTest.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 24/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import XCTest
import PlayPoint

class UsuarioItemTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testarCriarUsuarioFromDicionarioFacebook() {
        
        // Arrange
        let dicionarioFacebook = ["picture": { "data" = {
                "is_silhouette" = 0;
                "url" = "https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/10660156_631777293624460_1617754289583412644_n.jpg?oh=17044e01f3eb60865d2cdb083a97b593&oe=5A0CB780";
            };
            }, "name": "Gabriel Rodrigues", "last_name": "Rodrigues", "email": "gabrielll.bsb@hotmail.com", "id": "1049264178542434", "first_name": "Gabriel"]
        
        var usuario: UsuarioItem?
        
        // Act
        usuario = UsuarioItem(dicionarioFromFacebok: dicionarioFacebook)
        
        
        // Asserts
        XCTAssertEqual(usuario?.nomeCompleto, "Gabriel Rodrigues")
        
    }
    
}
