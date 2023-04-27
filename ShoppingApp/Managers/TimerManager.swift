//
//  TimerManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/25.
//

import Foundation

protocol TimerManagerProtocol {
    func createTimer()
    func startTimer()
    func stopTimer()
}

struct TimerManager {
//    private var timer: Timer?

    func createTimer(
        interval: TimeInterval,
        repeats: Bool,
        using: @escaping (Timer) -> ()
    ) {
        let timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: repeats
        ) { timer in
            using(timer)
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    func startTimer() {

    }

    func stopTimer() {

    }

}
