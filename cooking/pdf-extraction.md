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

**Note:** this note assumes `majordome` has been installed with optional dependencies from `pdftools`, *i.e.* `pip install majordome[pdftools]`; it also assumes [tesseract](https://github.com/tesseract-ocr/tesseract) and [poppler](https://github.com/oschwartz10612/poppler-windows) are available in system path.

```{code-cell} ipython3
from dataclasses import dataclass
from pathlib import Path
from typing import Any
from pypdf import PdfReader
import shutil
import pytesseract
import warnings

from majordome import (
    PathLike,
    MaybePath,
    program_path
)
```

```{code-cell} ipython3
@dataclass
class PdfExtracted:
    """ Stores data extracted from a PDF file. """
    meta: dict[str, Any]
    content: str
```

```{code-cell} ipython3
class PdfToTextConverter:
    """ Performs text extraction from PDF file. """
    __slots__ = ("_tesseract", "_pdftotext", "_bigpdf")

    def __init__(self, tesseract: MaybePath = None,
                 pdftotext: MaybePath = None, n_pages_warn: int = 100) -> None:
        self._pdftotext = self._ensure_program("pdftotext", pdftotext)
        self._tesseract =  self._ensure_program("tesseract", tesseract)
        self._bigpdf = n_pages_warn
        pytesseract.tesseract_cmd = self._tesseract

    def _ensure_program(self, name: str, program: MaybePath) -> None:
        if program:
            if not Path(program).exists():
                raise FileNotFoundError(f"Missing {name} at {program}")
            return program

        return program_path(name)

    def read(self, pdf_path: PathLike) -> PdfReader | None:
        """ Return True if PDF is not encrypted, performs some checks. """
        doc = PdfReader(pdf_path)
    
        if doc.is_encrypted:
            warnings.warn(f"PDF is encrypted: {pdf_path}")
            return None
    
        if (n_pages := len(doc.pages)) > self._bigpdf:
            warnings.warn(f"{pdf_path} is too long ({n_pages})")

        return doc

    def __call__(self, pdf_path: PathLike, verbose: bool = False) -> PdfExtracted | None:
        if not (doc := self.read(pdf_path)):
            return None

        meta = doc.metadata
        
        if verbose:
            skip = max(map(len, meta.keys()))
            fmt = f"{{key:>{skip+1}s}} : {{value}}"

            for key, value in meta.items():
                print(fmt.format(key=key, value=value))


        return PdfExtracted(meta=meta, content="")
                
    # def __call__(self,
    #         pdf_path: Path,
    #         dpi: int = 150,
    #         first_page: int = None,
    #         last_page: int = None,
    #         userpw: str = None,
    #         thread_count: int = 8
    #     ):
    #     """ In-memory convertion of PDF to text. """
    #     try:
    #         ensure_readable_pdf(pdf_path)
    #     except RuntimeError as err:
    #         logging.error(f"Skipping {pdf_path}: {err}")
    #         return

    #     try:
    #         image_list = pdf_to_images(pdf_path, dpi, first_page,
    #             last_page, userpw, thread_count, self._poppler_path)
    #     except Exception as err:
    #         logging.error(f"Converting pdf2txt: {err}")
    #         return

    #     return image_to_text(image_list)
```

```{code-cell} ipython3
converter = PdfToTextConverter()
converter("../media/samples-pdf/paper.pdf")
```

```{code-cell} ipython3
doc = PdfReader("../media/samples-pdf/scanned.pdf")
```

```{code-cell} ipython3
if not doc.pages[0].extract_text():
    print("no")
```

```{code-cell} ipython3

```

```{code-cell} ipython3

```

```{code-cell} ipython3
from pdf2image import convert_from_path
from pytesseract import pytesseract,image_to_string

def pdf_to_images(
        pdf_path: Path | str,
        dpi: int,
        first_page: int,
        last_page: int,
        userpw: str,
        thread_count: int,
        poppler_path: str
    ) -> list:
    """ Handles in-memory conversion of PDF to image. """
    image_list = convert_from_path(
        pdf_path,
        dpi          = dpi,
        first_page   = first_page,
        last_page    = last_page,
        thread_count = thread_count,
        userpw       = userpw,
        poppler_path = poppler_path,
        output_folder= None,
        fmt          = "ppm",
        jpegopt      = None,
        use_cropbox  = False,
        strict       = False,
        transparent  = False,
        single_file  = False,
        grayscale    = False,
        size         = None,
        paths_only   = False,
    )
    return image_list


def image_to_text(image_list) -> str:
    """ Extract text from sequence of images. """
    texts = ""

    try:
        for idx, image in enumerate(image_list):
            logging.info(f"Image {idx+1}/{len(image_list)}")
            texts += image_to_string(image)
            texts += "\n---\n"

    except Exception as err:
        logging.error(f"Extracting text from image: {err}")

    return texts


# TODO support direct image conversion.
# def img2txt(img_path, valid, tesseract_cmd):
#     """ Extract text from image file. """
#     # Set path of executable.
#     pytesseract.tesseract_cmd = tesseract_cmd
#     base_error = "While converting img2txt"
#     file_format = imghdr.what(img_path)
#
#     if file_format is None:
#         raise ValueError(f"{base_error}: unable to get file format")
#
#     if file_format not in valid:
#         raise ValueError(f"{base_error}: {file_format} not in {valid}")
#
#     try:
#         with Image.open(img_path, mode="r") as img:
#             texts_list = image_to_string(img)
#     except (IOError, Exception) as err:
#         raise IOError(f"{base_error}: {err}")
#
#     return texts_list
```

```{code-cell} ipython3

```
