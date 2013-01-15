//
//  PBCustomTabBar.m
//  HotelApp
//
//  Created by Piet Brauer on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PBCustomTabBar.h"

@interface PBCustomTabBar (){
    NSArray *rootItems;
    int selected;
    BOOL hidden;
    BOOL rotationPending;
}

@property (nonatomic, strong) NSArray *rootItems;

@end

@implementation PBCustomTabBar
@synthesize rootItems;

-(id)init{
    self = [super init];
    if (self) {
        rootItems = [[NSArray alloc] init];
    }
    
    return self;
}

-(id)initWithRootItems:(NSArray *)_rootItems{
    self = [super init];
    
    if (self) {
        self.rootItems = _rootItems;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[self hideTabBar];
	[self setupTabItems];
}

- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
		}
	}
}

- (void)hideNewTabBar
{
    hidden = YES;
    for (UIButton *button in self.view.subviews) {
        if ([button isMemberOfClass:[UIButton class]]){
            button.hidden = 1;
        }
    }
}

-(void)releaseNewTabBar{
    for (UIButton *button in self.view.subviews) {
        if ([button isMemberOfClass:[UIButton class]]){
            [button removeFromSuperview];
        }
    }
}

- (void)showNewTabBar
{
    hidden = NO;
    if (rotationPending) {
        [self setupTabItems];        
        [self selectIndex:selected];
        selected = 500;
        rotationPending = NO;
    } else{
        for (UIButton *button in self.view.subviews) {
            if ([button isMemberOfClass:[UIButton class]]){
                button.hidden = 0;
            }
        }
    }
}

-(void)setupTabItems{
    if (self.viewControllers.count < 6) {
        
        CGSize imgSize = CGSizeMake(self.view.bounds.size.width/self.viewControllers.count, 55.f);
        
        for (int i = 0; i < self.viewControllers.count; i++) {
            [self setupViewControllerWithIndex:i andImageSize:imgSize];
        }
    } else {
        
        CGSize imgSize = CGSizeMake(self.view.bounds.size.width/5, 55.f);
        
        
        self.viewControllers = [NSArray arrayWithArray:[self getMutatedViewControllers]];
        rootItems = [NSArray arrayWithArray:[self getMutatedRootItems]];
        
        for (int i = 0; i < self.viewControllers.count; i++) {
            [self setupViewControllerWithIndex:i andImageSize:imgSize];
        }
    }
    
    [self selectIndex:0];
}

-(NSArray *)getMutatedViewControllers{
    
    NSMutableArray *viewControllerArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 4; i++)
        [viewControllerArray addObject:[self.viewControllers objectAtIndex:i]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[self getMoreViewController]];
    [viewControllerArray addObject:navController];
    
    return viewControllerArray;
}

-(NSArray *)getMutatedRootItems{
    NSMutableArray *rootItemArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 4; i++)
        [rootItemArray addObject:[rootItems objectAtIndex:i]];
    
    PBTabItem *item = [[PBTabItem alloc] init];
    item.selectedImageNamed = @"ico_more_hi.png";
    item.unselectedImageNamed = @"ico_more_lo.png";
    
    [rootItemArray addObject:item];
    
    return rootItemArray;
}

-(void)setupViewControllerWithIndex:(int)i andImageSize:(CGSize)imgSize{
    
    UIViewController *controller = [self.viewControllers objectAtIndex:i];
    
    UIButton *button = [self createCustomTabBarItemWithIndex:i andSize:imgSize];
    
    CGSize fontSize = [controller.tabBarItem.title sizeWithFont:[UIFont fontWithName:@"Helvetica" 
                                                                                size:10.f]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgSize.width/2-fontSize.width/2, 
                                                               40.f,
                                                               fontSize.width, 
                                                               fontSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = controller.tabBarItem.title;
    
    label.textColor = [UIColor colorWithRed:255.f/255.f 
                                      green:255.f/255.f 
                                       blue:255.f/255.f 
                                      alpha:1.0];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:10.f];
    
    [button addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:controller.tabBarItem.image];
    imageView.frame = CGRectMake((imgSize.width/2)-15.f, 10.f, 30.f, 30.f);
    
    [button addSubview:imageView];
    
    [self.view addSubview:button];
}

