import click
import pandas as pd

from scrape import scrape
from preprocess import preprocess
from template import template
from finalize import finalize


@click.command()
@click.argument("task")
def main(task: str):
    #if task == "scrape":
    #    scrape.scrape_all()
    
    match task:
        case "scrape":
            scrape.scrape_all()
        case "preprocess":
            preprocess.preprocess_all()
        case "create-templates":
            template.create_all()
        case "finalize":
            finalize.finalize_all()
        case _:
            assert False


if __name__ == "__main__":
    main()
