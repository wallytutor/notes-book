---
jupytext:
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

# PDF text extraction

+++

Below we illustrate the usage of `PdfToTextConverted`. Please notice that data curation of extracted texts is still required if readability is a requirement. If quality of automated extractions is often poor for a specific language, you might want to search the web how to *train tesseract*, that topic is not covered here.

+++

**Note:** this note assumes `majordome` has been installed with optional dependencies from `pdftools`, *i.e.* `pip install majordome[pdftools]`; it also assumes [tesseract](https://github.com/tesseract-ocr/tesseract) and [poppler](https://github.com/oschwartz10612/poppler-windows), and [ImageMagick](https://imagemagick.org/) are available in system path. Under Windows you might struggle to get them all working together, please check Majordome's Kompanion for automatic installation.

+++

Install dependencies on Ubuntu 22.04:

```bash
sudo apt install  tesseract-ocr imagemagick poppler-utils
```

In case of Rocky Linux 9:

```bash
sudo dnf install tesseract tesseract-langpack-eng ImageMagick poppler-utils
```

```{code-cell} ipython3
%load_ext autoreload
%autoreload 2
```

```{code-cell} ipython3
from majordome.pdftools import PdfToTextConverter
```

```{code-cell} ipython3
converter = PdfToTextConverter()

data = converter("../media/samples-pdf/paper.pdf", use_ocr=False)
data.meta
```

```{code-cell} ipython3
data = converter("../media/samples-pdf/scanned.pdf", use_ocr=False)
data.content[:100]
```
