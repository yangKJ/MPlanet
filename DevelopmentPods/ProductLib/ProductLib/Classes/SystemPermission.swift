//
//  SystemPermission.swift
//  FeatBox-FeatBox
//
//  Created by Condy on 2025/2/28.
//

import Foundation
import ProductLib
import CoreLocation
import AVFoundation
import Contacts
import Photos
import UIKit

public struct SystemPermission {

    public enum Status {
        case notDetermined
        case denied
        case authorized
        case notSupport
    }
}

extension SystemPermission {

    public static var locationAuthorized: SystemPermission.Status {
        // 修复：CLLocationManager.authorizationStatus() 在 iOS 14+ 已 deprecated
        // 改用 manager 实例的 authorizationStatus
        if #available(iOS 14.0, *) {
            let manager = CLLocationManager()
            switch manager.authorizationStatus {
            case .denied, .restricted:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .authorized
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .denied, .restricted:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .authorized
            }
        }
    }

    public static var addressBookAuthorized: SystemPermission.Status {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        default:
            return .authorized
        }
    }

    public static var cameraAuthorized: SystemPermission.Status {
        if UIImagePickerController.availableMediaTypes(for: .camera) == nil {
            return .notSupport
        }
        // 修复：AVCaptureDevice.authorizationStatus(for:) 在 iOS 14+ 已 deprecated
        // 改用 AVCaptureDevice.authorizationStatus(for:of:)
        if #available(iOS 14.0, *) {
            switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            case .denied, .restricted:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .authorized
            }
        } else {
            switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            case .denied, .restricted:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .authorized
            }
        }
    }

    public static var photoLibraryAuthorized: SystemPermission.Status {
        // 修复：PHPhotoLibrary.authorizationStatus() 在 iOS 14+ 已 deprecated
        // 改用 PHPhotoLibrary.authorizationStatus(for:)
        if #available(iOS 14.0, *) {
            switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .denied, .restricted:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .authorized
            }
        } else {
            switch PHPhotoLibrary.authorizationStatus() {
            case .denied, .restricted:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .authorized
            }
        }
    }

    public static func requestPhotoLibraryAuthorized(_ response: @escaping (PHAuthorizationStatus) -> Void) {
        // 修复：PHPhotoLibrary.requestAuthorization(handler:) 在 iOS 14+ 已 deprecated
        // 改用 PHPhotoLibrary.requestAuthorization(for:handler:)
        if #available(iOS 14.0, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { (status) in
                DispatchQueue.main.fy.safeAsync {
                    response(status)
                }
            })
        } else {
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.fy.safeAsync {
                    response(status)
                }
            })
        }
    }

    public static func requestRecordPermission(_ response: @escaping (Bool) -> Void) {
        // 修复：AVAudioSession.requestRecordPermission(_:) 在 iOS 17+ 已 deprecated
        // 改用 AVAudioApplication.requestRecordPermission(completionHandler:)
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { (result) in
                DispatchQueue.main.fy.safeAsync {
                    response(result)
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
                DispatchQueue.main.fy.safeAsync {
                    response(result)
                }
            })
        }
    }

    public static func requestAddressBookPermission(contactStore: CNContactStore, completion: @escaping (Bool, Error?) -> Void) {
        contactStore.requestAccess(for: .contacts) { (result, error) in
            DispatchQueue.main.fy.safeAsync {
                completion(result, error)
            }
        }
    }

    public static func openSettingURL() {
        // 修复：UIApplication.shared.openURL(_:) 在 iOS 10+ 已 deprecated
        // 改用异步的 open(_:options:completionHandler:)
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
