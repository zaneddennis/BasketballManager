import sys

import numpy as np
import pandas as pd
import sqlite3

from sklearn.preprocessing import OneHotEncoder
from sklearn.linear_model import LinearRegression


if __name__ == "__main__":

    args = sys.argv
    print("Args:", args)
    #slot = "end_reg_season_test_8"
    #year = 2025
    slot = args[1]
    year = int(args[2])

    conn = sqlite3.connect(f"/C:/Users/zaned/AppData/Roaming/Godot/app_userdata/BasketballManager/save_data/{slot}/database.db")

    df_games = pd.read_sql(
        f"""
        SELECT ID, Home, Away, HomeScore, AwayScore,
	    HomeScore - AwayScore AS Diff

        FROM Games
        WHERE Timestamp >= '{year}-0-0-0' AND HomeScore NOT NULL
        """,
        conn,
        index_col="ID"
    )

    ohe = OneHotEncoder()
    home_ohe = ohe.fit_transform(df_games[["Home"]].values).toarray()
    away_ohe = ohe.transform(df_games[["Away"]].values).toarray()

    df_home = pd.DataFrame(home_ohe, columns=ohe.categories_)
    df_away = pd.DataFrame(away_ohe, columns=ohe.categories_)
    df = df_home - df_away
    df.columns = df.columns.get_level_values(0)
    df.index = df_games.index
    df["Result"] = df_games["Diff"]

    X = df.drop(columns=["Result"])
    y = df.Result

    linreg = LinearRegression()
    linreg.fit(X, y)

    df_ratings = pd.DataFrame(linreg.coef_, index=X.columns, columns=["Rating"]).sort_values(by="Rating", ascending=False)
    df_ratings.index.name = "ID"
    print(df_ratings)

    df_ratings.to_sql(f"team_ratings_{year}", conn, if_exists="replace")
