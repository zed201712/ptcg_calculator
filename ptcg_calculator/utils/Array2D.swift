//
//  Array2D.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/11.
//

import Foundation

extension Array where Element: Collection, Element.Indices.Iterator.Element == Int {
    func array2Map<T>(_ transform: (Element.Element)->T) -> [[T]] {
        self.map {
            $0.map(transform)
        }
    }
    func array2Map<T>(_ transform: (Int, Int, Element.Element)->T) -> [[T]] {
        self.enumerated().map { y, array in
            array.enumerated().map { x, element in
                transform(y, x, element)
            }
        }
    }
}
