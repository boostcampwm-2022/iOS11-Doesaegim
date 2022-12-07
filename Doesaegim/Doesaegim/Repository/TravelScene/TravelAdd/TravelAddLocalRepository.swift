//
//  TravelAddLocalRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/05.
//

import Foundation

struct TravelAddLocalRepository: TravelAddRepository {
    func addTravel(_ travelDTO: TravelDTO) -> Result<Travel, Error> {
        Travel.addAndSave(with: travelDTO)
    }
    
}
