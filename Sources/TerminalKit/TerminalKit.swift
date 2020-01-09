//
//  TerminalKit.swift
//  TerminalKit
//
//  Created by Banaple on 2020/01/06.
//  Copyright © 2020 BUGKING. All rights reserved.
//

import Foundation

public typealias Handler = (TerminalKit)->()

public class TerminalKit {
    private var commands:[String]!
    private var queuePoint:Int = 0
    public var task:Process!
    public var output:String? {
        didSet {
            if output != nil {
                self.paragraph.append(output!)
            }
        }
    }
    public var errput:String? {
        didSet {
            if errput != nil {
                self.paragraph.append(errput!)
            }
        }
    }
    
    public var paragraph:String = ""
    
    private init(_ launchPath:String?) {
        self.task = Process()
        self.task.launchPath = launchPath == nil ? "/bin/sh" : launchPath
    }
    
    public convenience init(_ command:String, launchPath:String?=nil, isWaitUntilExit:Bool=true) {
        self.init(launchPath)
        self.commands = [command]
        self.setCommand(isWaitUntilExit)
    }
    
    public convenience init(_ commands:[String]) {
        self.init(nil)
        self.commands = commands
        self.setCommand()
    }
    
    private func setCommand(_ isWaitUntilExit:Bool=true) {
        let command = String(self.commands.flatMap { $0 + "&&" }.dropLast(2))
        self.task.arguments = ["-c", command]
        self.output = nil
        self.errput = nil
        if isWaitUntilExit {
            self.task.waitUntilExit()
        }
    }
}

extension TerminalKit {
    private func readPipe(_ pipe:Pipe, _ isRealTime:Bool) -> String? {
        let pipeData:Data = isRealTime ? pipe.fileHandleForReading.availableData
                                       : pipe.fileHandleForReading.readDataToEndOfFile()
        
        if let out = String(data:pipeData, encoding: .utf8) {
            return out
        }
        
        return nil
    }
    
    private func launch() {
        DispatchQueue.global().async {
            self.task.launch()
        }
    }
        
    public func launch(_ onTerminate:Handler?=nil) {
        let outPipe = Pipe()
        let errPipe = Pipe()
        task.standardOutput = outPipe
        task.standardError = errPipe
        
        self.task.terminationHandler = { _ in
            self.output = self.readPipe(outPipe, false)
            self.errput = self.readPipe(errPipe, false)
            onTerminate?(self)
        }
        
        self.launch()
    }
    
    public func launch(onRunning:Handler?, onTerminate:Handler?) {
        let outPipe = Pipe()
        let errPipe = Pipe()
        task.standardOutput = outPipe
        task.standardError = errPipe
        
        outPipe.fileHandleForReading.readabilityHandler = { pipe in
            self.output = self.readPipe(outPipe, true)
            self.errput = nil
            onRunning?(self)
        }
        
        errPipe.fileHandleForReading.readabilityHandler = { pipe in
            self.output = nil
            self.errput = self.readPipe(errPipe, true)
            onRunning?(self)
        }
        
        task.terminationHandler = { _ in
            outPipe.fileHandleForReading.closeFile()
            errPipe.fileHandleForReading.closeFile()
            self.output = nil
            self.errput = nil
            onTerminate?(self)
        }
        
        self.launch()
    }
}
