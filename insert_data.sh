#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


CSV_FILE="games.csv"

# Vérifie si le fichier CSV existe
if [[ ! -f "$CSV_FILE" ]]
then
    echo "Erreur : Le fichier CSV '$CSV_FILE' n'existe pas. Veuillez le créer ou vérifier le chemin."
    exit 1
fi


tail -n +2 "$CSV_FILE" | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ -n "$WINNER" ]]
  then
    WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT(name) DO NOTHING;")
  fi

  if [[ -n "$OPPONENT" ]]
  then
    OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT(name) DO NOTHING;")
  fi

done

#year,round,winner,opponent,winner_goals,opponent_goals

tail -n +2 "$CSV_FILE" | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")


  ADD_INFO=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")


done



# INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, $ROUND, $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)
