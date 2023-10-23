//
//  ContentView.swift
//  CoreMotionSample
//
//  Created by Hangyeol on 10/23/23.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var gravityValue: String = "x: 0\ny: 0\nz: 0"
    @State private var accelerometerValue: String = "x: 0\ny: 0\nz: 0\nspeed: 0"
    @State private var motionActivityValue: String = "unknown"
    @State private var stepsValue: String = "0"
    
    private let motionManager = CMMotionManager()
    private let motionActivity = CMMotionActivityManager()
    private let pedometer = CMPedometer()

    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Gravity")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(gravityValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Text("Accelerometer")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(accelerometerValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Text("Motion Activity")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(motionActivityValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Text("Number Of Steps")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(stepsValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .onAppear {
            motionManager.startDeviceMotionUpdates(to: .current!) { deviceMotion, error in
                guard let deviceMotion else {
                    return
                }
                gravityValue = """
                x: \(deviceMotion.gravity.x)
                y: \(deviceMotion.gravity.y)
                z: \(deviceMotion.gravity.z)
                """
            }
            
            motionManager.startAccelerometerUpdates(to: .current!) { data, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                guard let data else {
                    return
                }
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z
                accelerometerValue = """
                x: \(x)
                y: \(y)
                z: \(z)
                speed: \(sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)))
                """
            }
            
            motionActivity.startActivityUpdates(to: .current!) { motionActivity in
                guard let motionActivity else {
                    return
                }
                if motionActivity.unknown {
                    motionActivityValue = "unknown"
                } else if motionActivity.stationary {
                    motionActivityValue = "stationary"
                } else if motionActivity.walking {
                    motionActivityValue = "walking"
                } else if motionActivity.running {
                    motionActivityValue = "running"
                } else if motionActivity.automotive {
                    motionActivityValue = "automotive"
                } else if motionActivity.cycling {
                    motionActivityValue = "cycling"
                }
            }
            
            pedometer.startUpdates(from: Date()) { data, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                guard let data else {
                    return
                }
                stepsValue = String(describing: data.numberOfSteps)
            }
        }
    }
}

#Preview {
    ContentView()
}
