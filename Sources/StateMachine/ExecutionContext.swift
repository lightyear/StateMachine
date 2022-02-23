//
//  ExecutionContext.swift
//  StateMachine
//
//  Created by Steve Madsen on 2/23/22.
//  Copyright © 2022 Light Year Software, LLC
//

import Foundation

public protocol ExecutionContext {
    func sync(execute: () -> Void)
}

extension DispatchQueue: ExecutionContext {}
