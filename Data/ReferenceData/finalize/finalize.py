import pandas as pd


def finalize_all():
    conferences = pd.read_csv("Data/ManualTemplates/conferences.csv")
    conferences = conferences.drop(columns=[c for c in conferences.columns if "_Original" in c])
    conferences = conferences.loc[conferences.ID.notna()]
    conferences.to_csv("Data/SSA/conferences.csv", index=False)

    schools = pd.read_csv("Data/ManualTemplates/schools.csv")
    schools = schools.drop(columns=[c for c in schools.columns if "_Original" in c])
    schools = schools.loc[schools.ID.notna()]
    schools.to_csv("Data/SSA/schools.csv", index=False)

    locations = pd.read_csv("Data/ManualTemplates/locations.csv")
    locations.to_csv("Data/SSA/locations.csv", index=False)
