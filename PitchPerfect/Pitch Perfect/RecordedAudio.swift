//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Erwin Mazwardi on 31/03/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    let filePathUrl: NSURL!
    let title: String!
    init (filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
