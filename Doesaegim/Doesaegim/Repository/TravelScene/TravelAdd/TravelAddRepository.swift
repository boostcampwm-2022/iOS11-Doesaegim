//
//  TravelAddRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/05.
//

import Foundation

protocol TravelAddRepository {
    func addTravel(_ travelDTO: TravelDTO) -> Result<Travel, Error>
    
}
