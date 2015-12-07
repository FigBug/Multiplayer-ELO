<?php

class ELOPlayer
{
  public $name      = "";
  public $place     = 0;
  public $eloPre    = 0;
  public $eloPost   = 0;
  public $eloChange = 0;
}

class ELOMatch
{
  private $players = array();

  public function addPlayer($name, $place, $elo)
  {
    $player = new ELOPlayer();

    $player->name    = $name;
    $player->place   = $place;
    $player->eloPre  = $elo;

    $this->players[] = $player;
  }

  public function getELO($name)
  {
    foreach ($this->players as $p)
    {
      if ($p->name == $name)
        return $p->eloPost;
    }
    return 1500;
  }

  public function calculateELOs()
  {
    $n = count($this->players);
    $K = 32 / ($n - 1);

    for ($i = 0; $i < $n; $i++)
    {
      $curPlace = $this->players[$i]->place;
      $curELO   = $this->players[$i]->eloPre;

      for ($j = 0; $j < $n; $j++)
      {
        if ($i != $j)
        {
          $opponentPlace = $this->players[$j]->place;
          $opponentELO   = $this->players[$j]->eloPre;

          //work out S
          if ($curPlace < $opponentPlace)
            $S = 1;
          else if   ($curPlace == $opponentPlace)
            $S = 0.5;
          else
            $S = 0;

          //work out EA
          $EA = 1 / (1 + pow(10, ($opponentELO - $curELO) / 400));

          //calculate ELO change vs this one opponent, add it to our change bucket  
          //I currently round at this point, this keeps rounding changes symetrical between EA and EB, but changes K more than it should
          $this->players[$i]->eloChange += round($K * ($S - $EA));
        }
      }
      //add accumulated change to initial ELO for final ELO   
      $this->players[$i]->eloPost = $this->players[$i]->eloPre + $this->players[$i]->eloChange;
    }
  }
}

?>