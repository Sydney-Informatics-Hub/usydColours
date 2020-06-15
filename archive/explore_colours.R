### Load packages
#' @importFrom grDevices rgb

## Helper function
cmyk2rgb <- function(cyan,magenta,yellow,black) {
    # https://stackoverflow.com/questions/22352568/cmy-colour-function-in-r
    missing_pre <- is.na(matrix(c(cyan, magenta, yellow, black), nrow = length(cyan)))
    missing = rowSums(missing_pre) > 0
    cyan <- cyan / 100.0
    magenta <- magenta / 100.0
    yellow <- yellow / 100.0
    black <- black / 100.0
    n.c <- (cyan * (1-black) + black)
    n.m <- (magenta * (1-black) + black)
    n.y <- (yellow * (1-black) + black)
    r.col <- round(255 * (1-n.c))
    g.col <- round(255 * (1-n.m))
    b.col <- round(255 * (1-n.y))
    colours <- character(length(cyan))
    colours[! missing] <- rgb(r.col[! missing], g.col[! missing], b.col[! missing], max = 255)
    # return(rgb(r.col, g.col, b.col, max = 255))
    return(colours)
}


# convert RGB to hex
myhex <- data.frame(mapply(rgb, mycolours$R, mycolours$G, mycolours$B, MoreArgs = list(max = 255)))
names(myhex) <- "hex"
mycolours <- cbind(mycolours, myhex)
rm(myhex)
# convert manually from cmyk to rgb
myrgbfromcmyk <- mapply(cmyk2rgb, mycolours$C, mycolours$M, mycolours$Y, mycolours$K)
names(myrgbfromcmyk) <- "rgbfromcmyk"
mycolours <- cbind(mycolours, myrgbfromcmyk)
rm(myrgbfromcmyk)
# use the official colours, not the ones I got from looking at the branding and marketing brochure using photoshop colour picker
mycolours <- mycolours[!grepl("dvPS$", mycolours$colourName),]
myhsv <- data.frame(t(mapply(rgb2hsv, mycolours$R, mycolours$G, mycolours$B)))
names(myhsv) <- c("H", "S","V")
mycolours <- cbind(mycolours, myhsv)
rm(myhsv)
# arrange by hsv
mycolours[order(mycolours$H, mycolours$S, mycolours$V),]
