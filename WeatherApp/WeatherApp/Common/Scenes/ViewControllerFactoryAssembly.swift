//
//  ViewControllerFactoryAssembly.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 19.10.2022.
//

import Foundation
import Swinject

class ViewControllerFactoryAssembly: Assembly{
    private let assembler : Assembler
    
    init(assembler: Assembler){
        self.assembler = assembler
    }
    
    func assemble(container: Container) {
        container.register(ViewControllerFactory.self) { _ in
            ViewControllerFactoryImpl(assembler: self.assembler)
        }
    }
}
