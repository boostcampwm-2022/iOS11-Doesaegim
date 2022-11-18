//
//  SearchingLocationViewControllerDelegate.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/17.
//

import Foundation

protocol SearchingLocationViewControllerDelegate: AnyObject {
    func searchingLocationViewController(didSelect location: LocationDTO)
}
