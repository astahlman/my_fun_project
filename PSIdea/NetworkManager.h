//
//  NetworkManager.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
{
    NSThread* _networkRunLoopThread;
    NSOperationQueue* _networkManagementQueue;
    NSOperationQueue* _networkTransferQueue;
    NSOperationQueue* _CPUqueue;
    NSMutableDictionary* _runningOperationToTargetMap;
    NSMutableDictionary* _runningOperationToActionMap;
    NSMutableDictionary* _runningOperationToThreadMap;
    NSUInteger _runningNetworkTransferCount;
}

// returns a url request with the user-agent supplied
- (NSMutableURLRequest *)requestToGetURL:(NSURL *)url;

// observable, always changes on main thread
@property (nonatomic, assign, readonly) BOOL networkInUse; 


/* Target-action pair is called on the thread that queued the operation.
 * The network operation callbacks runs on the networkRunLoopThread, by default.
 * Adding and canceling operations can be done from any thread.
 */
- (void)addNetworkManagementOperation:(NSOperation *)operation finishedTarget:(id)target action:(SEL)action;
- (void)addNetworkTransferOperation:(NSOperation *)operation finishedTarget:(id)target action:(SEL)action;
- (void)addCPUOperation:(NSOperation *)operation finishedTarget:(id)target action:(SEL)action;
- (void)cancelOperation:(NSOperation *)operation;

@end
