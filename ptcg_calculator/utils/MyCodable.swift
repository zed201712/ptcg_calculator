//
//  MyCodable.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/9.
//

import Foundation

protocol MyCodable: Codable {}

extension MyCodable {
    init?(data: Data) {
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = result
    }
    
    init?(json: String) {
        guard let data = json.data(using: .utf8), let result = Self(data: data) else { return nil }
        self = result
    }
    
    var toDictionary: [String: Any] {
        guard let dic = (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] else { return [:] }
        return dic
    }
    
    var prettyJsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self.toDictionary, options: .prettyPrinted)
    }
    
    var prettyJsonString: String? {
        guard let data = self.prettyJsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
