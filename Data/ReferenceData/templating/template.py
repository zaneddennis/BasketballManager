import os
import pandas as pd


def create_template(df, manual_cols=[]) -> pd.DataFrame:
    df.columns = [c + "_Original" for c in df.columns]

    for c in manual_cols:
        df[c] = ""

    return df


def create_all():
    conferences = create_template(
        pd.read_csv("Data/Preprocessed/conferences.txt"),
        ["ID", "Name", "ShortName", "Prestige"]
    )
    conferences.to_csv("Data/ManualTemplates/conferences.csv", index=False)

    schools = create_template(
        pd.read_csv("Data/Preprocessed/schools.csv"),
        ["ID", "FullName", "ShortName", "Mascot", "Location", "Conference", "PrestigeHistoric", "PrestigeCurrent"]
    )
    schools.to_csv("Data/ManualTemplates/schools.csv", index=False)

    # just copy so I can make manual additions/edits directly
    os.system(r"copy .\Data\Preprocessed\locations.csv .\Data\ManualTemplates\locations.csv")
