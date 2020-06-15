#' Visualise a palette
#'
#' @importFrom grDevices colorRampPalette
#' @param pal Palette name
#' @export
#'
#' @examples
#' util_visualise_pal(usyd_palettes[["ochre"]])
util_visualise_pal <- function(pal, num = length(pal)) {
  pal_func <- colorRampPalette(pal)
  image(seq_len(num), 1, as.matrix(seq_len(num)), col = pal_func(num),
        xlab = "", ylab = "", xaxt = "n", yaxt = "n",  bty = "n")
}
