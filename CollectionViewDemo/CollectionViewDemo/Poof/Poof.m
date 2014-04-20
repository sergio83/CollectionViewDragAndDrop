//
//  Poof.m
//  CareerOnDemand
//
//  Created by Sergio Cirasa on 20/12/11.
//  Copyright (c) 2011 Sovanta. All rights reserved.
//


#import "Poof.h"


@implementation Poof

- (id) initWithCenter:(CGPoint)center{
	self = [super initWithFrame:CGRectMake(0, 0, 32, 32)];
	if (self != nil) {
		UIImage *frame1 = [UIImage imageNamed:@"poof_1.png"];
		UIImage *frame2 = [UIImage imageNamed:@"poof_2.png"];
		UIImage *frame3 = [UIImage imageNamed:@"poof_3.png"];
		UIImage *frame4 = [UIImage imageNamed:@"poof_4.png"];
		UIImage *frame5 = [UIImage imageNamed:@"poof_5.png"];
		
		NSArray *array = [[NSArray alloc] initWithObjects:frame1, frame2, frame3, frame4, frame5, nil];
		self.animationImages = array;
		
		self.animationDuration = 0.6; // defaults is number of animation images * 1/30th of a second
		self.animationRepeatCount = 1; // default is 0, which repeats indefinitely
		self.center = center;
		[self startAnimating];
	}
	return self;
}

- (void)startAnimating{
	[super startAnimating];
	[self removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)dealloc {

}

@end
