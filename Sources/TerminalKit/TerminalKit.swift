//
//  TerminalKit.swift
//
//
//  Created by Kimun Kwon on 2021/06/24.
//

import Foundation

public typealias Handler = ((output: String?, errput: String?))->()

public class TerminalKit {
    private var commands: [String]
    private var task: Process
    
    private init(_ launchPath: String?) {
        self.task = Process()
        self.task.launchPath = launchPath == nil ? "/bin/sh" : launchPath
        self.commands = []
    }
    
    public convenience init(_ command: String, launchPath: String? = nil, isWaitUntilExit: Bool = true) {
        self.init(launchPath)
        self.commands = [command]
        self.setCommand(isWaitUntilExit)
    }
    
    public convenience init(_ commands: [String], launchPath: String? = nil, isWaitUntilExit: Bool = true) {
        self.init(launchPath)
        self.commands = commands
        self.setCommand(isWaitUntilExit)
    }
    
    private func setCommand(_ isWaitUntilExit: Bool) {
        let command = String(self.commands.flatMap { $0 + "&&" }.dropLast(2))
        self.task.arguments = ["-c", command]
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
    
    /// Invoked when the task is completed.
    public func launch(_ onCompleted: Handler? = nil) {
        let outPipe = Pipe()
        let errPipe = Pipe()
        task.standardOutput = outPipe
        task.standardError = errPipe
        
        self.task.terminationHandler = { _ in
            let output = self.readPipe(outPipe, false)
            let errput = self.readPipe(errPipe, false)
            outPipe.fileHandleForReading.closeFile()
            errPipe.fileHandleForReading.closeFile()
            onCompleted?((output, errput))
        }
        
        self.launch()
    }
    
    public func launch(onNext: Handler?, onCompleted: Handler?) {
        let outPipe = Pipe()
        let errPipe = Pipe()
        var fullOutput: String = ""
        var fullErrput: String = ""
        task.standardOutput = outPipe
        task.standardError = errPipe
        
        outPipe.fileHandleForReading.readabilityHandler = { _ in
            if let output: String = self.readPipe(outPipe, true) {
                fullOutput.append(output)
                onNext?((output, nil))
            }
        }
        
        errPipe.fileHandleForReading.readabilityHandler = { _ in
            if let errput: String = self.readPipe(errPipe, true) {
                fullErrput.append(errput)
                onNext?((nil, errput))
            }
        }
        
        task.terminationHandler = { _ in
            outPipe.fileHandleForReading.closeFile()
            errPipe.fileHandleForReading.closeFile()
            onCompleted?((fullOutput, fullErrput))
        }
        
        self.launch()
    }
}
