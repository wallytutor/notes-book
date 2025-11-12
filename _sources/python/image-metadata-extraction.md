---
jupytext:
  main_language: python
  cell_metadata_filter: -all
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.18.1
  formats: md:myst
kernelspec:
  name: python3
  display_name: Python 3 (ipykernel)
  language: python
---

# Getting image metadata


In this brief notebook we explore how to get image metadata, more specifically EXIF (Exchangeable image file format) data from a file. More about the format can be found on [Wikipedia](https://en.wikipedia.org/wiki/Exif) and the implementation is based on [this answer](https://stackoverflow.com/questions/4764932). So let's use some pictures on my personal database to see what sort of information we may extract.

To follow this notebook you will need `pillow==12.0.0`, `ExifRead==3.5.1`, and `folium==0.20.0`. Other versions might work, but since I am not making a `requirements.txt` for this notebook it is better to keep track of the versions it worked with. Methods for extracting data with be explained for both `PIL` and [`exifread`](https://github.com/ianare/exif-py), `folium` is there to do something actually usefull with the data. So let's import the packages:

```{code-cell} ipython3
from pathlib import Path
from PIL import Image
import exifread
import folium
```

I put some images from my trip in 2018 to play with under the folder listed below. Here we make use of Python `pathlib.Path` to get all images matching the extension `jpg` in a list. We will use a single image here but in the end you can change index of the list and check the others.

```{code-cell} ipython3
media = Path(".").resolve().parent / "media" / "samples-metadata"
media.exists()

file_list = list(media.glob("*.jpg"))
len(file_list)
```

Next we select one image from the list. If you want to see it you can uncomment `Image.open(selected)` below. I keep it commented to keep the file size of this notebook small (since the images are already in the repository).

```{code-cell} ipython3
selected =  file_list[1]

# Image.open(selected)
```

## Using PIL.Image (not recommended)

Using the well-known `PIL.Image` is not the recommended way and we choose to present it first so that we can explore further the recommended way. The image object has a method `getexif` (commented line) that provides (i) little data and in (ii) a nonsense format. Using the private method (you should not to do so) `_getexif` gets more data, but good luck making any proper use of it.

```{code-cell} ipython3
# exif_data = Image.open(selected).getexif().items()
exif_data = Image.open(selected)._getexif().items()
exif_data = {k: v for k, v in exif_data if k != 37500}
exif_data
```

## Using exifread (recommended)

This small and embedable package [exifread](https://github.com/ianare/exif-py) provides what it takes to get EXIF data from an image in a well formated dictionary. The following snippet illustrates how to do so:

```{code-cell} ipython3
with open(selected, "rb") as reader:
    exif_data = exifread.process_file(reader).items()
    exif_data = {k:v for k, v in exif_data if k != "JPEGThumbnail"}

exif_data
```

There is a bunch of information above, but let's imagine here you forgot where a picture was taken. Well, if your camera or cellphone has a GPS embedded you get find out with the extracted metadata. The following function extracts the latitude and logitude from the format exported by `exifread` for you and provides the results in degrees.

```{code-cell} ipython3
def get_exif_location(exif_data):
    """ Returns the latitude and longitude from exif data.

    Based on https://gist.github.com/snakeye/fdc372dbf11370fe29eb which
    by its way is based on https://gist.github.com/erans/983821.
    """

    def to_degress(value):
        """ Convert the GPS coordinates stored in the EXIF to degrees. """
        d = float(value.values[0].num) / float(value.values[0].den)
        m = float(value.values[1].num) / float(value.values[1].den)
        s = float(value.values[2].num) / float(value.values[2].den)
        return d + m / 60 + s / 3600

    lat, lon = None, None
    gps_lat_val = exif_data.get("GPS GPSLatitude", None)
    gps_lat_ref = exif_data.get("GPS GPSLatitudeRef", None)
    gps_lon_val = exif_data.get("GPS GPSLongitude", None)
    gps_lon_ref = exif_data.get("GPS GPSLongitudeRef", None)

    if gps_lat_val and gps_lat_ref and gps_lon_val and gps_lon_ref:
        lat = to_degress(gps_lat_val)
        lon = to_degress(gps_lon_val)

        lat = -lat if gps_lat_ref.values[0] != "N" else lat
        lon = -lon if gps_lon_ref.values[0] != "E" else lon

    return lat, lon
```

So here we go, we get the coordinates from the image and with help of `folium` we check on the map where it was taken.

```{code-cell} ipython3
coordinates = get_exif_location(exif_data)

m = folium.Map(location=coordinates)
folium.Marker(coordinates).add_to(m)
m
```

This is not forensics level but can be pretty useful. For instance, some microscopes store all the setup under which a picture was taken. If that is the case, you don't need to keep taking all those boring notes while doing your analysis, and leave image labeling for some automated post-processing in Python.
