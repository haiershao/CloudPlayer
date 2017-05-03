/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

@interface UIImageView (AVSPictureCache)



/**
 * Get the current image URL.
 *
 * Note that because of the limitations of categories this property can get out of sync
 * if you use sd_YaMaXun_setImage: directly.
 */
//- (NSURL *)sd_YaMaXun_imageURL;
//
///**
// * Set the imageView `image` with an `url`.
// *
// * The download is asynchronous and cached.
// *
// * @param url The url for the image.
// */
//- (void)sd_YaMaXun_setImageWithCid:(NSString*)cid Eid:(NSString*)eid;
//
///**
// * Set the imageView `image` with an `url` and a placeholder.
// *
// * The download is asynchronous and cached.
// *
// * @param url         The url for the image.
// * @param placeholder The image to be set initially, until the image request finishes.
// * @see sd_YaMaXun_setImageWithURL:placeholderImage:options:
// */
//- (void)sd_YaMaXun_setImageWithCid:(NSString*)cid Eid:(NSString*)eid placeholderImage:(UIImage *)placeholder;
//
///**
// * Set the imageView `image` with an `url`, placeholder and custom options.
// *
// * The download is asynchronous and cached.
// *
// * @param url         The url for the image.
// * @param placeholder The image to be set initially, until the image request finishes.
// * @param options     The options to use when downloading the image. @see SDWebImageOptions for the possible values.
// */
//- (void)sd_YaMaXun_setImageWithCid:(NSString*)cid Eid:(NSString*)eid placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
//
///**
// * Set the imageView `image` with an `url`.
// *
// * The download is asynchronous and cached.
// *
// * @param url            The url for the image.
// * @param completedBlock A block called when operation has been completed. This block has no return value
// *                       and takes the requested UIImage as first parameter. In case of error the image parameter
// *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
// *                       indicating if the image was retrived from the local cache or from the network.
// *                       The fourth parameter is the original image url.
// */
//- (void)sd_YaMaXun_setImageWithCid:(NSString*)cid Eid:(NSString*)eid completed:(SDWebImageCompletionBlock)completedBlock;
//
///**
// * Set the imageView `image` with an `url`, placeholder.
// *
// * The download is asynchronous and cached.
// *
// * @param url            The url for the image.
// * @param placeholder    The image to be set initially, until the image request finishes.
// * @param completedBlock A block called when operation has been completed. This block has no return value
// *                       and takes the requested UIImage as first parameter. In case of error the image parameter
// *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
// *                       indicating if the image was retrived from the local cache or from the network.
// *                       The fourth parameter is the original image url.
// */
//- (void)sd_YaMaXun_setImageWithCid:(NSString*)cid Eid:(NSString*)eid placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
//
///**
// * Set the imageView `image` with an `url`, placeholder and custom options.
// *
// * The download is asynchronous and cached.
// *
// * @param url            The url for the image.
// * @param placeholder    The image to be set initially, until the image request finishes.
// * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
// * @param completedBlock A block called when operation has been completed. This block has no return value
// *                       and takes the requested UIImage as first parameter. In case of error the image parameter
// *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
// *                       indicating if the image was retrived from the local cache or from the network.
// *                       The fourth parameter is the original image url.
// */
//- (void)sd_YaMaXun_setImageWithCid:(NSString*)cid Eid:(NSString*)eid placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
//
///**
// * Set the imageView `image` with an `url`, placeholder and custom options.
// *
// * The download is asynchronous and cached.
// *
// * @param url            The url for the image.
// * @param placeholder    The image to be set initially, until the image request finishes.
// * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
// * @param progressBlock  A block called while image is downloading
// * @param completedBlock A block called when operation has been completed. This block has no return value
// *                       and takes the requested UIImage as first parameter. In case of error the image parameter
// *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
// *                       indicating if the image was retrived from the local cache or from the network.
// *                       The fourth parameter is the original image url.
// */
//- (void)sd_YaMaXun_setImageWithCid:(NSString*)cid Eid:(NSString*)eid placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
//
///**
// * Cancel the current download
// */
- (void)sd_AVSPictureCache_cancelCurrentImageLoad;



@end
