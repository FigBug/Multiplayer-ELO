#ifndef elo_h
#define elo_h

typedef struct
{
    char* name;
    
    int place;
    int eloPre;
    int eloPost;
    int eloChange;
} ELOPlayer;

typedef struct
{
    int maxPlayers;
    int curPlayers;
    ELOPlayer* players;
} ELOMatch;

ELOMatch* elo_createMatch(int maxPlayers);
void elo_destroyMatch(ELOMatch* match);

void elo_addPlayer(ELOMatch* match, const char* name, int place, int elo);
int elo_getELO(ELOMatch* match, const char* name);
int elo_getELOChange(ELOMatch* match, const char* name);
void elo_calculateELOs(ELOMatch* match);

#endif
