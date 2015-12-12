#import <Foundation/Foundation.h>

@interface ELOPlayer : NSObject

@property NSString* name;

@property int place;
@property int eloPre;
@property int eloPost;
@property int eloChange;
    
@end

@interface ELOMatch : NSObject {
    NSMutableArray<ELOPlayer*>* players;
}

- (id)init;
- (void)addPlayer:(NSString*)name position:(int)place elo:(int)elo;
- (int)getELO:(NSString*)name;
- (int)getELOChange:(NSString*)name;
- (void)calculateELOs;


@end
