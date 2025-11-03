---
jupyter:
  jupytext:
    cell_metadata_filter: -all
    formats: md,ipynb
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.18.1
  kernelspec:
    display_name: Julia 1.12.1
    language: julia
    name: julia-1.12
---

# Porosity quantification


In this tutorial we will see how to implement a custom workflow for porosity quantification in materials. The selected tools are those from the [JuliaImages](https://juliaimages.org/latest/) suite.


## Importing required tools

```julia
using Pkg

requirements = [
    "Images",
    "ImageEdgeDetection",
    "ImageSegmentation",
    "IndirectArrays",
    "Statistics"
]

HERE = dirname(abspath(@__FILE__))
Pkg.activate(HERE)

for pkg ∈ requirements
    Pkg.add(pkg)
end
```

```julia
using Images
using ImageEdgeDetection
using ImageEdgeDetection: Percentile
using ImageSegmentation
using IndirectArrays
using Statistics
```

## Step-by-step


### Loading the image

```julia
filepath = "media/Ti_pure_1-50.1-50x.jpg"
img0 = load(filepath)

(h, w) = size(img0)
@info "$(typeof(img0)) : size $(h)x$(w)"

img0
```

### Gray-scale conversion

```julia
imgg = Gray.(img0)
```

It is important to observe the data type of our new matrix:

```julia
typeof(imgg)
```

### Cropping the bar


Next we need to crop the bottom of the image by `crop` pixels:

```julia
crop = 80

imgc = imgg[1:end-crop, 1:end]
```

```julia
typeof(imgc)
```

### Histogram correction (optional)


You might want to edit the next cell for parametrizing the algorithm.

```julia
correct_hist = true

# alg = AdaptiveEqualization(nbins = 256, rblocks = 4, cblocks = 4,
# 	                       clip = 0.6, minval = 0.0, maxval = 0.9)
# alg = Equalization(nbins = 256, minval = 0.0, maxval = 0.7)
# alg = LinearStretching(dst_minval = 0.1, dst_maxval = 0.9)
alg = GammaCorrection(gamma = 2)

imga = correct_hist ? adjust_histogram(imgc, alg) : imgc
```

### Gaussian filter (blur)


You can test the impact of blurring variance `σ`.

```julia
σ = 2.0

imgf = imfilter(imga, Kernel.gaussian(σ))
```

### Image binarization


Now select the trial binarization algorithm:

```julia
bin_alg = Balanced     
# bin_alg = Entropy
# bin_alg = MinimumError
# bin_alg = Moments
# bin_alg = Otsu
# bin_alg = UnimodalRosin
# bin_alg = Yen

imgb = binarize(imgf, bin_alg())
```

### Quantify porosity


White pixes are one valued while black pixels worth zero. Thus adding up the values of all pixels in the image counts the number of white pixels. Thus, the fraction of black pixels, the *porosity* η is

$$
\eta = 1 - \frac{\sum p}{h\times{}w}
$$

The function below implements this evaluation, with which we compute the porosity level.

```julia
"Implements porosity quantification in binarized image."
porosity(im) = 100convert(Float64, 1 - sum(im) / length(im))
```

```julia
@info "Porosity level of $(round(porosity(imgb), digits = 1))%"
```

### Final check


As a final step it is interesting to add contours of pores over the original image.

```julia
"Helper function to draw red edges over pore borders."
function add_red_edges(im0, imb)
	canny = Canny(spatial_scale=5, high=Percentile(50), low=Percentile(45))
	image = imfilter(imb, Kernel.gaussian(5))
	edges = detect_edges(image, canny)

	# Blur a bit to spread values around edges. Where
	# values are greated than zero are thicker edges.
	# Control thickness with gaussian variance.
	thicknen = imfilter(edges, Kernel.gaussian(1.0)) .> 0

	image = RGB.(im0)
	image[thicknen] .= RGB(1, 0, 0)

	# Replace imgc by imgb above and add this:
	# image[imgb .== 0] .= RGB(0.3, 0.4, 0.4)

	return image
end
```

```julia
add_red_edges(imgc, imgb)
```

## Workflow automation


Example following [this tutorial](https://juliaimages.org/dev/examples/image_segmentation/watershed/#Watershed-Segmentation-Algorithm) on watershed segmentation.

```julia
bw = imgc .> 0.5
bw_transform = feature_transform(bw)

dist = 1 .- distance_transform(bw_transform)
dist_trans = dist .< 1

markers = label_components(dist_trans)
segments = watershed(dist, markers)
labels = labels_map(segments)

# You may want to check this intermediate state.
# Gray.(markers/32.0)

thecolors = distinguishable_colors(maximum(labels))
colored_labels = IndirectArray(labels, thecolors)

masked_colored_labels = colored_labels .* (1 .- bw)

gray_labels = Gray.(masked_colored_labels)
gray_labels[gray_labels .> 0] .= 1
gray_labels = 1 .- gray_labels

@info "Porosity of $(round(porosity(gray_labels), digits = 1))%"
# mosaic(imgg, gray_labels; nrow=1)
```

```julia
add_red_edges(imgc, gray_labels)
```
