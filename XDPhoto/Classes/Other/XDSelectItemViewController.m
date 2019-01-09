//
//  XDSelectItemViewController.m
//  JSONModel
//
//  Created by XiaoDev on 2019/1/3.
//

#import "XDSelectItemViewController.h"
#import "NSString+XDPhoto.h"
@interface XDSelectItemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *mainTableView;
@end

@implementation XDSelectItemViewController
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height) style:UITableViewStylePlain];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selectcellid"];
    }
    return _mainTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectcellid" forIndexPath:indexPath];
    if (self.itemsArray.count > indexPath.row) {
        NSString *istr = self.itemsArray[indexPath.row];
        cell.textLabel.text = XDLocalizedString(istr, nil);
    }
    else
    {
        cell.textLabel.text = nil;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectedComplete) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSString *str = self.itemsArray[indexPath.row];
            self.didSelectedComplete(indexPath.row, str);
        }];
    }
}
- (void)dealloc {
    NSLog(@"XDSelectItemViewController dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
