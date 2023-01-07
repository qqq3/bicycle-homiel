import os.path
from jinja2 import Environment, FileSystemLoader
import json

STATISTICS_PATH = "statistics"
FILE_CYCLEWAY_LENGTH = os.path.join(STATISTICS_PATH, "cycleway_length.json")
FILE_CYCLEWAY_BY_DISTRICT = os.path.join(STATISTICS_PATH, "cycleway_by_district.json")
FILE_CYCLEWAY_SMOOTHNESS = os.path.join(STATISTICS_PATH, "cycleway_smoothness.json")
FILE_CYCLEWAY_SURFACE = os.path.join(STATISTICS_PATH, "cycleway_surface.json")
FILE_PARKING_COUNT = os.path.join(STATISTICS_PATH, "parking_count.json")
FILE_PARKING_BY_DISTRICT = os.path.join(STATISTICS_PATH, "parking_by_district.json")
FILE_PARKING_BY_TYPE = os.path.join(STATISTICS_PATH, "parking_by_type.json")
FILE_SHOP_COUNT = os.path.join(STATISTICS_PATH, "shop_count.json")
FILE_SHOP_BY_DISTRICT = os.path.join(STATISTICS_PATH, "shop_by_district.json")
FILE_DATA_DATETIME = os.path.join(STATISTICS_PATH, "data_datetime.json")

headernames = {
    "cycleway_by_district": "Працягласць па раёнах", "cycleway_smoothness": "Стан",
    "cycleway_surface": "Паверхня", "parking_by_district": "Колькасць па раёнах",
    "parking_by_type": "Тып парковак", "shop_by_district": "Колькасць па раёнах"
}

environment = Environment(loader=FileSystemLoader(""))
results_file = '../statistics.html'
results_template = environment.get_template('statistics_template.html')

with open(FILE_CYCLEWAY_LENGTH, "r") as file:
    cycleway_length = json.load(file)
with open(FILE_CYCLEWAY_BY_DISTRICT, "r") as file:
    cycleway_by_district = json.load(file)
with open(FILE_CYCLEWAY_SMOOTHNESS, "r") as file:
    cycleway_smoothness = json.load(file)
with open(FILE_CYCLEWAY_SURFACE, "r") as file:
    cycleway_surface = json.load(file)
with open(FILE_PARKING_COUNT, "r") as file:
    parking_count = json.load(file)
with open(FILE_PARKING_BY_DISTRICT, "r") as file:
    parking_by_district = json.load(file)
with open(FILE_PARKING_BY_TYPE, "r") as file:
    parking_by_type = json.load(file)
with open(FILE_SHOP_COUNT, "r") as file:
    shop_count = json.load(file)
with open(FILE_SHOP_BY_DISTRICT, "r") as file:
    shop_by_district = json.load(file)
with open(FILE_DATA_DATETIME, "r") as file:
    data_datetime = json.load(file)

with open(results_file, mode="w", encoding="utf-8") as results:
    results.write(results_template.render(hn=headernames, cwl=cycleway_length, cwbd=cycleway_by_district,
                                          cwsm=cycleway_smoothness, cws=cycleway_surface,
                                          pc=parking_count, pbd=parking_by_district, pbt=parking_by_type,
                                          sc=shop_count, sbd=shop_by_district, dt=data_datetime, ))
    print(f"The {results_file} file is written.")
