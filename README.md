# shp-or-osm-to-oshdb.mv.db
Create Oshdb database file - https://gitlab.gistools.geog.uni-heidelberg.de/giscience/big-data/ohsome/oshdb/blob/master/oshdb-tool/etl/README.md

**Download the repo**

``` git clone https://github.com/Zia-/shp-or-osm-to-oshdb-mv-db.git ```

**Possible Commands** -

- When converting Shapefile

 ``` bash /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db/toOSHDB.sh -root /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db -shp /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db/sample_data/polyshp -o /Users/zia/Desktop/test ```

- When converting OSM file

``` bash /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db/toOSHDB.sh -root /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db -osm /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db/sample_data/map -o /Users/zia/Desktop/test ```

- When converting PBF file

``` bash /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db/toOSHDB.sh -root /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db -pbf /Users/zia/Documents/codes/gitHub/shp-or-osm-to-oshdb-mv-db/sample_data/andorra -o /Users/zia/Desktop/test ```