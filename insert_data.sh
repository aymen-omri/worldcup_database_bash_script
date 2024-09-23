#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

CLEAR=$($PSQL "TRUNCATE teams , games")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $year != year ]]
then
winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
if [[ -z $winner_id ]]
then
insert_winner=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
echo $insert_winner
fi
opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
if [[ -z $opponent_id ]]
then
insert_opponent=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
echo $insert_opponent
fi
fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $year != year ]]
then
winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")

if [[ -n $winner_id && -n $opponent_id ]]
then
insert_games=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES ($year,'$round',$winner_id,$opponent_id,$winner_goals,$opponent_goals)")
echo insert_games
fi

fi
done
