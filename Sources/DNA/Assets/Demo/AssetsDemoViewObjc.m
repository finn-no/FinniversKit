#import "AssetsDemoViewObjc.h"
@import FinniversKit;

@interface AssetsDemoViewObjc (Private) <UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AssetsDemoViewObjc
UITableView *_tableView;

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
                                              ]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UIImage finniversImageNames].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    NSString *imageName = [UIImage finniversImageNames][indexPath.row];
    cell.imageView.image = [UIImage named:imageName];
    cell.textLabel.text = imageName;
    return cell;
}

@end
