//
//  SnapshotTestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Yannic Borgfeld on 05.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import XCTest

protocol SnapshotTestCase: XCTestCase {}

extension SnapshotTestCase {
    func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshotData = UIImage(contentsOfFile: snapshotURL.path) else {
            return XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use `record` method to store a snapshot before asserting", file: file, line: line)
        }
        
        if !compare(storedSnapshotData, snapshot, precision: 0.999) {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)
            
            try? snapshotData?.write(to: temporarySnapshotURL)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }
    
    func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            
            try snapshotData?.write(to: snapshotURL)
            XCTFail("Record succeeded - use `assert` to compare the snapshot from now on.", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }
    
    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        
        return snapshotData
    }
    
    private func compare(_ old: UIImage, _ new: UIImage, precision: Float) -> Bool {
        Swift.assert(precision >= 0 && precision <= 1, "Precision has to be between 0 and 1")
        
        guard let oldCGImage = old.cgImage, let newCGImage = new.cgImage else { return false }
        
        guard haveSameDimensions(oldCGImage, newCGImage) else { return false }
        
        let minBytesPerRow = min(oldCGImage.bytesPerRow, newCGImage.bytesPerRow)
        let byteCount = minBytesPerRow * oldCGImage.height
        
        var oldByteBuffer = [UInt8](repeating: 0, count: byteCount)
        guard let oldDataPointer = dataPointer(for: oldCGImage, withBytesPerRow: minBytesPerRow, drawingDataInto: &oldByteBuffer) else { return false }
        
        if let newDataPointer = dataPointer(for: newCGImage, withBytesPerRow: minBytesPerRow),
           dataInMemoryIsEqual(oldDataPointer, newDataPointer, byteCount: byteCount) {
            return true
        }
        
        let newer = UIImage(data: new.pngData()!)!
        guard let newerCgImage = newer.cgImage else { return false }
        
        var newerByteBuffer = [UInt8](repeating: 0, count: byteCount)
        guard let newerDataPointer = dataPointer(for: newerCgImage, withBytesPerRow: minBytesPerRow, drawingDataInto: &newerByteBuffer) else { return false }
        
        if dataInMemoryIsEqual(oldDataPointer, newerDataPointer, byteCount: byteCount) { return true }
        
        if precision >= 1 { return false }
        
        return comparePixelByPixel(oldByteBuffer, newerByteBuffer, with: precision, byteCount: byteCount)
    }
    
    private func haveSameDimensions(_ old: CGImage, _ new: CGImage) -> Bool {
        guard old.width != 0, new.width != 0 else { return false }
        guard old.height != 0, new.height != 0 else { return false }
        guard old.width == new.width, old.height == new.height else { return false }
        return true
    }
    
    private func dataPointer(for cgImage: CGImage, withBytesPerRow: Int, drawingDataInto buffer: UnsafeMutableRawPointer? = nil) -> UnsafeMutableRawPointer? {
        guard
            let space = cgImage.colorSpace,
            let context = CGContext(
                data: buffer,
                width: cgImage.width,
                height: cgImage.height,
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: withBytesPerRow,
                space: space,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
        else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        return context.data
    }
    
    private func dataInMemoryIsEqual(_ old: UnsafeMutableRawPointer, _ new: UnsafeMutableRawPointer, byteCount: Int) -> Bool {
        memcmp(old, new, byteCount) == 0
    }
    
    private func comparePixelByPixel(_ oldBuffer: [UInt8], _ newerBuffer: [UInt8], with precision: Float, byteCount: Int) -> Bool {
        var mismatchedPixelCount = 0
        let threshold = 1 - precision
        
        for byte in 0..<byteCount where oldBuffer[byte] != newerBuffer[byte] {
            mismatchedPixelCount += 1
            
            if Float(mismatchedPixelCount) / Float(byteCount) > threshold { return false }
        }
        
        return true
    }
}

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection
    
    static func iPhone8(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
        return SnapshotConfiguration(
            size: CGSize(width: 375, height: 667),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
            traitCollection: UITraitCollection(traitsFrom: [
                .init(forceTouchCapability: .available),
                .init(layoutDirection: .leftToRight),
                .init(preferredContentSizeCategory: .medium),
                .init(userInterfaceIdiom: .phone),
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(displayScale: 2),
                .init(displayGamut: .P3),
                .init(userInterfaceStyle: style)
            ]))
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone8(style: .light)
    
    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }
    
    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }
    
    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}
