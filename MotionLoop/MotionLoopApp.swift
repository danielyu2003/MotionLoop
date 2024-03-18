//
//  MotionLoopApp.swift
//  MotionLoop
//
//  Created by Daniel Yu on 3/5/24.
//

import SwiftUI

@main 
struct MotionLoopApp: App {
	@State private var motion = Motion()
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(motion)
        }
    }
}
