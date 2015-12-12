import java.util.*;
import java.lang.*;

class ELOPlayer
{
    public String name;
    
    public int place     = 0;
    public int eloPre    = 0;
    public int eloPost   = 0;
    public int eloChange = 0;
}

class ELOMatch
{
    private ArrayList<ELOPlayer> players = new ArrayList<ELOPlayer>();

    public void addPlayer(String name, int place, int elo)
    {
        ELOPlayer player = new ELOPlayer();
        
        player.name    = name;
        player.place   = place;
        player.eloPre  = elo;
        
        players.add(player);
    }

    public int getELO(String name)
    {
        for (ELOPlayer p : players)
        {
            if (p.name == name)
                return p.eloPost;
        }
        return 1500;
    }

    public int getELOChange(String name)
    {
        for (ELOPlayer p : players)
        {
            if (p.name == name)
                return p.eloChange;
        }
        return 0;
    }

    public void calculateELOs()
    {
        int n = players.size();
        float K = 32 / (float)(n - 1);
        
        for (int i = 0; i < n; i++)
        {
            int curPlace = players.get(i).place;
            int curELO   = players.get(i).eloPre;
            
            for (int j = 0; j < n; j++)
            {
                if (i != j)
                {
                    int opponentPlace = players.get(j).place;
                    int opponentELO   = players.get(j).eloPre;
                    
                    //work out S
                    float S;
                    if (curPlace < opponentPlace)
                        S = 1.0F;
                    else if (curPlace == opponentPlace)
                        S = 0.5F;
                    else
                        S = 0.0F;
                    
                    //work out EA
                    float EA = 1 / (1.0f + (float)Math.pow(10.0f, (opponentELO - curELO) / 400.0f));
                    
                    //calculate ELO change vs this one opponent, add it to our change bucket
                    //I currently round at this point, this keeps rounding changes symetrical between EA and EB, but changes K more than it should
                    players.get(i).eloChange += Math.round(K * (S - EA));
                }
            }
            //add accumulated change to initial ELO for final ELO   
            players.get(i).eloPost = players.get(i).eloPre + players.get(i).eloChange;
        }
    }
}