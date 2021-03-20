//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//   Copyright Samurai development team and other contributors
//
//   http://www.samurai-framework.com
//
//   Permission is hereby granted, free of charge, to any person obtaining a copy
//   of this software and associated documentation files (the "Software"), to deal
//   in the Software without restriction, including without limitation the rights
//   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//   copies of the Software, and to permit persons to whom the Software is
//   furnished to do so, subject to the following conditions:
//
//   The above copyright notice and this permission notice shall be included in
//   all copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//   THE SOFTWARE.
//

#import "IDEAAppletServiceRootController.h"
#import "ServiceMonitorStatusBar.h"

#import "ServiceMonitorCPUModel.h"
#import "ServiceMonitorMemoryModel.h"
#import "ServiceMonitorNetworkModel.h"
#import "ServiceMonitorFPSModel.h"

#import "JBChartView.h"
#import "JBBarChartView.h"
#import "JBLineChartView.h"

#pragma mark -

static const CGFloat             kBarHeight              = 20.0f;

@interface ServiceMonitorStatusBar(Private)<JBLineChartViewDataSource, JBLineChartViewDelegate>
@end

#pragma mark -

@implementation ServiceMonitorStatusBar
{
   BOOL                      _inited;
   UILabel                 * _label;
   JBLineChartView         * _chart1;     // cpu
   JBLineChartView         * _chart2;     // fps
   ServiceMonitorCPUModel  * _cpuModel;
   ServiceMonitorFPSModel  * _fpsModel;
}

- (id)init
{
   CGRect stBarFrame;
   stBarFrame.origin.x    = 0.0f;
   stBarFrame.origin.y    = [UIScreen mainScreen].bounds.size.height - kBarHeight;
   stBarFrame.size.width  = [UIScreen mainScreen].bounds.size.width;
   stBarFrame.size.height = kBarHeight;
      
   if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]])
   {
      UITabBarController   *stTabBarController  = [UIApplication sharedApplication].delegate.window.rootViewController;
      
      stBarFrame.origin.y    = [UIScreen mainScreen].bounds.size.height - stTabBarController.tabBar.frame.size.height - kBarHeight;

   } /* End if () */
   
   self = [super initWithFrame:stBarFrame];
   if ( self )
   {
      self.hidden             = YES;
      self.backgroundColor    = [UIColor clearColor]; // [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:0.5f];
      self.windowLevel        = UIWindowLevelStatusBar + 5.0f;
      self.rootViewController = [[ServiceRootController alloc] init];
      
      _cpuModel = [ServiceMonitorCPUModel sharedInstance];
      _fpsModel = [ServiceMonitorFPSModel sharedInstance];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc
{
   [_label removeFromSuperview];
   _label = nil;
   
   [_chart1 removeFromSuperview];
   _chart1 = nil;

   [_chart2 removeFromSuperview];
   _chart2 = nil;
}

- (void)setFrame:(CGRect)aFrame
{
   CGRect stBarFrame;
   stBarFrame.origin.x     = 0.0f;
   stBarFrame.origin.y     = [UIScreen mainScreen].bounds.size.height - kBarHeight;
   stBarFrame.size.width   = [UIScreen mainScreen].bounds.size.width;
   stBarFrame.size.height  = kBarHeight;

   if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]])
   {
      UITabBarController   *stTabBarController  = [UIApplication sharedApplication].delegate.window.rootViewController;
      
      stBarFrame.origin.y    = [UIScreen mainScreen].bounds.size.height - stTabBarController.tabBar.frame.size.height - kBarHeight;

   } /* End if () */

   [super setFrame:stBarFrame];
}

- (void)update
{
   if ( NO == self.hidden )
   {
      [_chart1 reloadData];
      [_chart2 reloadData];

      _label.text = [NSString stringWithFormat:@"CPU:% .2f%%   FPS:%lu", _cpuModel.percent * 100.0f, (unsigned long)_fpsModel.fps];
   }
}

- (void)show
{
   if ( NO == _inited )
   {
      _chart1  = [[JBLineChartView alloc] initWithFrame:CGRectInset(self.bounds, -5.0f, -1.0f)];
      _chart1.delegate  = self;
      _chart1.dataSource= self;
      _chart1.alpha     = 0.95f;
      [self addSubview:_chart1];

      _chart2  = [[JBLineChartView alloc] initWithFrame:CGRectInset(self.bounds, -5.0f, -1.0f)];
      _chart2.delegate  = self;
      _chart2.dataSource= self;
      _chart2.alpha     = 0.95f;
      [self addSubview:_chart2];

      _label = [[UILabel alloc] initWithFrame:self.bounds];
      _label.backgroundColor     = [UIColor clearColor];
      _label.textColor           = [UIColor blackColor];
      _label.backgroundColor     = [UIColor clearColor];

//      _label.font                = [UIFont systemFontOfSize:12.0f];
      
      if (@available(iOS 13, *)) {
         
         _label.font             = [UIFont monospacedSystemFontOfSize:12.0f weight:UIFontWeightSemibold];

      } /* End if () */
      else {
         
//         _label.font             = [UIFont fontWithName:@"Menlo-Bold" size:12.0f];
         _label.font             = [UIFont fontWithName:@"Menlo" size:12.0f];

      } /* End else */

      _label.baselineAdjustment  = UIBaselineAdjustmentAlignCenters;
      _label.textAlignment       = NSTextAlignmentCenter;
      _label.lineBreakMode       = NSLineBreakByClipping;

      _label.layer.shadowColor   = [[UIColor whiteColor] CGColor];
      _label.layer.shadowOpacity = 1.0f;
      _label.layer.shadowRadius  = 1.0f;
      _label.layer.shadowOffset  = CGSizeMake(0.f, 0.0f);
      [self addSubview:_label];
      
      _inited = YES;
   }
   
   [self update];
   
   self.hidden = NO;
}

- (void)hide
{
   self.hidden = YES;
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
   return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
   if ( _chart1 == lineChartView )
   {
      return _cpuModel.history.count;
   }
   else if ( _chart2 == lineChartView )
   {
      return _fpsModel.history.count;
   }
   
   return 0;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
   return NO;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
   return YES;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
   if ( _chart1 == lineChartView )
   {
      return [[_cpuModel.history objectAtIndex:horizontalIndex] floatValue];
   }
   else if ( _chart2 == lineChartView )
   {
      return [[_fpsModel.history objectAtIndex:horizontalIndex] floatValue];
   }
   
   return 0;
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
   if ( _chart1 == lineChartView )
   {
      return [HEX_RGB(0xff002d) colorWithAlphaComponent:1.0f];
   }
   else if ( _chart2 == lineChartView )
   {
      return [HEX_RGB(0x00a651) colorWithAlphaComponent:1.0f];
   }
   
   return [UIColor grayColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
   return [[self lineChartView:lineChartView colorForLineAtLineIndex:lineIndex] colorWithAlphaComponent:0.2f];
//   return [UIColor clearColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
   return [UIColor whiteColor];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
   return 1.0f;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
   return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
   return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
   return [[self lineChartView:lineChartView selectionColorForLineAtLineIndex:lineIndex] colorWithAlphaComponent:0.9f];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
   return [UIColor lightGrayColor];
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
   return JBLineChartViewLineStyleSolid;
}

@end
