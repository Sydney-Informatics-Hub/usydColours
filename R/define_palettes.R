### Load packages
#' @import colorspace
#' @import purrr
#' @import grDevices

# Load internal data
load(file = "R/sysdata.rda")

# Create hex code matrix
fullhexpallette <- matrix(sydneyunicolours$hex)
rownames(fullhexpallette) <- sydneyunicolours$colourName

#' University branding colours
#'
usydSwatchplot <- colorspace::swatchplot(fullhexpallette)

# Create colour list
colourList <- as.character(sydneyunicolours[["hex"]])
names(colourList) <- sydneyunicolours$colourName

#' Function to call hex codes from colourList
#'
#' @param ... a list of colour names from colourList
#' @return A list of hex codes corresponding to the chosen colours
usyd_cols <- function(...) {
  cols <- c(...)
  if (is.null(cols))
    return (colourList)
  colourList[cols]
}

#' Complete list of USYD colour palettes
#'
#' @export
usyd_palettes <- list(
  `primary`  = usyd_cols("MasterbrandCharcoal", "MasterbrandOchre", "AccentBlue", "AccentYellow", "AccentGrey"),
  `extended`  = usyd_cols("MasterbrandCharcoal", "MasterbrandOchre", "AccentBlue", "AccentYellow", "SecondaryDarkGreen",
                                   "SecondaryBlue", "SecondaryPeach", "SecondaryBeige", "SecondaryLemon", "SecondaryLightGreen",
                                   "SecondaryDarkSeafoam", "SecondaryLightSeafoam", "SecondaryLightBlue", "SecondaryLilac",
                                   "SecondaryPurple", "SecondaryPink", "SecondaryLightPink", "SecondaryOrange", "SecondaryMaroon",
                                   "MasterbrandBlack", "AccentGrey"),
  `secondary`  = usyd_cols("MasterbrandOchre", "SecondaryBlue", "AccentYellow", "SecondaryDarkSeafoam", "SecondaryLilac"),
  `pastel` = usyd_cols("SecondaryLemon", "SecondaryPeach", "SecondaryLightPink", "SecondaryLilac", "SecondaryLightBlue", "SecondaryLightSeafoam", "SecondaryLightGreen"),
  `complementary_ReGr` = usyd_cols("MasterbrandOchre", "SecondaryPeach", "SecondaryMaroon", "SecondaryDarkSeafoam", "SecondaryLightSeafoam"),
  `complementary_ReBl` = usyd_cols("MasterbrandOchre", "SecondaryPeach", "SecondaryBeige", "AccentBlue", "SecondaryBlue", "SecondaryLightBlue"),
  `bright` = usyd_cols("MasterbrandOchre", "SecondaryDarkGreen", "SecondaryLightGreen", "SecondaryLightBlue", "SecondaryBlue", "SecondaryOrange", "AccentYellow"),
  `muted` = usyd_cols("SecondaryLightBlue", "SecondaryLemon", "SecondaryPeach"),
  `trafficlight` = usyd_cols("SecondaryDarkSeafoam", "SecondaryLemon", "MasterbrandOchre"),
  `heatmap` = usyd_cols("SecondaryDarkSeafoam", "MasterbrandWhite", "MasterbrandOchre"),
  `flametree` = usyd_cols("SecondaryLemon", "SecondaryOrange", "MasterbrandOchre", "SecondaryMaroon"),
  `jacaranda` = usyd_cols("SecondaryLightPink", "SecondaryLilac", "SecondaryBlue", "AccentBlue"),
  `harbour` = usyd_cols("SecondaryLightGreen", "SecondaryLightSeafoam", "SecondaryBlue", "AccentBlue"),
  `sandstone` = usyd_cols("SecondaryIvory", "SecondaryBeige", "SecondaryMaroon", "MasterbrandCharcoal"),
  `ochre` = usyd_cols("SecondaryIvory", "SecondaryBeige", "SecondaryPeach", "MasterbrandOchre"),
  `greyscale` = usyd_cols("MasterbrandCharcoal", "AccentGrey"),
  `BlGrYe` = usyd_cols("AccentBlue", "SecondaryLightGreen", "SecondaryLemon"),
  `BlOr` = usyd_cols("AccentBlue", "SecondaryOrange", "SecondaryLemon"),
  `diverging_blue_red` = usyd_cols("SecondaryMaroon", "MasterbrandOchre", "SecondaryPeach", "MasterbrandWhite", "SecondaryLightBlue", "SecondaryBlue", "AccentBlue"),
  `diverging_blue_orange` = usyd_cols("SecondaryOrange", "MasterbrandWhite", "AccentBlue")
)

#' Use purrr to remove the names of usyd_palettes
#'
usyd_palettes <- purrr::map2(usyd_palettes, usyd_palettes, unname)


#' Return hex codes based on predefined palettes
#'
#' @param name Name of the desired palette (refer to documentation for options). All colours are from the University of Sydney Brand Guidelines document version 2.0.
#' @param n The number of colours required. Most palettes support between 2 - 6 colours. The largest palette is \code{extended}, which contains 21 colours.
#' @param type "Discrete" or "continuous". Discrete is recommended for most palettes, unless the number of colours required is less than the number of variables, in which case continuous may be selected.
#' @export
#'
#' @examples
#' usyd_palette('primary')
#' usyd_palette('jacaranda')
#' usyd_palette('extended', 20, type = 'continuous')
usyd_palette <- function(name, n, type = c("discrete", "continuous")) {
  type <- match.arg(type)
  pal <- usyd_palettes[[name]]
  if (is.null(pal))
    stop("Palette not found. Please submit a pull request if you'd like to contribute your palette to the collection.")
  if (missing(n)) {
    n <- length(pal)
  }
  if (type == "discrete" && n > length(pal)) {
    stop("Number of requested colors exceeds number in palette. Try again and specify 'n'.")
  }
  out <- switch(type,
                continuous = grDevices::colorRampPalette(pal)(n),
                discrete = pal[1:n]
  )
  structure(out, class = "palette", name = name)
}




#' Generates new palettes based on colour selections
#'
#' @param ... Colour names from swatchplot (refer to documentation)
#' @return A colour palette ready for use.
#' @export
#' @examples
#' my_palette <- usyd_pal_gen("SecondaryDarkSeafoam", "SecondaryLightSeafoam", "AccentYellow")
usyd_pal_gen <- function(...) {
  cols <- c(...)
  if (is.null(cols))
    return (colourList)
  colourList2 <- colourList[cols]
  colourList2 <- unname(colourList2)
}

