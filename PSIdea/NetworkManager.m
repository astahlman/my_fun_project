//
//  NetworkManager.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//  This class is based off of the iOS Developer Library Networking example
//  class Networking/NetworkManager. It is adapted for use with ARC.
//  This implementation eliminates the a separate thread for the network run 
//  loop, as Grand Central Dispatch now runs the operations in the NSOperationQueue
//  on separate threads as necessary.
//
//

#import "NetworkManager.h"
#import "NSOperationWithState.h"

@interface NetworkManager ()

// private properties

@property (nonatomic, retain, readonly) NSThread* networkRunLoopThread;

@property (nonatomic, retain, readonly) NSOperationQueue* networkTransferQueue;
@property (nonatomic, retain, readonly) NSOperationQueue* networkManagementQueue;
@property (nonatomic, retain, readonly) NSOperationQueue* CPUqueue;

@end

@implementation NetworkManager

@synthesize networkRunLoopThread = _networkRunLoopThread;

@synthesize networkTransferQueue = _networkTransferQueue;
@synthesize networkManagementQueue = _networkManagementQueue;
@synthesize CPUqueue = _CPUqueue;

- (id)init
{
    // any thread can call init, but serialised by +sharedManager
    self = [super init];
    if (self != nil) {
        
        // We don't limit network management queue because its operations aren't resource intensive
        self->_networkManagementQueue = [[NSOperationQueue alloc] init];
        assert(self->_networkManagementQueue != nil);
        [self->_networkManagementQueue setMaxConcurrentOperationCount:NSIntegerMax];
        assert(self->_networkManagementQueue != nil);
        
        // Limit network transfer queue to 4 simultaneous network requests.
        self->_networkTransferQueue = [[NSOperationQueue alloc] init];
        assert(self->_networkTransferQueue != nil);
        [self->_networkTransferQueue setMaxConcurrentOperationCount:4];
        assert(self->_networkTransferQueue != nil);
        
        // Leave the max number of current operations as the default - currently 1
        self->_CPUqueue = [[NSOperationQueue alloc] init];
        assert(self->_CPUqueue != nil);
        
        // create the mappings for the running operations
        self->_runningOperationToTargetMap = [[NSMutableDictionary alloc] init];
        assert(self->_runningOperationToTargetMap != NULL);
        self->_runningOperationToActionMap = [[NSMutableDictionary alloc] init];
        assert(self->_runningOperationToActionMap != NULL);
        self->_runningOperationToThreadMap = [[NSMutableDictionary alloc] init];
        assert(self->_runningOperationToThreadMap != NULL);
    }
    
    return self;
}

// returns a url request with the user-agent supplied
- (NSMutableURLRequest*)requestToGetURL:(NSURL *)url
{
    NSMutableURLRequest* result;
    static NSString* userAgentString;
    
    assert(url != nil);
    
    // Create the request.
    result = [NSMutableURLRequest requestWithURL:url];
    assert(result != nil);
    
    // Set up the user agent string.
    if (userAgentString == nil) {
        @synchronized ([self class]) {
            userAgentString = [[NSString alloc] initWithFormat:@"PSI/%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleVersionKey]];
            assert(userAgentString != nil);
        }
    }
    [result setValue:userAgentString forHTTPHeaderField:@"User-Agent"];
    
    return result;
}

-(BOOL)networkInUse
{
    assert([NSThread isMainThread]);
    return self->_runningNetworkTransferCount != 0;
}

- (void)incrementRunningNetworkTransferCount
{
    BOOL movingToInUse;
    
    assert([NSThread isMainThread]);
    
    movingToInUse = (self->_runningNetworkTransferCount == 0);
    if (movingToInUse) {
        [self willChangeValueForKey:@"networkInUse"];
    }
    self->_runningNetworkTransferCount += 1;
    if (movingToInUse) {
        [self didChangeValueForKey:@"networkInUse"];
    }
}

- (void)decrementRunningNetworkTransferCount
{
    BOOL movingToNotInUse;
    
    assert([NSThread isMainThread]);
    
    assert(self->_runningNetworkTransferCount != 0);
    movingToNotInUse = (self->_runningNetworkTransferCount == 1);
    if (movingToNotInUse) {
        [self willChangeValueForKey:@"networkInUse"];
    }
    self->_runningNetworkTransferCount -= 1;
    if (movingToNotInUse) {
        [self didChangeValueForKey:@"networkInUse"];
    }
}

// Add an operation to a queue.
- (void)addOperation:(NSOperationWithState*)operation toQueue:(NSOperationQueue *)queue finishedTarget:(id)target action:(SEL)action
{
    // any thread
    assert(operation != nil);
    assert(target != nil);
    assert(action != nil);
    
    // Update our networkInUse property; because we can be running on any thread, we 
    // do this update on the main thread.
    if (queue == _networkTransferQueue) {
        [self performSelectorOnMainThread:@selector(incrementRunningNetworkTransferCount) withObject:nil waitUntilDone:NO];
    }
    
    // Atomically enter the operation into our target and action maps.
    
    @synchronized (self) {
        assert( [_runningOperationToTargetMap count] == [_runningOperationToActionMap count] );
        assert( [_runningOperationToTargetMap count] == [_runningOperationToThreadMap count] );

        // the operation shouldn't already be mapped
        assert( [_runningOperationToTargetMap objectForKey:operation] == NULL );              
        assert( [_runningOperationToActionMap objectForKey:operation] == NULL );
        assert( [_runningOperationToThreadMap objectForKey:operation] == NULL );   
        
        
        // add operation to mappings
        [_runningOperationToTargetMap setObject:target forKey:[operation operationID]];
        [_runningOperationToActionMap setObject:NSStringFromSelector(action) forKey:[operation operationID]];
        [_runningOperationToThreadMap setObject:[NSThread currentThread] forKey:[operation operationID]];
        assert( [_runningOperationToTargetMap count] == [_runningOperationToActionMap count] );
        assert( [_runningOperationToTargetMap count] == [_runningOperationToThreadMap count] );

    }
    
    // Pass queue as the context so we know which queue the operation came from
    [operation addObserver:self forKeyPath:@"isFinished" options:0 context:(__bridge void *)queue];
    
    // Queue the operation. When the operation isFinished, -operationDone: is called.
    [queue addOperation:operation];
}

- (void)addNetworkManagementOperation:(NSOperation *)operation finishedTarget:(id)target action:(SEL)action
{
    [self addOperation:operation toQueue:_networkManagementQueue finishedTarget:target action:action];
}

- (void)addNetworkTransferOperation:(NSOperation *)operation finishedTarget:(id)target action:(SEL)action
{
    [self addOperation:operation toQueue:_networkTransferQueue finishedTarget:target action:action];
}

- (void)addCPUOperation:(NSOperation *)operation finishedTarget:(id)target action:(SEL)action
{
    [self addOperation:operation toQueue:_CPUqueue finishedTarget:target action:action];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqual:@"isFinished"] ) {
        NSOperationWithState* operation;
        NSOperationQueue* queue;
        NSThread* thread;
        
        operation = (NSOperationWithState*) object;
        assert([operation isKindOfClass:[NSOperation class]]);
        assert([operation isFinished]);
        
        // +1 for retain count
        queue = (__bridge_transfer NSOperationQueue*) context;
        assert([queue isKindOfClass:[NSOperationQueue class]]);
        
        [operation removeObserver:self forKeyPath:@"isFinished"];
        
        @synchronized (self) {
            assert( [_runningOperationToTargetMap count] == [_runningOperationToActionMap count] );
            assert( [_runningOperationToTargetMap count] == [_runningOperationToThreadMap count] );
            
            thread = (NSThread*) [_runningOperationToThreadMap objectForKey:[operation operationID]];
        }
        
        if (thread != nil) {
            [self performSelector:@selector(operationDone:) onThread:thread withObject:operation waitUntilDone:NO];
            
            if (queue == _networkTransferQueue) {
                [self performSelectorOnMainThread:@selector(decrementRunningNetworkTransferCount) withObject:nil waitUntilDone:NO];
            }
        }
        
    } 
}

