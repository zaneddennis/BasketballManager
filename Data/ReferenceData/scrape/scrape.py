import pandas as pd


def scrape_conferences() -> pd.DataFrame:
    url = "https://en.wikipedia.org/wiki/2023%E2%80%9324_NCAA_Division_I_men%27s_basketball_season"
    df = pd.read_html(url)[13]
    
    df = df[["Conference"]]
    df.columns = ["Name"]

    return df

def scrape_schools() -> pd.DataFrame:
    url = "https://en.wikipedia.org/wiki/List_of_NCAA_Division_I_men%27s_basketball_programs"
    df = pd.read_html(url)[0]

    df = df[["School", "Nickname", "Conference"]]

    return df

def fetch_locations_geonames():
    path = "~/Downloads/cities1000/cities1000.txt"
    df = pd.read_csv(path, sep="\t", header=None)
    
    df.columns = [
        "geonameid", "name", "asciiname", "alternativenames", "latitude", "longitude", "feature class", "feature code", "country code", "cc2", "admin1 code", "admin2 code", "admin3 code", "admin4 code", "population", "elevation", "dem", "timezone", "modification date"
    ]
    df = df.loc[df["country code"] == "US"]
    df = df[["asciiname", "latitude", "longitude", "admin1 code", "timezone"]]
    
    return df

def fetch_locations_census():
    path = "~/Downloads/sub-est2023.csv"
    df = pd.read_csv(path, encoding="latin-1")
    df = df.loc[df.SUMLEV == 162]
    df = df[["NAME", "STNAME", "POPESTIMATE2023"]]
    return df



def scrape_all():
    print("Scraping Conferences...")
    conferences = scrape_conferences()
    print(conferences)

    print("Scraping Schools...")
    schools = scrape_schools()
    print(schools)

    print("Fetching Locations...")
    locations_geonames = fetch_locations_geonames()
    print(locations_geonames)
    locations_census = fetch_locations_census()
    print(locations_census)

    conferences.to_csv("Data/Raw/conferences.txt", index=False)
    schools.to_csv("Data/Raw/schools.csv", index=False)
    locations_geonames.to_csv("Data/Raw/locations_geonames.csv", index=False)
    locations_census.to_csv("Data/Raw/locations_census.csv", index=False)
