//
//  MKMapView+ZoomLevel.h
//  FungusProject
//
//  Created by humengfan on 2018/6/20.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)


- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
