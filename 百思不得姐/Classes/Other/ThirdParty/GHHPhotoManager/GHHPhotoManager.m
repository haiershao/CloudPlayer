//
//  GHHPhotoManager.m
//  videoDemo
//
//  Created by 高瑞浩 on 2017/3/9.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHPhotoManager.h"
#import "GHHImageItem.h"

@interface GHHPhotoManager()<PHPhotoLibraryChangeObserver>

@property(nonatomic, strong)PHCachingImageManager *cacheManager;

@end

@implementation GHHPhotoManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        self.cacheManager = [[PHCachingImageManager alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (NSArray *)getAlbums {
    NSMutableArray *results = [NSMutableArray array];
    PHFetchOptions *smartOptions = [[PHFetchOptions alloc] init];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:smartOptions];
    [results addObjectsFromArray:[self convertCollection:smartAlbums type:PHAssetMediaTypeImage]];
    
    PHFetchResult *topLevlelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [results addObjectsFromArray:[self convertCollection:topLevlelUserCollections type:PHAssetMediaTypeImage]];
    return results;
}

- (NSArray *)getVideos {
    NSMutableArray *results = [NSMutableArray array];
    PHFetchOptions *smartOptions = [[PHFetchOptions alloc] init];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:smartOptions];
    [results addObjectsFromArray:[self convertCollection:smartAlbums type:PHAssetMediaTypeVideo]];
    return results;
}

- (NSArray *)convertCollection:(PHFetchResult *)collection type:(PHAssetMediaType)type {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < collection.count; i++) {
        PHFetchOptions *resultOptions = [[PHFetchOptions alloc] init];
        resultOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        resultOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", type];
        PHAssetCollection *c = collection[i];
        if ([c isKindOfClass:[PHAssetCollection class]]) {
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:c options:resultOptions];
            if (assetsFetchResult.count > 0) {
                GHHImageItem *item = [[GHHImageItem alloc] initWithTitle:c.localizedTitle fetchResult:assetsFetchResult];
                [array addObject:item];
            }
        }
    }
    return array;
}

- (void)getImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size completeHandler:(void (^)(UIImage *))completeHandler {
    [self.cacheManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completeHandler(result);
    }];
}

- (void)resetCachedAssets {
    
}

- (AVURLAsset *)requestVideoWithAsset:(PHAsset *)asset {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    PHVideoRequestOptions *option = [PHVideoRequestOptions new];
    __block AVAsset *resultAsset;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
        resultAsset = avasset;
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // yay, we synchronously have the asset
    return resultAsset;
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
}

@end
