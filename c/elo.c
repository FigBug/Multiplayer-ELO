#include "elo.h"

#include <string.h>
#include <stdlib.h>
#include <math.h>

ELOMatch* elo_createMatch(int maxPlayers)
{
    ELOMatch* match = malloc(sizeof(ELOMatch));
    memset(match, 0, sizeof(*match));
    
    match->players = malloc(maxPlayers * sizeof(ELOPlayer));
    memset(match->players, 0, maxPlayers * sizeof(ELOPlayer));
    
    match->maxPlayers = maxPlayers;
    
    return match;
}

void elo_destroyMatch(ELOMatch* match)
{
    for (int i = 0; i < match->curPlayers; i++)
        free(match->players[i].name);
    
    free(match->players);
    free(match);
}

void elo_addPlayer(ELOMatch* match, const char* name, int place, int elo)
{
    if (match->curPlayers < match->maxPlayers)
    {
        ELOPlayer* player = &match->players[match->curPlayers];
        
        player->name    = malloc(strlen(name) + 1);
        strcpy(player->name, name);
        
        player->place   = place;
        player->eloPre  = elo;
        
        match->curPlayers++;
    }
}

int elo_getELO(ELOMatch* match, const char* name)
{
    for (int i = 0; i < match->curPlayers; i++)
    {
        if (!strcmp(match->players[i].name, name))
            return match->players[i].eloPost;
    }
    return 1500;
}

int elo_getELOChange(ELOMatch* match, const char* name)
{
    for (int i = 0; i < match->curPlayers; i++)
    {
        if (!strcmp(match->players[i].name, name))
            return match->players[i].eloChange;
    }
    return 0;
}

void elo_calculateELOs(ELOMatch* match)
{
    int n = match->curPlayers;
    float K = 32 / (float)(n - 1);
    
    for (int i = 0; i < n; i++)
    {
        int curPlace = match->players[i].place;
        int curELO   = match->players[i].eloPre;
        
        for (int j = 0; j < n; j++)
        {
            if (i != j)
            {
                int opponentPlace = match->players[j].place;
                int opponentELO   = match->players[j].eloPre;
                
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
                match->players[i].eloChange += round(K * (S - EA));
            }
        }
        //add accumulated change to initial ELO for final ELO
        match->players[i].eloPost = match->players[i].eloPre + match->players[i].eloChange;
    }
}
