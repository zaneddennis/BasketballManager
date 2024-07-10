import pandas as pd
import string

STATE_NAME_TO_ABBR = {
    "Alabama": "AL",
    "Alaska": "AK",
    "Arizona": "AZ",
    "Arkansas": "AR",
    "California": "CA",
    "Colorado": "CO",
    "Connecticut": "CT",
    "Delaware": "DE",
    "Florida": "FL",
    "Georgia": "GA",
    "Hawaii": "HI",
    "Idaho": "ID",
    "Illinois": "IL",
    "Indiana": "IN",
    "Iowa": "IA",
    "Kansas": "KS",
    "Kentucky": "KY",
    "Louisiana": "LA",
    "Maine": "ME",
    "Maryland": "MD",
    "Massachusetts": "MA",
    "Michigan": "MI",
    "Minnesota": "MN",
    "Mississippi": "MS",
    "Missouri": "MO",
    "Montana": "MT",
    "Nebraska": "NE",
    "Nevada": "NV",
    "New Hampshire": "NH",
    "New Jersey": "NJ",
    "New Mexico": "NM",
    "New York": "NY",
    "North Carolina": "NC",
    "North Dakota": "ND",
    "Ohio": "OH",
    "Oklahoma": "OK",
    "Oregon": "OR",
    "Pennsylvania": "PA",
    "Rhode Island": "RI",
    "South Carolina": "SC",
    "South Dakota": "SD",
    "Tennessee": "TN",
    "Texas": "TX",
    "Utah": "UT",
    "Vermont": "VT",
    "Virginia": "VA",
    "Washington": "WA",
    "West Virginia": "WV",
    "Wisconsin": "WI",
    "Wyoming": "WY",
    "District of Columbia": "DC",
    "American Samoa": "AS",
    "Guam": "GU",
    "Northern Mariana Islands": "MP",
    "Puerto Rico": "PR",
    "United States Minor Outlying Islands": "UM",
    "U.S. Virgin Islands": "VI",
}


# no business logic needed here
def preprocess_conferences():
    df = pd.read_csv("Data/Raw/conferences.txt")
    return df


# no business logic needed here (yet?)
def preprocess_schools():
    df = pd.read_csv("Data/Raw/schools.csv")
    return df


def preprocess_locations():
    census = pd.read_csv("Data/Raw/locations_census.csv")
    census.columns = ["City", "State", "Population"]

    census.City = census.City.map(lambda s: " ".join(s.split()[:-1]))
    census["StateName"] = census.State
    census.State = census.State.map(lambda s: STATE_NAME_TO_ABBR[s])

    geo = pd.read_csv("Data/Raw/locations_geonames.csv")
    geo.columns = [c.capitalize() for c in geo.columns]

    df = pd.merge(census, geo, how="inner", left_on=["City", "State"], right_on=["Asciiname", "Admin1 code"])
    df = df[["City", "State", "StateName", "Population", "Latitude", "Longitude", "Timezone"]]

    # add ID column
    #df["ID"] = df.index + 1
    df.insert(0, "ID", df.index + 1)
    return df


def preprocess_all():
    print("Preprocessing Conferences...")
    conferences = preprocess_conferences()
    print(conferences)
    conferences.to_csv("Data/Preprocessed/conferences.txt", index=False)

    print("Preprocessing Schools...")
    schools = preprocess_schools()
    print(schools)
    schools.to_csv("Data/Preprocessed/schools.csv", index=False)

    print("Preprocessing Locations...")
    locations = preprocess_locations()
    print(locations)
    locations.to_csv("Data/Preprocessed/locations.csv", index=False)