-(PBCustomMoreViewController *)getMoreViewController{
    NSMutableArray *viewControllerArray = [[NSMutableArray alloc] initWithCapacity:self.viewControllers.count-4];
    for (int j = 4; j < self.viewControllers.count; j++) {
        [viewControllerArray addObject:[self.viewControllers objectAtIndex:j]];
    }
    
    PBCustomMoreViewController *controller = [[PBCustomMoreViewController alloc] initWithViewController:viewControllerArray andRootItems:rootItems];
    
    PBTabItem *tabItem = [[PBTabItem alloc] init];
    tabItem.selectedImageNamed = @"ico_more_hi.png";
    tabItem.unselectedImageNamed = @"ico_more_lo.png";
    tabItem.labelText = @"More";
    
    controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:[tabItem labelText] image:[UIImage imageNamed:tabItem.unselectedImageNamed] tag:0];
    
    return controller;
}

-(UIButton *)createCustomTabBarItemWithIndex:(int)i andSize:(CGSize)imgSize{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(imgSize.width*i, self.view.bounds.size.height-imgSize.height, imgSize.width, imgSize.height);
    
    [button setBackgroundImage:[self transformImage:[UIImage imageNamed:@"tabbar_BG_hi.png"] andSize:imgSize] 
                      forState:UIControlStateSelected];
    [button setBackgroundImage:[self transformImage:[UIImage imageNamed:@"tabbar_BG_lo.png"] andSize:imgSize] 
                      forState:UIControlStateNormal];
    
    [button setTag:i];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

-(UIImage *)transformImage:(UIImage *)image andSize:(CGSize)imgSize{
    
    UIGraphicsBeginImageContext(imgSize);
    [image drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - TabBar actions

-(void)buttonClicked:(id)sender{
    int tag = [sender tag];
    [self selectIndex:tag];
}

-(void)selectIndex:(int)index{
    
    
    
    for (UIButton *button in self.view.subviews) {
        if ([button isMemberOfClass:[UIButton class]] && [button tag] != index) { //unselected
            [button setSelected:NO];
            
            for (UIImageView *imageView in button.subviews) {
                if ([imageView isMemberOfClass:[UIImageView class]]) {
                    PBTabItem *item = [rootItems objectAtIndex:[button tag]];
                    imageView.image = [UIImage imageNamed:item.unselectedImageNamed];
                }
            }
            
            
        } else if ([button isMemberOfClass:[UIButton class]] && [button tag] == index) { //selected
            [button setSelected:YES];
            
            for (UIImageView *imageView in button.subviews) {
                if ([imageView isMemberOfClass:[UIImageView class]]) {
                    
                    PBTabItem *item = [rootItems objectAtIndex:[button tag]];
                    imageView.image = [UIImage imageNamed:item.selectedImageNamed];
                }
            }
            
        }


    if (self.selectedIndex == index && selected != index) {
        if ([[self.viewControllers objectAtIndex:index] respondsToSelector:@selector(popToRootViewControllerAnimated:)]) {
            [[self.viewControllers objectAtIndex:index] popToRootViewControllerAnimated:YES];
        }
    }
    
    self.selectedIndex = index;

    }
}

#pragma mark - InterfaceOrientationChanging

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    selected = self.selectedIndex;
    [self hideTabBar];
    [self releaseNewTabBar]; //remove from superview
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (hidden) {
        rotationPending = YES;
    } else{
        [self setupTabItems];
        [self selectIndex:selected];
        selected = 500; //prevent snapping back to new view
    }
}



@end
