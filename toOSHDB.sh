ETLJar=target/etl-0.5.0-neighbours-SNAPSHOT.jar
H2Jar=h2-1.4.193.jar
JVMArgs="-Xms8g -Xmx8g -server -XX:+UseG1GC"

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "Possible Arguments -"
            echo " "
            echo "options:"
            echo "-h, --help                show brief help"
            echo "-root, --root=ABS_PATH_ROOT       specify absolute path of root directory where this repo resides"
            echo "-shp, --shp=ABS_PATH_SHP      specify absolute path of shapefile, without extension"
            echo "-osm, --osm=ABS_PATH_OSM      specify absolute path of osm, without extension"
            echo "-pbf, --pbf=ABS_PATH_PBF      specify absolute path of pbf, without extension"
            echo "-o, --output=ABS_PATH_OUTPUT       specify absolute path of output directory along with filename, without extension"
            exit 0
            ;;
        -root)
            shift
            ABS_PATH_ROOT=$1
            shift
            ;;
        -shp)
            shift
            ABS_PATH_SHP=$1
            shift
            ;;
        -osm)
            shift
            ABS_PATH_OSM=$1
            shift
            ;;
        -pbf)
            shift
            ABS_PATH_PBF=$1
            shift
            ;;
        -ETLJar)
            shift
            ABS_PATH_ETLJar=$1
            shift
            ;;
        -H2Jar)
            shift
            ABS_PATH_H2Jar=$1
            shift
            ;;
        -o)
            shift
            ABS_PATH_OUTPUT=$1
            shift
            ;;
        *)  
            echo "bad arguments!"
            break
            ;;
    esac
done

function osmiumSort {
    osmium sort $1 -o $ABS_PATH_ROOT/tmp/test.osh.pbf
}

function etl {
    cd $ABS_PATH_ROOT/oshdb/oshdb-tool/etl/

    mvn clean package

    echo "Starting Extract ***"

    time java -Xms8g -Xmx8g -server -XX:+UseG1GC -cp $ETLJar org.heigit.bigspatialdata.oshdb.tool.importer.extract.Extract --pbf $ABS_PATH_ROOT/tmp/test.osh.pbf -tmpDir ./tmp -workDir ./tmp --md5 `md5 -q $ABS_PATH_ROOT/tmp/test.osh.pbf` --timevalidity_from 1900-01-01

    echo "Starting Transform ***"

    time java -Xms8g -Xmx8g -server -XX:+UseG1GC -cp $ETLJar org.heigit.bigspatialdata.oshdb.tool.importer.transform.Transform --pbf $ABS_PATH_ROOT/tmp/test.osh.pbf -tmpDir ./tmp -workDir ./tmp

    echo "Starting Load ***"

    time java -Xms8g -Xmx8g -server -XX:+UseG1GC -cp $ETLJar:$H2Jar org.heigit.bigspatialdata.oshdb.tool.importer.load.handle.OSHDB2H2Handler -tmpDir ./tmp -workDir ./tmp --out $ABS_PATH_OUTPUT --attribution '© OpenStreetMap contributors' --attribution-url 'https://www.openstreetmap.org/copyright'

    rm -rf ./tmp
    rm -rf $ABS_PATH_ROOT/tmp/*
}

function run {
    if [ -n "$ABS_PATH_SHP" ]; then
        echo "Processing Shapefile to oshbd.mv.db **********"
        python $ABS_PATH_ROOT/ogr2osm/ogr2osm.py --no-memory-copy --id=100000000000 $ABS_PATH_SHP.shp --output=$ABS_PATH_ROOT/tmp/test.osm
        osmiumSort $ABS_PATH_ROOT/tmp/test.osm
        etl
    elif [ -n "$ABS_PATH_OSM" ]; then
        echo "Processing OSM to oshbd.mv.db **********"
        osmiumSort $ABS_PATH_OSM.osm
        etl
    elif [ -n "$ABS_PATH_PBF" ]; then
        echo "Processing PBF to oshbd.mv.db **********"
        osmiumSort $ABS_PATH_PBF.osm.pbf
        etl
    fi
}

run 