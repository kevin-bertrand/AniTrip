//
//  CircularSpinnerView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct CircularSpinnerView: View {
    static let initialDegree: Angle = .degrees(270)
    
    private let animationTime: Double = 1.75
    private let fullRotation: Angle = .degrees(360)
    private let rotationTime: Double = 0.75
    
    @State private var spinnerStart: CGFloat = 0.0
    @State private var spinnerEndS1: CGFloat = 0.03
    @State private var spinnerEndS2S3: CGFloat = 0.03
    
    @State private var rotationDegreeS1 = initialDegree
    @State private var rotationDegreeS2 = initialDegree
    @State private var rotationDegreeS3 = initialDegree
    @State private var rotationDegreeS4 = initialDegree
    
    var body: some View {
        ZStack {
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS4, color: .yellow)
            
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: .blue)
            
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS2, color: .red)
            
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: .accentColor)
            
        }
        .frame(width: 175, height: 175)
        .onAppear() {
            self.animateSpinner()
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { (mainTimer) in
                self.animateSpinner()
            }
        }
    }
    
    // MARK: Animation methods
    func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.rotationTime)) {
                completion()
            }
        }
    }
    
    func animateSpinner() {
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }
        
        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegreeS1 += fullRotation
            self.spinnerEndS2S3 = 0.8
        }
        
        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS1 = 0.03
            self.spinnerEndS2S3 = 0.03
        }
        
        animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreeS2 += fullRotation }
        
        animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreeS3 += fullRotation }
        
        animateSpinner(with: (rotationTime * 2) + 0.375) { self.rotationDegreeS4 += fullRotation }
    }
}

struct CircularSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        CircularSpinnerView()
    }
}

struct SpinnerCircleView: View {
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color
    
    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: .init(lineWidth: 20, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}
