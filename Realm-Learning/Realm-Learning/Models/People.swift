//
//  People.swift
//  Realm-Learning
//
//  Created by Tiến Việt Trịnh on 29/06/2023.
//

import RealmSwift
import UIKit

class People: Object {
    @Persisted var name: String
    @Persisted var listAge: List<Int> = List<Int>()
}
