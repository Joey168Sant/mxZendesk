//
//  ConfigProvider.swift
//  MXZendeskWrapper
//
//  Created by MacPro on 01/03/22.
//

import Foundation

class ConfigProvider {
    private var fileTarget: String = Configuration.DEFAULT_FILE
    
    func getConfig(
        fileName: String? = nil
    ) throws -> [String: Any] {
        if fileName != nil {
            fileTarget = fileName!
        }
        var config: [String: Any]?
        do {
            try Bundle.allBundles.forEach { bundle in
                if let path = bundle.path(forResource: fileTarget, ofType: "plist") {
                    var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
                    let plistXML = FileManager.default.contents(atPath: path)!
                    config = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String:Any]
                }
            }
        } catch {
            throw SantanderManagerError(description: "configuration error: \(error)")
        }
        return config ?? [:]
    }
}
