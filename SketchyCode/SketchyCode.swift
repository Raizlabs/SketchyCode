//
//  SketchyCode.swift
//  SketchyCode
//
//  Created by Brian King on 5/19/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation
import PathKit
import Marshal
import StencilSwiftKit

class SketchyCode {
    static let version: String = "0.suspect"
    
    fileprivate let verbose: Bool
    fileprivate let sketchPath: Path
    fileprivate let templatePaths: [Path]
    fileprivate let outputPath: Path

    init(verbose: Bool, sketchPath: Path, templatePaths: [Path], outputPath: Path) {
        self.verbose = verbose
        self.sketchPath = sketchPath
        self.templatePaths = templatePaths
        self.outputPath = outputPath
    }
    
    func process() throws {
        let command = Command("/usr/local/bin/sketchtool", arguments: "dump", sketchPath.string)
        let output = command.execute()
        let json = try JSONSerialization.jsonObject(with: output, options: [])

        guard let object = json as? [String: Any] else {
            throw MarshalError.typeMismatch(expected: [String: Any].self, actual: json)
        }

        let document = try MSDocumentData(object: object)
        
        for templatePath in templatePaths {
            let data = try Data(contentsOf: templatePath.url, options: [])
            guard let stencilString = String(data: data, encoding: String.Encoding.utf8) else {
                throw ParserError.canNotLoadClassStencil
            }
            let template = StencilSwiftTemplate(templateString: stencilString)
            let generated = try template.render(["document": document])
            
            if outputPath == "" {
                print(generated)
            }
            else {
                let newFile = templatePath.lastComponentWithoutExtension.appending(".swift")

                let newURL = URL(fileURLWithPath: outputPath.string + "/" + newFile)
                
                try generated.data(using: .utf8)?.write(to: newURL)
            }
        }
    }
}
