# Color and Palette Management Functions

#' Add or Modify Colors
#'
#' This function adds new colors or modifies existing ones in the color palette.
#'
#' @param new_colors A data frame containing new color information.
#' @return Updated color data frame.
#' @export
add_or_modify_colors <- function(new_colors) {
  # Ensure new_colors has the correct structure
  required_cols <- c("colourName", "R", "G", "B", "hex")
  if (!all(required_cols %in% names(new_colors))) {
    stop("new_colors must contain at least these columns: ", paste(required_cols, collapse = ", "))
  }

  # Add or update colors
  for (i in 1:nrow(new_colors)) {
    color_name <- new_colors$colourName[i]
    existing_index <- which(sydneyunicolours$colourName == color_name)

    if (length(existing_index) > 0) {
      # Update existing color
      sydneyunicolours[existing_index, names(new_colors)] <- new_colors[i, ]
    } else {
      # Add new color
      new_row <- data.frame(X = max(sydneyunicolours$X) + 1)
      new_row[names(new_colors)] <- new_colors[i, ]
      sydneyunicolours <- rbind(sydneyunicolours, new_row)
    }
  }

  sydneyunicolours
}

#' Remove Colors
#'
#' This function removes specified colors from the color palette.
#'
#' @param color_names A vector of color names to be removed.
#' @return Updated color data frame.
#' @export
remove_colors <- function(color_names) {
  sydneyunicolours <- sydneyunicolours[!sydneyunicolours$colourName %in% color_names, ]
  sydneyunicolours
}

#' Add or Modify Palettes
#'
#' This function adds new palette entries or modifies existing ones.
#'
#' @param new_palette_entries A data frame containing new palette information.
#' @return Updated palette data frame.
#' @export
add_or_modify_palettes <- function(new_palette_entries) {
  # Ensure new_palette_entries has the correct structure
  required_cols <- c("Palette", "Colour", "Role")
  if (!all(required_cols %in% names(new_palette_entries))) {
    stop("new_palette_entries must contain at least these columns: ", paste(required_cols, collapse = ", "))
  }

  # Add or update palette entries
  for (i in 1:nrow(new_palette_entries)) {
    palette_name <- new_palette_entries$Palette[i]
    color_name <- new_palette_entries$Colour[i]

    existing_index <- which(sydneyunipalettes$Palette == palette_name &
                              sydneyunipalettes$Colour == color_name)

    if (length(existing_index) > 0) {
      # Update existing entry
      sydneyunipalettes[existing_index, names(new_palette_entries)] <- new_palette_entries[i, ]
    } else {
      # Add new entry
      sydneyunipalettes <- rbind(sydneyunipalettes, new_palette_entries[i, ])
    }
  }

  sydneyunipalettes
}

#' Remove Palette Entries
#'
#' This function removes entire palettes or specific colors from a palette.
#'
#' @param palette_name The name of the palette to modify.
#' @param color_names Optional vector of color names to remove from the palette.
#' @return Updated palette data frame.
#' @export
remove_palette_entries <- function(palette_name, color_names = NULL) {
  if (is.null(color_names)) {
    # Remove entire palette
    sydneyunipalettes <- sydneyunipalettes[sydneyunipalettes$Palette != palette_name, ]
  } else {
    # Remove specific colors from the palette
    sydneyunipalettes <- sydneyunipalettes[!(sydneyunipalettes$Palette == palette_name &
                                               sydneyunipalettes$Colour %in% color_names), ]
  }
  sydneyunipalettes
}

#' Add or Modify Color (Simple)
#'
#' This function provides a simple way to add or modify a color using just name and hex code.
#'
#' @param color_name The name of the color to add or modify.
#' @param hex_code The hex code of the color (format: "#RRGGBB").
#' @return Updated color data frame.
#' @export
add_or_modify_color_simple <- function(color_name, hex_code) {
  # Validate hex code
  if (!grepl("^#[0-9A-Fa-f]{6}$", hex_code)) {
    stop("Invalid hex code. It should be in the format '#RRGGBB'.")
  }

  # Convert hex to RGB
  rgb_values <- grDevices::col2rgb(hex_code)

  # Create new color data
  new_color <- data.frame(
    colourName = color_name,
    R = rgb_values[1],
    G = rgb_values[2],
    B = rgb_values[3],
    hex = hex_code,
    stringsAsFactors = FALSE
  )

  # Add other necessary columns with NA or default values
  extra_cols <- setdiff(names(sydneyunicolours), names(new_color))
  for (col in extra_cols) {
    new_color[[col]] <- NA
  }

  # Add or update the color
  sydneyunicolours <- add_or_modify_colors(new_color)

  # Return the updated color data frame
  sydneyunicolours
}

# Internal helper function to save data
save_color_data <- function() {
  save(sydneyunicolours, sydneyunipalettes, file = "R/sysdata.rda")
}
