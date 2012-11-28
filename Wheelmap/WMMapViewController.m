//
//  WMMapViewController.m
//  Wheelmap
//
//  Created by Dorian Roy on 07.11.12.
//  Copyright (c) 2012 Sozialhelden e.V. All rights reserved.
//

#import "WMMapViewController.h"
#import "WMMapAnnotation.h"
#import "WMDetailViewController.h"
#import "Node.h"
#import "NodeType.h"


// TODO: re-position popover after orientation change

@implementation WMMapViewController
{
    NSArray *nodes;
    UIPopoverController *popover;
}

@synthesize dataSource, delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self loadNodes];
}

- (void) loadNodes
{
    nodes = [self.dataSource nodeList];
    
    // TODO: optimization: don't remove annotations that will be added again
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [nodes enumerateObjectsUsingBlock:^(Node *node, NSUInteger idx, BOOL *stop) {
        WMMapAnnotation *annotation = [[WMMapAnnotation alloc] initWithNode:node];
        [self.mapView addAnnotation:annotation];
    }];
}

- (void) showDetailPopoverForNode:(Node *)node
{
    WMMapAnnotation *annotation = [self annotationForNode:node];
    MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];

    WMDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"WMDetailView" bundle:nil] instantiateInitialViewController];
    detailViewController.node = node;
    
    UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:detailNavController];
    
    CGRect annotationViewRect = [self.view convertRect:annotationView.bounds fromView:annotationView];
    [popover presentPopoverFromRect:annotationViewRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (WMMapAnnotation*) annotationForNode:(Node*)node
{
    for (WMMapAnnotation* annotation in  self.mapView.annotations) {
        
        // filter out MKUserLocation annotation
        if ([annotation isKindOfClass:[WMMapAnnotation class]] && [annotation.node isEqual:node]) {
            return annotation;
        }
    }
    return nil;
}


#pragma mark - Node List View Protocol

- (void) nodeListDidChange
{
    [self loadNodes];
}

- (void)selectNode:(Node *)node
{
    WMMapAnnotation *annotation = [self annotationForNode:node];
    [self.mapView selectAnnotation:annotation animated:YES];
}


#pragma mark - Map View Delegate

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[WMMapAnnotation class]]) {
        Node *node = [(WMMapAnnotation*)annotation node];
        NSString *reuseId = [node.wheelchair stringByAppendingString:node.node_type.identifier];
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(6, -14);
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        annotationView.image = [UIImage imageNamed:[@"marker_" stringByAppendingString:node.wheelchair]];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([self.delegate respondsToSelector:@selector(nodeListView:didSelectNode:)]) {
        WMMapAnnotation *annotation = (WMMapAnnotation*)view.annotation;
        [self.delegate nodeListView:self didSelectNode:annotation.node];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([self.delegate respondsToSelector:@selector(nodeListView:didSelectNode:)]) {
        [self.delegate nodeListView:self didSelectNode:nil];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    WMMapAnnotation *annotation = (WMMapAnnotation*)view.annotation;
    [self.delegate nodeListView:self didSelectDetailsForNode:annotation.node];
}

- (IBAction)toggleMapTypeChanged:(UISegmentedControl*)segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0: self.mapView.mapType = MKMapTypeStandard; break;
        case 1: self.mapView.mapType = MKMapTypeHybrid; break;
        case 2: self.mapView.mapType = MKMapTypeSatellite; break;
    }
}

- (IBAction)returnToListViewTouched:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end