// Called by the operation queue when the operation is done. We find the corresponding 
// target/action and call it on this thread.
- (void)operationDone:(NSOperationWithState *)operation
{
    id target;
    SEL action;
    NSThread*  thread;
    
    assert(operation != nil);
    
    @synchronized (self) {
        assert( [_runningOperationToTargetMap count] == [_runningOperationToActionMap count] );
        assert( [_runningOperationToTargetMap count] == [_runningOperationToThreadMap count] );
        
        target = (id) [_runningOperationToTargetMap objectForKey:[operation operationID]];
        action = NSSelectorFromString([_runningOperationToActionMap objectForKey:[operation operationID]]);
        thread = (NSThread*) [_runningOperationToThreadMap objectForKey:[operation operationID]];
        
        assert( (target != nil) == (action != nil) );
        assert( (target != nil) == (thread != nil) );
        
        // We need to test target for nil because -cancelOperation: 
        // might have won the race to pull it out.
        if (target != nil) {
            assert( thread == [NSThread currentThread] );
            
            [_runningOperationToTargetMap removeObjectForKey:[operation operationID]];
            [_runningOperationToActionMap removeObjectForKey:[operation operationID]];
            [_runningOperationToThreadMap removeObjectForKey:[operation operationID]];
        }
        assert( [_runningOperationToTargetMap count] == [_runningOperationToActionMap count] );
        assert( [_runningOperationToTargetMap count] == [_runningOperationToThreadMap count] );
    }
    
    // note: there is no race condition because the map is guaranteed
    // not to contain the operation after the synchronized block, so
    // cancelOperation: can't be called now
    if (target != nil) {
        // operation could have been cancelled without removing the mapping yet
        if ( ! [operation isCancelled] ) {
            [target performSelector:action withObject:operation];
        }
    }
}

// Sets the operations status to cancelled and removes it from the mappings 
- (void)cancelOperation:(NSOperation *)operation
{
    id target;
    SEL action;
    NSThread* thread;
    
    if (operation != nil) {

        [operation cancel];
        
        // Remove the operation from the mappings
        @synchronized (self) {
            assert( [_runningOperationToTargetMap count] == [_runningOperationToActionMap count] );
            assert( [_runningOperationToTargetMap count] == [_runningOperationToThreadMap count] );
            
            target = (id) [_runningOperationToTargetMap objectForKey:operation];
            action = NSSelectorFromString([_runningOperationToActionMap objectForKey:operation]);
            thread = (NSThread*) [_runningOperationToThreadMap objectForKey:operation];
            assert( (target != nil) == (action != nil) );
            assert( (target != nil) == (thread != nil) );
            
            // We need to test for target for nil because -operationDone: 
            // might have won the race to pull it out.
            if (target != nil) {
                [_runningOperationToTargetMap removeObjectForKey:operation];
                [_runningOperationToActionMap removeObjectForKey:operation];
                [_runningOperationToThreadMap removeObjectForKey:operation];
            }
            assert( [_runningOperationToTargetMap count] == [_runningOperationToActionMap count] );
            assert( [_runningOperationToTargetMap count] == [_runningOperationToThreadMap count] );
        }
    }
}


@end
