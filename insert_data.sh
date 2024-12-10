#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.

#TRUNCATE TABLES FOR FRESH START WHEN RUN
echo $($PSQL "TRUNCATE teams, games;")

#FIRST LETS INSERT THE TEAMS TO THE TEAMS TABLE:
#this reads the csv file, creates a loop, separates itens by comma and put on variables
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #check if this is the header
  if [[ $YEAR != 'year' ]]
  then
    #CHECK IF WINER HAS ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      #IF NOT ADD TEAM
      INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo "Inserted into teams $WINNER"
      fi
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #CHECK IF OPPONENT HAS ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      #IF NOT ADD TEAM
      INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams $OPPONENT"
      fi
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #NOW LETS INSERT GAMES
    INSERT_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo "Inserted into games $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
      fi
    #echo "$($PSQL "SELECT * FROM games;")"

  fi
done

#echo "$($PSQL "")"