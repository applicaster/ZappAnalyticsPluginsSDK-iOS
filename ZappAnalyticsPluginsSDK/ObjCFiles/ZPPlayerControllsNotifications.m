//
//  APPlayerControllsNotifications.m
//  ApplicasterSDK
//
//  Created by user on 31/01/2016.
//  Copyright © 2016 Applicaster. All rights reserved.
//

#import "ZPPlayerControllsNotifications.h"

//Notifications
NSString *const APPlayableItemWillStartPlaying = @"kAPPlayableItemWillStartPlaying";
NSString *const APPlayerControllerFailedNotification = @"APPlayerControllerFailedNotification";
NSString *const APPlayerControllerReachedEndNotification = @"APPlayerControllerReachedEndNotification";
NSString *const APPlayerControllerLoadStateChanged = @"APPlayerControllerLoadStateChanged";
NSString *const ZPPlayerPhaseChangedNotification = @"ZPPlayerPhaseChangedNotification";
NSString *const APPlayerControllerOverlayVisibleNotification = @"APPlayerControllerOverlayVisibleNotification";
NSString *const APPlayerControllerMarkCurrentItemForDownloadNotification = @"APPlayerControllerMarkCurrentItemForDownloadNotification";

NSString *const APPlayerControllerDeleteCurrentItemFromCacheNotification = @"APPlayerControllerDeleteCurrentItemFromCacheNotification";
NSString *const APPlayerControllerCancelCurrentItemFromDownloadNotification = @"APPlayerControllerCancelCurrentItemFromDownloadNotification";

NSString *const APPlayerControllerAddToFavorites = @"APPlayerControllerAddToFavorites";
NSString *const APPlayerControllerRemoveFromFavorites = @"APPlayerControllerRemoveFromFavorites";

NSString *const APPlayerControllerItemDidPlayToEndTimeNotification = @"APPlayerControllerItemDidPlayToEndTimeNotification";
NSString *const APPlayerControllerDidPlayNotification = @"APPlayerControllerDidPlayNotification";
NSString *const APPlayerControllerDidPauseNotification = @"APPlayerControllerDidPauseNotification";
NSString *const APPlayerControllerDidStopNotification = @"APPlayerControllerDidStopNotification";
NSString *const APPlayerControllerPlayerWasCreatedNotification = @"APPlayerControllerPlayerWasCreatedNotification";
NSString *const APPlayerControllerPlayerFinishedPlaybackNotification = @"APPlayerControllerPlayerFinishedPlaybackNotification";

// userInfo keys
NSString *const kAPPlayerControllerPlayingItemDuration        = @"kAPPlayerControlsPlayingItemDuration";
NSString *const kAPPlayerControllerPlayingItemCurrentPosition = @"kAPPlayerControlsPlayingItemCurrentPosition";
NSString *const kAPPlayerControllerPlayingItemContentUrl = @"kAPPlayerControllerPlayingItemContentUrl";
NSString *const kAPPlayerControllerPlayingItemShowName = @"kAPPlayerControllerPlayingItemShowName";
NSString *const kAPPlayerControllerPlayingItemIsFavorite = @"kAPPlayerControllerPlayingItemIsFavorite";
NSString *const kAPPlayerControllerPlayingItemIsDownloading = @"kAPPlayerControllerPlayingItemIsDownloading";
NSString *const kAPPlayerControllerPlayingItemIsDownloaded = @"kAPPlayerControllerPlayingItemIsDownloaded";
NSString *const kAPPlayerControllerPlayingItemIsDeletable = @"kAPPlayerControllerPlayingItemIsDeletable";

//Notifications - Playback state (Legacy)
NSString * const APApplicasterPlayerDidStartNotification = @"APApplicasterPlayerDidStartNotification";
NSString * const APApplicasterPlayerDidStopNotification = @"APApplicasterPlayerDidStopNotification";

//Notifications - Controls
NSString *const APApplicasterPlayerStopNotification = @"APApplicasterPlayerStopNotification";
NSString *const APApplicasterPlayerReloadNotification = @"APApplicasterPlayerReloadNotification";
NSString *const APApplicasterPlayerResumePlaybackNotification = @"APApplicasterPlayerResumePlaybackNotification";
NSString *const APApplicasterPlayerPausePlaybackNotification = @"APApplicasterPlayerPausePlaybackNotification";
NSString *const APApplicasterPlayerForwardPlaybackNotification = @"APApplicasterPlayerForwardPlaybackNotification";
NSString *const APApplicasterPlayerBackwardPlaybackNotification = @"APApplicasterPlayerBackwardPlaybackNotification";

// Notifications - playing state changed
NSString *const APPlayerControllerControlsStopButtonTappedNotification = @"APPlayerControllerStopNotification";
NSString *const APPlayerControllerControlsPlayButtonTappedNotification = @"APPlayerControllerResumeNotification";
NSString *const APPlayerControllerControlsPauseButtonTappedNotification = @"APPlayerControllerPauseNotification";

NSString *const APPlayerControllerCurrentItemKey = @"APPlayerControllerCurrentItemKey";
