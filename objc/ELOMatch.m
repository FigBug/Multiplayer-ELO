#import "ELOMatch.h"

@implementation ELOPlayer

@synthesize name;
@synthesize eloPre;
@synthesize eloPost;
@synthesize eloChange;

@end

@implementation ELOMatch

- (id)init
{
    if (self = [super init])
    {
        players = [NSMutableArray array];
    }
    return self;
}

- (void)addPlayer:(NSString*)name position:(int)place elo:(int)elo
{
    ELOPlayer* player = [[ELOPlayer alloc] init];
    
    player.name    = name;
    player.place   = place;
    player.eloPre  = elo;
    
    [players addObject:player];
}

- (int)getELO:(NSString*)name
{
    for (ELOPlayer* p in players)
    {
        if ([p.name isEqual: name])
            return p.eloPost;
    }
    return 1500;
}

- (int)getELOChange:(NSString*)name
{
    for (ELOPlayer* p in players)
    {
        if ([p.name isEqual: name])
            return p.eloChange;
    }
    return 0;
}

- (void)calculateELOs
{
    int n = (int)players.count;
    float K = 32 / (float)(n - 1);
    
    for (int i = 0; i < n; i++)
    {
        int curPlace = players[i].place;
        int curELO   = players[i].eloPre;
        
        for (int j = 0; j < n; j++)
        {
            if (i != j)
            {
                int opponentPlace = players[j].place;
                int opponentELO   = players[j].eloPre;
                
                //work out S
                float S;
                if (curPlace < opponentPlace)
                    S = 1;
                else if (curPlace == opponentPlace)
                    S = 0.5;
                else
                    S = 0;
                
                //work out EA
                float EA = 1 / (1.0f + pow(10.0f, (opponentELO - curELO) / 400.0f));
                
                //calculate ELO change vs this one opponent, add it to our change bucket
                //I currently round at this point, this keeps rounding changes symetrical between EA and EB, but changes K more than it should
                players[i].eloChange += round(K * (S - EA));
            }
        }
        //add accumulated change to initial ELO for final ELO
        players[i].eloPost = players[i].eloPre + players[i].eloChange;
    }
}

@end
