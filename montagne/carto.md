# Cartographie

*This page is intentionally written in French.*

## OruxMaps

Pour ajouter des cartes IGN sur OruxMaps il faut [ajouter](https://oruxmaps.org/forum/index.php?topic=44755.0) ces entrées au fichier `onlinemapsources.xml` dans les configurations du logiciel:

```xml
<url><![CDATA[[https://data.geopf.fr/private/wmts?apikey=ign_scan_ws&Layer=GEOGRAPHICALGRIDSYSTEMS.MAPS&Style=normal&TileMatrixSet=PM&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image/jpeg&TileMatrix={$z}&TileCol={$x}&TileRow={$y}](https://data.geopf.fr/private/wmts?apikey=ign_scan_ws&Layer=GEOGRAPHICALGRIDSYSTEMS.MAPS&Style=normal&TileMatrixSet=PM&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image/jpeg&TileMatrix=%7B$z%7D&TileCol=%7B$x%7D&TileRow=%7B$y%7D)]]></url>
<website><![CDATA[<a href="[https://www.geoportail.gouv.fr/donnees/carte-ign](https://www.geoportail.gouv.fr/donnees/carte-ign)" target="_blank">GéoPortail - Cartes IGN</a>]]></website>
```
