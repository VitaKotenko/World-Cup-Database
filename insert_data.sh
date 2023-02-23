#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while  IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  #get team_id from winner
  if [[ $WINNER != 'winner' ]]
  then  
    TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $TEAM_ID ]]
    then
    #insert team
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
      echo $TEAM_ID
      fi
    #get new team_id
    TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")
    fi
  fi

  #get team_id from opponent
  if [[ $OPPONENT != 'opponent' ]]
  then  
    TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $TEAM_ID ]]
    then
    #insert team
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
      echo $TEAM_ID
      fi
    #get new team_id
    TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
    fi
  fi

  WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

  if [[ $YEAR != 'year' ]]
  then 
    #insert team
    INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
                        VALUES( $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
      echo $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done
