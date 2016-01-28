import Foundation

class ELOPlayer
{
    var name: String = "";
    
    var place: Int = 0;
    var eloPre: Int = 0;
    var eloPost: Int = 0;
    var eloChange: Int = 0;
}

class ELOMatch
{
    var players = [ELOPlayer]();
    
    func addPlayer(name: String, place: Int, elo: Int)
    {
        let player = ELOPlayer();
        
        player.name    = name;
        player.place   = place;
        player.eloPre  = elo;
        
        players.append(player);
    }
    
    func getELO(name : String) -> Int
    {
        for (p) in players
        {
            if p.name == name
            {
                return p.eloPost;
            }
        }
        return 1500;
    }
    
    func getELOChange(name : String) -> Int
    {
        for (p) in players
        {
            if p.name == name
            {
                return p.eloChange;
            }
        }
        return 0;
    }
    
    func calculateELOs()
    {
        let n = players.count;
        let K = 32 / Double(n - 1);
        
        for (var i = 0; i < n; i++)
        {
            let curPlace = players[i].place;
            let curELO   = players[i].eloPre;
            
            for (var j = 0; j < n; j++)
            {
                if i != j
                {
                    let opponentPlace = players[j].place;
                    let opponentELO   = players[j].eloPre;
                    
                    //work out S
                    var S : Double;
                    if curPlace < opponentPlace
                    {
                        S = 1;
                    }
                    else if curPlace == opponentPlace
                    {
                        S = 0.5;
                    }
                    else
                    {
                        S = 0;
                    }
                    
                    //work out EA
                    let EA = 1 / (1.0 + pow(10.0, Double(opponentELO - curELO) / 400.0));
                    
                    //calculate ELO change vs this one opponent, add it to our change bucket
                    //I currently round at this point, this keeps rounding changes symetrical between EA and EB, but changes K more than it should
                    players[i].eloChange += Int(round(K * (S - EA)));
                }
            }
            //add accumulated change to initial ELO for final ELO
            players[i].eloPost = players[i].eloPre + players[i].eloChange;
        }
    }
};
