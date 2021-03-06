//
//  UIDevices.swift
//  seller iOS7
//
//  Created by lin on 2/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice{
    
    fileprivate func orientationString() -> String{
        switch self.orientation {
        case .unknown:
            return "Unknown";
        case .portrait: // Device oriented vertically, home button on the bottom:
            return "Portrait";
        case .portraitUpsideDown: // Device oriented vertically, home button on the top:
            return "PortraitUpsideDown";
        case .landscapeLeft: // Device oriented horizontally, home button on the right:
            return "LandscapeLeft";
        case .landscapeRight: // Device oriented horizontally, home button on the left:
            return "LandscapeRight";
        case .faceUp: // Device oriented flat, face up:
            return "FaceUp";
        case .faceDown:
            return "FaceDown";
        }
    }
    
    fileprivate func batteryStateString() -> String{
        switch self.batteryState {
        case .unknown:
            return "Unknown";
        case .unplugged: // Device oriented vertically, home button on the bottom:
            return "Unplugged";
        case .charging: // Device oriented vertically, home button on the top:
            return "Charging";
        case .full: // Device oriented horizontally, home button on the right:
            return "Full";
        }
    }
    
    fileprivate func userInterfaceIdiomString() -> String{
        switch self.userInterfaceIdiom {
        case .unspecified:
            return "Unspecified";
        case .phone: // Device oriented vertically, home button on the bottom:
            return "Phone";
        case .pad: // Device oriented vertically, home button on the top:
            return "Pad";
        case .tv:
            return "TV";
        case .carPlay:
            return "CarPlay";
        }
    }
    
    public func toString()->String{
        
        var str = "name:" + self.name;
        str = str + "\nmodel:" + self.model;
        str = str + "\nlocalizedModel:" + self.localizedModel;
        str = str + "\nsystemName:" + self.systemName;
        str = str + "\nsystemVersion:" + self.systemVersion;
        str = str + "\norientation:" + self.orientationString();
        
        str = str + "\nidentifierForVendor:" + self.identifierForVendor!.description;
        str = str + "\ngeneratesDeviceOrientationNotifications:\(self.isGeneratingDeviceOrientationNotifications)";
        str = str + "\nbatteryMonitoringEnabled:\(self.isBatteryMonitoringEnabled)";
        str = str + "\nbatteryState:\(self.batteryStateString())";
        
        str = str + "\nbatteryLevel:\(self.batteryLevel)";
        str = str + "\nproximityMonitoringEnabled:\(self.isProximityMonitoringEnabled)";
        str = str + "\nproximityState:\(self.proximityState)";
        str = str + "\nmultitaskingSupported:\(self.isMultitaskingSupported)";
        str = str + "\nuserInterfaceIdiom:\(self.userInterfaceIdiomString())";
        
        
        return str;
        
    }
}
